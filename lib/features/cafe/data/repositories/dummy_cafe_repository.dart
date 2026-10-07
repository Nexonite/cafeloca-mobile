import '../../domain/models/cafe_detail.dart';
import '../../domain/models/cafe_summary.dart';
import '../../domain/repositories/cafe_repository.dart';
import '../cafe_dummy_data.dart';

class DummyCafeRepository implements CafeRepository {
  const DummyCafeRepository();

  @override
  Future<List<CafeSummary>> getCafes() async {
    return CafeDummyData.cafes;
  }

  @override
  Future<CafeDetail?> getCafeById(String id) async {
    return CafeDummyData.detailById(id);
  }
}
