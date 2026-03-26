import 'package:flutter/material.dart';


class ImageView extends StatelessWidget {
  final String imageUrl;

  const ImageView({
    super.key,
    required this.imageUrl,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
                width: 100,
                height: 100,
                // clips the image to your BorderRadius
                clipBehavior: Clip.antiAlias, 
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Makes the image fill the box
                  errorBuilder: (context, error, stackTrace) {
                    // fallback
                    return Icon(Icons.broken_image, color: Colors.blue);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    // show spinner while getting image
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              );
  }
}