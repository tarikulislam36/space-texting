import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:space_texting/app/services/socket_io_service.dart';

class ChatController extends GetxController {
  late SocketService socketService;
  var messages = <Map<String, dynamic>>[].obs; // Store messages
  var isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    socketService = SocketService();
  }

  // Connect to the socket
  void connectSocket(String userId, String targetUserId) {
    print("connection request send");
    socketService.connectSocket(userId, targetUserId);

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
    socketService.socket?.on('receive_message', (data) {
      print("data get ${data}");
      messages.add(data); // Add the received message to the list
    });
  }

  // Send a message
  void sendMessage(
      String senderId, String receiverId, String message, String type) {
    if (isConnected.value) {
      socketService.sendMessage(senderId, receiverId, message, type);
      messages.add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'isSender': true,
        "type": type,
      });
    } else {
      print('Not connected to the socket');
    }
  }

  @override
  void onClose() {
    socketService.disconnectSocket();
    super.onClose();
  }
}
