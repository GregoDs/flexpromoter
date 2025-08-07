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
        children: List.generate(6, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left icon shimmer
                Shimmer.fromColors(
                  baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  highlightColor:
                      isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Main info shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title shimmer
                      Shimmer.fromColors(
                        baseColor:
                            isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                        highlightColor:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                        child: Container(
                          height: 18,
                          width: 140,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Subtitle shimmer
                      Shimmer.fromColors(
                        baseColor:
                            isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                        highlightColor:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                        child: Container(
                          height: 14,
                          width: 100,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Progress bar shimmer
                      Shimmer.fromColors(
                        baseColor:
                            isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                        highlightColor:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                        child: Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Ref and Paid shimmer
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: isDarkMode
                                ? Colors.grey[800]!
                                : Colors.grey[300]!,
                            highlightColor: isDarkMode
                                ? Colors.grey[700]!
                                : Colors.grey[100]!,
                            child: Container(
                              height: 12,
                              width: 60,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Shimmer.fromColors(
                            baseColor: isDarkMode
                                ? Colors.grey[800]!
                                : Colors.grey[300]!,
                            highlightColor: isDarkMode
                                ? Colors.grey[700]!
                                : Colors.grey[100]!,
                            child: Container(
                              height: 12,
                              width: 70,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Badge shimmer
                Shimmer.fromColors(
                  baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  highlightColor:
                      isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                  child: Container(
                    height: 32,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16),
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
