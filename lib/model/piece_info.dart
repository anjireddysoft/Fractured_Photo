class Piece_Info {
  int? puzzleId;
 late  int angle;
  int? currentPosition;
  int? originalPosition;
  String? image;



  Piece_Info(
      {  this.puzzleId,
        required this.angle,
        required this.currentPosition,
         this.image,
        required this.originalPosition});

  Piece_Info.fromJson(Map<String, dynamic> json) {
    puzzleId = json['puzzle_Id'];
    angle = json['angle'];
    currentPosition = json['current_Position'];
    image = json['image'];
    originalPosition = json['original_Position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['puzzle_Id'] = puzzleId;
    data['angle'] = angle;
    data['current_Position'] = currentPosition;
    data['original_Position'] = originalPosition;
    data['image'] = image;

    return data;
  }
}
