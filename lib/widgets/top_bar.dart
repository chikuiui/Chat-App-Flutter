// Package
import 'package:flutter/material.dart';


class CustomTopBar extends StatelessWidget{

  CustomTopBar(this.barTitle,
  {
    super.key,
    this.primaryAction,
    this.secondaryAction,
    this.fontSize = 35
  });

  String barTitle;
  Widget? primaryAction;
  Widget? secondaryAction;
  double? fontSize;

  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return _buildUI();
  }

  Widget _buildUI(){
    return Container(
      height: _deviceHeight * 0.10,
      width: _deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(secondaryAction != null) secondaryAction!,
          _titleBar(),
          if(primaryAction != null) primaryAction!
        ],
      ),
    );
  }


  Widget _titleBar(){
    return Text(
      barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w700
      ),
    );
  }

}