import 'package:json_annotation/json_annotation.dart';

part 'create_wallet_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateWalletResponse {
  final CreateWalletData? data;
  final List<String>? errors;
  final bool success;

  @JsonKey(name: "status_code")
  final int statusCode;

  CreateWalletResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory CreateWalletResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateWalletResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateWalletResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateWalletData {
  final Map<String, List<String>>? validationErrors;

  final int? id;
  @JsonKey(name: "country_id")
  final int? countryId;
  @JsonKey(name: "product_id")
  final int? productId;
  @JsonKey(name: "booking_source")
  final String? bookingSource;
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "merchant_id")
  final int? merchantId;
  @JsonKey(name: "promoter_id")
  final int? promoterId;
  @JsonKey(name: "outlet_id")
  final int? outletId;
  @JsonKey(name: "booking_reference")
  final String? bookingReference;
  @JsonKey(name: "referral_coupon")
  final String? referralCoupon;
  @JsonKey(name: "booking_price")
  final int? bookingPrice;
  @JsonKey(name: "validation_price")
  final int? validationPrice;
  @JsonKey(name: "booking_offer_price")
  final int? bookingOfferPrice;
  @JsonKey(name: "initial_deposit")
  final int? initialDeposit;
  @JsonKey(name: "has_fixed_deadline")
  final String? hasFixedDeadline;
  @JsonKey(name: "booking_status")
  final String? bookingStatus;
  @JsonKey(name: "is_permanent")
  final bool? isPermanent;
  @JsonKey(name: "parent_booking_id")
  final int? parentBookingId;
  @JsonKey(name: "is_promotional")
  final int? isPromotional;
  @JsonKey(name: "promotional_amount")
  final int? promotionalAmount;
  @JsonKey(name: "end_date")
  final String? endDate;
  @JsonKey(name: "deadline_date")
  final String? deadlineDate;
  @JsonKey(name: "booking_on_credit")
  final int? bookingOnCredit;
  @JsonKey(name: "account_name")
  final String? accountName;
  @JsonKey(name: "account_no")
  final String? accountNo;
  final String? reference;
  @JsonKey(name: "phone_number")
  final String? phoneNumber;
  @JsonKey(name: "checkout_status")
  final String? checkoutStatus;
  final String? frequency;
  @JsonKey(name: "frequency_contribution")
  final String? frequencyContribution;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @JsonKey(name: "deleted_at")
  final String? deletedAt;

  @JsonKey(name: "booking_interest")
  final List<dynamic>? bookingInterest;

  @JsonKey(name: "interest_amount")
  final int? interestAmount;

  @JsonKey(name: "maturity_date")
  final String? maturityDate;

  @JsonKey(name: "target_saving")
  final int? targetSaving;

  @JsonKey(name: "chama_description")
  final String? chamaDescription;

  final String? image;
  final int? progress;

  final List<Payment>? payment;

  // Add user field from the response
  final BookingUser? user;

  CreateWalletData({
    this.validationErrors,
    this.id,
    this.countryId,
    this.productId,
    this.bookingSource,
    this.userId,
    this.merchantId,
    this.promoterId,
    this.outletId,
    this.bookingReference,
    this.referralCoupon,
    this.bookingPrice,
    this.validationPrice,
    this.bookingOfferPrice,
    this.initialDeposit,
    this.hasFixedDeadline,
    this.bookingStatus,
    this.isPermanent,
    this.parentBookingId,
    this.isPromotional,
    this.promotionalAmount,
    this.endDate,
    this.deadlineDate,
    this.bookingOnCredit,
    this.accountName,
    this.accountNo,
    this.reference,
    this.phoneNumber,
    this.checkoutStatus,
    this.frequency,
    this.frequencyContribution,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.bookingInterest,
    this.interestAmount,
    this.maturityDate,
    this.targetSaving,
    this.chamaDescription,
    this.image,
    this.progress,
    this.payment,
    this.user,
  });

  factory CreateWalletData.fromJson(Map<String, dynamic> json) {
    // Handle validation errors
    final errorMap = <String, List<String>>{};

    json.forEach((key, value) {
      if (value is List && value.isNotEmpty && value.first is String) {
        errorMap[key] = List<String>.from(value);
      }
    });

    // Helper function to safely convert to int
    int? safeIntConversion(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        return int.tryParse(value);
      }
      if (value is double) return value.toInt();
      return null;
    }

    // Helper function to safely convert to bool
    bool? safeBoolConversion(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value.toLowerCase() == 'true' || value == '1';
      return null;
    }

    return CreateWalletData(
      validationErrors: errorMap.isEmpty ? null : errorMap,
      id: safeIntConversion(json['id']),
      countryId: safeIntConversion(json['country_id']),
      productId: safeIntConversion(json['product_id']),
      bookingSource: json['booking_source'] as String?,
      userId: safeIntConversion(json['user_id']),
      merchantId: safeIntConversion(json['merchant_id']),
      promoterId: safeIntConversion(json['promoter_id']),
      outletId: safeIntConversion(json['outlet_id']),
      bookingReference: json['booking_reference'] as String?,
      referralCoupon: json['referral_coupon'] as String?,
      bookingPrice: safeIntConversion(json['booking_price']),
      validationPrice: safeIntConversion(json['validation_price']),
      bookingOfferPrice: safeIntConversion(json['booking_offer_price']),
      initialDeposit: safeIntConversion(json['initial_deposit']),
      hasFixedDeadline: json['has_fixed_deadline'] as String?,
      bookingStatus: json['booking_status'] as String?,
      isPermanent: safeBoolConversion(json['is_permanent']),
      parentBookingId: safeIntConversion(json['parent_booking_id']),
      isPromotional: safeIntConversion(json['is_promotional']),
      promotionalAmount: safeIntConversion(json['promotional_amount']),
      endDate: json['end_date'] as String?,
      deadlineDate: json['deadline_date'] as String?,
      bookingOnCredit: safeIntConversion(json['booking_on_credit']),
      accountName: json['account_name'] as String?,
      accountNo: json['account_no'] as String?,
      reference: json['reference'] as String?,
      phoneNumber: json['phone_number'] as String?,
      checkoutStatus: json['checkout_status'] as String?,
      frequency: json['frequency'] as String?,
      frequencyContribution: json['frequency_contribution'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      bookingInterest: json['booking_interest'] as List<dynamic>?,
      interestAmount: safeIntConversion(json['interest_amount']),
      maturityDate: json['maturity_date'] as String?,
      targetSaving: safeIntConversion(json['target_saving']),
      chamaDescription: json['chama_description'] as String?,
      image: json['image'] as String?,
      progress: safeIntConversion(json['progress']),
      payment: json['payment'] != null
          ? (json['payment'] as List).map((e) => Payment.fromJson(e)).toList()
          : null,
      user: json['user'] != null ? BookingUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => _$CreateWalletDataToJson(this);
}

// Add BookingUser class to handle the user object in the response
@JsonSerializable()
class BookingUser {
  final int? id;
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "referral_id")
  final int? referralId;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "phone_number_1")
  final String? phoneNumber1;
  @JsonKey(name: "id_number")
  final String? idNumber;
  @JsonKey(name: "passport_number")
  final String? passportNumber;
  final String? dob;
  final String? country;

  BookingUser({
    this.id,
    this.userId,
    this.referralId,
    this.firstName,
    this.lastName,
    this.phoneNumber1,
    this.idNumber,
    this.passportNumber,
    this.dob,
    this.country,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) =>
      _$BookingUserFromJson(json);

  Map<String, dynamic> toJson() => _$BookingUserToJson(this);
}

@JsonSerializable()
class Payment {
  final int? id;
  @JsonKey(name: "payment_id")
  final int? paymentId;
  @JsonKey(name: "booking_id")
  final int? bookingId;
  @JsonKey(name: "wallet_id")
  final int? walletId;
  @JsonKey(name: "payment_amount")
  final int? paymentAmount;
  final String? destination;
  @JsonKey(name: "destination_account_no")
  final String? destinationAccountNo;
  @JsonKey(name: "destination_phone_no")
  final String? destinationPhoneNo;
  @JsonKey(name: "destination_transaction_reference")
  final String? destinationTransactionReference;
  @JsonKey(name: "deleted_at")
  final String? deletedAt;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  Payment({
    this.id,
    this.paymentId,
    this.bookingId,
    this.walletId,
    this.paymentAmount,
    this.destination,
    this.destinationAccountNo,
    this.destinationPhoneNo,
    this.destinationTransactionReference,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
