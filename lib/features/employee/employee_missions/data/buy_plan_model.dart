class BuyPlanModel {
  final String title;
  final String? badge;
  final String price;
  final String currency;
  final List<String> features;
  final bool isFree;

  BuyPlanModel({
    required this.title,
    this.badge,
    required this.price,
    required this.currency,
    required this.features,
    this.isFree = false,
  });
}
