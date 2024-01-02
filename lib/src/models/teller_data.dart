class TellerUser {
  final String id;
  const TellerUser({required this.id});

  factory TellerUser.fromJson(Map<String, dynamic> json) =>
      TellerUser(id: json['id']);

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class TellerInstitution {
  final String name;
  const TellerInstitution({required this.name});

  factory TellerInstitution.fromJson(Map<String, dynamic> json) =>
      TellerInstitution(name: json['name']);

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

class TellerEnrollment {
  final String id;
  final TellerInstitution institution;

  const TellerEnrollment({
    required this.id,
    required this.institution,
  });

  factory TellerEnrollment.fromJson(Map<String, dynamic> json) =>
      TellerEnrollment(
        id: json['id'],
        institution: TellerInstitution.fromJson(json['institution']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'institution': institution.toJson(),
      };
}

class TellerData {
  final String accessToken;
  final List<String> signatures;
  final TellerUser user;
  final TellerEnrollment enrollment;

  const TellerData({
    required this.accessToken,
    required this.signatures,
    required this.user,
    required this.enrollment,
  });

  factory TellerData.fromJson(Map<String, dynamic> json) {
    return TellerData(
      accessToken: json['accessToken'],
      signatures: List.from(json['signatures']),
      user: TellerUser.fromJson(json['user']),
      enrollment: TellerEnrollment.fromJson(json['enrollment']),
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'signatures': signatures,
        'user': user.toJson(),
        'enrollment': enrollment.toJson(),
      };
}
