part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.keywordChanged(String keyword) = _KeywordChanged;
  const factory SearchEvent.historyRemoved(String keyword) = _HistoryRemoved;
  const factory SearchEvent.submitted() = _Submitted;
}
