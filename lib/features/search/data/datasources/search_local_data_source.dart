abstract class SearchLocalDataSource {
  Future<List<String>> getHistories({String? keyword});
  Future<void> storeKeyword(String keyword);
  Future<void> deleteKeyword(String keyword);
  Future<void> deleteAll();
}
