
class ValidateReceiptModel {
  final String slipNo;
  final String bookingReference;
  final String bookingPrice;

  ValidateReceiptModel({
    required this.slipNo,
    required this.bookingReference,
    required this.bookingPrice,
  });

  Map<String, dynamic> toJson() => {
        'slipNo': slipNo,
        'bookingReference': bookingReference,
        'bookingPrice': bookingPrice,
      };
}