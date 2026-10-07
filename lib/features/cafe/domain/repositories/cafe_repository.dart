import '../models/cafe_detail.dart';
import '../models/cafe_summary.dart';

abstract interface class CafeRepository {
  Future<List<CafeSummary>> getCafes();

  Future<CafeDetail?> getCafeById(String id);
}
