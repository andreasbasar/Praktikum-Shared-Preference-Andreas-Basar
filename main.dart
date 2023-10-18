import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class KalkulatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator'),
      ),
      body: KalkulatorWidget(),
    );
  }
}

class KalkulatorWidget extends StatefulWidget {
  @override
  _KalkulatorWidgetState createState() => _KalkulatorWidgetState();
}

class _KalkulatorWidgetState extends State<KalkulatorWidget> {
  TextEditingController num1Controller = TextEditingController();
  TextEditingController num2Controller = TextEditingController();
  TextEditingController operationController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void hitungDanSimpanHasil() {
    double num1 = double.tryParse(num1Controller.text) ?? 0.0;
    double num2 = double.tryParse(num2Controller.text) ?? 0.0;
    String operasi = operationController.text;

    double hasil = lakukanPerhitungan(num1, num2, operasi);

    // Simpan hasil dan operasi ke shared preferences
    prefs.setString('operasi', operasi);
    prefs.setDouble('hasil', hasil);
  }

  double lakukanPerhitungan(double num1, double num2, String operasi) {
    switch (operasi) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        return num1 / num2;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: num1Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Bilangan 1'),
          ),
          TextField(
            controller: num2Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Bilangan 2'),
          ),
          TextField(
            controller: operationController,
            decoration: InputDecoration(labelText: 'Operasi (+, -, *, /)'),
          ),

          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              hitungDanSimpanHasil();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Hasil perhitungan disimpan.')),
              );
            },
            child: Text('Hitung'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/hasil');
            },
            child: Text('Lihat Hasil'),
          )

        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Perhitungan'),
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            SharedPreferences prefs = snapshot.data as SharedPreferences;
            String operasi = prefs.getString('operasi') ?? '';
            double hasil = prefs.getDouble('hasil') ?? 0.0;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Operasi: $operasi'),
                  Text('Hasil: $hasil'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


class WidgetHasil extends StatefulWidget {
  @override
  _WidgetHasilState createState() => _WidgetHasilState();
}

class _WidgetHasilState extends State<WidgetHasil> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    String operasi = prefs.getString('operasi') ?? '';
    double hasil = prefs.getDouble('hasil') ?? 0.0;

    return Center(12
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Operasi: $operasi'),
          Text('Hasil: $hasil'),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KalkulatorScreen(),
      routes: {
        '/hasil': (context) => ResultScreen(),
      },
    );
  }
}


