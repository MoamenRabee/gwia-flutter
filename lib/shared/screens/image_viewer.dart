import 'package:flutter/material.dart';
import 'package:gwia/models/message_model.dart';
import 'package:gwia/services/services.dart';

class ImageViewerScreen extends StatelessWidget {
  ImageViewerScreen({Key? key, required this.messageModel}) : super(key: key);

  MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/logo.png",
          width: 130.0,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Center(
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: DioHelper.base_link + messageModel.image.toString(),
                width: double.infinity,
                placeholderFit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
