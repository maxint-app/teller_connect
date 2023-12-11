class PlaidConfig {
  final String? clientName;
  final List<Country> countryCodes;
  final PlaidEnvironment env;
  final String? key;
  final Language language;
  final String? linkCustomizationName;
  final String? oauthNonce;
  final String? oauthRedirectUri;
  final String? oauthStateId;
  final List<Product> product;
  final String? receivedRedirectUri;
  final String? token;
  final String? userEmailAddress;
  final String? userLegalName;
  final String? webhook;

  const PlaidConfig({
    this.clientName,
    this.countryCodes = const [Country.US],
    this.env = PlaidEnvironment.development,
    this.key,
    this.language = Language.en,
    this.linkCustomizationName,
    this.oauthNonce,
    this.oauthRedirectUri,
    this.oauthStateId,
    this.product = const [Product.auth],
    this.receivedRedirectUri,
    this.token,
    this.userEmailAddress,
    this.userLegalName,
    this.webhook,
  });

  factory PlaidConfig.fromJson(Map<String, dynamic> json) {
    return PlaidConfig(
      clientName: json["clientName"],
      countryCodes: (json["countryCodes"] as List<String>)
          .map((e) => Country.values.firstWhere((element) => element.name == e))
          .toList(),
      env: PlaidEnvironment.values
          .firstWhere((element) => element.name == json["env"]),
      key: json["key"],
      language: Language.values
          .firstWhere((element) => element.name == json["language"]),
      linkCustomizationName: json["linkCustomizationName"],
      oauthNonce: json["oauthNonce"],
      oauthRedirectUri: json["oauthRedirectUri"],
      oauthStateId: json["oauthStateId"],
      product: (json["product"] as List<String>)
          .map(
              (e) => Product.values.firstWhere((element) => element.value == e))
          .toList(),
      receivedRedirectUri: json["receivedRedirectUri"],
      token: json["token"],
      userEmailAddress: json["userEmailAddress"],
      userLegalName: json["userLegalName"],
      webhook: json["webhook"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "clientName": clientName,
      "countryCodes": countryCodes.map((e) => e.name).toList(),
      "env": env.name,
      "key": key,
      "language": language.name,
      "linkCustomizationName": linkCustomizationName,
      "oauthNonce": oauthNonce,
      "oauthRedirectUri": oauthRedirectUri,
      "oauthStateId": oauthStateId,
      "product": product.map((e) => e.value).toList(),
      "receivedRedirectUri": receivedRedirectUri,
      "token": token,
      "userEmailAddress": userEmailAddress,
      "userLegalName": userLegalName,
      "webhook": webhook,
    };
  }
}

enum PlaidEnvironment {
  development,
  sandbox,
  production,
}

enum Country {
  // ignore: constant_identifier_names
  CA,
  // ignore: constant_identifier_names
  DE,
  // ignore: constant_identifier_names
  DK,
  // ignore: constant_identifier_names
  EE,
  // ignore: constant_identifier_names
  ES,
  // ignore: constant_identifier_names
  FR,
  // ignore: constant_identifier_names
  GB,
  // ignore: constant_identifier_names
  IE,
  // ignore: constant_identifier_names
  IT,
  // ignore: constant_identifier_names
  LT,
  // ignore: constant_identifier_names
  LV,
  // ignore: constant_identifier_names
  NL,
  // ignore: constant_identifier_names
  NO,
  // ignore: constant_identifier_names
  PL,
  // ignore: constant_identifier_names
  SE,
  // ignore: constant_identifier_names
  US,
}

enum Language {
  da,
  de,
  en,
  es,
  et,
  fr,
  it,
  lt,
  lv,
  nl,
  no,
  po,
  ro,
  se,
}

enum Product {
  assets("assets"),
  auth("auth"),
  employment("employment"),
  identity("identity"),
  identityVerification("identity_verification"),
  income("income"),
  incomeVerification("income_verification"),
  investments("investments"),
  paymentInitiation("payment_initiation"),
  liabilities("liabilities"),
  standingOrders("standing_orders"),
  transactions("transactions"),
  transfer("transfer");

  final String value;

  const Product(this.value);

  factory Product.fromValue(String value) {
    switch (value) {
      case "assets":
        return Product.assets;
      case "auth":
        return Product.auth;
      case "employment":
        return Product.employment;
      case "identity":
        return Product.identity;
      case "identity_verification":
        return Product.identityVerification;
      case "income":
        return Product.income;
      case "income_verification":
        return Product.incomeVerification;
      case "investments":
        return Product.investments;
      case "payment_initiation":
        return Product.paymentInitiation;
      case "liabilities":
        return Product.liabilities;
      case "standing_orders":
        return Product.standingOrders;
      case "transactions":
        return Product.transactions;
      case "transfer":
        return Product.transfer;
      default:
        throw ArgumentError("Invalid value: $value");
    }
  }
}
