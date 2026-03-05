import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_edit_card_screen.dart';

class CardsScreen extends StatefulWidget {
  final int folderId;
  final String folderName;
  CardsScreen({required this.folderId, required this.folderName});

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<Map<String, dynamic>> _cards = [];

  void _refreshCards() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query('Cards', where: 'folder_id = ?', whereArgs: [widget.folderId]);
    setState(() { _cards = data; });
  }

  @override
  void initState() {
    super.initState();
    _refreshCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.folderName} Cards')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return Card(
            child: Column(
              children: [
                Expanded(child: Image.network(card['image_url'], fit: BoxFit.contain)),
                Text(card['card_name'], style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: Icon(Icons.edit, size: 20), onPressed: () => _navigateAddEdit(card)),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () async {
                      final db = await DatabaseHelper.instance.database;
                      await db.delete('Cards', where: 'id = ?', whereArgs: [card['id']]);
                      _refreshCards();
                    }),
                  ],
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateAddEdit(null),
      ),
    );
  }

  void _navigateAddEdit(Map<String, dynamic>? card) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditCardScreen(folderId: widget.folderId, card: card)),
    ).then((_) => _refreshCards());
  }
}