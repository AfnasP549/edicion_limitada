part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();
  
  @override
  List<Object?> get props => [];
}

class CheckoutInitialState extends CheckoutState {}

class CheckoutLoadedState extends CheckoutState {
  final List<CartItem> items;
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final double totalAmount;

  const CheckoutLoadedState({
    required this.items,
    required this.addresses,
    this.selectedAddress,
    required this.totalAmount,
  });

  CheckoutLoadedState copyWith({
    List<CartItem>? items,
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
    double? totalAmount,
  }) {
    return CheckoutLoadedState(
      items: items ?? this.items,
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  @override
  List<Object?> get props => [
    items, 
    addresses, 
    selectedAddress, 
    totalAmount
  ];
}

class CheckoutProcessing extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final String orderId;

  const CheckoutSuccess({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class CheckoutFailureState extends CheckoutState {
  final String error;

  const CheckoutFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
