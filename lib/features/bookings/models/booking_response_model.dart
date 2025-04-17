class BookingResponseModel {
  final BookingResponseData? data;
  final List<String> errors;
  final bool success;
  final int statusCode;

  BookingResponseModel({
    this.data,
    required this.errors,
    required this.success,
    required this.statusCode,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      data: json['data'] != null
          ? BookingResponseData.fromJson(json['data'])
          : null,
      errors: List<String>.from(json['errors'] ?? []),
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'errors': errors,
      'success': success,
      'status_code': statusCode,
    };
  }
}

class BookingResponseData {
  final ProductBooking? productBooking;

  BookingResponseData({
    this.productBooking,
  });

  factory BookingResponseData.fromJson(Map<String, dynamic> json) {
    return BookingResponseData(
      productBooking: json['product_booking'] != null
          ? ProductBooking.fromJson(json['product_booking'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_booking': productBooking?.toJson(),
    };
  }
}

class ProductBooking {
  final int productId;
  final int userId;
  final int merchantId;
  final int promoterId;
  final int bookingOnCredit;
  final int outletId;
  final String bookingPrice;
  final String bookingOfferPrice;
  final String initialDeposit;
  final String referralCoupon;
  final String bookingSource;
  final String deadlineDate;
  final String bookingReference;
  final String? frequency;
  final String? frequencyContribution;
  final String updatedAt;
  final String createdAt;
  final int id;
  final BookingUser user;
  final List<dynamic> bookingInterest;
  final int interestAmount;
  final String maturityDate;
  final String targetSaving;
  final String? chamaDescription;
  final String? image;
  final int progress;
  final List<dynamic> payment;

  ProductBooking({
    required this.productId,
    required this.userId,
    required this.merchantId,
    required this.promoterId,
    required this.bookingOnCredit,
    required this.outletId,
    required this.bookingPrice,
    required this.bookingOfferPrice,
    required this.initialDeposit,
    required this.referralCoupon,
    required this.bookingSource,
    required this.deadlineDate,
    required this.bookingReference,
    this.frequency,
    this.frequencyContribution,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.user,
    required this.bookingInterest,
    required this.interestAmount,
    required this.maturityDate,
    required this.targetSaving,
    this.chamaDescription,
    this.image,
    required this.progress,
    required this.payment,
  });

  factory ProductBooking.fromJson(Map<String, dynamic> json) {
  return ProductBooking(
    productId: json['product_id'] ?? 0,
    userId: json['user_id'] ?? 0,
    merchantId: json['merchant_id'] ?? 0,
    promoterId: json['promoter_id'] ?? 0,
    bookingOnCredit: json['booking_on_credit'] ?? 0,
    outletId: json['outlet_id'] ?? 0,
    bookingPrice: json['booking_price']?.toString() ?? '0',
    bookingOfferPrice: json['booking_offer_price']?.toString() ?? '0',
    initialDeposit: json['initial_deposit']?.toString() ?? '0',
    referralCoupon: json['referral_coupon']?.toString() ?? '',
    bookingSource: json['booking_source']?.toString() ?? '',
    deadlineDate: json['deadline_date']?.toString() ?? '',
    bookingReference: json['booking_reference']?.toString() ?? '',
    frequency: json['frequency']?.toString(),
    frequencyContribution: json['frequency_contribution']?.toString(),
    updatedAt: json['updated_at']?.toString() ?? '',
    createdAt: json['created_at']?.toString() ?? '',
    id: json['id'] ?? 0,
    user: BookingUser.fromJson(json['user'] ?? {}),
    bookingInterest: json['booking_interest'] ?? [],
    interestAmount: json['interest_amount'] ?? 0,
    maturityDate: json['maturity_date']?.toString() ?? '',
    targetSaving: json['target_saving']?.toString() ?? '0',
    chamaDescription: json['chama_description']?.toString(),
    image: json['image']?.toString(),
    progress: json['progress'] ?? 0,
    payment: json['payment'] ?? [],
  );
}

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'user_id': userId,
      'merchant_id': merchantId,
      'promoter_id': promoterId,
      'booking_on_credit': bookingOnCredit,
      'outlet_id': outletId,
      'booking_price': bookingPrice,
      'booking_offer_price': bookingOfferPrice,
      'initial_deposit': initialDeposit,
      'referral_coupon': referralCoupon,
      'booking_source': bookingSource,
      'deadline_date': deadlineDate,
      'booking_reference': bookingReference,
      // Add other properties as needed...
    };
  }
}

class BookingUser {
  final int id;
  final int userId;
  final String? referralId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? idNumber;
  final String? passportNumber;
  final String? dob;
  final String? country;

  BookingUser({
    required this.id,
    required this.userId,
    this.referralId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.idNumber,
    this.passportNumber,
    this.dob,
    this.country,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
  return BookingUser(
    id: json['id'] ?? 0,
    userId: json['user_id'] ?? 0,
    referralId: json['referral_id']?.toString(),
    firstName: json['first_name']?.toString() ?? '',
    lastName: json['last_name']?.toString() ?? '',
    phoneNumber: json['phone_number_1']?.toString() ?? '',
    idNumber: json['id_number']?.toString(),
    passportNumber: json['passport_number']?.toString(),
    dob: json['dob']?.toString(),
    country: json['country']?.toString(),
  );
}
}
