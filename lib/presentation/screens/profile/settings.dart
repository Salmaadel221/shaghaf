import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagf/core/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<bool> toggles = [false, false];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // -------------------------------
                // 🔔 Notification
                // -------------------------------
                buildSettingItem(
                  context: context,
                  icon: Icons.notifications,
                  text: "Notification",
                  index: 0,
                  onToggle: () {},
                ),
                SizedBox(height: 20),
                Divider(
                  color: Theme.of(context).colorScheme.secondary,
                  thickness: 2,
                ),

                const SizedBox(height: 20),

                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Preferences",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Language
                    buildStaticContainer(
                      context: context,
                      icon: Icons.language,
                      title: "Language",
                      trailing: "العربية",
                    ),

                    const SizedBox(height: 10),

                    // Dark Mode
                    buildSettingItem(
                      context: context,
                      icon: Icons.dark_mode,
                      text: "Dark Mode",
                      index: 1,
                      onToggle: () {
                        themeProvider.toggleTheme(!themeProvider.isDarkMode);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Divider(
                  color: Theme.of(context).colorScheme.secondary,
                  thickness: 2,
                ),

                const SizedBox(height: 20),

                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Privacy & Security",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 340,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 50),
                            child: Icon(Icons.lock, color: Color(0xFF133E39)),
                          ),
                          Text(
                            "Change Password",
                            style: TextStyle(
                                color: Color(0xFF133E39), fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 340,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 50),
                            child: Icon(Icons.privacy_tip_outlined,
                                color: Color(0xFF133E39)),
                          ),
                          Text(
                            "Privacy Policy",
                            style: TextStyle(
                                color: Color(0xFF133E39), fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 340,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 50),
                            child: Icon(Icons.delete_outline,
                                color: Color(0xFF133E39)),
                          ),
                          Text(
                            "Delete Account",
                            style: TextStyle(
                                color: Color(0xFF133E39), fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 340,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 50),
                            child: Icon(Icons.help_outline,
                                color: Color(0xFF133E39)),
                          ),
                          Text(
                            "Help Center",
                            style: TextStyle(
                                color: Color(0xFF133E39), fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 340,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 50),
                            child: Icon(Icons.description_outlined,
                                color: Color(0xFF133E39)),
                          ),
                          Text(
                            "Terms Of Service",
                            style: TextStyle(
                                color: Color(0xFF133E39), fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 340,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 50),
                            child: Icon(Icons.info_outline,
                                color: Color(0xFF133E39)),
                          ),
                          Text(
                            "About",
                            style: TextStyle(
                                color: Color(0xFF133E39), fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔧 إعداد الـ setting items (اللي فيها toggle)
  // -------------------------------------------------------
  Widget buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required int index,
    required VoidCallback onToggle,
  }) {
    return Container(
      width: 340,
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 18,
            ),
          ),
          ToggleButtons(
            isSelected: [toggles[index]],
            borderColor: Colors.transparent,
            selectedBorderColor: Colors.transparent,
            fillColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            borderWidth: 0,
            onPressed: (i) {
              setState(() {
                toggles[index] = !toggles[index];
              });

              // Apply theme change if needed
              onToggle();
            },
            children: [
              toggles[index]
                  ? Icon(Icons.toggle_on,
                      size: 40, color: Theme.of(context).colorScheme.secondary)
                  : Icon(Icons.toggle_off_outlined,
                      size: 40, color: Theme.of(context).colorScheme.secondary),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // 🔧 إعداد الكونتينرات الثابتة
  // -------------------------------------------------------
  Widget buildStaticContainer({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? trailing,
  }) {
    return Container(
      width: 340,
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 18,
            ),
          ),
          if (trailing != null)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                trailing,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
