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
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Expanded(
          child: Column(
            children: [
              Spacer(),
              TextField(
                onChanged: (value){
                  setState(() =>
                  _input =value
                  );
                },
                controller: _controller,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  final text = _controller.text;
                  _sendMessage(text);
                },
                child: Text('Send'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  final text = _controller.text;
                  setState(() {
                    _input = text;
                  });
                },
                child: Text('Connect'),

              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _conn.disconnect();
                },
                child: Text('Disconnect'),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 50,
                child: Text(_input),
                color: Colors.black12,
              ),
              Spacer(),
            ],
          ),
        ),
      ),
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

  void _updateInput(String data){
    setState(() {
      _input = data;
    });
  }
}