// models/payment_gateway.dart

class PaymentGateway {

  PaymentGateway({
    required this.id,
    required this.arName,
    required this.enName,

    required this.logoUrl,
    required this.description,
    required this.avaiable,

  });

  // Create PaymentGateway instance from JSON
  factory PaymentGateway.fromJson(Map<String, dynamic> json) {
    return PaymentGateway(
      id: int.parse(json['id'].toString()),
      arName: json['ar_name'] .toString(),
      enName: json['en_name'] .toString(),

      logoUrl: json['logo_url'].toString(),
      description: json['description'] .toString(),
      avaiable: int.parse( json['availble'].toString()),
    );
  }
  final int id;
  final String arName;
   final String enName;
  final String logoUrl;
  final String description;
  final int avaiable;

  // Convert PaymentGateway instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ar_name': arName,
      'en_name':enName,
      'available':avaiable,
      'logo_url': logoUrl,
      'description': description,
    };
  }
}
