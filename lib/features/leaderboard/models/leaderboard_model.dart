class LeaderboardModel {
  final int userId;
  final double totalAmount;
  final int bookingCount;
  final String bookingReference;
  final String firstName;
  final String lastName;
  final String merchantName;
  final String outletName;

  LeaderboardModel({
    required this.userId,
    required this.totalAmount,
    required this.bookingCount,
    required this.bookingReference,
    required this.firstName,
    required this.lastName,
    required this.merchantName,
    required this.outletName,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      userId: json['user_id'] as int,
      totalAmount: (json['total_amount'] as num).toDouble(),
      bookingCount: json['booking_count'] as int,
      bookingReference: json['booking_reference'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      merchantName: json['merchant_name'] as String,
      outletName: json['outlet_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_amount': totalAmount,
      'booking_count': bookingCount,
      'booking_reference': bookingReference,
      'first_name': firstName,
      'last_name': lastName,
      'merchant_name': merchantName,
      'outlet_name': outletName,
    };
  }
}
