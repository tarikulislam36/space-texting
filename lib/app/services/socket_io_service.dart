import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? socket;

  void connectSocket(String userId, String targetUserId) {
    try {
      socket = IO.io('http://82.180.139.1:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket?.connect();

      socket?.onConnect((_) {
        print('Connected to the server');
        socket?.emit('join', {'userId': userId, 'targetUserId': targetUserId});
      });

      // Listen for messages
      socket?.on('receive_message', (data) {
        print('Message received: $data');
        // Handle the incoming message (update the chat UI)
      });

      // Listen for message deletions
      socket?.on('message_deleted', (data) {
        print('Message deleted: $data');
        // Remove the message from the chat UI
      });

      socket?.onDisconnect((_) {
        print('Disconnected from the server');
      });

      socket?.onError((data) {
        print('Error: $data');
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void sendMessage(String senderId, String receiverId, String message,
      String type, String time, String date) {
    if (socket != null && socket!.connected) {
      socket?.emit('send_message', {
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'type': type,
        'time': time,
        'date': date,
      });
    } else {
      print('Socket not connected');
    }
  }

  void deleteMessage(String message, String time, String date) {
    if (socket != null && socket!.connected) {
      socket?.emit('delete_message', {
        'senderId': "",
        'receiverId': "",
        "message": message,
        "time": time,
        "date": date,
      });
    } else {
      print('Socket not connected');
    }
  }

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

  if (input.contains("images")) {
    return 'photo';
  }

  if (input.contains("documents")) {
    return 'document';
  }

  // If no match is found, return unknown
  return 'message';
}
