class Notification {
  final String id;
  final String userId; // ID of the user receiving the notification
  final String title; // Short notification title
  final String message; // Detailed message
  final String type; // e.g., "order", "promo", "system"
  final bool isRead; // Whether the notification is read
  final DateTime createdAt; // When the notification was created
  final DateTime? readAt; // When the notification was read

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  // Convert Notification to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  // Create Notification from JSON
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] .toString(),
      userId: json['userId'] .toString(),
      title: json['title'] .toString(),
      message: json['message'] .toString(),
      type: json['type'] .toString(),
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] .toString()),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt'].toString()) : null,
    );
  }
}
