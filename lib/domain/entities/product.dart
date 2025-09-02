import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  String get truncatedTitle =>
      title.length > 50 ? '${title.substring(0, 50)}...' : title;

  String get truncatedDescription => description.length > 100
      ? '${description.substring(0, 100)}...'
      : description;

  bool get isHighRated => rating.rate >= 4.0;

  @override
  List<Object?> get props =>
      [id, title, price, description, category, image, rating];
}

class Rating extends Equatable {
  final double rate;
  final int count;

  const Rating({
    required this.rate,
    required this.count,
  });

  String get formattedRate => rate.toStringAsFixed(1);

  @override
  List<Object?> get props => [rate, count];
}
