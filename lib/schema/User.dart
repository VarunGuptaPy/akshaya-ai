class User {
  String name;
  String email;
  int grade;
  DateTime dob;
  String phoneNumber;
  String uid;
  int streak;
  int timeSpent;
  int totalAnswerSolved;
  int totalAnswerCorrect;

  User({
    required this.name,
    required this.email,
    required this.grade,
    required this.dob,
    required this.phoneNumber,
    required this.uid,
    this.streak = 0,
    this.timeSpent = 0,
    this.totalAnswerSolved = 0,
    this.totalAnswerCorrect = 0,
  });

  // Factory method to create a User from a map (for JSON serialization)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      grade: json['grade'],
      dob: DateTime.parse(json['dob']),
      phoneNumber: json['phoneNumber'],
      uid: json['uid'],
      streak: json['streak'] ?? 0,
      timeSpent: json['timeSpent'] ?? 0,
      totalAnswerSolved: json['totalAnswerSolved'] ?? 0,
      totalAnswerCorrect: json['totalAnswerCorrect'] ?? 0,
    );
  }

  // Method to convert a User instance to a map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'grade': grade,
      'dob': dob.toIso8601String(),
      'phoneNumber': phoneNumber,
      'uid': uid,
      'streak': streak,
      'timeSpent': timeSpent,
      'totalAnswerSolved': totalAnswerSolved,
      'totalAnswerCorrect': totalAnswerCorrect,
    };
  }
}
