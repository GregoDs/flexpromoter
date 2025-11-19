// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_otp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletOtpResponse _$WalletOtpResponseFromJson(Map<String, dynamic> json) =>
    WalletOtpResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WalletOtpData.fromJson(e as Map<String, dynamic>))
          .toList(),
      errors: json['errors'] as List<dynamic>?,
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$WalletOtpResponseToJson(WalletOtpResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

WalletOtpData _$WalletOtpDataFromJson(Map<String, dynamic> json) =>
    WalletOtpData(
      token: json['token'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber: (json['phone_number'] as num?)?.toInt(),
      target: (json['target'] as num?)?.toInt(),
      designationId: (json['designation_id'] as num?)?.toInt(),
      username: json['username'] as String?,
    );

Map<String, dynamic> _$WalletOtpDataToJson(WalletOtpData instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user?.toJson(),
      'id': instance.id,
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'target': instance.target,
      'designation_id': instance.designationId,
      'username': instance.username,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      userType: (json['user_type'] as num?)?.toInt(),
      isVerified: (json['is_verified'] as num?)?.toInt(),
      rememberToken: json['remember_token'] as String?,
      profilePicture: json['profile_picture'] as String?,
      apiToken: json['api_token'] as String?,
      idNumber: json['id_number'] as String?,
      dob: json['dob'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'user_type': instance.userType,
      'is_verified': instance.isVerified,
      'remember_token': instance.rememberToken,
      'profile_picture': instance.profilePicture,
      'api_token': instance.apiToken,
      'id_number': instance.idNumber,
      'dob': instance.dob,
    };
