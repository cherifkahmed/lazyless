
class FocusModel {
    final int? focusId;
    final String pickedTime;
    final String focusTime;
    final int? breakNumber;
    final String? createdAt;

    FocusModel({
        this.focusId,
        required this.pickedTime,
        required this.focusTime,
        required this.breakNumber,
        this.createdAt,
    });

    factory FocusModel.fromMap(Map<String, dynamic> json) => FocusModel(
        focusId: json["focusId"],
        pickedTime: json["pickedTime"],
        focusTime: json["focusTime"],
        breakNumber: json["breakNumber"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toMap() => {
        "focusId": focusId,
        "pickedTime": pickedTime,
        "focusTime": focusTime,
        "breakNumber": breakNumber,
        "createdAt": createdAt,
    };
}
