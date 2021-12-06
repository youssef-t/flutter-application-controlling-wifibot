import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/connection.dart';
import 'package:wifibot_application/utils/wifibot_commands_lib/connection_tcp.dart';

class TestCommunication extends StatefulWidget {
  @override
  _TestCommunicationState createState() => _TestCommunicationState();
}

class _TestCommunicationState extends State<TestCommunication> {
  late ConnectionTCP _conn;
  var _input = '';
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('This is a test'),
      ),
      body: _buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _conn = ConnectionTCP();
    _conn.connect();
  }

  Widget _buildBody() {
    return Column(
      children: [
        const Spacer(),
        TextField(
          onChanged: (value) {
            setState(() => _input = value);
          },
          controller: _controller,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            final text = _controller.text;
            _sendMessage(text);
          },
          child: Text('Send'),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            _conn.connect();
            final text = _controller.text;
            setState(() {
              _input = text;
              //_messages_from_wifibot = _conn.streamMessage!;
            });
          },
          child: Text('Connect'),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            _conn.disconnect();
          },
          child: Text('Disconnect'),
        ),
        const Spacer(),
        Container(
          width: double.infinity,
          height: 50,
          child: Text(_input),
          color: Colors.black12,
        ),
        const Spacer(),
        Container(
          width: double.infinity,
          height: 50,
          color: Colors.black12,
          child: StreamBuilder<String>(
            stream: _conn.streamMessage,
            initialData: "NOTHING",
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              debugPrint(snapshot.data);
              print("snapshot.data : ${snapshot.data}");
              String _textToDisplay = (snapshot.data ?? "NULL");
              return RichText(
                  text: TextSpan(
                text: 'Wifibot response: ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: _textToDisplay,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ));
            },
          ),
        ),
        const Spacer(),
      ],
    );
  }

  void _sendMessage(String text) {
    _conn.send('$text\n');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _conn.disconnect();
    super.dispose();
  }

  void _updateInput(String data) {
    setState(() {
      _input = data;
    });
  }
}
