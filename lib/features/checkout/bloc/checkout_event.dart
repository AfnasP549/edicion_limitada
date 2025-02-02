part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCheckoutEvent extends CheckoutEvent {}

class SelectAddressEvent extends CheckoutEvent {
  final AddressModel address;

  const SelectAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class PlaceOrderEvent extends CheckoutEvent {
  final String? paymentMethod;
  final String? paymentStatus;

  const PlaceOrderEvent({
    this.paymentMethod,
    this.paymentStatus,
  });

  @override
  List<Object?> get props => [paymentMethod, paymentStatus];
}

class AddAddressInCheckoutEvent extends CheckoutEvent {
  final AddressModel address;

  const AddAddressInCheckoutEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class CancelOrderEvent extends CheckoutEvent {
  final String orderId;

  const CancelOrderEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}