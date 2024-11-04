import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chat_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        senderId TEXT,
        receiverId TEXT,
        message TEXT,
        type TEXT,
        time TEXT,
        date TEXT,
        isSender INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_users (
        userId TEXT PRIMARY KEY,
        name TEXT,
        date TEXT,
        time TEXT,
        lastMessage TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_bg (
        userId TEXT PRIMARY KEY,
        isActive INT,
        imageList TEXT
      )
    ''');
  }

  // Insert message
  Future<int> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    print("insert meaase");
    return await db.insert('messages', message);
  }

  Future<int> clearAllMessages(String senderId, String receiverId) async {
    final db = await database;
    return await db.delete(
      'messages',
      where:
          '(senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?)',
      whereArgs: [senderId, receiverId, receiverId, senderId],
    );
  }

  // Insert or update chat user
  Future<int> insertOrUpdateChatUser(String userId, String name, String date,
      String time, String lastMessage) async {
    final db = await database;
    print("insert user chat called");
    // Use conflict algorithm to update the record if it already exists
    return await db.insert(
        'chat_users',
        {
          'userId': userId,
          'name': name,
          'date': date,
          'time': time,
          'lastMessage': lastMessage,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get messages for a specific chat
  Future<List<Map<String, dynamic>>> getMessages(
      String userId, String targetUserId) async {
    final db = await database;
    return await db.query(
      'messages',
      where:
          '(senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?)',
      whereArgs: [userId, targetUserId, targetUserId, userId],
      orderBy: 'time ASC',
    );
  }

  // Get all chat users with their details
  Future<List<Map<String, dynamic>>> getChatUsers() async {
    final db = await database;
    return await db.query('chat_users');
  }

  // Get a specific chat user by userId
  Future<Map<String, dynamic>?> getChatUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'chat_users',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return result.isNotEmpty ? result.first : null;
  }

  // Insert or update chat background images for a user
  Future<int> insertOrUpdateChatBg(
      String userId, bool isActive, List<String> imageList) async {
    final db = await database;

    // Convert the imageList to a JSON string
    String imageListJson = jsonEncode(imageList);

    return await db.insert(
      'chat_bg',
      {
        'userId': userId,
        'isActive': isActive ? 1 : 0,
        'imageList': imageListJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
    );
  }

  // Get chat background images for a specific user
  Future<Map<String, dynamic>?> getChatBg(String userId) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'chat_bg',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      // Create a new map to avoid modifying the read-only result map
      Map<String, dynamic> chatBgData = Map<String, dynamic>.from(result.first);

      // Decode the imageList JSON string back to a list of strings
      List<String> imageList =
          List<String>.from(jsonDecode(chatBgData['imageList']));
      chatBgData['imageList'] = imageList; // Replace string with list

      return chatBgData;
    }

    return null;
  }

  // Check if chat background is active for a specific user
  Future<bool> isChatBgActive(String userId) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'chat_bg',
      columns: ['isActive'],
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return result.first['isActive'] == 1;
    }

    return true; // Default if no record exists
  }

  Future<int> deleteMessage(
      String messageText, String messageDate, String messageTime) async {
    final db = await database;
    return await db.delete(
      'messages',
      where: 'message = ? AND date = ? AND time = ?',
      whereArgs: [messageText, messageDate, messageTime],
    );
  }

  // Clear all data from every table
  Future<void> clearAllData() async {
    final db = await database;

    // Delete all rows from each table
    await db.delete('messages');
    await db.delete('chat_users');
    await db.delete('chat_bg');
  }
}
