import '../database/database_helper.dart';
import '../models/card_model.dart';

class CardRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insertCard(CardModel card) async {
    final db = await dbHelper.database;
    return await db.insert('Cards', card.toMap());
  }

  Future<List<CardModel>> getCardsByFolder(int folderId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Cards', 
      where: 'folder_id = ?', 
      whereArgs: [folderId]
    );
    return maps.map((map) => CardModel.fromMap(map)).toList();
  }

  Future<int> deleteCard(int id) async {
    final db = await dbHelper.database;
    return await db.delete('Cards', where: 'id = ?', whereArgs: [id]);
  }
}