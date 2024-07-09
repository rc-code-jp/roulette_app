import 'package:flutter/material.dart';
import 'package:roulette/roulette.dart';
import 'package:roulette_app/components/arrow.dart';
import 'package:roulette_app/utils/random_number.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '支払いルーレット',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class MyRoulette extends StatelessWidget {
  const MyRoulette({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final RouletteController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Roulette(
              controller: controller,
              style: const RouletteStyle(
                dividerThickness: 0.0,
                dividerColor: Colors.black,
                centerStickSizePercent: 0.05,
                centerStickerColor: Colors.black,
              ),
            ),
          ),
        ),
        const Arrow(),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late RouletteController _controller;

  final colors = <Color>[
    Colors.red.withAlpha(50),
    Colors.green.withAlpha(30),
    Colors.blue.withAlpha(70),
    Colors.amber.withAlpha(50),
    Colors.indigo.withAlpha(70),
  ];

  final List<String> texts = [
    'すべてA',
    'すべてB',
    '半分',
    'A多め',
    'B多め',
  ];

  bool isFirst = true;

  @override
  void initState() {
    super.initState();

    _controller = RouletteController(
      vsync: this,
      group: RouletteGroup.uniform(colors.length,
          colorBuilder: (index) => colors[index],
          textBuilder: (index) => texts[index],
          textStyleBuilder: (index) => const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支払いルーレット'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.05),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              MyRoulette(controller: _controller),
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Aの名前',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Bの名前',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller
            .rollTo(
          3,
          minRotateCircles: 40,
          duration: const Duration(seconds: 20),
          clockwise: true,
          // 最初のみ3.1-3.9でAがすべてを指すようにする
          offset: isFirst
              ? generateRandomNumber(3.1, 3.9)
              : generateRandomNumber(0.1, 7.9),
        )
            .then((_) {
          setState(() {
            isFirst = false;
          });
        }),
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
