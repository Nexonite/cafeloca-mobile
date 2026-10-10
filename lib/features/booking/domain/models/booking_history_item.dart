import 'booking.dart';

class BookingHistoryItem {
  const BookingHistoryItem({
    required this.id,
    required this.cafeId,
    required this.cafeName,
    required this.date,
    required this.time,
    required this.guestCount,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  final String id;
  final String cafeId;
  final String cafeName;
  final DateTime date;
  final String time;
  final int guestCount;
  final BookingStatus status;
  final DateTime createdAt;
  final String? notes;
}
