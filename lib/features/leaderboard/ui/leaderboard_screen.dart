import 'dart:math' show pi;
import 'package:flexpromoter/features/leaderboard/ui/lb_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import 'package:flexpromoter/features/leaderboard/cubit/leaderboard_cubit.dart';
import 'package:flexpromoter/features/leaderboard/cubit/leaderboard_state.dart';
import 'package:flexpromoter/features/leaderboard/repo/leaderboard_repository.dart';


class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool isGlobalView = false;
  late LeaderboardCubit _leaderboardCubit;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _leaderboardCubit = LeaderboardCubit(repository: LeaderboardRepository());
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _fetchLeaderboardData();
    // Start confetti after a brief delay to let the page load
    Future.delayed(const Duration(milliseconds: 500), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _fetchLeaderboardData() {
    _leaderboardCubit.fetchLeaderboardData();
  }

  String _maskName(String name) {
    if (name.isEmpty) return '';
    return '${name[0]}${'*' * (name.length - 1)}';
  }

  Widget _buildPositionBadge(int index) {
    if (index > 2) return const SizedBox.shrink(); // Only show for top 3

    final colors = [
      Colors.amber, // Gold for 1st
      Colors.grey.shade400, // Silver for 2nd
      Colors.brown.shade300, // Bronze for 3rd
    ];

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: colors[index],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors[index].withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.grey[50];
    final firstPlaceCardColor =
        isDarkMode ? Colors.amber.shade900 : Colors.amber.shade50;
    final iconColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
    final firstPlaceIconColor =
        isDarkMode ? Colors.amber.shade300 : Colors.amber;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leadingWidth: 100,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    'Back',
                    style: GoogleFonts.montserrat(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                ],
              ),
            ),
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(right: 40, left: 25),
              child: Text(
                'Leaderboard',
                style: GoogleFonts.montserrat(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: textColor),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '0',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Lottie.asset(
                "assets/images/leaderboard.json",
                height: MediaQuery.of(context).size.height * 0.22,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 5),
              Expanded(
                child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
                  bloc: _leaderboardCubit,
                  builder: (context, state) {
                    if (state is LeaderboardLoading) {
                      return const LeaderboardShimmer();
                    } else if (state is LeaderboardError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: GoogleFonts.montserrat(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                      );
                    } else if (state is LeaderboardLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.leaderboardData.length,
                        itemBuilder: (context, index) {
                          final item = state.leaderboardData[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color:
                                  index == 0 ? firstPlaceCardColor : cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  _buildPositionBadge(index),
                                  const SizedBox(width: 12),
                                  CircleAvatar(
                                    backgroundColor: isDarkMode
                                        ? Colors.grey[700]
                                        : Colors.grey.shade200,
                                    child: Icon(
                                      Icons.person_outline,
                                      color: index == 0
                                          ? firstPlaceIconColor
                                          : iconColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_maskName(item.firstName)} ${_maskName(item.lastName)}',
                                          style: GoogleFonts.montserrat(
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.business_outlined,
                                              size: 16,
                                              color: iconColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${item.outletName}',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: iconColor,
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '${item.merchantName}',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: iconColor,
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.teal.shade900
                                          : Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'kshs ${item.totalAmount}',
                                      style: GoogleFonts.montserrat(
                                        color: isDarkMode
                                            ? Colors.teal.shade200
                                            : Colors.teal.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // Straight down
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.2,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.amber,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isSelected
          ? (isDarkMode ? Colors.grey[800] : Colors.black)
          : (isDarkMode ? Colors.grey[700] : Colors.grey.shade200),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.grey[300] : Colors.black),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: isSelected
                      ? Colors.white
                      : (isDarkMode ? Colors.grey[300] : Colors.black),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
