class Animal {
  String? id;
  String? imagem;
  String tipo;
  String nome;
  String sexo;
  double peso;
  double idade;
  double abate;
  String raca;
  int lote;

  Animal({
    this.id,
    this.imagem,
    this.tipo = '',
    this.nome = '',
    this.sexo = 'Fêmea',
    this.peso = 0,
    this.idade = 0,
    this.abate = 0,
    this.raca = '',
    this.lote = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'imagem': imagem,
      'tipo': tipo,
      'nome': nome,
      'sexo': sexo,
      'peso': peso,
      'idade': idade,
      'abate': abate,
      'raca': raca,
      'lote': lote,
    };
  }

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id']?.toString(),
      imagem: json['imagem']?.toString(),
      tipo: json['tipo'] ?? '',
      nome: json['nome'] ?? '',
      sexo: json['sexo'] ?? 'Fêmea',
      peso: (json['peso'] as num?)?.toDouble() ?? 0,
      idade: (json['idade'] as num?)?.toDouble() ?? 0,
      abate: (json['abate'] as num?)?.toDouble() ?? 0,
      raca: json['raca'] ?? '',
      lote: (json['lote'] as num?)?.toInt() ?? 0,
    );
  }

  void operator []=(String other, String value) {}
}
