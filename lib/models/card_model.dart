class CardModel {
  final int? id;
  final String cardName;
  final String suit;
  final String imageUrl;
  final int folderId;

  CardModel({this.id, required this.cardName, required this.suit, required this.imageUrl, required this.folderId});

  Map<String, dynamic> toMap() => {
    'id': id,
    'card_name': cardName,
    'suit': suit,
    'image_url': imageUrl,
    'folder_id': folderId,
  };

  factory CardModel.fromMap(Map<String, dynamic> map) => CardModel(
    id: map['id'],
    cardName: map['card_name'],
    suit: map['suit'],
    imageUrl: map['image_url'],
    folderId: map['folder_id'],
  );
}