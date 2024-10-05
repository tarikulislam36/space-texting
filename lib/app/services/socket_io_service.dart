import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;

  // Initialize and connect to Socket.IO server
  void connectSocket(String userId, String targetUserId) {
    print("connect socket called");

    try {
      socket = IO.io('http://82.180.139.1:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false, // You can choose when to connect manually
      });

      // Establish connection
      socket?.connect();

      // Join the specific room for one-to-one chat
      socket?.onConnect((_) {
        print('Connected to the server');
        socket?.emit('join', {'userId': userId, 'targetUserId': targetUserId});
      });

      // Listen for messages from the server

      // Handle disconnection
      socket?.onDisconnect((_) {
        print('Disconnected from the server');
      });

      socket?.onError((data) {
        print('Error: $data');
      });
    } catch (e) {
      print("error $e");
    }
  }

  // Send a message to the specific room (one-to-one)
  void sendMessage(
      String senderId, String receiverId, String message, String type) {
    if (socket != null && socket!.connected) {
      socket?.emit('send_message', {
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        "type": type,
      });
    } else {
      print('Socket not connected');
    }
  }

  // Disconnect the socket when not needed
  void disconnectSocket() {
    socket?.disconnect();
  }
}

String identifyContentType(String input) {
  // Check if the input contains a Giphy URL
  if (input.contains('giphy.com')) {
    return 'gif';
  }

  // Check if the input contains a photo extension
  final photoExtensions = ['.png', '.jpg', '.jpeg', '.gif'];
  for (String extension in photoExtensions) {
    if (input.endsWith(extension)) {
      return 'photo';
    }
  }

  // Check if the input contains a document extension
  final documentExtensions = [
    '.pdf',
    '.doc',
    '.docx',
    '.xls',
    '.xlsx',
    '.ppt',
    '.pptx'
  ];
  for (String extension in documentExtensions) {
    if (input.endsWith(extension)) {
      return 'document';
    }
  }

  // If no match is found, return unknown
  return 'message';
}
