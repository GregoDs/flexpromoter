import 'package:json_annotation/json_annotation.dart';

part 'customer_reg_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomerWalletRegResponse {
  final CustomerData? data;
  final List<dynamic>? errors;
  @JsonKey(name: "success")
  final bool success;
  @JsonKey(name: "status_code")
  final int statusCode;

  CustomerWalletRegResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory CustomerWalletRegResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerWalletRegResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerWalletRegResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CustomerData {
  // Success fields
  final int? id;
  @JsonKey(name: "country_id")
  final int? countryId;
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
  @JsonKey(name: "mpesa_customer_id")
  final String? mpesaCustomerId;
  @JsonKey(name: "phone_number_2")
  final String? phoneNumber2;
  @JsonKey(name: "id_number")
  final String? idNumber;
  @JsonKey(name: "passport_number")
  final String? passportNumber;
  final String? dob;
  final String? gender;
  final String? country;
  @JsonKey(name: "customer_longitude")
  final String? customerLongitude;
  @JsonKey(name: "customer_latitude")
  final String? customerLatitude;
  @JsonKey(name: "stripe_customer_id")
  final String? stripeCustomerId;
  @JsonKey(name: "score_has_been_computed")
  final int? scoreHasBeenComputed;
  @JsonKey(name: "referral_code")
  final String? referralCode;
  @JsonKey(name: "is_flexsave_customer")
  final int? isFlexsaveCustomer;

  // Error fields (example: phone_number: ["error msg"])
  @JsonKey(name: 'phone_number')
  final List<String>? phoneNumberErrors;

  CustomerData({
    this.id,
    this.countryId,
    this.userId,
    this.referralId,
    this.firstName,
    this.lastName,
    this.phoneNumber1,
    this.mpesaCustomerId,
    this.phoneNumber2,
    this.idNumber,
    this.passportNumber,
    this.dob,
    this.gender,
    this.country,
    this.customerLongitude,
    this.customerLatitude,
    this.stripeCustomerId,
    this.scoreHasBeenComputed,
    this.referralCode,
    this.isFlexsaveCustomer,
    this.phoneNumberErrors,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert phone number to string
    String? convertPhoneNumber(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is int) return value.toString();
      return value.toString();
    }

    // Helper function to safely convert to int
    int? safeIntConversion(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      if (value is double) return value.toInt();
      return null;
    }

    // Helper function to safely convert to string
    String? safeStringConversion(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is int) return value.toString();
      if (value is double) return value.toString();
      return value.toString();
    }

    return CustomerData(
      id: safeIntConversion(json['id']),
      countryId: safeIntConversion(json['country_id']),
      userId: safeIntConversion(json['user_id']),
      referralId: safeIntConversion(json['referral_id']),
      firstName: safeStringConversion(json['first_name']),
      lastName: safeStringConversion(json['last_name']),
      phoneNumber1: convertPhoneNumber(json['phone_number_1']),
      mpesaCustomerId: safeStringConversion(json['mpesa_customer_id']),
      phoneNumber2: convertPhoneNumber(json['phone_number_2']),
      idNumber: safeStringConversion(json['id_number']),
      passportNumber: safeStringConversion(json['passport_number']),
      dob: safeStringConversion(json['dob']),
      gender: safeStringConversion(
          json['gender']), 
      country: safeStringConversion(json['country']),
      customerLongitude: safeStringConversion(json['customer_longitude']),
      customerLatitude: safeStringConversion(json['customer_latitude']),
      stripeCustomerId: safeStringConversion(json['stripe_customer_id']),
      scoreHasBeenComputed: safeIntConversion(json['score_has_been_computed']),
      referralCode: safeStringConversion(json['referral_code']),
      isFlexsaveCustomer: safeIntConversion(json['is_flexsave_customer']),
      phoneNumberErrors:
          json['phone_number'] != null && json['phone_number'] is List
              ? List<String>.from(json['phone_number'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => _$CustomerDataToJson(this);
}
