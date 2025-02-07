part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}


class LoadOrders extends OrderEvent {}

class CancelOrderEvent extends OrderEvent {
  final OrderModel order;

  CancelOrderEvent(this.order);


}