// class Product {
//   final int id;
//   final String title;
//   final String description;
//   final String category;
//   final double price;
//   final double discountPercentage;
//   final double rating;
//   final int stock;
//   final List<String> tags;
//   final String brand;
//   final String sku;
//   final double weight;
//   final Dimensions dimensions;
//   final String warrantyInformation;
//   final String shippingInformation;
//   final String availabilityStatus;
//   final List<Review> reviews;
//   final String returnPolicy;
//   final int minimumOrderQuantity;
//   final Meta meta;
//   final List<String> images;
//   final String thumbnail;

//   Product({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.category,
//     required this.price,
//     required this.discountPercentage,
//     required this.rating,
//     required this.stock,
//     required this.tags,
//     required this.brand,
//     required this.sku,
//     required this.weight,
//     required this.dimensions,
//     required this.warrantyInformation,
//     required this.shippingInformation,
//     required this.availabilityStatus,
//     required this.reviews,
//     required this.returnPolicy,
//     required this.minimumOrderQuantity,
//     required this.meta,
//     required this.images,
//     required this.thumbnail,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       category: json['category'],
//       price: json['price'].toDouble(),
//       discountPercentage: json['discountPercentage'].toDouble(),
//       rating: json['rating'].toDouble(),
//       stock: json['stock'],
//       tags: List<String>.from(json['tags']),
//       brand: json['brand'],
//       sku: json['sku'],
//       weight: json['weight'].toDouble(),
//       dimensions: Dimensions.fromJson(json['dimensions']),
//       warrantyInformation: json['warrantyInformation'],
//       shippingInformation: json['shippingInformation'],
//       availabilityStatus: json['availabilityStatus'],
//       reviews: (json['reviews'] as List<dynamic>)
//           .map((review) => Review.fromJson(review))
//           .toList(),
//       returnPolicy: json['returnPolicy'],
//       minimumOrderQuantity: json['minimumOrderQuantity'],
//       meta: Meta.fromJson(json['meta']),
//       images: List<String>.from(json['images']),
//       thumbnail: json['thumbnail'],
//     );
//   }
// }

// class Dimensions {
//   final double width;
//   final double height;
//   final double depth;

//   Dimensions({
//     required this.width,
//     required this.height,
//     required this.depth,
//   });

//   factory Dimensions.fromJson(Map<String, dynamic> json) {
//     return Dimensions(
//       width: json['width'].toDouble(),
//       height: json['height'].toDouble(),
//       depth: json['depth'].toDouble(),
//     );
//   }
// }

// class Review {
//   final int rating;
//   final String comment;
//   final String date;
//   final String reviewerName;
//   final String reviewerEmail;

//   Review({
//     required this.rating,
//     required this.comment,
//     required this.date,
//     required this.reviewerName,
//     required this.reviewerEmail,
//   });

//   factory Review.fromJson(Map<String, dynamic> json) {
//     return Review(
//       rating: json['rating'],
//       comment: json['comment'],
//       date: json['date'],
//       reviewerName: json['reviewerName'],
//       reviewerEmail: json['reviewerEmail'],
//     );
//   }
// }

// class Meta {
//   final String createdAt;
//   final String updatedAt;
//   final String barcode;
//   final String qrCode;

//   Meta({
//     required this.createdAt,
//     required this.updatedAt,
//     required this.barcode,
//     required this.qrCode,
//   });

//   factory Meta.fromJson(Map<String, dynamic> json) {
//     return Meta(
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       barcode: json['barcode'],
//       qrCode: json['qrCode'],
//     );
//   }
// }

class Product {
  final int id;
  final String title;
  final String? description;
  final String category;
  final double price;
  final double? discountPercentage;
  final double? rating;
  final int? stock;
  final List<String>? tags;
  final String? brand;
  final String? sku;
  final int? weight;
  final Dimensions? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<Review>? reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final Meta? meta;
  final List<String> images;
  final String? thumbnail;

  Product({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    required this.images,
    this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? "Unknown Title",
      description: json['description'],
      category: json['category'] ?? "Unknown Category",
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      stock: json['stock'] as int?,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      brand: json['brand'] ?? "Unknown Brand",
      sku: json['sku'],
      weight: json['weight'] as int?,
      dimensions: json['dimensions'] != null
          ? Dimensions.fromJson(json['dimensions'])
          : null,
      warrantyInformation: json['warrantyInformation'],
      shippingInformation: json['shippingInformation'],
      availabilityStatus: json['availabilityStatus'],
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((review) => Review.fromJson(review))
              .toList()
          : null,
      returnPolicy: json['returnPolicy'],
      minimumOrderQuantity: json['minimumOrderQuantity'] as int?,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [], // Default empty list
      thumbnail: json['thumbnail'],
    );
  }
}

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
    );
  }
}

class Review {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String? reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'] as int,
      comment: json['comment'] ?? "",
      date: json['date'] ?? "",
      reviewerName: json['reviewerName'] ?? "Anonymous",
      reviewerEmail: json['reviewerEmail'],
    );
  }
}

class Meta {
  final String createdAt;
  final String updatedAt;
  final String? barcode;
  final String? qrCode;

  Meta({
    required this.createdAt,
    required this.updatedAt,
    this.barcode,
    this.qrCode,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      barcode: json['barcode'],
      qrCode: json['qrCode'],
    );
  }
}

