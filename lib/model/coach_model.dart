class CoachModel {
  String coachId;
  String coachFirstName;
  String coachLastName;
  int age;
  String domain;

  CoachModel({
    required this.coachId,
    required this.coachFirstName,
    required this.coachLastName,
    required this.age,
    required this.domain,
  });
  Map<String, dynamic> toMap(){
    return{
      'coachId':coachId,
      'coachFirstName':coachFirstName,
      'coachLastName':coachLastName,
      'age':age,
      'domain':domain
    };
  }
}