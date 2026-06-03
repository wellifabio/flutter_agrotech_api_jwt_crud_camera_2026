import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import '/ui/style/colors.dart';
import '../root/api.dart';
import '../models/animal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String nome = '';
  String token = '';
  List<dynamic> animais = [];
  Animal animal = Animal();

  @override
  initState() {
    verificarCredenciais();
    super.initState();
  }

  Future<void> verificarCredenciais() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('autenticacao')) {
      final usuario = json.decode(prefs.getString('autenticacao').toString());
      setState(() {
        nome = usuario['user']['nome'];
        token = usuario['accessToken'];
      });
      obterAnimais();
    } else {
      sair();
    }
  }

  Future<void> obterAnimais() async {
    final url = Uri.parse(Api.animais);
    try {
      final resp = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp.statusCode == 200) {
        setState(() {
          animais = json.decode(resp.body);
        });
      } else if (resp.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Esta sessão expirou, saia e faça login novamente"),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("API não está respondendo")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("API erro: $e")));
    }
  }

  Future<void> removerCredeciais() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('autenticacao');
    verificarCredenciais();
  }

  void sair() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  Future<void> cadastrarAnimal() async {
    final url = Uri.parse(Api.animais);
    if (animal.tipo.isEmpty ||
        animal.nome.isEmpty ||
        animal.sexo.isEmpty ||
        animal.raca.isEmpty ||
        animal.peso <= 0 ||
        animal.idade <= 0 ||
        animal.abate <= 0 ||
        animal.lote <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos corretamente!")),
      );
      return;
    }
    try {
      final resp = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(animal.toJson()),
      );
      if (resp.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Animal cadastrado com sucesso!")),
        );
        obterAnimais();
      } else if (resp.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Esta sessão expirou, saia e faça login novamente"),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("API não está respondendo")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("API erro: $e")));
    }
  }

  Future<void> atualizarAnimal() async {
    final url = Uri.parse('${Api.animais}/${animal.id}');
    if (animal.tipo.isEmpty ||
        animal.nome.isEmpty ||
        animal.sexo.isEmpty ||
        animal.raca.isEmpty ||
        animal.peso <= 0 ||
        animal.idade <= 0 ||
        animal.abate <= 0 ||
        animal.lote <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos corretamente!")),
      );
      return;
    }
    try {
      final resp = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(animal.toJson()),
      );
      if (resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Animal atualizado com sucesso!")),
        );
        obterAnimais();
      } else if (resp.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Esta sessão expirou, saia e faça login novamente"),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("API não está respondendo")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("API erro: $e")));
    }
  }

  Future<void> excluirAnimal(int indice) async {
    final url = Uri.parse('${Api.animais}/${animais[indice]['id']}');
    try {
      final resp = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (resp.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Animal excluído com sucesso!")));
        obterAnimais();
      } else if (resp.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Esta sessão expirou, saia e faça login novamente"),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("API não está respondendo")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("API erro: $e")));
    }
  }

  Future<String?> tirarFoto() async {
    try {
      final picker = ImagePicker();
      final foto = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        maxWidth: 1280,
      );

      if (foto == null) {
        return null;
      }

      final url = Uri.parse(Api.imgs.toString());
      final req = http.MultipartRequest('POST', url)
        ..headers['Content-Type'] = 'multipart/form-data'
        ..files.add(await http.MultipartFile.fromPath('imagem', foto.path));
      final resp = await req.send();
      if (resp.statusCode == 200) {
        String? nomeImagem;
        final respStr = await resp.stream.bytesToString();
        final jsonResp = json.decode(respStr);
        nomeImagem = jsonResp['arquivo'];
        if (nomeImagem != null && nomeImagem.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Imagem $nomeImagem enviada para a API!')),
          );
          return nomeImagem;
        } else {
          await obterAnimais();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Falha ao enviar foto (${resp.statusCode}). Verifique o endpoint /static/images.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return null;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao tirar foto: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home: $nome"),
        actions: [
          ElevatedButton(onPressed: removerCredeciais, child: Text("Sair")),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: animais[i]['imagem'] != null
                          ? NetworkImage(
                              '${Api.arquivos}${animais[i]['imagem']}',
                            )
                          : AssetImage('assets/icone.png') as ImageProvider,
                    ),
                    title: Text('Nome: ${animais[i]['nome']}'),
                    subtitle: Text('Tipo:${animais[i]['tipo']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => excluirAnimal(i),
                    ),
                    onTap: () => modalDetalhes(i),
                  );
                },
                shrinkWrap: true,
                separatorBuilder: (_, _) => Divider(),
                itemCount: animais.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: modalNovoAnimal,
        child: Icon(Icons.add),
      ),
    );
  }

  void modalDetalhes(int indice) {
    setState(() {
      animal = Animal.fromJson(animais[indice]);
    });
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text(
            '${animais[indice]['tipo']}: ${animais[indice]['nome']} - Id: ${animais[indice]['id']}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 2,
            children: [
              GestureDetector(
                onTap: () async {
                  String? nomeImagem = await tirarFoto();
                  if (nomeImagem != null) {
                    setModalState(() {
                      animal.imagem = nomeImagem;
                    });
                  }
                },
                child: animal.imagem != null
                    ? Image.network(
                        '${Api.arquivos}${animal.imagem}',
                        height: 150,
                      )
                    : Image.asset('assets/icone.png', height: 150),
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                controller: TextEditingController(text: animal.tipo),
                decoration: InputDecoration(
                  labelText: "Tipo",
                  hintText: "Ex: Bovino",
                ),
                onChanged: (value) {
                  animal.tipo = value;
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                controller: TextEditingController(text: animal.nome),
                decoration: InputDecoration(
                  labelText: "Nome",
                  hintText: "Ex: Boi Bandido",
                ),
                onChanged: (value) {
                  animal.nome = value;
                },
              ),
              RadioGroup<String>(
                onChanged: (value) => setModalState(() {
                  animal.sexo = value!;
                }),
                groupValue: animal.sexo,
                child: Row(
                  children: [
                    Text("Sexo:"),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(value: "Fêmea"),
                          Text("Fêmea"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(value: "Macho"),
                          Text("Macho"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                controller: TextEditingController(text: animal.raca),
                decoration: InputDecoration(
                  labelText: "Raça",
                  hintText: "Ex: Nelore",
                ),
                onChanged: (value) {
                  animal.raca = value;
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: animal.peso.toString()),
                decoration: InputDecoration(
                  labelText: "Peso",
                  hintText: "Ex: 350.50",
                ),
                onChanged: (value) {
                  animal.peso = double.parse(value);
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: animal.idade.toString(),
                ),
                decoration: InputDecoration(
                  labelText: "Idade",
                  hintText: "Ex: 5.0",
                ),
                onChanged: (value) {
                  animal.idade = double.parse(value);
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: animal.abate.toString(),
                ),
                decoration: InputDecoration(
                  labelText: "Abate",
                  hintText: "Ex: 7.0",
                ),
                onChanged: (value) {
                  animal.abate = double.parse(value);
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: animal.lote.toString()),
                decoration: InputDecoration(
                  labelText: "Lote",
                  hintText: "Ex: 1",
                ),
                onChanged: (value) {
                  animal.lote = int.parse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await atualizarAnimal();
                await obterAnimais();
                Navigator.of(context).pop();
              },
              child: Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }

  void modalNovoAnimal() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text('Cadastro de animal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 2,
            children: [
              TextField(
                style: TextStyle(color: AppColors.p1),
                decoration: InputDecoration(
                  labelText: "Tipo",
                  hintText: "Ex: Bovino",
                ),
                onChanged: (value) {
                  animal.tipo = value;
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                decoration: InputDecoration(
                  labelText: "Nome",
                  hintText: "Ex: Boi Bandido",
                ),
                onChanged: (value) {
                  animal.nome = value;
                },
              ),
              RadioGroup<String>(
                onChanged: (value) => setModalState(() {
                  animal.sexo = value!;
                }),
                groupValue: animal.sexo,
                child: Row(
                  children: [
                    Text("Sexo:"),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(value: "Fêmea"),
                          Text("Fêmea"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<String>(value: "Macho"),
                          Text("Macho"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                decoration: InputDecoration(
                  labelText: "Raça",
                  hintText: "Ex: Nelore",
                ),
                onChanged: (value) {
                  animal.raca = value;
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Peso",
                  hintText: "Ex: 350.50",
                ),
                onChanged: (value) {
                  animal.peso = double.parse(value);
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Idade",
                  hintText: "Ex: 5.0",
                ),
                onChanged: (value) {
                  animal.idade = double.parse(value);
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Abate",
                  hintText: "Ex: 7.0",
                ),
                onChanged: (value) {
                  animal.abate = double.parse(value);
                },
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Lote",
                  hintText: "Ex: 1",
                ),
                onChanged: (value) {
                  animal.lote = int.parse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await cadastrarAnimal();
                await obterAnimais();
                Navigator.of(context).pop();
              },
              child: Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
