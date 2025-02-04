class Address {

  Address({
     this.id,
     this.userId,
     this.street,
     this.city,
     this.state,
     this.zipCode,
     this.country,
  });

  // Create Address from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as int,
      userId: json['userId'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String,
    );
  }
  final int? id;
  final String? userId;
  final String? street;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  // Convert Address to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'street': street,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'country': country,
      };
}
