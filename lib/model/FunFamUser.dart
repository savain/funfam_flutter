class FunFamUser {
  FunFamUser({
    required this.uid,
    required this.email,
    required this.nickname,
    this.avatarRef,
  });

  FunFamUser.fromJson(Map<String, Object?> json)
      : this(
    uid: json['uid']! as String,
    email: json['email']! as String,
    nickname: json['nickname']! as String,
    avatarRef: json['avatarRef'] as String?,
  );

  final String uid;
  final String nickname;
  final String email;
  final String? avatarRef;

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'avatarRef': avatarRef,
    };
  }
}