import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Hombre extends StatefulWidget {
  @override
  _HombreState createState() => _HombreState();
}

class _HombreState extends State<Hombre> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final Uri uri = Uri.parse('https://fakestoreapi.com/products/category/men\'s clothing');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Product> products = data.map((item) => Product.fromJson(item)).toList();
      setState(() {
        _products = products;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.network(
                'lib/img/model01.png',
                fit: BoxFit.cover,
              ),
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Buscar producto'),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    _fetchProducts();
                  } else {
                    _products = _products.where((product) {
                      return product.title.toLowerCase().contains(value.toLowerCase());
                    }).toList();
                  }
                });
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 600,
                        ),
                        child: Column(
                          children: [
                            Image.network(
                              _products[index].image,
                              height: 250, // Ajusta la altura deseada para la imagen de cada producto
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Text(_products[index].title),
                            Text('Precio: \$${_products[index].price.toString()}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final int id;
  final String title;
  final String image;
  final double price;

  Product({required this.id, required this.title, required this.image, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: json['price'].toDouble(),
    );
  }
}
