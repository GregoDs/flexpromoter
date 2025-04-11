import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingsShimmer extends StatelessWidget {
  final bool isDarkMode;
  const BookingsShimmer({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(4, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title shimmer
                Shimmer.fromColors(
                  baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                  child: Container(
                    height: 20,
                    width: 180,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                // Message shimmer
                Shimmer.fromColors(
                  baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                  child: Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                // Count number shimmer
                Align(
                  alignment: Alignment.center,
                  child: Shimmer.fromColors(
                    baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                    highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                    child: Container(
                      height: 36,
                      width: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}