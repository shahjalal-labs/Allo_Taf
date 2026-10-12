class JobGridModel {
  final String title;
  final String location;
  final String duration;
  final String agencyName;
  final String price;
  final String timeFrame;
  final bool isBoosted;

  JobGridModel({
    required this.title,
    required this.location,
    required this.duration,
    required this.agencyName,
    required this.price,
    required this.timeFrame,
    this.isBoosted = false,
  });
}
