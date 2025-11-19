import 'package:json_annotation/json_annotation.dart';

part 'wallet_otp_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletOtpResponse {
  final List<WalletOtpData>? data;
  final List<dynamic>? errors;
  @JsonKey(name: "success")
  final bool success;
  @JsonKey(name: "status_code")
  final int statusCode;

  WalletOtpResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory WalletOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletOtpResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WalletOtpData {
  // Authentication token
  final String? token;
  
  // User object from the response
  final User? user;
  
  // Customer/Promoter details
  final int? id;
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "phone_number")
  final int? phoneNumber;
  final int? target;
  @JsonKey(name: "designation_id")
  final int? designationId;
  final String? username;

  WalletOtpData({
    this.token,
    this.user,
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.target,
    this.designationId,
    this.username,
  });

  factory WalletOtpData.fromJson(Map<String, dynamic> json) =>
      _$WalletOtpDataFromJson(json);

  Map<String, dynamic> toJson() => _$WalletOtpDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class User {
  final int? id;
  final String? email;
  @JsonKey(name: "user_type")
  final int? userType;
  @JsonKey(name: "is_verified")
  final int? isVerified;
  @JsonKey(name: "remember_token")
  final String? rememberToken;
  @JsonKey(name: "profile_picture")
  final String? profilePicture;
  @JsonKey(name: "api_token")
  final String? apiToken;
  @JsonKey(name: "id_number")
  final String? idNumber;
  final String? dob;

  User({
    this.id,
    this.email,
    this.userType,
    this.isVerified,
    this.rememberToken,
    this.profilePicture,
    this.apiToken,
    this.idNumber,
    this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}