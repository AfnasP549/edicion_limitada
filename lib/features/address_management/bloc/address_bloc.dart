import 'package:bloc/bloc.dart';
import 'package:edicion_limitada/features/address_management/model/address_model.dart';
import 'package:edicion_limitada/features/address_management/service/address_service.dart';
import 'package:equatable/equatable.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressService _addressService;
  AddressBloc(this._addressService) : super(AddressInitialState()) {

      //!get
    on<LoadAddressesEvent>((event, emit) async {
      try {
        emit(AddressLoadingState());
        final addresses = await _addressService.getAddresses();
        emit(AddressLoadedState(addresses));
      } catch (e) {
        emit(AddressErrorState(e.toString()));
      }
    });
    
    //!add
    on<AddAddressEvent>((event, emit) async {
      try {
           emit(AddressLoadingState());
      print('Adding address: ${event.address}'); // Debug print
      await _addressService.addAddress(event.address);
      print('Address added successfully'); // Debug print
      final addresses = await _addressService.getAddresses();
      emit(AddressLoadedState(addresses));
    } catch (e) {
      print('Error adding address: $e'); // Debug print
      emit(AddressErrorState(e.toString()));
    }
  });

    //!edit
on<UpdateAddressEvent>((event, emit) async {
      try {
        emit(AddressLoadingState());
        print('Updating address with ID: ${event.addressId}');  // Debug print
        
        await _addressService.updateAddress(event.addressId, event.address);
        
        // Refresh the address list
        final addresses = await _addressService.getAddresses();
        emit(AddressLoadedState(addresses));
      } catch (e) {
        print('Error updating address: $e');  // Debug print
        emit(AddressErrorState(e.toString()));
      }
    });

    //!delete
    on<DeleteAddressEvent>((event, emit) async {
      try {
        emit(AddressLoadingState());
        print('Deleting address: ${event.addressId}'); // Debug print
        await _addressService.deleteAddress(event.addressId);
        print('Address deleted successfully'); // Debug print
        
        // Refresh the address list
        final addresses = await _addressService.getAddresses();
        emit(AddressLoadedState(addresses));
      } catch (e) {
        print('Error deleting address: $e'); // Debug print
        emit(AddressErrorState(e.toString()));
      }
    });
  }
}
