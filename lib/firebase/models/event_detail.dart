
class EventDetail {
  String id;
  String description;
  String date;
  String startTime;
  String endTime;
  String speaker;
  String isFavorite;

  EventDetail({
    this.id,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.speaker,
    this.isFavorite,
  });

  EventDetail.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.description = obj['description'];
    this.date = obj['date'];
    this.startTime = obj['start_time'];
    this.endTime = obj['end_time'];
    this.speaker = obj['speaker'];
    this.isFavorite = obj['is_favourite'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['description'] = description;
    map['date'] = date;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['speaker'] = speaker;
    map['is_favourite'] = isFavorite;

    return map;
  }
}
