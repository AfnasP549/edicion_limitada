// ignore_for_file: deprecated_member_use, prefer_const_declarations, unused_local_variable, unused_field

import 'dart:convert';
import 'package:edicion_limitada/common/widget/custom_nav_bar.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';
import 'package:edicion_limitada/features/address_management/view/address_manage_screen.dart';
import 'package:edicion_limitada/features/cart/bloc/cart_bloc.dart';
import 'package:edicion_limitada/features/checkout/bloc/checkout_bloc.dart';
import 'package:edicion_limitada/features/checkout/widget/address_card.dart';
import 'package:edicion_limitada/features/checkout/widget/order_success_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Razorpay _razorpay;
  bool _isInitialLoading = true;
  AddressModel? selectedAddress;
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Add initial loading delay
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isInitialLoading = false);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Clear all cart items
    context.read<CartBloc>().add(const ClearCartEvent());

    // Create order
    context.read<CheckoutBloc>().add(
        PlaceOrderEvent(paymentMethod: 'Razorpay', paymentStatus: 'Paid'));

    // Show success popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OrderSuccessPopup(
          orderId: response.orderId ?? 'N/A',
          onDismiss: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const CustomNavBar()),
              (route) => false,
            );
          },
        );
      },
    );

    // Handle successful payment
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CustomNavBar()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

 void _startRazorpayPayment(CheckoutLoadedState state) {
    final double finalTotal = state.totalAmount + 40.99; // Add delivery charge
    var options = {
      'key': 'rzp_test_jIotm3SaZbXO9x',
      'amount': (finalTotal * 100).toInt(), // Use final total including delivery
      'name': 'Limitada Shopping',
      'description': 'Payment for Order',
      'prefill': {
        'contact': '',
        'email': ''
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error starting Razorpay: $e');
    }
  }
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
           Lottie.asset('image/successLottie.json');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const CustomNavBar()),
              (route) => false,
            );
          } else if (state is CheckoutFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is CheckoutLoadedState && selectedAddress == null) {
            selectedAddress = state.selectedAddress;
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoadedState) {
            final currentAddress = selectedAddress ?? state.selectedAddress;
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderSummary(state),
                      const SizedBox(height: 24),
                      _buildAddressSelector(context, state, currentAddress),
                      const SizedBox(height: 24),
                      _buildPaymentSelector(context),
                      const SizedBox(height: 24),
                      _buildTotalSection(state),
                      const SizedBox(height: 24),
                      _buildPlaceOrderButton(context, currentAddress, state),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildOrderSummary(CheckoutLoadedState state) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...state.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(item.product.imageUrls.first),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.phone_iphone),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Quantity: ${item.quantity}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '₹${item.totalPrice.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSelector(BuildContext context, CheckoutLoadedState state,
      AddressModel? currentAddress) {
    return AddressDisplayCard(
      address: currentAddress,
      onTap: () async {
        final newAddress = await Navigator.push<AddressModel>(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AddressScreen(selectedAddress: currentAddress),
          ),
        );

        if (newAddress != null && mounted) {
          setState(() => selectedAddress = newAddress);
          context.read<CheckoutBloc>().add(SelectAddressEvent(newAddress));
        }
      },
    );
  }

  Widget _buildPaymentSelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(
              'Online Payment',
              onTap: () {
                if (selectedAddress == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select delivery address first')),
                  );
                  return;
                }
                setState(() => selectedPaymentMethod = 'ONLINE');
              },
            ),
            const Divider(height: 24),
            _buildPaymentOption(
              'Cash on Delivery',
              onTap: () {
                if (selectedAddress == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select delivery address first')),
                  );
                  return;
                }
                setState(() => selectedPaymentMethod = 'COD');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, {required VoidCallback onTap}) {
    final isSelected = selectedPaymentMethod ==
        (title == 'Cash on Delivery' ? 'COD' : 'ONLINE');

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(CheckoutLoadedState state) {
    final double deliveryCharge = 40.99;
    final double finalTotal = state.totalAmount + deliveryCharge;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cart Total',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '₹${state.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery Charge',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '₹$deliveryCharge',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${finalTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //!Place order button

    Widget _buildPlaceOrderButton(BuildContext context,
      AddressModel? currentAddress, CheckoutLoadedState state) {
    final bool canPlaceOrder =
        currentAddress != null && selectedPaymentMethod != null;
    final bool isOnlinePayment = selectedPaymentMethod == 'ONLINE';
    final double finalTotal = state.totalAmount + 40.99; // Add delivery charge

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canPlaceOrder
            ? () async {
                if (isOnlinePayment) {
                  try {
                    _startRazorpayPayment(state);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Payment failed: ${e.toString()}')),
                      );
                    }
                    return;
                  }
                } else {
                  context.read<CartBloc>().add(const ClearCartEvent());
                  context.read<CheckoutBloc>().add(PlaceOrderEvent(
                      paymentMethod: 'Cash on Delivery',
                      paymentStatus: 'Paid'));

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return OrderSuccessPopup(
                        orderId: 'Processing',
                        onDismiss: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CustomNavBar()),
                            (route) => false,
                          );
                        },
                      );
                    },
                  );
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Text(
          isOnlinePayment ? 'Pay Now' : 'Place Order',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}
