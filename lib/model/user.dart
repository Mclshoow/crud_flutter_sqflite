class User {
  final int id;
  final String nome;
  final int numero;
  final String email;

  User({
    required this.id,
    required this.nome,
    required this.numero,
    required this.email,
  });

  factory User.fromSqfliteDatabase(Map<String, dynamic> map) => User(
      id: map['id']?.toInt() ?? 0,
      nome: map['nome'] ?? '',
      numero: map['numero']?.toInt() ?? 0,
      email: map['email'] ?? '');
}
