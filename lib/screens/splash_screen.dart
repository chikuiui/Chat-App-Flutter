// Packages
import 'package:chatapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Services
import '../main.dart';
import '../services/cloud_storage_service.dart';
import '../services/database_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';



class SplashScreen extends StatefulWidget{

  const SplashScreen({
    required Key key,
    required this.onInitializationComplete
  }) : super(key: key);

  final VoidCallback onInitializationComplete;


  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }

}


class _SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1)).then( (_){
      _setup().then((_) => widget.onInitializationComplete());
    });

  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    _registerServices();
  }

  void _registerServices(){
    // get_it -> used to create singleton of any class.
    // so that when we are using those methods in those classes we don't have to create multiple instances of those
    // classes in different screens.
      GetIt.instance.registerSingleton<NavigationService>(NavigationService());
      GetIt.instance.registerSingleton<MediaService>(MediaService());
      GetIt.instance.registerSingleton<CloudStorageService>(CloudStorageService());
      GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatify',
      theme: theme,
      home:Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image : AssetImage('assets/images/logo.png')
                )
            ),
          ),
        ),
      ) ,
    );

  }

}