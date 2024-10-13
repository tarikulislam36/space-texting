import 'package:get/get.dart';
import 'package:space_texting/app/services/socket_io_service.dart';
import 'package:space_texting/app/services/database_helper.dart'; // Import the database helper

class ChatController extends GetxController {
  late SocketService socketService;
  var messages = <Map<String, dynamic>>[].obs; // Store messages
  var isConnected = false.obs;
  DatabaseHelper dbHelper = DatabaseHelper(); // Initialize the database helper

  @override
  void onInit() {
    super.onInit();
    socketService = SocketService();
  }

  // Connect to the socket
  void connectSocket(String userId, String targetUserId) {
    print("connection request send");
    socketService.connectSocket(userId, targetUserId);

    // Load previous chat history from the database
    loadMessagesFromDb(userId, targetUserId);

    // Listen for socket connection events
    socketService.socket?.on('connect', (_) {
      isConnected.value = true;
      print('Connected to the socket');
    });

    socketService.socket?.on('disconnect', (_) {
      isConnected.value = false;
      print('Disconnected from the socket');
    });

    // Listen for incoming messages
    socketService.socket?.on('receive_message', (data) async {
      print("data get ${data}");
      messages.add(data); // Add the received message to the list

      // Save message to the local database
      await dbHelper.insertMessage(data);
    });
  }

  // Send a message
  void sendMessage(String senderId, String receiverId, String message,
      String type, String time, String date, String receverName) async {
    if (isConnected.value) {
      // Send the message via the socket
      socketService.sendMessage(
          senderId, receiverId, message, type, time, date);

      // Add the message to the local list and database
      Map<String, dynamic> newMessage = {
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'isSender': 1,
        'type': type,
        'time': time,
        'date': date,
      };

      messages.add(newMessage);
      await dbHelper.insertMessage(newMessage);

      // Save the user ID to the chat users list
      await dbHelper.insertOrUpdateChatUser(
          receiverId, receverName, date, time, message);
    } else {
      print('Not connected to the socket');
    }
  }

  // Load messages from local database
  Future<void> loadMessagesFromDb(String userId, String targetUserId) async {
    List<Map<String, dynamic>> localMessages =
        await dbHelper.getMessages(userId, targetUserId);
    messages.addAll(localMessages); // Load into the observable list
  }

  @override
  void onClose() {
    socketService.disconnectSocket();
    super.onClose();
  }
}
