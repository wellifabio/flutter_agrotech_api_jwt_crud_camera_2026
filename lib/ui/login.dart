import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import '../root/api.dart';
import '/ui/style/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "maria@email.com";
  String password = "senha123";

  @override
  initState() {
    verificarCredenciais();
    super.initState();
  }

  Future<void> compartilharCredencias(String perfil) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('autenticacao', perfil);
    verificarCredenciais();
  }

  Future<void> verificarCredenciais() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('autenticacao')) {
      irParaHome();
    }
  }

  Future<void> irParaHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  Future<void> autenticar() async {
    final url = Uri.parse(Api.login);
    try {
      final resp = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: '{"email":"$email","password":"$password"}',
      );
      if (resp.statusCode == 200) {
        compartilharCredencias(resp.body);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("E-mail ou senha inválidos")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Image.asset('assets/icone.png', width: 150),
              TextField(
                style: TextStyle(color: AppColors.p1),
                decoration: InputDecoration(labelText: "E-mail"),
                onChanged: (value) => setState(() {
                  email = value;
                }),
              ),
              TextField(
                style: TextStyle(color: AppColors.p1),
                decoration: InputDecoration(labelText: "Senha"),
                onChanged: (value) => setState(() {
                  password = value;
                }),
                obscureText: true,
              ),
              ElevatedButton(onPressed: autenticar, child: Text("Entrar")),
            ],
          ),
        ),
      ),
    );
  }
}
