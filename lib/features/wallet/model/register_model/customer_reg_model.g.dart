// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_reg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerWalletRegResponse _$CustomerWalletRegResponseFromJson(
        Map<String, dynamic> json) =>
    CustomerWalletRegResponse(
      data: json['data'] == null
          ? null
          : CustomerData.fromJson(json['data'] as Map<String, dynamic>),
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$CustomerWalletRegResponseToJson(
        CustomerWalletRegResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

CustomerData _$CustomerDataFromJson(Map<String, dynamic> json) => CustomerData(
      id: (json['id'] as num?)?.toInt(),
      countryId: (json['country_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      referralId: (json['referral_id'] as num?)?.toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber1: json['phone_number_1'] as String?,
      mpesaCustomerId: json['mpesa_customer_id'] as String?,
      phoneNumber2: json['phone_number_2'] as String?,
      idNumber: json['id_number'] as String?,
      passportNumber: json['passport_number'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
      customerLongitude: json['customer_longitude'] as String?,
      customerLatitude: json['customer_latitude'] as String?,
      stripeCustomerId: json['stripe_customer_id'] as String?,
      scoreHasBeenComputed: (json['score_has_been_computed'] as num?)?.toInt(),
      referralCode: json['referral_code'] as String?,
      isFlexsaveCustomer: (json['is_flexsave_customer'] as num?)?.toInt(),
      phoneNumberErrors: (json['phone_number'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CustomerDataToJson(CustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country_id': instance.countryId,
      'user_id': instance.userId,
      'referral_id': instance.referralId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number_1': instance.phoneNumber1,
      'mpesa_customer_id': instance.mpesaCustomerId,
      'phone_number_2': instance.phoneNumber2,
      'id_number': instance.idNumber,
      'passport_number': instance.passportNumber,
      'dob': instance.dob,
      'gender': instance.gender,
      'country': instance.country,
      'customer_longitude': instance.customerLongitude,
      'customer_latitude': instance.customerLatitude,
      'stripe_customer_id': instance.stripeCustomerId,
      'score_has_been_computed': instance.scoreHasBeenComputed,
      'referral_code': instance.referralCode,
      'is_flexsave_customer': instance.isFlexsaveCustomer,
      'phone_number': instance.phoneNumberErrors,
    };
