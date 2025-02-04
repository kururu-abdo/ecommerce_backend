class VariantAttribute {
  final int id;
  final String attributeName;
  final String value;

  VariantAttribute({
    required this.id,
    required this.attributeName,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributeName': attributeName,
      'value': value,
    };
  }
}