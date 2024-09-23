import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'button.dart';
import 'dart:async';
import 'data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebSocketChannel _channel;
  bool connected = false;
  late bool led1_state = false;
  late bool led2_state = false;
  String sensor = "55";
  @override
  void initState() {
    // _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.4.1:81'));
    // _channel.stream.isEmpty.then((value) {
    //   connected = !value;
    //   print(value);
    // }).catchError((e) {
    //   print(e);
    // });
    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Icon(Icons.lightbulb,
              color: connected ? Colors.green : Colors.red, size: 35),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "TEMP  $sensor" " \u2103",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                  ),
                ),
              ),
              const SizedBox(height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Button(
                    text: "LIGHT",
                    state: led1_state,
                    onPressed: () {
                      _sendMessage(1);
                    },
                  ),
                  Button(
                      text: "FAN",
                      onPressed: () {
                        _sendMessage(2);
                      },
                      state: led2_state)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  channelconnect() {
    //function to connect
    try {
      _channel = WebSocketChannel.connect(
          Uri.parse('ws://192.168.4.1:81')); //channel IP : Port
      _channel.stream.listen(
        (message) {
          // print(message);

          setState(() {
            if (message == "Connected") {
              connected = true; //message is "connected" from NodeMCU
            } else {
              Map<String, dynamic> dataReceived = jsonDecode(message);
              led1_state = dataReceived["led1"];
              led2_state = dataReceived["led2"];
              sensor = dataReceived["sensor"].toString();
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          // print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          // print(error.toString());
        },
      );
    } catch (_) {
      // print("error on connecting to websocket.");
    }
  }

  void _sendMessage(int ledNo) async {
    if (connected == true) {
      if (ledNo == 1) {
        led1_state = !led1_state;
      } else {
        led2_state = !led2_state;
      }
      Data data = Data(led1: led1_state, led2: led2_state, sensor: "");
      String encodedData = jsonEncode(data.toJson());
      _channel.sink.add(encodedData);
    } else {
      channelconnect();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
