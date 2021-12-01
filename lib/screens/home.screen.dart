import 'package:conversormoedas/main.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar = 0;
  double euro = 0;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _clearText() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChange(String text) {
    double real = 0;
    if (text != "") {
      real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / dolar).toStringAsFixed(2);
    } else {
      _clearText();
    }
  }

  void _dolarChange(String text) {
    double dolar = 0;
    if (text != "") {
      dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    } else {
      _clearText();
    }
  }

  void _euroChange(String text) {
    double euro = 0;
    if (text != "") {
      euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    } else {
      _clearText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Conversor',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text('Carrengando dados',
                    style: TextStyle(color: Colors.white)),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Erro ao carregar dados'),
                );
              } else {
                if (snapshot.data != null) {
                  dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(Icons.monetization_on,
                          size: 150, color: Colors.white),
                      buildTextField(
                          "R\$", "Reais", realController, _realChange),
                      const Divider(),
                      buildTextField(
                          "US\$", "Dolares", dolarController, _dolarChange),
                      const Divider(),
                      buildTextField("€", "Euros", euroController, _euroChange),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String prefix, String label,
    TextEditingController controller, Function(String) change) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
        prefixText: prefix,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white)),
    onChanged: change,
  );
}
