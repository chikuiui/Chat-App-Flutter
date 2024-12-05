// Package
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class RoundedImageNetwork extends StatelessWidget{
  const RoundedImageNetwork({
    super.key,
    required this.imagePath,
    required this.size
  });

  final String imagePath;
  final double size;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imagePath)
        ),
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: Colors.black
      ),
    );
  }
}


class RoundedImage extends StatelessWidget{
  const RoundedImage({
    super.key,
    required this.image,
    required this.size
  });

  final PlatformFile image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              // image: AssetImage(image.path!)   // not work bcz the image is not in the asset.
              image: FileImage(File(image.path!))
          ),
          borderRadius: BorderRadius.all(Radius.circular(size)),
          color: Colors.black
      ),
    );
  }
}


class RoundedImageNetworkWithStatusIndicator extends RoundedImageNetwork{

  const RoundedImageNetworkWithStatusIndicator({
    super.key,
    required super.imagePath,
    required super.size,
    required this.isActive
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,   // if widgets go beyond the size do not clip them
      alignment: Alignment.bottomRight,
      children: [
        super.build(context),
        Container(
          height: size * 0.20,
          width: size * 0.20,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(size)
          ),
        )
      ],
    );
  }


}