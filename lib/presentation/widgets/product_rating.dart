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
        Row(
          children: [
            Text(
              '$rating',
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating.round() ? Icons.star : Icons.star_border,
                  color: index < rating.round() ? Colors.amber : Colors.grey,
                );
              }),
            ),
            SizedBox(width: 8),
            Text('$reviews reviews'),
          ],
        ),
        for (int i = 5; i >= 1; i--) ...[
          Row(
            children: [
              Text('$i  ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (i == 5
                              ? fiveStarReviews
                              : i == 4
                                  ? fourStarReviews
                                  : i == 3
                                      ? threeStarReviews
                                      : i == 2
                                          ? twoStarReviews
                                          : oneStarReviews) /
                          reviews,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        i == 5
                            ? Colors.green
                            : i == 4
                                ? Colors.blue
                                : i == 3
                                    ? Colors.orange
                                    : i == 2
                                        ? Colors.yellow
                                        : Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                  '${(i == 5 ? fiveStarReviews : i == 4 ? fourStarReviews : i == 3 ? threeStarReviews : i == 2 ? twoStarReviews : oneStarReviews)}'), // Display count
            ],
          ),
        ],
        SizedBox(height: 16),
        Text('Đánh giá gần nhất:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        _buildRecentReviews(),
      ],
    );
  }
}

Widget _buildRecentReviews() {
  List<Widget> reviewWidgets = [];

  // Check if recentReviews is not null before iterating
  for (var review in recentReviews) {
    reviewWidgets.add(
      Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    review['username'] as String, // Cast to String
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    review['date'] as String, // Cast to String
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (review['rating'] as int)
                        ? Icons.star
                        : Icons.star_border,
                    color: index < (review['rating'] as int)
                        ? Colors.amber
                        : Colors.grey,
                    size: 14,
                  );
                }),
              ),
              SizedBox(height: 8),
              Text(
                review['review'] as String, // Cast to String
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              if (review['reply'] != null) ...[
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    review['reply'] as String, // Cast to String
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  return Column(children: reviewWidgets);
}

final recentReviews = [
  {
    'username': 'Kim, Frankfurt',
    'rating': 3,
    'date': 'Jan 11',
    'review':
        'Decent car insurance company. Average service and claims processing time. Customer support could be better. Premiums are somewhat affordable, but coverage options are limited.',
    'reply':
        'Hi Kim! We\'ve responded to your email. Please check your inbox, including the Spam folder. Thanks for your patience and regards, Soglasie Team.'
  },
  {
    'username': 'Alice, Munich',
    'rating': 4,
    'date': 'Jan 10',
    'review':
        'Good service overall, but the claims process took longer than expected.',
    'reply':
        'Thank you for your feedback, Alice! We are working on improving our claims process.'
  },
  {
    'username': 'Mike, Hamburg',
    'rating': 1,
    'date': 'Jan 9',
    'review':
        'Terrible experience. I had issues with my claim and customer service was unhelpful.',
  },
  {
    'username': 'Sara, Berlin',
    'rating': 5,
    'date': 'Jan 8',
    'review':
        'Excellent coverage options and great customer support. Highly recommend!',
  },
  {
    'username': 'Tom, Stuttgart',
    'rating': 4,
    'date': 'Jan 7',
    'review': 'Affordable premiums and decent coverage. Happy with my choice.',
    'reply':
        'Thanks for your review, Tom! We’re glad you’re satisfied with our services.'
  },
  {
    'username': 'Emily, Cologne',
    'rating': 2,
    'date': 'Jan 6',
    'review': 'The service was okay, but I expected more options for coverage.',
  },
];

// Dữ liệu giả cho sản phẩm
final fakeProductData = {
  'rating': 4.7,
  'reviews': 1315,
  'oneStarReviews': 46,
  'twoStarReviews': 17,
  'threeStarReviews': 65,
  'fourStarReviews': 205,
  'fiveStarReviews': 982,
};
