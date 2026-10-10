enum BookingStatus { pending, confirmed, cancelled, completed }

class Booking {
  const Booking({
    required this.cafeId,
    required this.cafeName,
    required this.date,
    required this.time,
    required this.guestCount,
    this.id,
    this.status = BookingStatus.pending,
    this.notes,
  });

  final String? id;
  final String cafeId;
  final String cafeName;
  final DateTime date;
  final String time;
  final int guestCount;
  final BookingStatus status;
  final String? notes;
}
