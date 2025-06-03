part of '_models_lib.dart';

class Developer {
  final String nome;
  final String cargo;
  final String email;
  final String telefone;
  final String? fotoUrl;
  final String? githubUrl;
  final String? linkedinUrl;

  Developer({
    required this.nome,
    required this.cargo,
    required this.email,
    required this.telefone,
    this.fotoUrl,
    this.githubUrl,
    this.linkedinUrl,
  });
}
