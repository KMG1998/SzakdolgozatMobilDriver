import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/history/history_state.dart';
import 'package:szakdolgozat_mobil_driver_side/services/order_service.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super((HistoryInit()));

  void getHistory() async {
    try {
      emit(HistoryLoading());
      final history = await getIt.get<OrderService>().getHistory();
      if (history != null) {
        emit(HistoryLoaded(orders: history));
        return;
      }
      emit(HistoryLoaded(orders: [], errorMessage: 'Ismeretlen hiba'));
    } catch (e) {
      if (e is DioException) {
        emit(HistoryLoaded(orders: [], errorMessage: e.message));
        return;
      }
      emit(HistoryLoaded(orders: [], errorMessage: 'Ismeretlen hiba'));
    }
  }

  void reset() {
    emit(HistoryInit());
  }

  void selectOrder(int index) {
    emit((state as HistoryLoaded).copyWith(selectedOrderIndex: index));
  }
}
