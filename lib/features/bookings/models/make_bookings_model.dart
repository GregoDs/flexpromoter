class BookingRequestModel {
  final String phoneNumber;
  final String userId;
  final String bookingPrice;
  final String bookingDays;
  final String initialDeposit;
  final String firstName;
  final String lastName;
  final String productName;

  BookingRequestModel({
    required this.phoneNumber,
    required this.userId,
    required this.bookingPrice,
    required this.bookingDays,
    required this.initialDeposit,
    required this.firstName,
    required this.lastName,
    required this.productName,
  });

  // Convert the model to JSON payload
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'user_id': userId,
      'booking_price': bookingPrice,
      'booking_days': bookingDays,
      'initial_deposit': initialDeposit,
      'first_name': firstName,
      'last_name': lastName,
      'product_name': productName,
    };
  }

  // Factory constructor to create a BookingRequestModel from JSON
  factory BookingRequestModel.fromJson(Map<String, dynamic> json) {
    return BookingRequestModel(
      phoneNumber: json['phone_number']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      bookingPrice: json['booking_price']?.toString() ?? '0',
      bookingDays: json['booking_days']?.toString() ?? '0',
      initialDeposit: json['initial_deposit']?.toString() ?? '0',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
    );
  }
}