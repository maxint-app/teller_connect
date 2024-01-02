import 'dart:async';

import 'package:teller_connect/src/models/teller_data.dart';

export './iframe_helper_web.dart'
    if (dart.library.io) './iframe_helper_io.dart';

final tellerSuccessStreamController = StreamController<TellerData>.broadcast();

Stream<TellerData> get tellerSuccessStream =>
    tellerSuccessStreamController.stream;

final tellerExitStreamController = StreamController<void>.broadcast();

Stream<void> get tellerExitStream => tellerExitStreamController.stream;
