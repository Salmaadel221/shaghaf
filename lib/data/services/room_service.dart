// lib/data/services/backend_api_service.dart

import 'package:shagf/data/models/roof_model.dart';
import 'package:shagf/data/models/room_model.dart';
import 'package:shagf/data/models/booking.dart';
import 'package:shagf/data/services/api_service.dart';

class BackendApiService {
  /// Rooms
  Future<RoomModel> getRoomById(String roomId) {
    return ApiService.getRoomById(roomId);
  }

  Future<List<RoomModel>> getRoomsById(List<String> roomIds) {
    return ApiService.getRoomsById(roomIds);
  }

  /// Roofs
  Future<RoofModel> getRoofById(String roofId) {
    return ApiService.getRoofById(roofId);
  }

  Future<List<RoofModel>> getAllRoofs() {
    return ApiService.getAllRoofs();
  }

  /// Availability
  Future<bool> checkRoomAvailability({
    required String roomId,
    required String date,
    required String startTime,
    required String endTime,
  }) {
    return ApiService.checkRoomAvailability(
      roomId: roomId,
      date: date,
      startTime: startTime,
      endTime: endTime,
    );
  }

  /// Booking (بس Forward مش Logic)
  Future<Booking> getBookingById(String bookingId) {
    return ApiService.getBookingById(bookingId);
  }
}

final backendApiService = BackendApiService();
