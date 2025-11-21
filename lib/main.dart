import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';
import 'providers/game_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';
import 'services/ad_service.dart'; 

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await AdService().init(); 
  runApp(const LinguaDashApp());
}

class LinguaDashApp extends StatelessWidget {
  const LinguaDashApp({super.key});
  @override 
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: Consumer<SettingsProvider>(builder: (c, s, _) { 
        return MaterialApp(
          title: 'LinguaDash', 
          debugShowCheckedModeBanner: false, 
          theme: ThemeData(
            fontFamily: s.fontFamily, 
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryPurple), 
            scaffoldBackgroundColor: AppColors.background, 
            useMaterial3: true
          ), 
          home: const SplashScreen()
        ); 
      }),
    );
  }
}