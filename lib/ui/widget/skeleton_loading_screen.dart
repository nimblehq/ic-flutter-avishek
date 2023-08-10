import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoadingScreen extends StatelessWidget {
  const SkeletonLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 28,
          right: 20,
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.white12,
          highlightColor: Colors.white30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSkeleton(screenWidth),
              const Expanded(child: SizedBox.shrink()),
              _buildSkeleton(width: screenWidth / 6),
              const SizedBox(height: 18),
              _buildSkeleton(width: screenWidth / 1.5),
              const SizedBox(height: 10),
              _buildSkeleton(width: screenWidth / 3),
              const SizedBox(height: 18),
              _buildSkeleton(width: screenWidth / 1.2),
              const SizedBox(height: 10),
              _buildSkeleton(width: screenWidth / 1.5),
              const SizedBox(height: 54),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildHeaderSkeleton(double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeleton(width: screenWidth / 2),
              const SizedBox(height: 16),
              _buildSkeleton(width: screenWidth / 3),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: _buildSkeleton(
            width: 36,
            height: 36,
            borderRadius: 36,
          ),
        ),
      ],
    );
  }

  Widget _buildSkeleton({
    required double width,
    double height = 20,
    double borderRadius = 14,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white,
      ),
    );
  }
}
