class Product {
  final String id;
  final String name;
  final int price;
  final String gender;
  final String categoryId;
  final String type;
  final String subcategory;

  final List<String> season;
  final List<String> style;
  final List<String> formality;
  final String color;
  final String palette;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.gender,
    required this.categoryId,
    required this.type,
    required this.subcategory,
    required this.season,
    required this.style,
    required this.formality,
    required this.color,
    required this.palette,
  });

  String get imageUrl => 'assets/images/$id.jpg';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      gender: json['gender'],
      categoryId: json['categoryId'],
      type: json['type'],
      subcategory: json['subcategory'],

      season: List<String>.from(json['season'] ?? []),
      style: List<String>.from(json['style'] ?? []),
      formality: List<String>.from(json['formality'] ?? []),
      color: json['color'] ?? "",
      palette: json['palette'] ?? "",
    );
  }
}