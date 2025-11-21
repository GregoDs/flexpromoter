// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promoter_referrals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoterReferralsResponse _$PromoterReferralsResponseFromJson(
        Map<String, dynamic> json) =>
    PromoterReferralsResponse(
      data: json['data'] == null
          ? null
          : PromoterReferralData.fromJson(json['data'] as Map<String, dynamic>),
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$PromoterReferralsResponseToJson(
        PromoterReferralsResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

PromoterReferralData _$PromoterReferralDataFromJson(
        Map<String, dynamic> json) =>
    PromoterReferralData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PromoterReferralItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      firstPageUrl: json['first_page_url'] as String?,
      from: (json['from'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      lastPageUrl: json['last_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String?,
      perPage: (json['per_page'] as num?)?.toInt(),
      prevPageUrl: json['prev_page_url'] as String?,
      to: (json['to'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PromoterReferralDataToJson(
        PromoterReferralData instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'first_page_url': instance.firstPageUrl,
      'from': instance.from,
      'last_page': instance.lastPage,
      'last_page_url': instance.lastPageUrl,
      'next_page_url': instance.nextPageUrl,
      'path': instance.path,
      'per_page': instance.perPage,
      'prev_page_url': instance.prevPageUrl,
      'to': instance.to,
      'total': instance.total,
    };

PromoterReferralItem _$PromoterReferralItemFromJson(
        Map<String, dynamic> json) =>
    PromoterReferralItem(
      id: (json['id'] as num?)?.toInt(),
      promoterPhone: json['promoter_phone'] as String?,
      customerPhone: json['customer_phone'] as String?,
      bookingReference: json['booking_reference'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$PromoterReferralItemToJson(
        PromoterReferralItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'promoter_phone': instance.promoterPhone,
      'customer_phone': instance.customerPhone,
      'booking_reference': instance.bookingReference,
      'created_at': instance.createdAt,
    };
