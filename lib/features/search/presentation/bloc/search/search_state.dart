part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required String keyword,
    required KtList<String> histories,
    @Default(false) bool isEditing,
  }) = _SearchState;

  factory SearchState.initial() =>
      const SearchState(keyword: '', histories: KtList.empty());
}
