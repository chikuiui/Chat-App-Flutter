// Packages
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/navigation_service.dart';

// Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_image.dart';

// Providers
import '../providers/authentication_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signupFormKey = GlobalKey<FormState>();

  late double _deviceHeight;
  late double _deviceWidth;

  // we may have image selected or not.
  PlatformFile? _profileImage;

  String? _name;
  String? _email;
  String? _password;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;
  late NavigationService _navigation;


  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage= GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<NavigationService>();

    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // so when keyboard open the screen should not be resized.
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
            _profileImageField(),
            SizedBox(height: _deviceHeight * 0.05),
            _signUpForm(),
            SizedBox(height: _deviceHeight * 0.05),
            _signUpButton(),
            SizedBox(height: _deviceHeight * 0.05),

          ],
        ),
      ),
    );
  }


  Widget _profileImageField(){

    return GestureDetector(
      onTap: (){
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((file){
          setState(() {
            _profileImage = file;
          });
        });
      },
      child: (){  // anonymous function.
        if(_profileImage != null){
          return RoundedImage(
              image: _profileImage!,
              size:  _deviceHeight * 0.15
          );
        }else{
          return RoundedImageNetwork(
              imagePath: 'https://i.pravatar.cc/1000?img=65',
              size: _deviceHeight * 0.15
          );
        }
      }(),
    );


  }

  Widget _signUpForm(){
    return SizedBox(
      height: _deviceHeight * 0.35,
      child: Form(
          key: _signupFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [

              CustomTextFormField(
                  onSaved: (value){
                    setState(() {
                      _name = value;
                    });
                  },
                  regEx: r'.{8,}',
                  hintText: 'Name',
                  obscureText: false
              ),
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
                  regEx: r'.{8,}',
                  hintText: 'Password',
                  obscureText: true
              ),
            ],
          )
      ),
    );
  }

  Widget _signUpButton(){
    return RoundedButton(
        name: 'Sign Up',
        height: _deviceHeight * 0.065,
        width: _deviceWidth * 0.65,
        onPressed: () async{
           // Validate the user input
           bool isValid = _signupFormKey.currentState!.validate();
           if(!isValid || _profileImage == null)return;
           _signupFormKey.currentState!.save();

           // Sign Up the user
           String? _uid = await _auth.signUpUserUsingEmailAndPassword(_email!, _password!);

           // Store image in storage in firebase.
           String? imageUrl = await _cloudStorage.saveUserImageToStorage(_uid!, _profileImage!);
           // Copy the info into firestore database so we have representation of user data in database.
           await _db.createUser(_uid, _name!, _email!, imageUrl!);
           await _auth.logout();
           await _auth.loginUsingEmailAndPassword(_email!, _password!);
           _navigation.goBack();
        }
    );
  }


}
