/// Represents a single EMI plan available for a product.
class EmiPlan {
  final String id;
  final String productId;
  final double monthlyAmount;
  final int tenureMonths;
  final double interestRate;
  final double cashback;
  final String tag;       // e.g. "Popular", "Best Value"
  final String bankName;  // e.g. "1Fi Credit"

  const EmiPlan({
    required this.id,
    required this.productId,
    required this.monthlyAmount,
    required this.tenureMonths,
    required this.interestRate,
    required this.cashback,
    required this.tag,
    required this.bankName,
  });

  bool get isNoCost => interestRate == 0.0;
  bool get hasCashback => cashback > 0;
  bool get hasTag => tag.isNotEmpty;

  factory EmiPlan.fromJson(Map<String, dynamic> json) {
    return EmiPlan(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? json['product_id']?.toString() ?? '',
      monthlyAmount: (json['monthlyAmount'] ?? json['monthly_amount'] as num?)
              ?.toDouble() ??
          0.0,
      tenureMonths:
          (json['tenureMonths'] ?? json['tenure_months'] as num?)?.toInt() ?? 0,
      interestRate: (json['interestRate'] ?? json['interest_rate'] as num?)
              ?.toDouble() ??
          0.0,
      cashback: (json['cashback'] as num?)?.toDouble() ?? 0.0,
      tag: json['tag']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? json['bank_name']?.toString() ?? '1Fi Credit',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'monthlyAmount': monthlyAmount,
    'tenureMonths': tenureMonths,
    'interestRate': interestRate,
    'cashback': cashback,
    'tag': tag,
    'bankName': bankName,
  };

  EmiPlan copyWith({
    String? id,
    String? productId,
    double? monthlyAmount,
    int? tenureMonths,
    double? interestRate,
    double? cashback,
    String? tag,
    String? bankName,
  }) {
    return EmiPlan(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      interestRate: interestRate ?? this.interestRate,
      cashback: cashback ?? this.cashback,
      tag: tag ?? this.tag,
      bankName: bankName ?? this.bankName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is EmiPlan && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
