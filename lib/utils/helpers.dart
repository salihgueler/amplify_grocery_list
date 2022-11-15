import 'package:flutter/foundation.dart';

bool isMobile() =>
    defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;