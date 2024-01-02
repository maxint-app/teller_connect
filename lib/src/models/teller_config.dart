enum TellerEnvironment {
  sandbox,
  development,
  production,
}

enum SelectAccount {
  disabled,
  single,
  multiple,
}

class TellerConfig {
  /// Your Teller application id, can be found in https//teller.io/settings/application.
  final String appId;

  /// The environment to use for enrolling the user's accounts.
  final TellerEnvironment? environment;

  ///  The institution id.
  ///  If set, Teller Connect will skip the institution picker
  ///  and load the first step for the corresponding institution.
  final String? institution;

  ///  Can be set to one of
  ///  `disabled` - automatically connect all the supported financial accounts associated with this user's account at the institution (default)
  ///  `single` - the user will see a list of supported financial accounts and will need to select one to connect
  ///  `multiple` - the user will see a list of supported financial accounts and will need to select one or more to connect
  final SelectAccount? selectAccount;

  /// Set to true to disable going back to the picker screen from an institution screen.
  final bool skipPicker;

  ///  The User ID of the Teller user
  ///  you want to add more enrollments to.
  final String? userId;

  ///  The ID of the Teller enrollment
  ///  you want to update if it has become disconnected.
  final String? enrollmentId;

  /// The Connect Token returned by one of Teller API's endpoints
  /// and used to initialize Teller Connect to perform a particular task
  /// (e.g. as completing a payment requiring multi-factor authentication).
  final String? connectToken;

  /// The host to use for the Teller Connect server.
  /// Defaults to https://teller.io.
  ///
  /// Useful for Teller Sidecar proxy for plaid users.
  final String host;

  const TellerConfig({
    required this.appId,
    this.environment,
    this.institution,
    this.selectAccount = SelectAccount.disabled,
    this.skipPicker = false,
    this.userId,
    this.enrollmentId,
    this.connectToken,
    this.host = "https://teller.io",
  });

  Map<String, dynamic> toJson() {
    return {
      "app_id": appId,
      "environment": environment?.name,
      "institution": institution,
      "select_account": selectAccount?.name,
      "skip_picker": skipPicker.toString(),
      "user_id": userId,
      "enrollment_id": enrollmentId,
      "connect_token": connectToken,
    }..removeWhere((key, value) => value == null);
  }

  Map<String, dynamic> toJsMap() {
    return {
      "applicationId": appId,
      "environment": environment?.name,
      "institution": institution,
      "selectAccount": selectAccount?.name,
      "enrollmentId": enrollmentId,
      "connectToken": connectToken,
    }..removeWhere((key, value) => value == null);
  }

  Map<String, dynamic> queryParams() {
    return toJson()..removeWhere((key, value) => ["app_id"].contains(key));
  }

  Uri toUri() {
    return Uri.parse(
      "$host/connect/$appId",
    ).replace(
      queryParameters: queryParams(),
    );
  }
}
