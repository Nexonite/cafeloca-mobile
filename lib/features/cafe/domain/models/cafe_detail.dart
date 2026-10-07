import 'cafe_summary.dart';

class CafeDetail {
  const CafeDetail({
    required this.summary,
    required this.description,
    required this.address,
    required this.openingHours,
    required this.suitableFor,
    required this.facilities,
    required this.menuItems,
    required this.reviewCount,
  });

  final CafeSummary summary;
  final String description;
  final String address;
  final String openingHours;

  final List<String> suitableFor;
  final List<CafeFacility> facilities;
  final List<CafeMenuItem> menuItems;

  final int reviewCount;
}

enum CafeFacility {
  wifi,
  powerOutlet,
  parking,
  airConditioner,
  outdoor,
  smokingArea,
  prayerRoom,
  meetingRoom,
  petFriendly,
  toilet,
  wheelchairAccessible,
}

class CafeMenuItem {
  const CafeMenuItem({
    required this.name,
    required this.category,
    required this.price,
  });

  final String name;
  final String category;
  final int price;
}
