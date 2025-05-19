class UserModel {
  String userId;
  String userFirstName;
  String userLastName;
  int userAge;
  String condition;

  UserModel({
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userAge,
    required this.condition,
  });
  Map<String, dynamic> toMap(){
    return{
      'userId':userId,
      'userFirstName':userFirstName,
      'userLastName':userLastName,
      'userAge':userAge,
      'condition':condition
    };
  }
}