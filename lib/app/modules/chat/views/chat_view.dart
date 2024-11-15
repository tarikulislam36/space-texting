import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:space_texting/app/modules/chat/controllers/chat_controller.dart';
import 'package:space_texting/app/modules/chat/views/bubble_chat.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/date_format.dart';
import 'package:space_texting/app/services/dialog_helper.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/app/services/socket_io_service.dart';
import 'package:space_texting/constants/assets.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class ChatView extends StatefulWidget {
  final String name;
  final String profileImage;
  final bool isOnline;
  final String targetUserId;
  final String userId;

  const ChatView({
    Key? key,
    required this.name,
    required this.profileImage,
    this.isOnline = false,
    required this.targetUserId,
    required this.userId,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late PageController _pageController;
  ChatController chatController = Get.put(ChatController());
  final _messageController = TextEditingController();
  late Timer _backgroundTimer;
  int _currentBackgroundIndex = 0;

  // List of background images

  void _showMediaOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 34, 14, 66),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              InkWell(
                onTap: () {},
                child: ListTile(
                  leading: const Icon(Icons.image, color: Colors.white),
                  title: const Text('Image',
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    await _pickAndUploadImage();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);
      File? compressedImageFile = await _compressImage(imageFile);

      if (compressedImageFile != null) {
        DialogHelper.showLoading();
        try {
          String downloadUrl =
              await _uploadToFirebase(compressedImageFile, 'images');
          if (downloadUrl.isNotEmpty) {
            chatController.sendMessage(
                widget.userId,
                widget.targetUserId,
                downloadUrl,
                "photo",
                DateFormat('h:mma').format(DateTime.now()).toLowerCase(),
                DateFormat('MM-dd-yy').format(DateTime.now()),
                widget.name);
            _messageController.clear();
          }
          print('Image uploaded successfully. URL: $downloadUrl');
          DialogHelper.hideDialog();
        } catch (e) {
          DialogHelper.hideDialog();
          print('Error uploading image: $e');
        }
      }
    }
  }

  Future<File?> _compressImage(File imageFile) async {
    try {
      final img.Image originalImage =
          img.decodeImage(await imageFile.readAsBytes())!;
      final img.Image resizedImage = img.copyResize(originalImage, width: 800);
      final List<int> compressedImageData =
          img.encodeJpg(resizedImage, quality: 80);

      final String fileName = path.basename(imageFile.path);
      final File compressedFile =
          File('${imageFile.parent.path}/compressed_$fileName');

      await compressedFile.writeAsBytes(compressedImageData);
      return compressedFile;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  Future<String> _uploadToFirebase(File file, String folder) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = storage.ref().child('$folder/$fileName');

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  late List<Color> _gradientColors;

  @override
  void initState() {
    super.initState();

    getChatBg();
    _pageController = PageController();
    _gradientColors = _generateRandomGradientColors();

    // Initialize background image timer
    _backgroundTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentBackgroundIndex = (_currentBackgroundIndex + 1) %
            Get.find<ChatController>().backgroundImages.length;
      });
    });

    chatController.connectSocket(widget.userId, widget.targetUserId);
  }

  void getChatBg() async {
    Map<String, dynamic> chatBg = await Get.find<ChatController>()
            .dbHelper
            .getChatBg(widget.targetUserId) ??
        {};

    print("Background Data : ${chatBg}");
    int v = chatBg["isActive"] ?? 1;
    chatController.isBgActive.value = v == 1;

    if (chatBg["imageList"] != null && chatBg["imageList"].isNotEmpty) {
      chatController.backgroundImages.value = chatBg["imageList"];
    }
  }

  List<Color> _generateRandomGradientColors() {
    final Random random = Random();
    double hue;

    do {
      hue = random.nextDouble() * 360;
    } while (hue >= 90 && hue <= 150);

    final double saturation = 0.5 + random.nextDouble() * 0.5;
    final double lightness = 0.5;

    Color color1 = HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
    Color color2 =
        HSLColor.fromAHSL(1.0, (hue + 30) % 360, saturation, lightness)
            .toColor();

    return [color1, color2];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundTimer.cancel(); // Cancel timer to avoid memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Obx(
        () => GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < 0) {
              print("swipe down");
              if (!chatController.isMoreLoading.value) {
                chatController.goDown();
              }
            } else if (details.delta.dy > 0) {
              // Swiping down - load next messages

              // Swiping up - load previous messages
              print("swip up");
              if (!chatController.isMoreLoading.value) {
                chatController.goUp();
              }
            }
          },
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: Duration(seconds: 2),
                child: Container(
                  key: ValueKey<int>(_currentBackgroundIndex),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: chatController.isBgActive.value
                          ? chatController.backgroundImages[0]
                                  .contains("com.joy.space_texting")
                              ? FileImage(File(chatController.backgroundImages[
                                  _currentBackgroundIndex])) as ImageProvider
                              : AssetImage(Get.find<ChatController>()
                                  .backgroundImages[_currentBackgroundIndex])
                          : const AssetImage(Assets.assetsBackground),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(widget.targetUserId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.VIEW_PROFILE,
                                          arguments: {
                                            "targetUserId": widget.targetUserId
                                          });
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              widget.profileImage.isEmpty
                                                  ? const AssetImage(
                                                      "assets/default_user.jpg")
                                                  : NetworkImage(
                                                          widget.profileImage)
                                                      as ImageProvider<Object>,
                                          radius: 24,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (snapshot.hasData)
                                              Text(
                                                snapshot.data!.data()![
                                                            "isOnline"] &&
                                                        isRecentlyActive((snapshot
                                                                        .data!
                                                                        .data()![
                                                                    "lastSeen"]
                                                                as Timestamp)
                                                            .toDate())
                                                    ? 'Online'
                                                    : isRecentlyActive((snapshot
                                                                        .data!
                                                                        .data()![
                                                                    "lastSeen"]
                                                                as Timestamp)
                                                            .toDate())
                                                        ? 'Last seen recently'
                                                        : formatDateTime((snapshot
                                                                        .data!
                                                                        .data()![
                                                                    "lastSeen"]
                                                                as Timestamp)
                                                            .toDate()),
                                                style: TextStyle(
                                                  color: snapshot.data!
                                                          .data()!["isOnline"]
                                                      ? Colors.greenAccent
                                                      : Colors.grey[300],
                                                  fontSize: 12,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            const Spacer(),
                            InkWell(
                                onTap: () async {
                                  Get.toNamed(Routes.VOICE_CALL, arguments: {
                                    "receiverId": widget.targetUserId,
                                    'isCaller': true,
                                    'name': widget.name,
                                    'profileImage': widget.profileImage,
                                  });
                                },
                                child: const Icon(Icons.call,
                                    color: Colors.white)),
                            const SizedBox(width: 20),
                            InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.VIDEO_CALL, arguments: {
                                    "receiverId": widget.targetUserId,
                                    'isCaller': true,
                                  });
                                },
                                child: const Icon(Icons.videocam,
                                    color: Colors.white)),
                            const SizedBox(width: 20),
                            PopupMenuButton<int>(
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.white),
                              color: const Color.fromARGB(255, 44, 40, 40)
                                  .withOpacity(0.8),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.chat_bubble_outline,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      Text('Clear Chat',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(Icons.image, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text(
                                          chatController.isBgActive.value
                                              ? "Inavtive Background"
                                              : 'Active Background',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) async {
                                if (value == 1) {
                                  print('Block User');
                                } else if (value == 2) {
                                  chatController.clearChat(
                                    widget.userId,
                                    widget.targetUserId,
                                  );
                                  Get.back();
                                  print('Clear Chat');
                                } else if (value == 3) {
                                  if (chatController.isBgActive.value) {
                                    chatController.dbHelper
                                        .insertOrUpdateChatBg(
                                            widget.targetUserId, false, []);
                                    chatController.isBgActive.value = false;
                                    Get.snackbar(
                                        "Message", "Background disabled");
                                  } else {
                                    final ImagePicker _picker = ImagePicker();
                                    List<XFile>? images = await _picker
                                        .pickMultiImage(); // open gallery and allow multiple selection

                                    if (images != null && images.isNotEmpty) {
                                      // Get the file paths of the selected images
                                      List<String> imagePaths = images
                                          .map((image) => image.path)
                                          .toList();

                                      // Store the paths in your database or list
                                      chatController.dbHelper
                                          .insertOrUpdateChatBg(
                                              widget.targetUserId,
                                              true,
                                              imagePaths);
                                      chatController.isBgActive.value = true;
                                      chatController.backgroundImages.value =
                                          imagePaths;
                                      Get.snackbar("Message",
                                          "Background updated with selected images");
                                    } else {
                                      Get.snackbar(
                                          "Message", "No images selected");
                                    }
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              chatController.messages.isNotEmpty
                                  ? getFormattedDate(chatController
                                      .messages.value.last["date"])
                                  : "Today",
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 14),
                            ),
                          ),
                        ),
                        ...chatController.messages
                            .sublist(
                                chatController.messages.length < 5
                                    ? 0
                                    : chatController.messages.length -
                                        (chatController.currentIndex.value + 5),
                                chatController.messages.length -
                                    chatController.currentIndex.value)
                            .map(
                          (element) {
                            return ChatBubble(
                              senderName: widget.name,
                              isSender: element['isSender'] ?? 0,
                              text: "${element["message"]}",
                              time: "${element["time"]}",
                              date: "${element["date"]}",
                              receiverId: "${element[widget.targetUserId]}",
                              type: element["type"] ??
                                  identifyContentType(element["message"]),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  buildMessageInputField(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageInputField() {
    return Container(
      height: 60,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // "+" Icon for opening media options (moved to the left)
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: Colors.white),
            onPressed: () {
              _showMediaOptions(context);
            }, // Open media options when tapped
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.emoji_emotions, color: Colors.white),
            onPressed: () async {
              GiphyGif? gif = await GiphyGet.getGif(
                context: context, //Required
                apiKey: "s9ZjuJ6GRnhhi6OlY96DbOAeSFTWU7Q9", //Required.
                // Optional - An ID/proxy for a specific user.
                tabColor: const Color.fromARGB(
                    255, 25, 22, 61), // Optional- default accent color.
                debounceTimeInMilliseconds:
                    350, // Optional- time to pause between search keystrokes
              );
              if (gif != null) {
                chatController.sendMessage(
                    widget.userId,
                    widget.targetUserId,
                    gif.images!.downsizedSmall!.mp4,
                    "gif",
                    DateFormat('h:mma').format(DateTime.now()).toLowerCase(),
                    DateFormat('MM-dd-yy').format(DateTime.now()),
                    widget.name);
              }
              print(gif!.images!.downsizedSmall!.mp4);
            }, // Open media options when tapped
          ),
          // Send message icon
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              String message = _messageController.text.trim();
              if (message.length > 85) {
                Get.snackbar("Error", "Message is so long!");
                return;
              }
              if (message.isNotEmpty) {
                chatController.sendMessage(
                    widget.userId,
                    widget.targetUserId,
                    message,
                    "message",
                    DateFormat('h:mma').format(DateTime.now()).toLowerCase(),
                    DateFormat('MM-dd-yy').format(DateTime.now()),
                    widget.name);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
