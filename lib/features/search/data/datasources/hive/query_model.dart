import 'package:hive/hive.dart';

part 'query_model.g.dart';

@HiveType(typeId: 1)
class QueryModel extends HiveObject {
  @HiveField(0)
  String? keyword;

  @HiveField(1)
  String? createdAt;

  QueryModel({
    this.keyword,
    this.createdAt,
  });
}
