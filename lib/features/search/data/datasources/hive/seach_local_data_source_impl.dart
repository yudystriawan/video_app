import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/failures.dart';
import '../search_local_data_source.dart';
import 'query_model.dart';

@Injectable(as: SearchLocalDataSource)
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final _searchBox = 'searchBox';

  Future<Box<QueryModel>> _openBox() async {
    return Hive.openBox<QueryModel>(_searchBox);
  }

  @override
  Future<void> clear() async {
    try {
      final box = await _openBox();
      await box.deleteAll(box.keys);
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }

  @override
  Future<List<String>> getHistories({String? keyword}) async {
    try {
      final box = await _openBox();
      List<QueryModel> histories = box.values.toList();

      // get keyword that does not null and not empty
      if (keyword != null && keyword.isNotEmpty) {
        histories = histories
            .where((element) =>
                element.keyword
                    ?.toLowerCase()
                    .contains(keyword.toLowerCase()) ??
                false)
            .toList();
      }

      // sort descending order
      histories.sort(
        (a, b) {
          if (a.createdAt != null && b.createdAt != null) {
            final createdAtB = DateTime.parse(b.createdAt!);
            final createdAtA = DateTime.parse(a.createdAt!);

            return createdAtB.compareTo(createdAtA);
          }

          return -1;
        },
      );

      final result = histories.map((e) => e.keyword ?? '').toList();

      return result;
    } catch (e) {
      log('getHistories', error: e);
      throw const Failure.unexpectedError();
    }
  }

  @override
  Future<void> storeKeyword(String keyword) async {
    try {
      final box = await _openBox();
      final histories = box.values.toList();

      // check if keyword exist
      final filteredHistories = histories
          .where((element) =>
              element.keyword?.toLowerCase() == keyword.toLowerCase())
          .toList();

      if (filteredHistories.isNotEmpty) return;

      await box.add(QueryModel(
        keyword: keyword,
        createdAt: DateTime.now().toIso8601String(),
      ));
    } catch (e) {
      log('storeKeyword', error: e);
      throw const Failure.unexpectedError();
    }
  }

  @override
  Future<void> deleteKeyword(String keyword) async {
    try {
      final box = await _openBox();
      final histories = box.toMap();

      for (var history in histories.entries) {
        if (history.value.keyword == keyword) {
          await box.delete(history.key);
        }
      }
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }
}
