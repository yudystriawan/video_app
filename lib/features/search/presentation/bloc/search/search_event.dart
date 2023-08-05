part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.initialized([String? keyword]) = _Initialized;
  const factory SearchEvent.keywordChanged(String keyword) = _KeywordChanged;
  const factory SearchEvent.historyRemoved(String keyword) = _HistoryRemoved;
  const factory SearchEvent.historySelected(String keyword) = _HistorySelected;
  const factory SearchEvent.submitted() = _Submitted;
}
