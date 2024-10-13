import 'package:get/get.dart';
import 'package:space_texting/app/services/database_helper.dart';

class ChatScreenController extends GetxController {
  //TODO: Implement ChatScreenController

  final count = 0.obs;
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Map> allChats = [];
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    allChats = await getChatUsers();
    isLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Get the list of users you have chatted with
  Future<List<Map>> getChatUsers() async {
    return await dbHelper.getChatUsers();
  }
}
