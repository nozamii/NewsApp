import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class EditNews extends StatefulWidget {
  const EditNews({Key key,this.id,this.title,this.desc}) : super(key: key);
  final id,title,desc;
  @override
  _EditNewsState createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNews> {
  String apipath = "http://192.168.10.103:8050/News/edit/";
  SharedPreferences sharedPreferences;
  TextEditingController _userTitleController = new TextEditingController();
  TextEditingController _userDescController = new TextEditingController();
  String title,desc;

  Future<void> _createNews(int id,String title, String desc) async
  {
    Map<String, dynamic> responseData = Map<String, dynamic>();
    sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post(apipath+id.toString(),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id' : id,
          'title': title,
          'desc': desc
        }),
        encoding: Encoding.getByName("utf-8")
    );
    print(apipath+id.toString());
    if(response.statusCode == 200)
    {
      setState(()
      {
        Fluttertoast.showToast(
            msg: "Post Success",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pop(context);
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    double w_device = MediaQuery.of(context).size.width;
    double h_device = MediaQuery.of(context).size.height;

    return  Dialog(
        child: Container(
          width: w_device*0.8,height: h_device*0.45,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(h_device*0.02),
                child: Column(
                  children: [
                    Text("เขียนข่าวของคุณ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: h_device*0.025
                        )),
                               SizedBox(height: h_device*0.01,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(h_device*0.015)),
                          color:Color(0xffF2F2F7)
                      ),
                      height: h_device*0.06,width: w_device*0.9,
                      child: Center(
                        child: TextField(
                            controller: _userTitleController,
                            style: TextStyle(
                                fontSize: h_device*0.02
                            ),
                            decoration:
                            InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                hintStyle: TextStyle(fontSize: h_device*0.02),
                                hintText: widget.title,
                                contentPadding: EdgeInsets.symmetric(horizontal: w_device*0.03)
                            )),
                      ),
                    ),
                    SizedBox(height: h_device*0.01,),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(h_device*0.015)),
                          color:Color(0xffF2F2F7)
                      ),
                      height: h_device*0.2,width: w_device*0.9,
                      child: TextField(
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: null,
                          expands: true,
                          controller: _userDescController,
                          style: TextStyle(
                              fontSize: h_device*0.02
                          ),
                          decoration:
                          InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none
                              ),
                              hintStyle: TextStyle(fontSize: h_device*0.02),
                              hintText: widget.desc,
                              contentPadding: EdgeInsets.symmetric(horizontal: w_device*0.03)
                          )),
                    ),
                    SizedBox(height: h_device*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async
                          {
                            setState(()
                            {
                              if(_userTitleController.text=='' && _userDescController.text == '' ){
                                _createNews(widget.id,widget.title,widget.desc);
                              }
                              else if (_userTitleController.text==''){
                                _createNews(widget.id,widget.title, _userDescController.text,);
                              }
                              else if (_userDescController.text==''){
                                _createNews(widget.id,_userTitleController.text, widget.desc);
                              }
                              else {
                                _createNews(widget.id,_userTitleController.text, _userDescController.text);
                              }

                            });
                          },
                          child: Container(
                            width: w_device*0.3,height: h_device*0.06,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(h_device*0.015)
                            ),
                            child: Center(
                              child: Text("แก้ไขข่าว",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: h_device*0.03
                                  )),
                            ),),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            width: w_device*0.3,height: h_device*0.06,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(h_device*0.015)
                            ),
                            child: Center(
                              child: Text("ยกเลิก",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: h_device*0.03
                                  )),
                            ),),
                        )
                      ],
                    )
                  ],
                ),

              ),
            ],
          ),
        )
    );
  }
}
