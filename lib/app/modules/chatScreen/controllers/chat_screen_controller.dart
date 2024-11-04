import 'dart:async';
import 'package:get/get.dart';
import 'package:space_texting/app/services/database_helper.dart';

class ChatScreenController extends GetxController {
  final count = 0.obs;
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map> allChats = [];
  RxBool isLoading = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Start the periodic timer to fetch chat users every second
    _startChatUserRefresh();
  }

  void increment() => count.value++;

  // Get the list of users you have chatted with
  Future<List<Map>> getChatUsers() async {
    return await dbHelper.getChatUsers();
  }

  // Refresh chat users every second
  void _startChatUserRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      allChats = await getChatUsers();
      isLoading.value = false;
      // You can update the UI by triggering a state update if necessary.
      update(); // This will update the GetX state management
    });
  }
}
