class CommissionModel {
  final int totalCommissions;
  final int deficit;

  CommissionModel({
    required this.totalCommissions,
    required this.deficit,
  });

  factory CommissionModel.fromJson(Map<String, dynamic> json) {
    return CommissionModel(
      totalCommissions: json['data']['totalCommissions'] ?? 0,
      deficit: json['data']['deficit'] ?? 0,
    );
  }
}