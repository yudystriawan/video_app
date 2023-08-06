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
    on<_Initialized>(_onInitialized);
    on<_KeywordChanged>(_onKeywordChanged);
    on<_HistoryRemoved>(_onHistoryRemoved);
    on<_Submitted>(_onSubmitted);
    on<_HistorySelected>(_onHistorySelected);
  }

  _searchStarted() {
    _cancelableOperation = CancelableOperation.fromFuture(
      Future.delayed(const Duration(milliseconds: 800)),
    );
  }

  Future<SearchState> _fetched(String? keyword) async {
    final newState = state.copyWith(isEditing: false);

    final failureOrHistories =
        await _getSearchHistory(GetSearchParams(keyword));

    return failureOrHistories.fold(
      (f) => newState,
      (histories) => newState.copyWith(histories: histories),
    );
  }

  void _onInitialized(
    _Initialized event,
    Emitter<SearchState> emit,
  ) async {
    final keyword = event.keyword;

    if (keyword?.isNotEmpty ?? false) {
      emit(state.copyWith(
        keyword: keyword!,
        isEditing: true,
      ));
    }

    emit(await _fetched(keyword));
  }

  void _onKeywordChanged(
    _KeywordChanged event,
    Emitter<SearchState> emit,
  ) async {
    final keyword = event.keyword;

    final isChanged = keyword != state.keyword;

    if (isChanged) {
      emit(state.copyWith(keyword: keyword));

      // when keyword is empty, immedietly fetch histories.
      if (keyword.isEmpty) {
        emit(await _fetched(keyword));
        return;
      }

      _cancelableOperation?.cancel();
      _searchStarted();

      _cancelableOperation?.value.whenComplete(
        () => add(SearchEvent.initialized(keyword)),
      );
    }
  }

  void _onHistoryRemoved(
    _HistoryRemoved event,
    Emitter<SearchState> emit,
  ) async {
    final keyword = event.keyword;

    await _removeSearchKeyword(RemoveSearchParams(keyword));

    add(const SearchEvent.initialized());
  }

  void _onHistorySelected(
    _HistorySelected event,
    Emitter<SearchState> emit,
  ) async {
    final keyword = event.keyword;

    emit(state.copyWith(isEditing: true, keyword: keyword));

    add(SearchEvent.initialized(keyword));
  }

  void _onSubmitted(
    _Submitted event,
    Emitter<SearchState> emit,
  ) async {
    await _saveSearchKeyword(SaveSearchKeywordParams(state.keyword));
    // add(const SearchEvent.fetched());
  }
}
