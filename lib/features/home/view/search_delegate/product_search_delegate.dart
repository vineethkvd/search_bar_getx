import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/fetch_product_controller.dart';
import '../../model/product_model.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final FetchProductController fetchProductController =
      Get.find<FetchProductController>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return StreamBuilder(
      stream: fetchProductController.searchProducts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<Products> products = snapshot.data ?? [];
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.title ?? ''),
                subtitle: Text('Price: \$${product.price ?? ''}'),
                onTap: () {
                  close(context, product.title ?? '');
                },
              );
            },
          );
        }
      },
    );
  }
}
