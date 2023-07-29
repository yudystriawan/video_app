import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/usecases/get_search_history.dart';
import '../../../domain/usecases/remove_search_keyword.dart';
import '../../../domain/usecases/save_search_keyword.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetSearchHistory _getSearchHistory;
  final RemoveSearchKeyword _removeSearchKeyword;
  final SaveSearchKeyword _saveSearchKeyword;

  CancelableOperation? _cancelableOperation;

  SearchBloc(
    this._getSearchHistory,
    this._removeSearchKeyword,
    this._saveSearchKeyword,
  ) : super(SearchState.initial()) {
    on<_Fetched>(_onFetched);
    on<_KeywordChanged>(_onKeywordChanged);
    on<_HistoryRemoved>(_onHistoryRemoved);
    on<_Submitted>(_onSubmitted);
  }

  _searchStarted() {
    _cancelableOperation = CancelableOperation.fromFuture(
      Future.delayed(const Duration(milliseconds: 800)),
    );
  }

  void _onFetched(
    _Fetched event,
    Emitter<SearchState> emit,
  ) async {
    final failureOrHistories =
        await _getSearchHistory(GetSearchParams(event.keyword));
    emit(failureOrHistories.fold(
      (f) => state,
      (histories) => state.copyWith(histories: histories),
    ));
  }

  void _onKeywordChanged(
    _KeywordChanged event,
    Emitter<SearchState> emit,
  ) async {
    final keyword = event.keyword;

    final isChanged = keyword != state.keyword;

    if (isChanged) {
      emit(state.copyWith(keyword: keyword));

      _cancelableOperation?.cancel();
      _searchStarted();

      _cancelableOperation?.value.whenComplete(
        () => add(SearchEvent.fetched(keyword)),
      );
    }
  }

  void _onHistoryRemoved(
    _HistoryRemoved event,
    Emitter<SearchState> emit,
  ) async {
    final keyword = event.keyword;

    await _removeSearchKeyword(RemoveSearchParams(keyword));

    add(const SearchEvent.fetched());
  }

  void _onSubmitted(
    _Submitted event,
    Emitter<SearchState> emit,
  ) async {
    await _saveSearchKeyword(SaveSearchKeywordParams(state.keyword));
    // add(const SearchEvent.fetched());
  }
}