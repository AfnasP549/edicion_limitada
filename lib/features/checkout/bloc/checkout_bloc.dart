import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:edicion_limitada/features/address_management/bloc/address_bloc.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';
import 'package:edicion_limitada/features/cart/bloc/cart_bloc.dart';
import 'package:edicion_limitada/features/cart/model/cart_model.dart';
import 'package:edicion_limitada/features/checkout/service/checkou_service.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutService _checkoutService;
  final CartBloc _cartBloc;
  final AddressBloc _addressBloc;

  CheckoutBloc({
    required CheckoutService checkoutService,
    required CartBloc cartBloc,
    required AddressBloc addressBloc,
  })  : _checkoutService = checkoutService,
        _cartBloc = cartBloc,
        _addressBloc = addressBloc,
        super(CheckoutInitialState()) {
    on<InitializeCheckoutEvent>(_onInitializeCheckout);
    on<SelectAddressEvent>(_onSelectAddress);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<AddAddressInCheckoutEvent>(_onAddAddressInCheckout);
  }

  //! Initialize Checkout
  Future<void> _onInitializeCheckout(
    InitializeCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      final cartState = _cartBloc.state;

      // Ensure cart has items
      if (cartState.items.isEmpty) {
        emit(const CheckoutFailureState(error: 'Cart is empty'));
        return;
      }

      // Trigger loading of addresses if not already loaded
      if (_addressBloc.state is! AddressLoadedState) {
        _addressBloc.add(LoadAddressesEvent());
        await Future.delayed(const Duration(milliseconds: 200));
      }

      // Fetch updated address state
      final addressState = _addressBloc.state;
      List<AddressModel> addresses = [];
      if (addressState is AddressLoadedState) {
        addresses = addressState.addresses;
      }

      // Set default or first available address
      AddressModel? selectedAddress = addresses.isNotEmpty
          ? addresses.firstWhere(
              (address) => address.isDefault,
              orElse: () => addresses.first,
            )
          : null;

      emit(CheckoutLoadedState(
        items: cartState.items,
        addresses: addresses,
        selectedAddress: selectedAddress,
        totalAmount: cartState.totalAmount,
      ));
    } catch (e) {
      emit(CheckoutFailureState(error: 'Failed to initialize checkout: $e'));
    }
  }

  //! Select Address
  void _onSelectAddress(
    SelectAddressEvent event,
    Emitter<CheckoutState> emit,
  ) {
    if (state is CheckoutLoadedState) {
      final currentState = state as CheckoutLoadedState;
      emit(currentState.copyWith(selectedAddress: event.address));
    }
  }

  //! Place Order
  Future<void> _onPlaceOrder(
  PlaceOrderEvent event,
  Emitter<CheckoutState> emit,
) async {
  if (state is CheckoutLoadedState) {
    try {
      final currentState = state as CheckoutLoadedState;

      if (currentState.selectedAddress == null) {
        emit(const CheckoutFailureState(error: 'Please select a delivery address.'));
        return;
      }

      emit(CheckoutProcessing());

      final orderId = await _checkoutService.placeOrder(
        items: currentState.items,
        address: currentState.selectedAddress!,
        totalAmount: currentState.totalAmount,
        paymentMethod: event.paymentMethod ?? 'Cash on Delivery',
        paymentStatus: event.paymentStatus ?? 'Pending',
      );

      emit(CheckoutSuccess(orderId: orderId));
    } catch (e) {
      emit(CheckoutFailureState(error: 'Order placement failed: $e'));
    }
  }
}

  //! Add Address in Checkout
  Future<void> _onAddAddressInCheckout(
    AddAddressInCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    if (state is CheckoutLoadedState) {
      try {
        final currentState = state as CheckoutLoadedState;

        _addressBloc.add(AddAddressEvent(event.address));
        final addressState = _addressBloc.state;
        if (addressState is AddressLoadedState) {
          emit(CheckoutLoadedState(
            items: currentState.items,
            addresses: addressState.addresses,
            selectedAddress: event.address,
            totalAmount: currentState.totalAmount,
          ));
        }
      } catch (e) {
        emit(CheckoutFailureState(error: 'Failed to add address: $e'));
      }
    }
  }


}
