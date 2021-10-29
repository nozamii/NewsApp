import 'dart:convert';

import 'package:NewsFlutter/createnews.dart';
import 'package:NewsFlutter/editnews.dart';
import 'package:NewsFlutter/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'News Feed'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String apipath = "http://192.168.10.103:8050/News";
  SharedPreferences sharedPreferences;
  var maxnews;
  List allnews;
  List<Map> news = [];
  bool isLoading = true;

  Future<void> _getNews() async
  {
    var responseData;
    sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.get(apipath+"/show",
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if(response.statusCode == 200)
    {
      setState(()
      {
        responseData = json.decode(response.body);
        allnews = responseData;
         for(var item in allnews)
        {
         news.add(item);
        }
        maxnews = news.length;
        isLoading = false;
      });
    }
    else if (response.statusCode == 400)
    {
      setState(()
      {
        responseData = json.decode(response.body);
      });
    }
  }

  Future<void> _delete(var index) async
  {
    Map<String, dynamic> responseData = Map<String, dynamic>();
    sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.delete(apipath+"/del"+"/"+index.toString(),
      headers:
      {
        'Content-Type': 'application/json',
      },
    );
    print(apipath+"/del"+"/"+index.toString());

    if(response.statusCode == 200)
    {
      setState(() async
      {
        Fluttertoast.showToast(
            msg: "Delete Success",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Phoenix.rebirth(context);
      });
    }

  }

  Future<void> onPullToRefresh() async
  {
    setState(()
    {
      Phoenix.rebirth(context);
    });
  }

  Future _getInit() async
  {
    await _getNews();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInit();
  }


  @override
  Widget build(BuildContext context) {

    return isLoading
        ? LoadingScreen()
        : Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
          onRefresh: onPullToRefresh,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                    itemCount: maxnews,scrollDirection: Axis.vertical ,
                      itemBuilder: (context, index){
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black38)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          showDialog( context: context,
                                              builder: (context) {
                                                return EditNews(id:news[index]['id'],title: news[index]['title'],desc: news[index]['desc']);
                                              });
                                        });

                                      },
                                      child: Icon(Icons.edit,
                                        color: Colors.blue,
                                        size: 20 ,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _delete(news[index]['id']);
                                        });

                                      },
                                      child: Icon(Icons.close,
                                      color: Colors.red,
                                      size: 20 ,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("หัวข้อข่าว : ",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),),
                                    Text(news[index]['title'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                        ))
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text("เนื้อข่าว : ",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    )),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(news[index]['desc'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ))
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      );


              }))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showDialog( context: context,
                builder: (context) {
              return CreateNews();
            });
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add_sharp),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
