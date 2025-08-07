import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchCustomersBookingsPage extends StatefulWidget {
  const SearchCustomersBookingsPage({super.key});

  @override
  State<SearchCustomersBookingsPage> createState() =>
      _SearchCustomersBookingsPageState();
}

class _SearchCustomersBookingsPageState
    extends State<SearchCustomersBookingsPage> {
  final TextEditingController _searchController = TextEditingController();
  String selectedTag = 'Active';

  // Dummy bookings data for each tag
  final Map<String, List<Map<String, dynamic>>> bookingsByTag = {
    'Active': [
      {
        'title': 'Mattress, 3×6×8',
        'subtitle': 'Naivas Eastgate',
        'progress': 0.2,
        'ref': 'BK84349',
        'paid': 'Kshs 1',
        'badge': '20%',
        'badgeColor': const Color(0xFFFFF6D6),
        'badgeTextColor': const Color(0xFFFEA900),
        'badgeIcon': Icons.verified,
        'status': 'active',
      },
      {
        'title': 'Sofa Set, 5 Seater',
        'subtitle': 'Victoria Furnishers',
        'progress': 0.5,
        'ref': 'BK12345',
        'paid': 'Kshs 10,000',
        'badge': '50%',
        'badgeColor': const Color(0xFFD6F6FF),
        'badgeTextColor': const Color(0xFF009BFE),
        'badgeIcon': Icons.verified,
        'status': 'active',
      },
    ],
    'Completed': [
      {
        'title': 'Dining Table',
        'subtitle': 'Home Centre',
        'progress': 1.0,
        'ref': 'BK67890',
        'paid': 'Kshs 20,000',
        'badge': '100%',
        'badgeColor': const Color(0xFFD6FFD8),
        'badgeTextColor': const Color(0xFF00C853),
        'badgeIcon': Icons.verified,
        'status': 'completed',
      },
    ],
    'Redeemed': [
      {
        'title': 'Microwave',
        'subtitle': 'Hotpoint',
        'progress': 1.0,
        'ref': 'BK55555',
        'paid': 'Kshs 7,000',
        'badge': 'Redeemed',
        'badgeColor': const Color(0xFFE0E0E0),
        'badgeTextColor': const Color(0xFF757575),
        'badgeIcon': Icons.redeem,
        'status': 'redeemed',
      },
    ],
    'Unserviced': [
      {
        'title': 'TV Stand',
        'subtitle': 'Furniture Palace',
        'progress': 0.0,
        'ref': 'BK99999',
        'paid': 'Kshs 0',
        'badge': '0%',
        'badgeColor': const Color(0xFFFFD6D6),
        'badgeTextColor': const Color(0xFFD32F2F),
        'badgeIcon': Icons.error,
        'status': 'unserviced',
      },
    ],
  };

  final List<String> tags = ['Active', 'Completed', 'Redeemed', 'Unserviced'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Header with rounded corners and background image
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/appbarbackground.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(52),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppBar Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                'Back',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "FlexPay",
                          style: GoogleFonts.montserrat(
                            fontSize: size.width * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 44),
                    Text(
                      'Search Customer Bookings',
                      style: GoogleFonts.montserrat(
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find and view bookings for any customer by searching their phone number.',
                      style: GoogleFonts.montserrat(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Search Bar moved here
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by phone number',
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Tags
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tags.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, idx) {
                    final tag = tags[idx];
                    final isSelected = tag == selectedTag;
                    return GestureDetector(
                      onTap: () => setState(() => selectedTag = tag),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF337687)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.montserrat(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Bookings List
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: bookingsByTag[selectedTag]?.length ?? 0,
                  itemBuilder: (context, idx) {
                    final booking = bookingsByTag[selectedTag]![idx];
                    return _buildBookingCard(booking, context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Leading Icon
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 26,
            child: Icon(
              booking['badgeIcon'],
              color: booking['badgeTextColor'],
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Booking Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['title'],
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  booking['subtitle'],
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: booking['progress'],
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      booking['badgeTextColor'],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Ref: ${booking['ref']}',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Paid: ${booking['paid']}',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Badge
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: booking['badgeColor'],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      booking['badgeIcon'],
                      color: booking['badgeTextColor'],
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      booking['badge'],
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: booking['badgeTextColor'],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                booking['status'],
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
