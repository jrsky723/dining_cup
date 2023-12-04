import 'package:dining_cup/constants/sizes.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageUrls;
  final VoidCallback? onTap;

  const ImageSlider({
    super.key,
    required this.imageUrls,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: imageUrls.isEmpty
            ? Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(
                    Icons.no_photography_outlined,
                    color: Colors.grey,
                    size: Sizes.size48,
                  ),
                ),
              )
            : PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
