import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learn_drawing/theme_app.dart';
import 'package:learn_drawing/game_route.dart';
import 'package:learn_drawing/home_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(
    MaterialApp(
      home: HomeRoute(),
      routes: <String,WidgetBuilder>{
        '/home':(BuildContext context)=>new HomeRoute(),
        '/game':(BuildContext context)=>new GameRoute()
      },
      theme: ThemeData(
        primaryColor: MyAppTheme.primary,
        primaryColorDark: MyAppTheme.primaryDark,
        accentColor: MyAppTheme.accent,
        textTheme: GoogleFonts.acmeTextTheme().copyWith(
          button: GoogleFonts.ubuntuMono(
            fontSize: 16,
            fontWeight: FontWeight.bold
          )
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: MyAppTheme.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)
          ),
          textTheme: ButtonTextTheme.primary
        )
      ),
    )
  );
}



