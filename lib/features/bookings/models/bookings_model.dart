//Booking Model
class Booking {
  final int id;
  final String bookingReference;
  final int bookingPrice;
  final String createdAt;
  final String updatedAt;
  final String bookingStatus;
  final int productId;
  final int outletId;
  final int userId;
  final int? totalPayments;
  final List<dynamic> bookingInterest;
  final int interestAmount;
  final String maturityDate;
  final int targetSaving;
  final String? chamaDescription;
  final String? image;
  final int progress;
  final Customer customer;
  final Product product;
  final Outlet outlet;
  final List<Payment> payment;

  Booking({
    required this.id,
    required this.bookingReference,
    required this.bookingPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingStatus,
    required this.productId,
    required this.outletId,
    required this.userId,
    this.totalPayments,
    required this.bookingInterest,
    required this.interestAmount,
    required this.maturityDate,
    required this.targetSaving,
    this.chamaDescription,
    this.image,
    required this.progress,
    required this.customer,
    required this.product,
    required this.outlet,
    required this.payment,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? 0,
      bookingReference: json['booking_reference'] ?? '',
      bookingPrice: json['booking_price'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      bookingStatus: json['booking_status'] ?? '',
      productId: json['product_id'] ?? 0,
      outletId: json['outlet_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      totalPayments: json['total_payments'],
      bookingInterest: json['booking_interest'] ?? [],
      interestAmount: json['interest_amount'] ?? 0,
      maturityDate: json['maturity_date'] ?? '',
      targetSaving: json['target_saving'] ?? 0,
      chamaDescription: json['chama_description'],
      image: json['image'],
      progress: json['progress'] ?? 0,
      customer: Customer.fromJson(json['customer'] ?? {}),
      product: Product.fromJson(json['product'] ?? {}),
      outlet: Outlet.fromJson(json['outlet'] ?? {}),
      payment: (json['payment'] as List?)
              ?.map((payment) => Payment.fromJson(payment))
              .toList() ??
          [],
         
    );
  }
}

//Customer Model
class Customer {
  final int id;
  final int countryId;
  final int userId;
  final String? referralId;
  final String firstName;
  final String lastName;
  final String phoneNumber1;
  final String mpesaCustomerId;
  final String? phoneNumber2;
  final String? idNumber;
  final String? passportNumber;
  final String? dob;
  final String gender;
  final String? country;
  final double? customerLongitude;
  final double? customerLatitude;
  final String? pin;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final String? stripeCustomerId;
  final int scoreHasBeenComputed;
  final String referralCode;
  final int isFlexsaveCustomer;

  Customer({
    required this.id,
    required this.countryId,
    required this.userId,
    this.referralId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber1,
    required this.mpesaCustomerId,
    this.phoneNumber2,
    this.idNumber,
    this.passportNumber,
    this.dob,
    required this.gender,
    this.country,
    this.customerLongitude,
    this.customerLatitude,
    this.pin,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.stripeCustomerId,
    required this.scoreHasBeenComputed,
    required this.referralCode,
    required this.isFlexsaveCustomer,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      referralId: json['referral_id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber1: json['phone_number_1'] ?? '',
      mpesaCustomerId: json['mpesa_customer_id'] ?? '',
      phoneNumber2: json['phone_number_2'],
      idNumber: json['id_number'],
      passportNumber: json['passport_number'],
      dob: json['dob'],
      gender: json['gender'] ?? '',
      country: json['country'],
      customerLongitude: json['customer_longitude']?.toDouble(),
      customerLatitude: json['customer_latitude']?.toDouble(),
      pin: json['pin'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      stripeCustomerId: json['stripe_customer_id'],
      scoreHasBeenComputed: json['score_has_been_computed'] ?? 0,
      referralCode: json['referral_code'] ?? '',
      isFlexsaveCustomer: json['is_flexsave_customer'] ?? 0,
    );
  }
}

//Product Model
class Product {
  final int id;
  final String productName;
  final String? maturityDate;
  final int targetSaving;
  final String? chamaDescription;

  Product({
    required this.id,
    required this.productName,
    this.maturityDate,
    required this.targetSaving,
    this.chamaDescription,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      maturityDate: json['maturity_date'],
      targetSaving: json['target_saving'] ?? 0,
      chamaDescription: json['chama_description'],
    );
  }
}

//Outlet Model
class Outlet {
  final int id;
  final String outletName;

  Outlet({
    required this.id,
    required this.outletName,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      id: json['id'] ?? 0,
      outletName: json['outlet_name'] ?? '',
    );
  }
}

//Payment Model
class Payment {
  final int id;
  final int bookingId;
  final int paymentAmount;
  final String createdAt;

  Payment({
    required this.id,
    required this.bookingId,
    required this.paymentAmount,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? 0,
      bookingId: json['booking_id'] ?? 0,
      paymentAmount: json['payment_amount'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}
