import 'package:flutter/material.dart';

class TestCommunication extends StatefulWidget {
  @override
  _TestCommunicationState createState() => _TestCommunicationState();
}

class _TestCommunicationState extends State<TestCommunication> {
  var _input = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('This is a test'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Expanded(
          child: Column(
            children: [
              Spacer(),
              TextField(),
              Spacer(),
              ElevatedButton(onPressed: (){}, child: Text('Send'),),
              Spacer(),
              Container(child: Text(_input), color: Colors.black12,),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
