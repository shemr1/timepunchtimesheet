class TimeRecord{
  DateTime date;
  Duration duration;

  TimeRecord({
    this.date,
    this.duration,
  });

  TimeRecord.fromJson(Map<String, dynamic>json){
    date = json ['Date'];
    duration = json ['Duration'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data ['Date'] = this.date;
    data ['Duration'] = this.duration;
  }



}