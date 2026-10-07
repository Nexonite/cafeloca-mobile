import '../domain/models/cafe_detail.dart';
import '../domain/models/cafe_summary.dart';

abstract final class CafeDummyData {
  static const List<CafeSummary> cafes = [
    CafeSummary(
      id: '1',
      name: 'Nook Coffee',
      category: 'Coffee Shop',
      rating: 4.8,
      distance: '1.2 km',
      liveStatus: CafeLiveStatus.quiet,
      imagePath: 'assets/images/cafes/cafe_01.jpg',
    ),
    CafeSummary(
      id: '2',
      name: 'Sora Coffee House',
      category: 'Specialty Coffee',
      rating: 4.7,
      distance: '2.1 km',
      liveStatus: CafeLiveStatus.moderate,
      imagePath: 'assets/images/cafes/cafe_02.jpg',
    ),
    CafeSummary(
      id: '3',
      name: 'Atelier Brew',
      category: 'Coffee & Casual',
      rating: 4.6,
      distance: '2.8 km',
      liveStatus: CafeLiveStatus.crowded,
      imagePath: 'assets/images/cafes/cafe_03.jpg',
    ),
  ];

  static const List<CafeDetail> details = [
    CafeDetail(
      summary: CafeSummary(
        id: '1',
        name: 'Nook Coffee',
        category: 'Coffee Shop',
        rating: 4.8,
        distance: '1.2 km',
        liveStatus: CafeLiveStatus.quiet,
        imagePath: 'assets/images/cafes/cafe_01.jpg',
      ),
      description: 'A calm neighborhood coffee spot with a warm interior, comfortable seating, and plenty of space for slow mornings or focused work.',
      address: 'Central Jakarta',
      openingHours: '08:00 - 22:00',
      suitableFor: ['Work', 'Study', 'Relax'],
      facilities: [
        CafeFacility.wifi,
        CafeFacility.powerOutlet,
        CafeFacility.airConditioner,
        CafeFacility.parking,
        CafeFacility.toilet,
      ],
      menuItems: [
        CafeMenuItem(name: 'Caffè Latte', category: 'Coffee', price: 32000),
        CafeMenuItem(name: 'Iced Americano', category: 'Coffee', price: 28000),
        CafeMenuItem(
          name: 'Butter Croissant',
          category: 'Pastry',
          price: 26000,
        ),
      ],
      reviewCount: 128,
    ),

    CafeDetail(
      summary: CafeSummary(
        id: '2',
        name: 'Sora Coffee House',
        category: 'Specialty Coffee',
        rating: 4.7,
        distance: '2.1 km',
        liveStatus: CafeLiveStatus.moderate,
        imagePath: 'assets/images/cafes/cafe_02.jpg',
      ),
      description: 'A warm specialty coffee house with an intimate atmosphere, crafted drinks, and a comfortable setting for conversations.',
      address: 'South Jakarta',
      openingHours: '09:00 - 23:00',
      suitableFor: ['Hangout', 'Meeting', 'Date'],
      facilities: [
        CafeFacility.wifi,
        CafeFacility.airConditioner,
        CafeFacility.smokingArea,
        CafeFacility.parking,
        CafeFacility.toilet,
      ],
      menuItems: [
        CafeMenuItem(name: 'Flat White', category: 'Coffee', price: 34000),
        CafeMenuItem(name: 'Spanish Latte', category: 'Coffee', price: 36000),
        CafeMenuItem(name: 'Chocolate Cake', category: 'Dessert', price: 38000),
      ],
      reviewCount: 96,
    ),

    CafeDetail(
      summary: CafeSummary(
        id: '3',
        name: 'Atelier Brew',
        category: 'Coffee & Casual',
        rating: 4.6,
        distance: '2.8 km',
        liveStatus: CafeLiveStatus.crowded,
        imagePath: 'assets/images/cafes/cafe_03.jpg',
      ),
      description: 'An open and social café with indoor and outdoor spaces designed for casual afternoons, group conversations, and weekend coffee.',
      address: 'West Jakarta',
      openingHours: '08:00 - 00:00',
      suitableFor: ['Hangout', 'Family', 'Relax'],
      facilities: [
        CafeFacility.wifi,
        CafeFacility.parking,
        CafeFacility.outdoor,
        CafeFacility.smokingArea,
        CafeFacility.prayerRoom,
        CafeFacility.toilet,
      ],
      menuItems: [
        CafeMenuItem(name: 'Cold Brew', category: 'Coffee', price: 30000),
        CafeMenuItem(
          name: 'Matcha Latte',
          category: 'Non Coffee',
          price: 35000,
        ),
        CafeMenuItem(name: 'Chicken Sandwich', category: 'Food', price: 42000),
      ],
      reviewCount: 74,
    ),
  ];

  static CafeDetail? detailById(String id) {
    for (final cafe in details) {
      if (cafe.summary.id == id) {
        return cafe;
      }
    }

    return null;
  }
}
