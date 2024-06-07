import 'package:flutter/material.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/screens/main_home_screen.dart';
import 'package:provider/provider.dart';
import 'helper/database_helper.dart';
import 'providers/workout_provider.dart';
import 'providers/navigation_provider.dart';
import 'screens/activities_screen.dart';
import 'utils/color.dart';
import 'package:google_fonts/google_fonts.dart';

var dbHelper = DatabaseHelper();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dbHelper = DatabaseHelper();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'Workout App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor,
          textTheme: GoogleFonts.interTextTheme(),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: primaryBlack,
          ),
          tabBarTheme: TabBarTheme(
            labelColor: primaryBlack,
            unselectedLabelColor: primaryBlack,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlack,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryBlack)
              .copyWith(secondary: primaryBlack),
        ),
        home: MainHomeScreen(),
      ),
    );
  }
}
