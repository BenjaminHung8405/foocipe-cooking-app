import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/product_rating.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Product {
  final String name;
  final String price;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviews;
  final int oneStarReviews;
  final int twoStarReviews;
  final int threeStarReviews;
  final int fourStarReviews;
  final int fiveStarReviews;
  final List<String> recentReviews;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.oneStarReviews,
    required this.twoStarReviews,
    required this.threeStarReviews,
    required this.fourStarReviews,
    required this.fiveStarReviews,
    required this.recentReviews,
  });
}

class ProductPage extends StatefulWidget {
  final String productId;

  ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final storage = const FlutterSecureStorage();
  Product? product;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      print('No access token found');
      return;
    }
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['RECIPE_SERVICE_API']}/products/${widget.productId}'),
      headers: {
        'access_token': accessToken ?? '',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        product = Product(
          name: data['title'],
          price: '\$${data['price']}',
          description: data['description'],
          imageUrl: data['image_urls'][0],
          rating: 4.2,
          reviews: 150,
          oneStarReviews: 10,
          twoStarReviews: 20,
          threeStarReviews: 30,
          fourStarReviews: 40,
          fiveStarReviews: 50,
          recentReviews: [
            "Sản phẩm rất tốt, tôi rất hài lòng!",
            "Chất lượng không như mong đợi.",
            "Tôi sẽ không mua lại sản phẩm này.",
            "Dịch vụ khách hàng rất tốt.",
            "Sản phẩm tuyệt vời, sẽ giới thiệu cho bạn bè!"
          ],
        );
      });
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<void> addToCart(String productId) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['RECIPE_SERVICE_API']}/carts/add/$productId/1'),
      headers: {
        'access_token': await storage.read(key: 'access_token') ?? '',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Product added to cart successfully');
    } else {
      // Handle error response
      print('Failed to add product to cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey.shade800),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
            child: Text('Thông tin sản phẩm', style: TextStyle(fontSize: 16))),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: product == null
                ? Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(product!.imageUrl),
                            SizedBox(height: 16),
                            Text(
                              product!.name,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              product!.price,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.orange.shade500),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                Text(
                                    '${product!.rating} (${product!.reviews} Review)'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              product!.description,
                            ),
                            SizedBox(height: 16),
                            ProductRating(
                              rating: product!.rating,
                              reviews: product!.reviews,
                              oneStarReviews: product!.oneStarReviews,
                              twoStarReviews: product!.twoStarReviews,
                              threeStarReviews: product!.threeStarReviews,
                              fourStarReviews: product!.fourStarReviews,
                              fiveStarReviews: product!.fiveStarReviews,
                              recentReviews: product!.recentReviews,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          Positioned(
            left: 0, // Đặt lại vị trí bên trái
            right: 0, // Đặt lại vị trí bên phải
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa hàng
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(8),
                    side: BorderSide(color: Colors.black),
                    backgroundColor: Colors.white, // Thêm màu nền trắng
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {},
                  child:
                      Icon(Icons.chat_outlined, color: Colors.black, size: 18),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.all(8),
                    side: BorderSide(color: Colors.black),
                    backgroundColor: Colors.white, // Thêm màu nền trắng
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () async {
                    await addToCart(
                        widget.productId); // Call the function to add to cart
                  },
                  child: Icon(Icons.shopping_cart_outlined,
                      color: Colors.black, size: 18),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {},
                  child: Text('Buy Now',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
