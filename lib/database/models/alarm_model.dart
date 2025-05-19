class AlarmModel {
    final int habitId;
    final String alarmHour;
    final String alarmMinute;

    AlarmModel({
        required this.habitId,
        required this.alarmHour,
        required this.alarmMinute,
    });

    factory AlarmModel.fromMap(Map<String, dynamic> json) => AlarmModel(
        habitId: json["habitId"],
        alarmHour: json["alarmHour"],
        alarmMinute: json["alarmMinute"],
    );

    Map<String, dynamic> toMap() => {
        "habitId": habitId,
        "alarmHour": alarmHour,
        "alarmMinute": alarmMinute,
    };
}