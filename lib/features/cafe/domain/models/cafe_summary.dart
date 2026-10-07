enum CafeLiveStatus { quiet, moderate, crowded }

class CafeSummary {
  const CafeSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.distance,
    required this.liveStatus,
    this.imagePath,
    this.isSaved = false,
  });

  final String id;
  final String name;
  final String category;
  final double rating;
  final String distance;
  final CafeLiveStatus liveStatus;
  final String? imagePath;
  final bool isSaved;
}
