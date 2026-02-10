import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wordle/models/result_status.dart';
import 'package:wordle/pages/home.dart';
import 'package:wordle/utils/constants.dart';
import 'package:wordle/models/result_object.dart';
import 'package:wordle/utils/spell_apis.dart';
import 'package:wordle/wordle_daily.dart';
import 'package:wordle/wordle_random.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ResultObjectAdapter());
  Hive.registerAdapter(ResultStatusAdapter());
  await Hive.openBox<ResultObject>(hiveDailyDataField);
  await Hive.openBox<ResultObject>(hiveRandomDataField);
  setPathUrlStrategy();
  await SpellApis().setDailyWords();
  await SpellApis().setCommonWords();
  await SpellApis().setAllWords();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Wordles',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // home: const WordleDaily(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/daily': (context) => const WordleDaily(),
        '/random': (context) => const WordleRandom(),
      },
    );
  }
}
