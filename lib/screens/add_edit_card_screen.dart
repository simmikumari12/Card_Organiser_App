import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddEditCardScreen extends StatefulWidget {
  final int folderId;
  final Map<String, dynamic>? card; // Null if adding new
  AddEditCardScreen({required this.folderId, this.card});

  @override
  _AddEditCardScreenState createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _nameController.text = widget.card!['card_name'];
      _urlController.text = widget.card!['image_url'];
    }
  }

  void _save() async {
    final db = await DatabaseHelper.instance.database;
    final data = {
      'card_name': _nameController.text,
      'image_url': _urlController.text,
      'suit': 'Manual', // Or pass the suit name if needed
      'folder_id': widget.folderId,
    };

    if (widget.card == null) {
      await db.insert('Cards', data);
    } else {
      await db.update('Cards', data, where: 'id = ?', whereArgs: [widget.card!['id']]);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.card == null ? 'Add Card' : 'Edit Card')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Card Name')),
            TextField(controller: _urlController, decoration: InputDecoration(labelText: 'Image URL')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: Text('Save Card')),
          ],
        ),
      ),
    );
  }
}