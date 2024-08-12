import 'package:flutter/material.dart';

class ImagePost extends StatelessWidget {
  final String text;
  final String url;
  const ImagePost({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            text,
          ),
        ],
      ),
    );
  }
}
