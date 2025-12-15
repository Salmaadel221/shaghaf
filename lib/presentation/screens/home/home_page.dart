
import 'package:flutter/material.dart';
import 'package:shagf/data/services/api_service.dart';
import 'package:shagf/presentation/screens/profile/profile_screen.dart';
import 'package:shagf/presentation/screens/room/room_screen.dart';
import 'package:shagf/presentation/widgets/expandeblebutton.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<dynamic>> eventsFuture;
  late Future<List<dynamic>> gamesFuture;
  late Future<List<dynamic>> branchesFuture;

  // local cache
  List<dynamic> branches = [];
  bool showBranchesMenu = false;

  // default fallback until API decides
  String selectedBranchName = "ElKorba";

  @override
  void initState() {
    super.initState();
    eventsFuture = ApiService.getEvents();
    gamesFuture = ApiService.getGames();

    // fetch branches and set selectedBranchName from API default (if any)
    branchesFuture = ApiService.getBranches();

    branchesFuture.then((list) {
      if (!mounted) return;
      setState(() {
        branches = list;
        // 1) try explicit default flags from backend
        final explicitDefault = branches.firstWhere(
          (b) =>
              (b is Map &&
                  ((b['isDefault'] == true) ||
                      (b['default'] == true) ||
                      (b['is_default'] == true))),
          orElse: () => null,
        );

        if (explicitDefault != null) {
          selectedBranchName = (explicitDefault['branch_name'] ??
                  explicitDefault['nameEn'] ??
                  explicitDefault['nameAr'] ??
                  explicitDefault['name'] ??
                  explicitDefault['name-en'])?.toString() ??
              "ElKorba";
        } else if (branches.isNotEmpty) {
          // 2) pick first branch that has any name field
          final firstValid = branches.firstWhere(
            (b) =>
                (b is Map) &&
                (((b['branch_name'] ?? b['nameEn'] ?? b['nameAr'] ?? b['name']) !=
                        null) &&
                    ((b['branch_name'] ?? b['nameEn'] ?? b['nameAr'] ?? b['name'])
                            .toString()
                            .trim() !=
                        "")),
            orElse: () => branches[0],
          );
          selectedBranchName = (firstValid['branch_name'] ??
                  firstValid['nameEn'] ??
                  firstValid['nameAr'] ??
                  firstValid['name'] ??
                  firstValid['name-en'])?.toString() ??
              "ElKorba";
        } else {
          // 3) fallback
          selectedBranchName = "ElKorba";
        }
      });
    }).catchError((err) {
      // ignore; keep default ElKorba if fetch fails
      // optionally you can log the error
      // print("branches fetch error: $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ---------------- MAIN BODY ------------------
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --------------------- HEADER -------------------------
                Container(
                  height: height * 0.17,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()));
                        },
                        child: CircleAvatar(
                          radius: width * 0.075,
                          backgroundImage: const AssetImage(
                              "assets/blank-profile-picture-973460_1280.png"),
                        ),
                      ),
                      SizedBox(width: width * 0.09),

                      // ---- BRANCH SELECTOR ----
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showBranchesMenu = true;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.location_pin,
                                  size: width * 0.06,
                                  color: theme.textTheme.bodyLarge!.color),
                              SizedBox(width: width * 0.01),
                              Flexible(
                                child: Text(
                                  "📍 ${selectedBranchName}\nTap to change location",
                                  style: TextStyle(
                                      fontSize: width * 0.032,
                                      color: theme
                                          .textTheme.bodyLarge!.color),
                                ),
                              ),
                              Icon(Icons.arrow_drop_down_rounded,
                                  size: width * 0.07,
                                  color: theme.textTheme.bodyLarge!.color),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.02),

                // --------------------- EVENTS -------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming Events",
                        style: TextStyle(
                          fontSize: width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge!.color,
                        ),
                      ),

                      SizedBox(
                        height: height * 0.28,
                        child: FutureBuilder<List<dynamic>>(
                          future: eventsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text("No events available");
                            }
                            final events = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                final event = events[index];

                                final timestamp = event["date"];
                                DateTime? date;
                                if (timestamp is Map &&
                                    timestamp["_seconds"] != null) {
                                  date = DateTime.fromMillisecondsSinceEpoch(
                                      timestamp["_seconds"] * 1000);
                                }

                                final day =
                                    date != null ? date.day.toString() : "??";
                                final month = date != null
                                    ? _getMonthFromNumber(date.month)
                                    : "Unknown";

                                final imageUrl = event["images"] != null &&
                                        event["images"].isNotEmpty
                                    ? event["images"][0]
                                    : null;

                                return Container(
                                  width: width * 0.80,
                                  margin: EdgeInsets.all(width * 0.03),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        top: height * 0.01,
                                        bottom: height * 0.08,
                                        right: width * 0.03,
                                        left: width * 0.03,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: imageUrl != null
                                              ? Image.network(imageUrl,
                                                  fit: BoxFit.cover)
                                              : Image.asset(
                                                  "assets/placeholder.png",
                                                  fit: BoxFit.cover),
                                        ),
                                      ),

                                      // DATE BOX
                                      Positioned(
                                        top: height * 0.025,
                                        left: width * 0.05,
                                        child: Container(
                                          padding:
                                              EdgeInsets.all(width * 0.015),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(day,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10)),
                                              Text(month,
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10)),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        left: width * 0.04,
                                        bottom: height * 0.015,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event["name"] ?? "",
                                              style: TextStyle(
                                                fontSize: width * 0.032,
                                                color:
                                                    theme.colorScheme.surface,
                                              ),
                                            ),
                                            Text(
                                              "Book Now!",
                                              style: TextStyle(
                                                fontSize: width * 0.035,
                                                color:
                                                    theme.colorScheme.surface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      // --------------------- GAMES -------------------------
                      Text(
                        "Games",
                        style: TextStyle(
                          fontSize: width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge!.color,
                        ),
                      ),

                      SizedBox(
                        height: height * 0.28,
                        child: FutureBuilder<List<dynamic>>(
                          future: gamesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text("No games available");
                            }
                            final games = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: games.length,
                              itemBuilder: (context, index) {
                                final game = games[index];
                                final imageUrl = game["image"]?["img1"];
                                return Container(
                                  width: width * 0.80,
                                  margin: EdgeInsets.all(width * 0.03),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        top: height * 0.01,
                                        bottom: height * 0.05,
                                        right: width * 0.03,
                                        left: width * 0.03,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: imageUrl != null
                                              ? Image.network(imageUrl,
                                                  fit: BoxFit.cover)
                                              : Image.asset(
                                                  "assets/placeholder.png",
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      Positioned(
                                        left: width * 0.04,
                                        bottom: height * 0.015,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              game["name-en"] ?? "",
                                              style: TextStyle(
                                                fontSize: width * 0.032,
                                                color:
                                                    theme.colorScheme.surface,
                                              ),
                                            ),
                                            Text(
                                              "Grab your friends and play!",
                                              style: TextStyle(
                                                fontSize: width * 0.035,
                                                color:
                                                    theme.colorScheme.surface,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: FittedBox(
                          child: ExpandableBookButton(
                            backgroundColor: theme.cardColor,
                            iconColor: theme.colorScheme.primary,
                            onNavigate: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RoomScreen()));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // -------------------- OVERLAY BRANCH MENU --------------------
          if (showBranchesMenu)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() => showBranchesMenu = false);
                },
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                  child: Center(
                    child: Container(
                      width: width * 0.8,
                      constraints: BoxConstraints(maxHeight: height * 0.6),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: branches.isEmpty
                          ? FutureBuilder<List<dynamic>>(
                              future: branchesFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Text("No branches");
                                }
                                // populate local cache and render list
                                final list = snapshot.data!;
                                return ListView(
                                  shrinkWrap: true,
                                  children: list.map((branch) {
                                    final name = (branch['branch_name'] ??
                                            branch['nameEn'] ??
                                            branch['nameAr'] ??
                                            branch['name'] ??
                                            branch['name-en'])?.toString() ??
                                        "Unnamed";
                                    return ListTile(
                                      title: Text(name),
                                      onTap: () {
                                        setState(() {
                                          selectedBranchName = name;
                                          showBranchesMenu = false;
                                          branches = list; // cache
                                        });
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                            )
                          : ListView(
                              shrinkWrap: true,
                              children: branches.map((branch) {
                                final name = (branch['branch_name'] ??
                                        branch['nameEn'] ??
                                        branch['nameAr'] ??
                                        branch['name'] ??
                                        branch['name-en'])?.toString() ??
                                    "Unnamed";
                                return ListTile(
                                  title: Text(name),
                                  onTap: () {
                                    setState(() {
                                      selectedBranchName = name;
                                      showBranchesMenu = false;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getMonthFromNumber(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    if (month < 1 || month > 12) return "Unknown";
    return months[month - 1];
  }

  @override
  bool get wantKeepAlive => true;
}
