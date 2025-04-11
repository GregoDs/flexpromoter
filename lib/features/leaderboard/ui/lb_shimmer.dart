import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LeaderboardShimmer extends StatelessWidget {
  const LeaderboardShimmer({Key? key}) : super(key: key);

  Widget buildShimmerItem({
    required double width,
    required double height,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
    required Color baseColor,
    required Color highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          shape: shape,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[500]! : Colors.grey[100]!;
    final containerColor = isDark ? Colors.grey[850] : Colors.white;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Profile image shimmer
              buildShimmerItem(
                width: 40,
                height: 40,
                shape: BoxShape.circle,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildShimmerItem(
                      width: double.infinity,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                    ),
                    const SizedBox(height: 6),
                    buildShimmerItem(
                      width: double.infinity,
                      height: 12,
                      borderRadius: BorderRadius.circular(4),
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                    ),
                    const SizedBox(height: 4),
                    buildShimmerItem(
                      width: 100,
                      height: 12,
                      borderRadius: BorderRadius.circular(4),
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Amount shimmer container
              Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 60,
                    height: 16,
                    color: baseColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}