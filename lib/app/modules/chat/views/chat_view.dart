import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/components/gif_video_player.dart';
import 'package:space_texting/app/modules/chat/controllers/chat_controller.dart';
import 'package:space_texting/app/modules/chat/views/bubble_chat.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/dialog_helper.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/app/services/socket_io_service.dart';
import 'package:space_texting/constants/assets.dart';
import 'package:image/image.dart' as img; // Importing the image package
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

  void _showMediaOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color.fromARGB(255, 34, 14, 66),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              InkWell(
                onTap: () {},
                child: ListTile(
                  leading: const Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Image',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    // Handle image selection here
                    await _pickAndUploadImage();
                    Navigator.pop(context);
                  },
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  leading: const Icon(
                    Icons.insert_drive_file,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Document',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    // Handle document selection here
                    await _pickAndUploadDocument();
                    Navigator.pop(context);
                  },
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  leading: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Location',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Handle location sharing here
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

      // Compress the image
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

// Function to compress the image
  Future<File?> _compressImage(File imageFile) async {
    try {
      // Read the image file
      final img.Image originalImage =
          img.decodeImage(await imageFile.readAsBytes())!;

      // Resize the image (you can specify the width and height as needed)
      final img.Image resizedImage =
          img.copyResize(originalImage, width: 800); // Resize width to 800px

      // Convert the resized image back to bytes
      final List<int> compressedImageData =
          img.encodeJpg(resizedImage, quality: 80); // Set quality to 80

      // Create a new file to save the compressed image
      final String fileName = path.basename(imageFile.path);
      final File compressedFile =
          File('${imageFile.parent.path}/compressed_$fileName');

      // Write the compressed image data to the new file
      await compressedFile.writeAsBytes(compressedImageData);

      return compressedFile; // Return the compressed file
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

// Function to pick and upload a document
  Future<void> _pickAndUploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      DialogHelper.showLoading();
      File file = File(result.files.single.path!);

      try {
        String downloadUrl = await _uploadToFirebase(file, 'documents');
        if (downloadUrl.isNotEmpty) {
          chatController.sendMessage(
              widget.userId,
              widget.targetUserId,
              downloadUrl,
              "document",
              DateFormat('h:mma').format(DateTime.now()).toLowerCase(),
              DateFormat('MM-dd-yy').format(DateTime.now()),
              widget.name);
          _messageController.clear();
        }
        DialogHelper.hideDialog();
      } catch (e) {
        DialogHelper.hideDialog();
        print('Error uploading document: $e');
      }
    }
  }

// Function to upload files to Firebase Storage and return the download URL
  Future<String> _uploadToFirebase(File file, String folder) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = storage.ref().child('$folder/$fileName');

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});

    // Get download URL after successful upload
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  late List<Color> _gradientColors;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _gradientColors = _generateRandomGradientColors();

    chatController.connectSocket(widget.userId, widget.targetUserId);
  }

  List<Color> _generateRandomGradientColors() {
    final Random random = Random();
    double hue;

    // Generate a hue that does not fall within the green range (90-150 degrees)
    do {
      hue = random.nextDouble() * 360; // Random hue between 0 and 360
    } while (hue >= 90 && hue <= 150); // Repeat until we get a valid hue

    final double saturation =
        0.5 + random.nextDouble() * 0.5; // Random saturation between 0.5 and 1
    final double lightness = 0.5; // Fixed lightness to ensure readability

    Color color1 = HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
    Color color2 =
        HSLColor.fromAHSL(1.0, (hue + 30) % 360, saturation, lightness)
            .toColor(); // Slightly different hue

    return [color1, color2];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.userId} llll ${widget.targetUserId}");
    return Scaffold(
      body: Obx(
        () => Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.assetsBackground),
              fit: BoxFit.cover,
            ),
          ),
          height: Get.height,
          width: Get.width,
          child: Column(
            children: [
              // Gradient AppBar with rounded corners
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Get.back(); // Navigate back to the previous screen
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.VIEW_PROFILE);
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: widget.profileImage.isEmpty
                                    ? const AssetImage(
                                        "assets/default_user.jpg") // Provide a default local asset image
                                    : NetworkImage(
                                        widget
                                            .profileImage) as ImageProvider<
                                        Object>, // Use the profile image URL
                                radius: 24,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.isOnline ? 'Online' : 'Offline',
                                    style: TextStyle(
                                      color: widget.isOnline
                                          ? Colors.greenAccent
                                          : Colors.grey[300],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              Get.toNamed(Routes.VIDEO_CALL, arguments: {
                                "callId": "joysarkarcalltest",
                                "receiverId": "joysarkar",
                                'isCaller': false,
                              });
                            },
                            child: const Icon(Icons.call, color: Colors.white)),
                        const SizedBox(width: 20),
                        InkWell(
                            onTap: () {
                              Get.toNamed(Routes.VIDEO_CALL, arguments: {
                                "callId": "joysarkarcalltest",
                                "receiverId": "joysarkar",
                                'isCaller': true,
                              });
                            },
                            child: const Icon(Icons.videocam,
                                color: Colors.white)),
                        const SizedBox(width: 20),
                        PopupMenuButton<int>(
                          icon: const Icon(Icons.more_vert,
                              color: Colors.white), // More options icon
                          color: const Color.fromARGB(255, 44, 40, 40)
                              .withOpacity(
                                  0.8), // Set the background color with opacity
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.block, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Block User',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.chat_bubble_outline,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Clear Chat',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 1) {
                              // Handle Block User action
                              print('Block User');
                            } else if (value == 2) {
                              // Handle Clear Chat action
                              print('Clear Chat');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Chat list (Chat messages)
              Expanded(
                child: Stack(
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Today',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ),
                    ),
                    ...chatController.messages
                        .sublist(
                      chatController.messages.length >= 5
                          ? chatController.messages.length - 5
                          : 0,
                    )
                        .map(
                      (element) {
                        return ChatBubble(
                          senderName: widget.name,
                          isSender: element['isSender'] ??
                              0, // Assuming messages have 'isSender' field
                          text:
                              "${element["message"]}", // Assuming messages have 'message' field
                          time: "7:10 AM",
                          type: element["type"] ??
                              identifyContentType(element[
                                  "message"]), // Adjust time based on the message if needed
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Message input field
              buildMessageInputField(),
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
