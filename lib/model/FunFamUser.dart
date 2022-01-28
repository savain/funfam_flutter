class FunFamUser {
  FunFamUser({
    required this.uid,
    required this.email,
    required this.nickname,
    this.avatarUrl,
  });

  FunFamUser.fromJson(Map<String, Object?> json)
      : this(
          uid: json['uid']! as String,
          email: json['email']! as String,
          nickname: json['nickname']! as String,
          avatarUrl: json['avatarUrl'] as String?,
        );

  final String uid;
  final String nickname;
  final String email;
  final String? avatarUrl;

  Map<String, Object?> toJson() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
    };
  }
}
