import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

enum ViewState { initial, loading, error, hasData, noData }

extension ViewStateExtension on ViewState {
  bool get isInitial => this == ViewState.initial;
  bool get isLoading => this == ViewState.loading;
  bool get isError => this == ViewState.error;
  bool get isHasData => this == ViewState.hasData;
  bool get isNoData => this == ViewState.noData;
}

class ViewData<T> extends Equatable {
  final ViewState status;
  final T? data;
  final String message;
  final Failure? failure;

  const ViewData._({
    required this.status,
    this.data,
    this.message = '',
    this.failure,
  });

  // ---- factories ----

  factory ViewData.initial() {
    return const ViewData._(status: ViewState.initial);
  }

  factory ViewData.loading({String? message}) {
    return ViewData._(status: ViewState.loading, message: message ?? '');
  }

  factory ViewData.loaded({required T data}) {
    return ViewData._(status: ViewState.hasData, data: data);
  }

  factory ViewData.error({required Failure failure}) {
    return ViewData._(
      status: ViewState.error,
      failure: failure,
      message: failure.message,
    );
  }

  factory ViewData.noData() {
    return const ViewData._(status: ViewState.noData);
  }

  // ---- helpers ----

  bool get isInitial => status.isInitial;
  bool get isLoading => status.isLoading;
  bool get isError => status.isError;
  bool get isHasData => status.isHasData;
  bool get isNoData => status.isNoData;

  ViewData<T> copyWith({
    ViewState? status,
    T? data,
    String? message,
    Failure? failure,
  }) {
    return ViewData._(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, data, message, failure];
}
