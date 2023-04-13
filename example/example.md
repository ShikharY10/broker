# Example

```dart
import 'package:flutter/material.dart';
import 'package:broker/broker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final broker = Broker();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Broker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Broker broker;

  String data = "";

  // this is just for demo. It is showing how to publish a message for a particular subscriber.
  _brokerMessagePublisherDemo() {
    int count = 0;
    final _timer = Timer(Duration(seconds: 2), () {
        broker.publish("<publisher-name>","<subscriber-name>", "${count++}")
    });
  }

  @override
  void initState() {
    super.initState();

    broker = getBroker();
    broker.register("<subscriber-name>")

    broker.listen("<subscriber-name>", (event) {
        Protocol protocol = (event as Protocol);
        setState(() {
            data = protocol.data;
        });
    })
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Broker Demo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate_rounded),
            onPressed: () {
            },
          )
        ],
      ),

      body: Container(
        child: Center(
            child: Text("Data: $data")
        )
      )
    );
  }
}

```
