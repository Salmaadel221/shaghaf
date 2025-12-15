
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shagf/data/models/roof_model.dart';
import 'package:shagf/data/models/room_model.dart';
import 'package:shagf/data/services/api_service.dart';
import 'package:shagf/presentation/screens/booking/booking_overview_screen.dart';
import 'package:shagf/presentation/screens/booking/booking_selection.dart';
import 'package:shagf/presentation/screens/room/rooms_tab_content%20(2).dart';
import 'package:shagf/presentation/widgets/bottom_bar.dart';
import 'package:shagf/presentation/widgets/tab_selector.dart';
import 'roof_tab_content.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key}); // branchId اتشال

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  int _selectedTabIndex = 0; // 0 = Rooms, 1 = Roof
  List<RoomModel> _allRooms = [];
  List<RoofModel> _allRoofs = [];
  bool _isLoading = true;

  List<BookingSelection> _roomsBookings = [];
  List<BookingSelection> _roofsBookings = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    List<RoomModel> rooms = [];
    List<RoofModel> roofs = [];
    String? errorMessage;

    try {
      // جلب كل الأسطح بدون branch
      roofs = await ApiService.getAllRoofs();
    } catch (e) {
      errorMessage = 'خطأ في تحميل الأسطح: $e';
      print('Error loading roofs: $e');
    }

    try {
      // جلب الغرف باستخدام معرفات محددة
      const List<String> roomIds = [
        'Small%20Study%20Room',
        'gaming%20room2',
        'study%20room3',
      ];
      rooms = await ApiService.getRoomsById(roomIds);
      print('Fetched Rooms Count: ${rooms.length}');
    } catch (e) {
      if (errorMessage == null) {
        errorMessage = 'خطأ في تحميل الغرف: $e';
      }
      print('Error loading rooms: $e');
    }

    setState(() {
      _allRooms = rooms;
      _allRoofs = roofs;
      _isLoading = false;
    });

    if (errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  void _handleRoomsBookingsChanged(List<BookingSelection> bookings) {
    setState(() => _roomsBookings = bookings);
  }

  void _handleRoofsBookingsChanged(List<BookingSelection> bookings) {
    setState(() => _roofsBookings = bookings);
  }

  double _getTotalPrice() {
    double total = 0;

    for (var booking in _roomsBookings) {
      final room = _allRooms.firstWhere(
        (r) => r.id == booking.roomId,
        orElse: () => RoomModel(
          id: '',
          images: [],
          nameEn: '',
          nameAr: '',
          pricePerHour: 0,
          availableHours: [],
        ),
      );
      total += booking.getTotalPrice(room.pricePerHour);
    }

    for (var booking in _roofsBookings) {
      final roof = _allRoofs.firstWhere(
        (r) => r.id == booking.roomId,
        orElse: () => RoofModel(
          nameEn: "Roof",
          nameAr: "سطح",
          descriptionAr: "",
          descriptionEn: "",
          isActive: true,
          numOfChairs: 0,
          pricePerHour: 0,
          images: [],
          id: '',
        ),
      );
      total += booking.getTotalPrice(roof.pricePerHour);
    }

    return total;
  }

  void _clearBookings() {
    setState(() {
      _roomsBookings = [];
      _roofsBookings = [];
    });
  }

  void _handleCheckout() {
    final allBookings = [..._roomsBookings, ..._roofsBookings];

    if (allBookings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا توجد حجوزات للدفع'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingOverviewScreen(
          rooms: _allRooms,
          roofs: _allRoofs,
          roomsBookings: _roomsBookings,
          roofsBookings: _roofsBookings,
        ),
      ),
    ).then((_) => _clearBookings());
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF5C7363),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFF2F0D9)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            children: [
              TabSelector(
                selectedTab: _selectedTabIndex == 0 ? 'Rooms' : 'Roof',
                onTabSelected: (tab) {
                  setState(() {
                    _selectedTabIndex = tab == 'Rooms' ? 0 : 1;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: IndexedStack(
                  index: _selectedTabIndex,
                  children: [
                    RoomsTabContent(
                      key: const ValueKey('rooms-tab'),
                      rooms: _allRooms,
                      onBookingsChanged: _handleRoomsBookingsChanged,
                    ),
                    RoofTabContent(
                      key: const ValueKey('roof-tab'),
                      roofs: _allRoofs,
                      onBookingsChanged: _handleRoofsBookingsChanged,
                    ),
                  ],
                ),
              ),
              BottomBar(
                totalPrice: _getTotalPrice(),
                onCheckout: _handleCheckout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
