import 'package:flexpromoter/exports.dart';
import 'package:flexpromoter/features/commissions/cubit/commissions_cubit.dart';
import 'package:flexpromoter/features/commissions/repo/commission_repo.dart';
import 'package:flexpromoter/utils/constants/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'comm_shimmer.dart'; // Import the shimmer widget

class Commissions extends StatefulWidget {
  const Commissions({super.key});

  @override
  State<Commissions> createState() => _CommissionsState();
}

class _CommissionsState extends State<Commissions> {
  String filter = 'month'; // Default filter
  late CommissionsCubit _commissionsCubit;

  @override
  void initState() {
    super.initState();
    _commissionsCubit = CommissionsCubit(repository: CommissionRepository());
    _fetchCommissions();
  }

  @override
  void dispose() {
    _commissionsCubit.close();
    super.dispose();
  }

  void _fetchCommissions() {
    _commissionsCubit.fetchCommissions(context, filter);
  }

  void _filterData(String timeFilter) {
    setState(() {
      filter = timeFilter;
      _fetchCommissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
          title: Text(
            "FlexPay",
            style: GoogleFonts.montserrat(
              fontSize: 33.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
          ],
          elevation: 0,
          toolbarHeight: 100.0,
        ),
        body: BlocBuilder<CommissionsCubit, CommissionsState>(
          bloc: _commissionsCubit,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(isDarkMode),
                  Padding(
                    padding: const EdgeInsets.all(tDashboardPadding),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildFilterTab(isDarkMode),
                        const SizedBox(height: 20),
                        if (state is CommissionsLoading)
                          const CommissionsShimmer(isDarkMode: true,) // Use shimmer loading rows
                        else if (state is CommissionsSuccess)
                          _buildCommissionsAndDeficit(state, isDarkMode)
                        else if (state is CommissionsError)
                          Center(
                            child: Text(
                              state.message,
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          )
                        else
                          const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      color: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello Promoter",
            style: GoogleFonts.montserrat(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Commissions data is as follows:',
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFilterTab(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTabButton("Weekly", 'week', isDarkMode),
          _buildTabButton("Monthly", 'month', isDarkMode),
          _buildTabButton("Yearly", 'year', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String value, bool isDarkMode) {
    final isSelected = filter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => _filterData(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDarkMode ? const Color(0xFF337687) : Colors.black)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommissionsAndDeficit(
      CommissionsSuccess state, bool isDarkMode) {
    return Column(
      children: [
        _buildStyledCard(
          "Total Commissions",
          state.totalCommissions.toString(),
          "Keep up the good work!",
          isDarkMode,
        ),
        const SizedBox(height: 20),
        _buildStyledCard(
          "Deficit",
          state.deficit.toString(),
          "Strive to reach your goal!",
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildStyledCard(
    String title,
    String value,
    String message,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
