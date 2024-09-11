class UserModel {
  final String username;
  final String userId;
  final String profileUrl;
  final String phoneNumber;
  final List<String> groupId;
  final bool active;
  final int lastSeen;

  UserModel({
    required this.username,
    required this.userId,
    required this.profileUrl,
    required this.phoneNumber,
    required this.groupId,
    required this.active,
    required this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userId': userId,
      'profileImageUrl': profileUrl,
      'active': active,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      userId: map['userId'] ?? '',
      profileUrl: map['profileImageUrl'] ?? '',
      active: map['active'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
      lastSeen: map['lastSeen'] ?? 0,
    );
  }
}