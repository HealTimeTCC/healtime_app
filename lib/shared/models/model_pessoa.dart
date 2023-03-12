class Pessoa {
  Pessoa(
      {required this.cpfPessoa,
      required this.nomePessoa,
      required this.pessoaId,
      required this.sobrenomePessoa,
      required this.dtNascPessoa,
      required this.tipoPessoa});

  int       pessoaId = 0;
  int       tipoPessoa = 1;
  String    cpfPessoa = '';
  String    nomePessoa = '';
  String    sobrenomePessoa = '';
  DateTime  dtNascPessoa = DateTime.now();
  String    tokenUser = '';

  /* Des. dados */
  Pessoa.fromJson(Map<String, dynamic> json) {
    pessoaId =          json['pessoaId'];
    tipoPessoa =        json['tipoPessoa'] ?? 1;
    cpfPessoa =         json['cpfPessoa'];
    nomePessoa =        json['nomePessoa'];
    sobrenomePessoa =   json['sobrenomePessoa'] ?? '';
    dtNascPessoa =      DateTime.parse(json['dtNascPessoa']);
    tokenUser =         json['tokenJwt'];
  }

  /* Serializar dados */
  Map<String, dynamic> toJson() {
    return {
      'pessoaId': pessoaId,
      'tipoPessoa': tipoPessoa,
      'cpfPessoa': cpfPessoa,
      'nomePessoa': nomePessoa,
      'sobrenomePessoa': sobrenomePessoa,
      'dtNascPessoa': dtNascPessoa,
    };
  }

}
