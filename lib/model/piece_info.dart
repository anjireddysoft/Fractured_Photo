class Piece_Info {
  int? puzzleId;
  int? rotation;
  int? currentPosition;
  int? originalPosition;
  String? image;



  Piece_Info(
      {  this.puzzleId,
        required this.rotation,
        required this.currentPosition,
         this.image,
        required this.originalPosition});

  Piece_Info.fromJson(Map<String, dynamic> json) {
    puzzleId = json['puzzle_Id'];
    rotation = json['rotation'];
    currentPosition = json['current_Position'];
    image = json['image'];
    originalPosition = json['original_Position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['puzzle_Id'] = this.puzzleId;
    data['rotation'] = this.rotation;
    data['current_Position'] = this.currentPosition;
    data['original_Position'] = this.originalPosition;
    data['image'] = this.image;

    return data;
  }
}