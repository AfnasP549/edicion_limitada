import 'package:flutter/material.dart';
import 'package:edicion_limitada/model/product_model.dart';
import 'package:edicion_limitada/view_model/service/product_service.dart';
import 'package:edicion_limitada/features/search/widget/search_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _searchResults = [];
  List<String> _searchSuggestions = [];
  //List<String> _availableBrands = [];
  String? _selectedBrand;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await ProductService().fetchProducts();
   //   final brands = products.map((p) => p.brand).toSet().toList()
      //  ..sort((a, b) => a.compareTo(b));
      
      setState(() {
        _allProducts = products;
      //  _availableBrands = brands;
        _searchResults = products; // Initially show all products
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = _filterByBrand(_allProducts);
        _searchSuggestions = [];
      });
      return;
    }

    final suggestions = _generateSuggestions(query);
    final results = _filterProducts(query);

    setState(() {
      _searchSuggestions = suggestions;
      _searchResults = _filterByBrand(results);
    });
  }

  List<ProductModel> _filterByBrand(List<ProductModel> products) {
    if (_selectedBrand == null) return products;
    return products.where((p) => p.brand == _selectedBrand).toList();
  }

  // void _onBrandSelected(String? brand) {
  //   setState(() {
  //     _selectedBrand = brand;
  //     _searchResults = _filterProducts(_searchController.text);
  //   });
  // }

  // Widget _buildBrandFilter() {
  //   return Container(
  //     height: 50,
  //     margin: const EdgeInsets.symmetric(vertical: 8),
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       itemCount: _availableBrands.length + 1, // +1 for "All" option
  //       itemBuilder: (context, index) {
  //         final isAllOption = index == 0;
  //         final brand = isAllOption ? null : _availableBrands[index - 1];
  //         final isSelected = _selectedBrand == brand;
  //         final displayText = isAllOption ? "All Brands" : brand!;

  //         return Padding(
  //           padding: const EdgeInsets.only(right: 8),
  //           child: FilterChip(
  //             label: Text(displayText),
  //             selected: isSelected,
  //             onSelected: (_) => _onBrandSelected(brand),
  //             backgroundColor: Colors.grey.shade100,
  //             selectedColor: Colors.blue.shade100,
  //             labelStyle: TextStyle(
  //               color: isSelected ? Colors.blue.shade900 : Colors.black87,
  //               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  List<String> _generateSuggestions(String query) {
    Set<String> suggestions = {};
    suggestions.addAll(
      _allProducts
          .map((product) => product.brand)
          .where((brand) => brand.toLowerCase().contains(query.toLowerCase()))
          .take(3),
    );
    suggestions.addAll(
      _allProducts
          .map((product) => product.name)
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .take(3),
    );
    _allProducts.forEach((product) {
      final keywords = product.description
          .split(' ')
          .where((word) => word.length > 3)
          .where((word) => word.toLowerCase().contains(query.toLowerCase()));
      suggestions.addAll(keywords.take(2));
    });

    return suggestions.take(5).toList();
  }

  List<ProductModel> _filterProducts(String query) {
    if (query.isEmpty) return _allProducts;
    
    return _allProducts.where((product) {
      final searchLower = query.toLowerCase();
      return product.name.toLowerCase().contains(searchLower) ||
          product.brand.toLowerCase().contains(searchLower) ||
          product.description.toLowerCase().contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search for products, brands...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                if (_searchSuggestions.isNotEmpty && _searchController.text.isNotEmpty)
                  _buildSuggestions(),
               // _buildBrandFilter(),
                _buildSearchResults(),
              ],
            ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      color: Colors.grey.shade100,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _searchSuggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.search),
            title: Text(_searchSuggestions[index]),
            onTap: () {
              setState(() {
                _searchController.text = _searchSuggestions[index];
                _onSearchChanged(_searchSuggestions[index]);
                _searchSuggestions = [];
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: _searchResults.isEmpty
          ? const Center(child: Text('No products found'))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final product = _searchResults[index];
                return ProductSearchTile(product: product);
              },
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}