import 'package:json_annotation/json_annotation.dart';

part 'promoter_referrals_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PromoterReferralsResponse {
  final PromoterReferralData? data;
  final List<String>? errors;
  final bool success;

  @JsonKey(name: "status_code")
  final int statusCode;

  PromoterReferralsResponse({
    this.data,
    this.errors,
    required this.success,
    required this.statusCode,
  });

  factory PromoterReferralsResponse.fromJson(Map<String, dynamic> json) =>
      _$PromoterReferralsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PromoterReferralsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PromoterReferralData {
  final List<PromoterReferralItem>? data;

  @JsonKey(name: "first_page_url")
  final String? firstPageUrl;

  final int? from;

  @JsonKey(name: "last_page")
  final int? lastPage;

  @JsonKey(name: "last_page_url")
  final String? lastPageUrl;

  @JsonKey(name: "next_page_url")
  final String? nextPageUrl;

  final String? path;

  @JsonKey(name: "per_page")
  final int? perPage;

  @JsonKey(name: "prev_page_url")
  final String? prevPageUrl;

  final int? to;
  final int? total;

  PromoterReferralData({
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory PromoterReferralData.fromJson(Map<String, dynamic> json) =>
      _$PromoterReferralDataFromJson(json);

  Map<String, dynamic> toJson() => _$PromoterReferralDataToJson(this);
}

@JsonSerializable()
class PromoterReferralItem {
  final int? id;

  @JsonKey(name: "promoter_phone")
  final String? promoterPhone;

  @JsonKey(name: "customer_phone")
  final String? customerPhone;

  @JsonKey(name: "booking_reference")
  final String? bookingReference;

  @JsonKey(name: "created_at")
  final String? createdAt;

  PromoterReferralItem({
    this.id,
    this.promoterPhone,
    this.customerPhone,
    this.bookingReference,
    this.createdAt,
  });

  /// Custom parsing because promoter_phone may come as int or String
  factory PromoterReferralItem.fromJson(Map<String, dynamic> json) {
    String safePhone(dynamic value) {
      if (value == null) return "";
      if (value is int) return value.toString();
      if (value is String) return value;
      return value.toString();
    }

    return PromoterReferralItem(
      id: json['id'] as int?,
      promoterPhone: safePhone(json['promoter_phone']),
      customerPhone: safePhone(json['customer_phone']),
      bookingReference: json['booking_reference'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$PromoterReferralItemToJson(this);
}