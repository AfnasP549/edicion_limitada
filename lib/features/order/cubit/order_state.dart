part of 'order_cubit.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

class OrderLoading extends OrderState{}

class OrderLoaded extends OrderState{
  final List<OrderModel> orders;

  const OrderLoaded(this.orders);
}

class OrderError extends OrderState{
  final String error;

  const OrderError(this.error);
}
