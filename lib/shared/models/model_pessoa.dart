class Pessoa {
  Pessoa(
      {required this.cpfPessoa,
      required this.nomePessoa,
      required this.sobrenomePessoa,
      required this.dtNascPessoa,
      required this.tipoPessoaId,
      required this.passwordString});

  int pessoaId = 0;
  int tipoPessoaId = 1;
  String cpfPessoa = '';
  String nomePessoa = '';
  String sobrenomePessoa = '';
  DateTime dtNascPessoa = DateTime.now();
  String passwordString = '';
  String tokenUser = '';

  /* Des. dados */
  Pessoa.fromJson(Map<String, dynamic> json)
      : pessoaId = json['pessoaId'],
        tipoPessoaId = json['tipoPessoaId'] ?? 1,
        cpfPessoa = json['cpfPessoa'],
        nomePessoa = json['nomePessoa'],
        sobrenomePessoa = json['sobrenomePessoa'] ?? '',
        dtNascPessoa = DateTime.parse(json['dtNascPessoa']),
        passwordString = json['passwordString'] ?? '',
        tokenUser = json['tokenJwt'];

  /* Serializar dados */
  Map<String, dynamic> toJson() {
    return {
      'pessoaId': pessoaId,
      'tipoPessoaId': tipoPessoaId,
      'cpfPessoa': cpfPessoa,
      'nomePessoa': nomePessoa,
      'sobrenomePessoa': sobrenomePessoa,
      'dtNascPessoa': dtNascPessoa.toIso8601String(),
      'passwordString': passwordString,
      'tokenJwt': tokenUser,
    };
  }
}
