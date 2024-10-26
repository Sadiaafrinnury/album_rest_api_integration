import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'model/model.dart';


class AlbumsPage extends StatefulWidget {
  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {

 Future<List<AlbumModel>>fetchalbums() async{
   final response = await http.get(Uri.parse
     ("https://jsonplaceholder.typicode.com/albums"));

   if(response.statusCode==200){
     List<dynamic>data = jsonDecode(response.body);

     return data.map((json)=>AlbumModel.fromJson(json)).toList();
   } else {
     throw Exception("Failed to load albums");
   }
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
          future: fetchalbums(),
          builder: (context, snapshot) {
            if(snapshot.connectionState== ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            } else if(snapshot.hasError){
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(child: Text("No albums found"));
            }else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final album = snapshot.data![index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(album.title),
                        subtitle: Text("Album ID: ${album.id}\nUser ID: ${album.userId}"),
                      ),
                    );
                  },
              );
            }
          },),
    );
  }
}

