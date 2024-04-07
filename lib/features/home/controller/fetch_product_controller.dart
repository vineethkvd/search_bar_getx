import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../model/product_model.dart';

class FetchProductController extends GetxController {
  var productModel = ProductModel().obs;
  var productsList = <Products>[].obs;
  var filteredProductsList = <Products>[].obs;

  @override
  void onInit() {
    fetchProducts(); // Fetch products when the controller is initialized
    super.onInit();
  }

  Stream<RxList<Products>> fetchProducts() async* {
    const apiUrl = 'https://dummyjson.com/products';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        productModel(ProductModel.fromJson(responseData));
        print("Success to fetch products");

        productsList.assignAll(productModel.value.products ?? []);
        filteredProductsList.assignAll(
            productsList); // Initialize filtered list with all products
        yield productsList;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('HTTP Client Exception: $e');
    } on SocketException catch (e) {
      throw Exception('Socket Exception: $e');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Stream<RxList<Products>> searchProducts(String query) async* {
    if (query.isEmpty) {
      // If the search query is empty, show all products
      filteredProductsList.assignAll(productsList);
      yield filteredProductsList;
    } else {
      // Filter products based on the search query
      final lowercaseQuery = query.toLowerCase();
      final filteredProducts = productsList.where((product) {
        return product.title?.toLowerCase()?.contains(lowercaseQuery) ?? false;
      }).toList();
      filteredProductsList.assignAll(filteredProducts);
      yield filteredProductsList;
    }
  }
}
