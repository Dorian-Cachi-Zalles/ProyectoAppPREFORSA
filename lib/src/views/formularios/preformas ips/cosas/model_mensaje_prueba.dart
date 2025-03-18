class Message {
  final int? id;
  final String message;
  final int number;

  Message({this.id, required this.message, required this.number});

  // Convertir JSON a Message
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      message: json['message'],
      number: json['number'],
    );
  }

  // Convertir Message a JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'number': number,
    };
  }
}
