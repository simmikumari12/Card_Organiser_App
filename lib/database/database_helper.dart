import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('card_organizer.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        // Essential for Q4: Enable Foreign Key support for CASCADE delete
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Create Folders Table
    await db.execute('''
      CREATE TABLE Folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_name TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    // 2. Create Cards Table with CASCADE DELETE
    await db.execute('''
      CREATE TABLE Cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        card_name TEXT NOT NULL,
        suit TEXT NOT NULL,
        image_url TEXT NOT NULL,
        folder_id INTEGER NOT NULL,
        FOREIGN KEY (folder_id) REFERENCES Folders (id) ON DELETE CASCADE
      )
    ''');

    // 3. Automated Prepopulation (Requirement: 13 cards per suit)
    final List<Map<String, String>> suits = [
      {'name': 'Hearts', 'code': 'H'},
      {'name': 'Spades', 'code': 'S'},
      {'name': 'Diamonds', 'code': 'D'},
      {'name': 'Clubs', 'code': 'C'},
    ];

    final List<String> ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'J', 'Q', 'K'];

    for (int i = 0; i < suits.length; i++) {
      // Insert Folder and get its ID
      int folderId = await db.insert('Folders', {
        'folder_name': suits[i]['name'],
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Insert all 13 cards for this suit using the Network URL pattern
      for (var rank in ranks) {
        String displayRank = rank == '0' ? '10' : rank;
        await db.insert('Cards', {
          'card_name': '$displayRank of ${suits[i]['name']}',
          'suit': suits[i]['name']!,
          'image_url': 'https://deckofcardsapi.com/static/img/$rank${suits[i]['code']}.png',
          'folder_id': folderId,
        });
      }
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}