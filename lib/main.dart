import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<User>> _getUsers() async{
    var data = await http.get("https://jsonplaceholder.typicode.com/photos");

    var jsonData = json.decode(data.body);
    List <User> users = [];

    for (var i in jsonData){
      User user = User(i["id"],i["title"],i["url"],i["url"]);

      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Fake REST API",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: new Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            print(snapshot.data);
            if(snapshot.data==null){
              return Container(
                child: new Center(
                  child: new Text("Loading...")
                )
              );
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int id){
                  return ListTile(
                    leading : CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data[id].tUrl)
                    ),
                    title: new Text(snapshot.data[id].title)
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class User{
  final int id;
  final String title;
  final String url;
  final String tUrl;

  User(this.id,this.title,this.tUrl,this.url);

}
