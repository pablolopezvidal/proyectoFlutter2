import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mujer extends StatefulWidget {
  @override
  _MujerState createState() => _MujerState();
}

class _MujerState extends State<Mujer> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _productsWomen = [];
  List<Product> _productsJewelry = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts('women\'s clothing', _productsWomen);
    _fetchProducts('jewelery', _productsJewelry);
  }

  Future<void> _fetchProducts(String category, List<Product> productList) async {
    final Uri uri = Uri.parse('https://fakestoreapi.com/products/category/$category');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Product> products = data.map((item) => Product.fromJson(item)).toList();
      setState(() {
        productList.addAll(products);
      });
    } else {
      throw Exception('Failed to load products for category $category');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.network(
                    'https://s3-alpha-sig.figma.com/img/cf0c/d101/56c1a319c5a2cd6ac4713c681741bb52?Expires=1708905600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=PK6-jv2URK9CsBr1ID8oWud4Rvk~lUKlxPfyvJjXOHYgglIUj6iVe0v-XdTWpL9uTpKl77BfNGa72lVzLyTpwrwc0TXBkjL4wa9lXJ5ouv7hxwadYIxqj3vcLbxpeolbTSfXRrDSKcXIReUNATi91ey2uOgGm0uxoRkdApDlcxkg4WW9UDgTpyxTLLHdZeyg8aqxhqr9CnI3S2GqnQEb9EFlFmIBdKdZ6n5RRBVKzho9WiEVf5n-phsGtpZABaE89PGxWtr3cb0BcDtlhIvNum-a4pO9V8-2kFZBWqfVv47y0miNSrw2es7GbgadML657V5IrMQ8guKS7Lh0LQg~rA__',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navegar a la ruta correspondiente al primer texto
                          Navigator.pushNamed(context, '/ruta1');
                        },
                        child: Text(
                          'Texto1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Navegar a la ruta correspondiente al segundo texto
                          Navigator.pushNamed(context, '/ruta2');
                        },
                        child: Text(
                          'Texto2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Text(
                    'Usuario X', // Reemplaza 'Usuario X' con el nombre del usuario
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://s3-alpha-sig.figma.com/img/171e/ba33/511a5c08fc9660dd570b084dc81efa9d?Expires=1708905600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Y4rZHKhGeG3neAiJ-fmwuaUTJJqCjtaQ5etKoqywGrP3GCkF3RvyYz19czrLvwOQZv~Em-0TQV9QTtTyMjN3e0dGWwpZ4f2kgKeQkDVGqvEx17wCGuJSdqwMJfhVGKGWes1OCDTcRpseE5Eq3OGhtbFIHVChSomk~W7jJEZcPpp~fX1U0Ozoj9wYUcchJyFe3~MQTg4XzyOF0KrDQfvh4fEEVrqadg3Gq0xk1IXQQxZ628Xq2ip7Bgl0SVrxWoEbTA88gj64bEBu7yMRyXay4LxFVxhtPiu5Uq4IgxhXLrYscO0fnPGTq3pWmy6Y2zkQN1Q4utPPOQAg4dQQFYXVBw__',
                    width: 300,
                    height: 200,
                  ),
                  SizedBox(width: 100),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 200,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(labelText: 'Buscar producto'),
                      onChanged: (value) {
                        setState(() {
                          _searchProducts(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
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
                  itemCount: _productsWomen.length + _productsJewelry.length,
                  itemBuilder: (context, index) {
                    if (index < _productsWomen.length) {
                      return buildProductCard(_productsWomen[index]);
                    } else {
                      return buildProductCard(_productsJewelry[index - _productsWomen.length]);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(Product product) {
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
              product.image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Text(product.title),
            Text('Precio: \$${product.price.toString()}'),
          ],
        ),
      ),
    );
  }

  void _searchProducts(String value) {
    _productsWomen.clear();
    _productsJewelry.clear();
    _fetchProducts('women\'s clothing', _productsWomen);
    _fetchProducts('jewelry', _productsJewelry);

    if (value.isNotEmpty) {
      _productsWomen = _productsWomen.where((product) {
        return product.title.toLowerCase().contains(value.toLowerCase());
      }).toList();

      _productsJewelry = _productsJewelry.where((product) {
        return product.title.toLowerCase().contains(value.toLowerCase());
      }).toList();
    }
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
