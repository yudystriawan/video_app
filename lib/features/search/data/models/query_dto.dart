import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_app/features/search/domain/entities/query.dart';

part 'query_dto.freezed.dart';
part 'query_dto.g.dart';

@freezed
class QueryModel with _$QueryModel {
  const QueryModel._();
  const factory QueryModel({
    String? keyword,
  }) = _QueryModel;

  factory QueryModel.fromJson(Map<String, dynamic> json) =>
      _$QueryModelFromJson(json);

  factory QueryModel.fromEntity(Query entity) {
    return QueryModel(
      keyword: entity.keyword,
    );
  }
}
