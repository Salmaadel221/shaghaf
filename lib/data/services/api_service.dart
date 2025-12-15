import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shagf/data/models/notification_item.dart';
import 'package:shagf/data/models/roof_model.dart';
import 'package:shagf/data/models/room_model.dart';
import 'package:shagf/data/models/booking.dart';

class ApiService {
  static const String _notificationsEndpoint = '/notification';
 static const String baseUrl = "https://co-work-backend-test.up.railway.app";

  // ================== HELPERS ==================
  static Future<String?> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  static String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  // ================== EVENTS & GAMES & BRANCHES ==================

  /// GET /events
  static Future<List<dynamic>> getEvents() async {
    final url = Uri.parse("$baseUrl/events");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load events");
    }
  }

  /// GET /api/games/all
  static Future<List<dynamic>> getGames() async {
    final url = Uri.parse("$baseUrl/api/games/all");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load games");
    }
  }

  /// GET /branches
  static Future<List<dynamic>> getBranches() async {
    final url = Uri.parse("$baseUrl/branches");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load branches");
    }
  }

  // ================== ROOMS ==================
  static Future<RoomModel> getRoomById(String roomId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/rooms/$roomId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return RoomModel.fromJson(json.decode(response.body));
    } else {
      print('API Error for room $roomId: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load room: ${response.statusCode}');
    }
  }

  static Future<List<RoomModel>> getRoomsById(List<String> roomIds) async {
    final List<Future<RoomModel>> fetchFutures =
        roomIds.map((id) => getRoomById(id)).toList();

    try {
      final rooms = await Future.wait(fetchFutures);
      return rooms;
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }

  // ================== ROOFS ==================
  static Future<RoofModel> getRoofById(String roofId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/roof/$roofId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return RoofModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load roof: ${response.statusCode}');
    }
  }

  static Future<List<RoofModel>> getAllRoofs() async {
    // Endpoint عام بدون فرع
    final response = await http.get(
      Uri.parse('$baseUrl/roof/'), // تأكدي من وجود endpoint عام للأسطح
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => RoofModel.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      print('API Info: No roofs found (404). Returning empty list.');
      return []; // Return empty list on 404 (Not Found)
    } else {
      print('API Error for roofs: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load roofs: ${response.statusCode}');
    }
  }

  // ================== BOOKINGS ==================
static Future<Booking> createBooking({
  required String roomId,
  required String branchId,
  required String date,
  required String startTime,
  required String endTime,
  required double totalPrice,
  required String depositScreenshotUrl,
}) async {
  final token = await FirebaseAuth.instance.currentUser!.getIdToken();

  final response = await http.post(
    Uri.parse("${ApiService.baseUrl}/api/bookings/create"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "roomId": roomId,
      "branchId": branchId,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "totalPrice": totalPrice,
      "depositScreenshotUrl": depositScreenshotUrl,
    }),
  );

  if (response.statusCode == 201) {
    return Booking.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to create booking: ${response.body}");
  }
}


  static Future<Booking> getBookingById(String bookingId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/bookings/$bookingId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Booking.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load booking: ${response.statusCode}');
    }
  }

  // ================== PAYMENTS ==================
  static Future<String> uploadPaymentProof(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/payments/upload-proof'),
    );

    request.files.add(await http.MultipartFile.fromPath('receipt', imageFile.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['url'] ?? data['imageUrl'] ?? '';
    } else {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
  }

  // ================== USER PROFILE ==================
  static Future<String> uploadProfilePicture(File file) async {
    final token = await _getToken();
    // تم حذف userId من هنا لأنه سيتم استخراجه من التوكن في الخادم
    if (token == null) throw Exception("User not logged in");

    final url = Uri.parse("$baseUrl/profilePicture/upload-profile-picture");
    final request = http.MultipartRequest("POST", url );

    request.headers["Authorization"] = "Bearer $token";
    // لم نعد بحاجة لإرسال userId كحقل منفصل
    // request.fields["userId"] = userId;

    request.files.add(await http.MultipartFile.fromPath("file", file.path ));

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();
    final data = jsonDecode(responseBody);

    if (streamedResponse.statusCode == 200) {
      return data["profilePicture"] ?? "";
    } else {
      throw Exception(data["message"] ?? "Failed to upload profile picture");
    }
  }

  static Future<void> updateUserProfile({
    required String nameEn,
    required String email,
    required String phone,
    required String personalId,
  }) async {
    final token = await _getToken();
    final userId = currentUserId;
    if (token == null || userId == null) throw Exception("User not logged in");

    final url = Uri.parse("$baseUrl/users/$userId");

    //  التعديل: تم تغيير أسماء الحقول لتتطابق مع الخادم
    final body = {
      "email": email,
      "name": nameEn,      // تم التغيير من "name-en" إلى "name"
      "phone": phone,
      "personalId": personalId, // تم التغيير من "user_id" إلى "personalId"
    };

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body ),
    );

    if (response.statusCode != 200) {
      // طباعة جسم الاستجابة يساعد في تصحيح الأخطاء
      print("Failed to update user. Status: ${response.statusCode}, Body: ${response.body}");
      throw Exception("Failed to update user: ${response.body}");
    }
  }


  // ================== AVAILABILITY ==================
  static Future<bool> checkRoomAvailability({
    required String roomId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/rooms/check-availability'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'roomId': roomId,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['available'] == true;
    } else {
      return false;
    }
  }


static Future<List<NotificationItem>> fetchNotifications() async {
    final uri = Uri.parse('$baseUrl$_notificationsEndpoint');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      late final List list;

      if (body is List) {
        list = body;
      } else if (body is Map && body['notifications'] is List) {
        list = body['notifications'];
      } else if (body is Map) {
        list = [body];
      } else {
        throw Exception('Unexpected notifications response format');
      }

      return list
          .map(
            (item) => NotificationItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load notifications (status: ${response.statusCode})',
      );
    }
  }


}

final apiService = ApiService();


  
  

