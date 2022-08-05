class PuzzleInfo {
  int? puzzle_id;
  String? file_path;
  String? puzzleName;
  String? pattern;
  int? pieces_count;
  String? dateTime;

  PuzzleInfo(
      { this.puzzle_id,
      required this.file_path,
      required this.puzzleName,
      required this.pattern,
        required this.dateTime,
      required this.pieces_count});

//converting puzzle object to Map object to store in database
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (puzzle_id != null) {
      map["puzzle_id"] = puzzle_id;
    }
    map['puzzleName'] = puzzleName;
    map['file_path'] = file_path;
    map['pattern'] = pattern;
    map['pieces_count'] = pieces_count;
    map["dateTime"]=dateTime;

    return map;
  }

  PuzzleInfo.fromMapObject(Map<String, dynamic> map) {
    puzzle_id = map['puzzle_id'];
    puzzleName = map['puzzleName'];
    file_path = map['file_path'];
    pattern = map['pattern'];
    pieces_count = map['pieces_count'];
    dateTime=map["dateTime"];
  }
}
