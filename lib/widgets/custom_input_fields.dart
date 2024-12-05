import 'package:flutter/material.dart';



class CustomTextFormField extends StatelessWidget{
  const CustomTextFormField({
    super.key,
    required this.onSaved,
    required this.regEx,
    required this.hintText,
    required this.obscureText
  });

  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.white,
      obscureText: obscureText,
      style: const TextStyle(color : Colors.white),
      validator: (value){
        return RegExp(regEx).hasMatch(value!) ? null : 'Enter a valid ${hintText.toLowerCase()} .';
      },
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54)
      ),

    );
  }
}

class CustomTextField extends StatelessWidget {

  const CustomTextField({
    super.key,
    required this.onEditingComplete,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.icon
  });

  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // using lambda fun.. so this can be only triggered when we invoke the onEditingComplete function.
      onEditingComplete: () => onEditingComplete(controller.value.text),
      cursorColor: Colors.white,
      style: const TextStyle(color : Colors.white),
      obscureText: obscureText,
      decoration:  InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54)
      ),
    );
  }

}