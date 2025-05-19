
class HabitModel {
    final int? habitId;
    final String habitName;
    final String habitType;
    bool done;
    final String? createdAt;

    HabitModel({
        this.habitId,
        required this.habitName,
        required this.habitType,
        required this.done,
        this.createdAt,
    });

    factory HabitModel.fromMap(Map<String, dynamic> json) => HabitModel(
        habitId: json["habitId"],
        habitName: json["habitName"],
        habitType: json["habitType"],
        done: json["done"]==1,
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toMap() => {
        "habitId": habitId,
        "habitName": habitName,
        "habitType": habitType,
        'done':done ? 1 : 0,
        "createdAt": createdAt,
    };
}