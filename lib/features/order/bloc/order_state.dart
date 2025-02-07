part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();
  
  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}


class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderModel> orders;

  OrderLoaded(this.orders);

 
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);

 
}

class OrderCancelling extends OrderState {}

class OrderCancelled extends OrderState {}