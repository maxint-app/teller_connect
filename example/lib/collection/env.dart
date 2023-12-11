import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
class Env {
  @EnviedField(varName: "TELLER_APP_ID")
  static const String tellerAppId = _Env.tellerAppId;

  @EnviedField(varName: "PLAID_LINK_TOKEN")
  static const String plaidLinkToken = _Env.plaidLinkToken;
}
