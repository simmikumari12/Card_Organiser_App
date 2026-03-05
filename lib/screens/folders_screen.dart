import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'cards_screen.dart';

class FoldersScreen extends StatefulWidget {
  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  List<Map<String, dynamic>> _folders = [];

  @override
  void initState() {
    super.initState();
    _refreshFolders();
  }

  void _refreshFolders() async {
    final db = await DatabaseHelper.instance.database;
    // Query folders with a subquery to count cards (Requirement: Show card count)
    final data = await db.rawQuery('''
      SELECT f.*, (SELECT COUNT(*) FROM Cards WHERE folder_id = f.id) as card_count 
      FROM Folders f
    ''');
    setState(() { _folders = data; });
  }

  void _deleteFolder(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('Folders', where: 'id = ?', whereArgs: [id]);
    _refreshFolders();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Folder and its cards deleted (Cascade)')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Suit Folders')),
      body: ListView.builder(
        itemCount: _folders.length,
        itemBuilder: (context, index) {
          final folder = _folders[index];
          return ListTile(
            leading: Icon(Icons.folder, color: Colors.blue, size: 40),
            title: Text(folder['folder_name'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${folder['card_count']} Cards'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(folder['id'], folder['folder_name']),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CardsScreen(folderId: folder['id'], folderName: folder['folder_name'])),
            ).then((_) => _refreshFolders()),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $name?'),
        content: Text('This will delete the folder and ALL cards inside it. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('CANCEL')),
          TextButton(onPressed: () { _deleteFolder(id); Navigator.pop(context); }, child: Text('DELETE', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}