import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diction',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = " e6d30fa24e4e10c323fe05bd1d027221d8953261";
  TextEditingController _controller = TextEditingController();

  StreamController _streamController;
  Stream _stream;

  _search() async {

    if (_controller.text == null || _controller.text.length == 0){
      _streamController.add(null);

      return;
    }
    _streamController.add("Waiting");
   Response response = await get(_url + _controller.text.trim(), headers: {"Authorization": "Token " + _token});

   _streamController.add(json.decode(response.body));

  }


  @override
  void initState(){
    super.initState();
    _streamController = StreamController();
  _stream = _streamController.stream ;
  

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diction"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    onChanged: (String text) {},
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Search Your Word",
                      contentPadding: const EdgeInsets.only(left: 24.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // ignore: missing_required_param
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: (){
                  _search();
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(
                child: Text("Enter a Text"),
              );
              }
              if(snapshot.data == "waiting"){
                return Center(child: CircularProgressIndicator());
              }
            return ListView.builder(
              itemCount:  snapshot.data["definitions"].length,
              itemBuilder: (BuildContext context, int index){
                return ListBody(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[300],
                      child: ListTile(
                  title: Text(_controller.text.trim()+ "(" + snapshot.data["definitions"][index]["type"] +")"),
                      ),
                    )
                  ],
                );
                
                
              });
          },
           
        ),
      ),
    );
  }
}
