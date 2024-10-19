import 'package:flutter/material.dart';

class ProductRating extends StatelessWidget {
  final double rating;
  final int reviews;
  final int oneStarReviews;
  final int twoStarReviews;
  final int threeStarReviews;
  final int fourStarReviews;
  final int fiveStarReviews;
  final List<String> recentReviews;

  const ProductRating({
    Key? key,
    required this.rating,
    required this.reviews,
    required this.oneStarReviews,
    required this.twoStarReviews,
    required this.threeStarReviews,
    required this.fourStarReviews,
    required this.fiveStarReviews,
    required this.recentReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đánh giá sản phẩm',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('Tổng số đánh giá: $reviews'),
        Text('Đánh giá trung bình: $rating'),
        // Hiển thị số lượt đánh giá theo sao
        Text('1 sao: $oneStarReviews'),
        Text('2 sao: $twoStarReviews'),
        Text('3 sao: $threeStarReviews'),
        Text('4 sao: $fourStarReviews'),
        Text('5 sao: $fiveStarReviews'),
        SizedBox(height: 16),
        Text('Đánh giá gần nhất:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        for (var review in recentReviews) Text('- $review'),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Viết đánh giá của bạn',
          ),
          maxLines: 3,
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // Xử lý gửi đánh giá
          },
          child: Text('Gửi đánh giá'),
        ),
      ],
    );
  }
}

// Dữ liệu giả cho sản phẩm
final fakeProductData = {
  'rating': 4.2,
  'reviews': 150,
  'oneStarReviews': 10,
  'twoStarReviews': 20,
  'threeStarReviews': 30,
  'fourStarReviews': 40,
  'fiveStarReviews': 50,
  'recentReviews': [
    "Sản phẩm rất tốt, tôi rất hài lòng!",
    "Chất lượng không như mong đợi.",
    "Tôi sẽ không mua lại sản phẩm này.",
    "Dịch vụ khách hàng rất tốt.",
    "Sản phẩm tuyệt vời, sẽ giới thiệu cho bạn bè!"
  ],
};
