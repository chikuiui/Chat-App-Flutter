// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';

// Providers
import '../providers/authentication_provider.dart';

// Services
import '../services/navigation_service.dart';

class LogInScreen extends StatefulWidget{
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() {
    return _LoginScreenState();
  }

}

class _LoginScreenState extends State<LogInScreen>{
  late double _deviceHeight;
  late double _deviceWidth;

  final _loginFormKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  late AuthenticationProvider _auth;
  late NavigationService _navigation;



  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return _buildUI();
  }

  Widget _buildUI(){
    return Scaffold(
       body: Container(
         padding: EdgeInsets.symmetric(
           horizontal: _deviceWidth * 0.03,
           vertical: _deviceHeight * 0.02
         ),
         height: _deviceHeight * 0.98,
         width: _deviceWidth * 0.97,
         child: Column(
           mainAxisSize: MainAxisSize.max,
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             _screenTitle(),
             SizedBox(height: _deviceHeight * 0.04),
             _loginForm(),
             SizedBox(height: _deviceHeight * 0.05),
             _loginButton(),
             SizedBox(height: _deviceHeight * 0.02),
             _registerAccountLink()
           ],
         ),
       ),
    );
  }

  Widget _screenTitle(){
    return SizedBox(
      height: _deviceHeight * 0.10,
      child: const Text(
          'Chatify',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight:  FontWeight.w600
          ),
      ),
    );
  }

  Widget _loginForm(){
    return SizedBox(
      height: _deviceHeight *  0.18,
      child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               CustomTextFormField(
                  onSaved: (value){
                    setState(() {
                      _email = value;
                    });
                  },
                  regEx: r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  hintText: 'Email',
                  obscureText: false
               ),
               CustomTextFormField(
                  onSaved: (value){
                    setState(() {
                      _password = value;
                    });
                  },
                  regEx: r".{8,}", // at least 8 characters.
                  hintText: 'Password',
                  obscureText: true
               ),

            ],
          )
      ) ,
    );
  }

  Widget _loginButton(){
    return RoundedButton(
        name: 'Login',
        height: _deviceHeight * 0.065,
        width: _deviceWidth * 0.65,
        onPressed: (){
           bool isValid = _loginFormKey.currentState!.validate();
           if(!isValid)return;
           _loginFormKey.currentState!.save();
           _auth.loginUsingEmailAndPassword(_email!, _password!);
        }
    );
  }

  Widget _registerAccountLink(){
     return GestureDetector(
       onTap: () => _navigation.navigateToRoute('/signup'),
       child: const Text("Don't have an account", style: TextStyle(color: Colors.blueAccent)),
     );
  }

}
