class Booking {
  const Booking({
    required this.cafeId,
    required this.cafeName,
    required this.date,
    required this.time,
    required this.guestCount,
    this.notes,
  });

  final String cafeId;
  final String cafeName;
  final DateTime date;
  final String time;
  final int guestCount;
  final String? notes;
}
