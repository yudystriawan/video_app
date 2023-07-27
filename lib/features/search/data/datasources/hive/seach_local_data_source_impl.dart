import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:video_app/core/errors/failures.dart';
import 'package:video_app/features/search/data/datasources/search_local_data_source.dart';
import 'package:video_app/features/search/data/models/query_dto.dart';

@Injectable(as: SearchLocalDataSource)
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final _searchBox = 'searchBox';
  late Box<QueryModel> _box;

  @PostConstruct()
  init() async {
    _box = await Hive.openBox<QueryModel>(_searchBox);
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _box.deleteAll(_box.keys);
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }

  @override
  Future<List<String>> getHistories({String? keyword}) async {
    try {
      final histories = _box.values;

      // get keyword that does not null and not empty
      final filteredHistories = histories
          .where((element) =>
              element.keyword != null && element.keyword!.isNotEmpty)
          .toList();

      final result = filteredHistories.map((e) => e.keyword!).toList();

      return result;
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }

  @override
  Future<void> storeKeyword(String keyword) async {
    try {
      await _box.add(QueryModel(keyword: keyword));
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }

  @override
  Future<void> deleteKeyword(String keyword) async {
    try {
      await _box.delete(keyword);
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }
}
