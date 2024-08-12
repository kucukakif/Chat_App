class Message {
  final String email;
  final String date;
  final String message;
  const Message({required this.email,required this.date, required this.message});

  Map<String, dynamic> toJson() => {
        'email': email,
        'date':date,
        'message': message,
      };
}
