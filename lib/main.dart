import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

double _numberForm = 0;
// String _startMeasure = "";
String _resultMessage = "";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Measures Converter',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyan, Colors.purple],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class TextWidgetCustom extends StatelessWidget {
  final String title;
  const TextWidgetCustom({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _measures = [
    "meters",
    "kilometers",
    "gram",
    "kilogram",
    "feet",
    "miles",
    "pounds (ibs)",
    "ounces"
  ];
  String _startMeasure = "meters";
  String _endMeasure = "kilometers";

  Map<String, int> measures = {
    "meters": 0,
    "kilometers": 1,
    "gram": 2,
    "kilogram": 3,
    "feet": 4,
    "miles": 5,
    "pounds (ibs)": 6,
    "ounces": 7
  };

  // Khai báo một Map<String, dynamic> có tên `formulas`
  Map<String, dynamic> formulas = {
    // Key là ký tự số, value là một mảng các số
    "0": [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    "1": [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    "2": [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    "3": [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    "4": [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    "5": [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    "6": [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    "7": [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  void convert(double value, String from, String to) {
    int? nFrom = measures[from];
    int? nTo = measures[to];

    var multiplier = formulas[nFrom.toString()][nTo];

    double result = value * multiplier;

    setState(() {
      if (result == 0) {
        _resultMessage = "This conversion cannot be performed";
      } else {
        _resultMessage =
            "${_numberForm.toString()} $_startMeasure are ${result.toString()} $_endMeasure";
      }
    });
    // return value * multiplier;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Measures Converter"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const TextWidgetCustom(title: "Value"),
            TextField(
              onChanged: (value) {
                var rv = double.tryParse(value);
                setState(() {
                  _numberForm = rv ?? 0;
                });
              },
              decoration: const InputDecoration(
                  hintText: "Chỗ này để nhập!",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.red)),
            ),
            Text("Data: $_numberForm"),
            const SizedBox(
              height: 30,
            ),
            const TextWidgetCustom(title: "From"),
            DropdownButton<String>(
                value: _startMeasure,
                items: _measures
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _startMeasure = value.toString();
                  });
                }),
            const SizedBox(
              height: 30,
            ),
            const TextWidgetCustom(title: "To"),
            const SizedBox(
              height: 30,
            ),
            DropdownButton<String>(
                value: _endMeasure,
                items: _measures
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _endMeasure = value.toString();
                  });
                }),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () =>
                    convert(_numberForm, _startMeasure, _endMeasure),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.blue,
                    // maximumSize: Size(12, 4),
                    // minimumSize: const Size(50, 30)
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15)),
                child: const Text(
                  "Convert",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Result: $_resultMessage",
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
