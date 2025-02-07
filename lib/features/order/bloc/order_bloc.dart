import 'package:bloc/bloc.dart';
import 'package:edicion_limitada/features/order/model/order_model.dart';
import 'package:edicion_limitada/features/order/service/order_service.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
   final OrderService _orderService;
  OrderBloc(this._orderService) : super(OrderInitial()) {
     on<LoadOrders>(_onLoadOrders);
    on<CancelOrderEvent>(_onCancelOrder);
   
  }

   void _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) {
    emit(OrderLoading());
    try {
      _orderService.getOrdersStream().listen(
        (orders) {
          emit(OrderLoaded(orders));
        },
        onError: (error) {
          emit(OrderError('Failed to load orders: $error'));
        },
      );
    } catch (e) {
      emit(OrderError('Failed to set up orders stream: $e'));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderCancelling());
      await _orderService.cancelOrder(event.order);
      emit(OrderCancelled());
    } catch (e) {
      emit(OrderError('Failed to cancel order: $e'));
    }
  }
}
