// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Services
import './services/navigation_service.dart';

// Screens
import './screens/splash_screen.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';
import './screens/signup_screen.dart';

// Providers
import './providers/authentication_provider.dart';


final colorScheme = ColorScheme.fromSwatch().copyWith(
  surface: const Color.fromRGBO(36, 35, 49 , 1.0)
);


final theme = ThemeData().copyWith(
    scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
);



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (BuildContext context){
              return AuthenticationProvider();
            }
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chatify',
        theme: theme.copyWith(
                 bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                 backgroundColor: Color.fromRGBO(30, 29, 37, 1.0)
               )
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login' : (BuildContext context) => const LogInScreen(),
          '/home' : (BuildContext context) => const HomeScreen(),
          '/signup' : (BuildContext context) => const SignUpScreen()
        },
      ),
    );
  }

}

void main() {

  runApp(
      SplashScreen(
          key: UniqueKey(),
          onInitializationComplete: (){
               runApp(const MyApp());
          }
      )
  );
}