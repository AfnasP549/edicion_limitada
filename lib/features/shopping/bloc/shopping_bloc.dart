import 'package:bloc/bloc.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:edicion_limitada/view_model/service/product_service.dart';
import 'package:equatable/equatable.dart';

part 'shopping_event.dart';
part 'shopping_state.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  List<ProductModel> allProducts = [];
  ShoppingBloc() : super(ShoppingInitial()) {

   on<LoadProducts>((event, emit) async {
  try {
    emit(ShoppingLoading());
    final products = await ProductService().fetchProducts(); // Fetch all products
    final brands = await ProductService().fetchBrands(); // Fetch brands
    emit(ShoppingLoaded(products: products, brands: brands, selectedBrand: null));
  } catch (e) {
    emit(ShoppinError('Failed to load products: $e'));
  }
});


    on<LoadBrands>((event, emit) async{
      try{
        if(state is ShoppingLoaded){
          final brands = await ProductService().fetchBrands();
          // emit(ShoppingLoaded(products: (state as ShoppingLoaded).products, brands: brands));
          emit(ShoppingLoaded(brands: brands, products: const [])); 
        }
      }catch(e){
        emit(ShoppinError(e.toString()));
      }
    });




 on<FilterByBrand>((event, emit) async {
  try {
    emit(ShoppingLoading());
    
    // Filter products based on the selected brand
    final filteredProducts = (await ProductService().fetchProducts())
        .where((product) => product.brand == event.brand)
        .toList();

    final brands = await ProductService().fetchBrands();

    emit(ShoppingLoaded(
      products: filteredProducts,
      brands: brands,
      selectedBrand: event.brand,
    ));
  } catch (e) {
    emit(ShoppinError('Failed to filter products: $e'));
  }
});





    on<SelectProduct>((event, emit) {
  try {
    if (state is ShoppingLoaded) {
      final currentState = state as ShoppingLoaded;
      emit(ShoppingLoaded(
        products: currentState.products,
        brands: currentState.brands,
        selectedBrand: currentState.selectedBrand,
        selectedProduct: event.product,
      ));
    }
  } catch (e) {
    emit(ShoppinError('Failed to select product'));
  }
});

  }
}
