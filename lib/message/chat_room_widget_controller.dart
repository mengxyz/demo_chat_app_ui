import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PageData<P, T> {
  final P? nextPage;
  final dynamic error;

  const PageData({
    this.nextPage,
    this.error,
  });
}

enum PageState {
  init,
  loading,
  loaded,
  error,
  ended;
}

class ChatRoomWidgetController<P, T> {
  List<T> _buffer = [];
  Future<void> Function(P)? _fetchListener;
  List<T> get items => _buffer;
  bool Function(T, T) diffUtils;
  final List<Function> _listeners = [];
  late PageData<P, T> currentPage;
  final int Function(T a, T b)? sort;
  PageState _pageState = PageState.init;
  PageState get pageState => _pageState;
  final scrollController = ScrollController();
  // scrollToEnd When add or update
  final bool scrollToEnd;

  set pageState(n) {
    _pageState = n;
    _notifyListeners();
  }

  ChatRoomWidgetController({
    required this.diffUtils,
    required P initialPage,
    this.sort,
    this.scrollToEnd = true,
  }) {
    currentPage = PageData(nextPage: initialPage);
  }

  void _notifyListeners() {
    for (var element in _listeners) {
      element.call();
    }
  }

  void addListener(Function listener) => _listeners.add(listener);
  void removeListener(Function listener) => _listeners.remove(listener);
  void dispose() => _listeners.clear();

  void add(List<T> newItem, {bool replace = false}) {
    if (replace) {
      _buffer = newItem;
    } else {
      _buffer.insertAll(0, newItem);
    }
    _notifyListeners();
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.bounceIn,
    );
  }

  /// Call init page when add listener
  Future<void> fetchListener(Future<void> Function(P) fetchListener) async {
    _fetchListener = fetchListener;
    pageState = PageState.loading;
    await _fetchListener?.call(currentPage.nextPage as P);
  }

  Future<void> refresh() async {
    if (currentPage.nextPage == null) return;
    pageState = PageState.loading;
    await _fetchListener?.call(currentPage.nextPage as P);
  }

  void addPage(List<T> newItem, P nextPage) {
    currentPage = PageData(nextPage: nextPage);
    _buffer.addAll(newItem);
    pageState = PageState.loaded;
  }

  void addLatestPage(List<T> newItem) {
    currentPage = const PageData(nextPage: null);
    _buffer.addAll(newItem);
    pageState = PageState.ended;
  }

  /// Update sended message when send success or fail
  updateAtAndSort(bool Function(T) where, T newItem) {
    final T? updateItem = _buffer.firstWhereOrNull(where);
    if (updateItem == null) return;
    final updateIndex = _buffer.indexOf(updateItem);
    _buffer[updateIndex] = newItem;
    _buffer.sort(sort);
    _notifyListeners();
  }

  pageError(dynamic error) {
    currentPage = PageData(
      error: error,
      nextPage: currentPage.nextPage,
    );
    pageState = PageState.error;
  }

  void callNextPage() {
    refresh();
  }
}
