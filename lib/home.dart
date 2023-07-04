import 'dart:io';
import 'package:activitypub/config.dart';
import 'package:fedodo_general/Extensions/string_extensions.dart';
import 'package:fedodo_general/Extensions/url_extensions.dart';
import 'package:fedodo_general/Globals/general.dart';
import 'package:fedodo_general/Globals/preferences.dart';
import 'package:fedodo_general/SuSi/APIs/login_manager.dart';
import 'package:fedodo_ui_photo/navigation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Config.accessToken = Preferences.prefs?.getString("AccessToken");
    Config.domainName = Preferences.prefs?.getString("DomainName");
    Config.ownActorId = General.actorId;
    Config.asProxyString = (String value) {
      return value.asFedodoProxyString();
    };
    Config.asProxyUri = (Uri value) {
      return value.asFedodoProxyUri();
    };
    Config.refreshAccessToken = () async {
      LoginManager loginManager = LoginManager(!kIsWeb && Platform.isAndroid);
      await loginManager.refreshAsync();
      Config.accessToken = Preferences.prefs?.getString("AccessToken");
    };
    Config.logger = General.logger;

    return const Navigation();
  }
}
