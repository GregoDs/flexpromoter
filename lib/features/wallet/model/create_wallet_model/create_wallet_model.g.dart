// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWalletResponse _$CreateWalletResponseFromJson(
        Map<String, dynamic> json) =>
    CreateWalletResponse(
      data: json['data'] == null
          ? null
          : CreateWalletData.fromJson(json['data'] as Map<String, dynamic>),
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      success: json['success'] as bool,
      statusCode: (json['status_code'] as num).toInt(),
    );

Map<String, dynamic> _$CreateWalletResponseToJson(
        CreateWalletResponse instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
      'errors': instance.errors,
      'success': instance.success,
      'status_code': instance.statusCode,
    };

CreateWalletData _$CreateWalletDataFromJson(Map<String, dynamic> json) =>
    CreateWalletData(
      validationErrors:
          (json['validationErrors'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      id: (json['id'] as num?)?.toInt(),
      countryId: (json['country_id'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      bookingSource: json['booking_source'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      merchantId: (json['merchant_id'] as num?)?.toInt(),
      promoterId: (json['promoter_id'] as num?)?.toInt(),
      outletId: (json['outlet_id'] as num?)?.toInt(),
      bookingReference: json['booking_reference'] as String?,
      referralCoupon: json['referral_coupon'] as String?,
      bookingPrice: (json['booking_price'] as num?)?.toInt(),
      validationPrice: (json['validation_price'] as num?)?.toInt(),
      bookingOfferPrice: (json['booking_offer_price'] as num?)?.toInt(),
      initialDeposit: (json['initial_deposit'] as num?)?.toInt(),
      hasFixedDeadline: json['has_fixed_deadline'] as String?,
      bookingStatus: json['booking_status'] as String?,
      isPermanent: json['is_permanent'] as bool?,
      parentBookingId: (json['parent_booking_id'] as num?)?.toInt(),
      isPromotional: (json['is_promotional'] as num?)?.toInt(),
      promotionalAmount: (json['promotional_amount'] as num?)?.toInt(),
      endDate: json['end_date'] as String?,
      deadlineDate: json['deadline_date'] as String?,
      bookingOnCredit: (json['booking_on_credit'] as num?)?.toInt(),
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
      interestAmount: (json['interest_amount'] as num?)?.toInt(),
      maturityDate: json['maturity_date'] as String?,
      targetSaving: (json['target_saving'] as num?)?.toInt(),
      chamaDescription: json['chama_description'] as String?,
      image: json['image'] as String?,
      progress: (json['progress'] as num?)?.toInt(),
      payment: (json['payment'] as List<dynamic>?)
          ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : BookingUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWalletDataToJson(CreateWalletData instance) =>
    <String, dynamic>{
      'validationErrors': instance.validationErrors,
      'id': instance.id,
      'country_id': instance.countryId,
      'product_id': instance.productId,
      'booking_source': instance.bookingSource,
      'user_id': instance.userId,
      'merchant_id': instance.merchantId,
      'promoter_id': instance.promoterId,
      'outlet_id': instance.outletId,
      'booking_reference': instance.bookingReference,
      'referral_coupon': instance.referralCoupon,
      'booking_price': instance.bookingPrice,
      'validation_price': instance.validationPrice,
      'booking_offer_price': instance.bookingOfferPrice,
      'initial_deposit': instance.initialDeposit,
      'has_fixed_deadline': instance.hasFixedDeadline,
      'booking_status': instance.bookingStatus,
      'is_permanent': instance.isPermanent,
      'parent_booking_id': instance.parentBookingId,
      'is_promotional': instance.isPromotional,
      'promotional_amount': instance.promotionalAmount,
      'end_date': instance.endDate,
      'deadline_date': instance.deadlineDate,
      'booking_on_credit': instance.bookingOnCredit,
      'account_name': instance.accountName,
      'account_no': instance.accountNo,
      'reference': instance.reference,
      'phone_number': instance.phoneNumber,
      'checkout_status': instance.checkoutStatus,
      'frequency': instance.frequency,
      'frequency_contribution': instance.frequencyContribution,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'booking_interest': instance.bookingInterest,
      'interest_amount': instance.interestAmount,
      'maturity_date': instance.maturityDate,
      'target_saving': instance.targetSaving,
      'chama_description': instance.chamaDescription,
      'image': instance.image,
      'progress': instance.progress,
      'payment': instance.payment?.map((e) => e.toJson()).toList(),
      'user': instance.user?.toJson(),
    };

BookingUser _$BookingUserFromJson(Map<String, dynamic> json) => BookingUser(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      referralId: (json['referral_id'] as num?)?.toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber1: json['phone_number_1'] as String?,
      idNumber: json['id_number'] as String?,
      passportNumber: json['passport_number'] as String?,
      dob: json['dob'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$BookingUserToJson(BookingUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'referral_id': instance.referralId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number_1': instance.phoneNumber1,
      'id_number': instance.idNumber,
      'passport_number': instance.passportNumber,
      'dob': instance.dob,
      'country': instance.country,
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: (json['id'] as num?)?.toInt(),
      paymentId: (json['payment_id'] as num?)?.toInt(),
      bookingId: (json['booking_id'] as num?)?.toInt(),
      walletId: (json['wallet_id'] as num?)?.toInt(),
      paymentAmount: (json['payment_amount'] as num?)?.toInt(),
      destination: json['destination'] as String?,
      destinationAccountNo: json['destination_account_no'] as String?,
      destinationPhoneNo: json['destination_phone_no'] as String?,
      destinationTransactionReference:
          json['destination_transaction_reference'] as String?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'payment_id': instance.paymentId,
      'booking_id': instance.bookingId,
      'wallet_id': instance.walletId,
      'payment_amount': instance.paymentAmount,
      'destination': instance.destination,
      'destination_account_no': instance.destinationAccountNo,
      'destination_phone_no': instance.destinationPhoneNo,
      'destination_transaction_reference':
          instance.destinationTransactionReference,
      'deleted_at': instance.deletedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
