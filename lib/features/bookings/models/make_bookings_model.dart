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
      phoneNumber: json['phone_number'] ?? '',
      userId: json['user_id'] ?? '',
      bookingPrice: json['booking_price'] ?? '',
      bookingDays: json['booking_days'] ?? '',
      initialDeposit: json['initial_deposit'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      productName: json['product_name'] ?? '',
    );
  }
}
