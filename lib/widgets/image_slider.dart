import 'package:dining_cup/constants/sizes.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final VoidCallback? onTap;

  const ImageSlider({
    super.key,
    required this.imageUrls,
    this.onTap,
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void resetToFirstImage() {
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: widget.imageUrls.isEmpty
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
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) {
                  return AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(
                      widget.imageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.grey,
                          ), // 또는 오류 메시지, 대체 이미지 등을 표시
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
