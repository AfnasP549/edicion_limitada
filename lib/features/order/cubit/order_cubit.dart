import 'package:bloc/bloc.dart';
import 'package:edicion_limitada/features/order/model/order_model.dart';
import 'package:edicion_limitada/features/order/service/order_service.dart';
import 'package:equatable/equatable.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderService _orderService;
  OrderCubit(this._orderService) : super(OrderInitial());

  Future<void> fetchOrders() async {
    try {
      emit(OrderLoading());
      final orders = await _orderService.fetchUserOrders();
      print('Fetched orders: ${orders.length}'); // Debug print
      for (var order in orders) {
        print('Order ID: ${order.id}');
        print('Items count: ${order.items.length}');
        for (var item in order.items) {
          print('Product: ${item.productName}');
          print('ImageUrl: ${item.imageUrl}');
          print('ImageUrls: ${item.imageUrls}');
        }
      }
      emit(OrderLoaded(orders));
    } catch (e) {
      print('Error in OrderCubit: $e'); // Debug print
      emit(OrderError('Order cannot be Fetched: ${e.toString()}'));
    }
  }


  
}