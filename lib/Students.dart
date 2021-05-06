import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';


class Students extends StatefulWidget {
  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {

  /// =========================== Random Text For Insert ========================================
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  /// =========================== Random Text For Insert ========================================


  var name;
  var stage;
  DatabaseHelper db = DatabaseHelper.instance;
  Future getStudents_fu;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = getRandomString(5);
    stage = getRandomString(5);
    getStudents_fu = db.getAllStudents();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                height: 50.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.pink,)),
                  onPressed: () {
                    setState(() {
                      name = getRandomString(5);
                      stage = getRandomString(5);
                    });
                  },
                  padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text("Random 🔀",
                      style: TextStyle(fontSize: 15)),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                height: 50.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.pink,)),
                  onPressed: name == null || stage == null ? null :() {
                    Map<String, dynamic> map = {
                      'name' : name,
                      'stage' : stage
                    };
                      db.insertToStudents(map).whenComplete(()async{
                        setState(() {
                          name = getRandomString(5);
                          stage = getRandomString(5);
                          getStudents_fu = db.getAllStudents();
                        });
                      });
                  },
                  padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text("Insert",
                      style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text('Name : ',style: TextStyle(color: Color(0xff3AB14B),fontSize: 17,fontWeight: FontWeight.w900),),
                  Text('$name',style: TextStyle(color: Colors.pink,fontSize: 17,)),
                ],
              ),
              Row(
                children: [
                  Text('Stage : ',style: TextStyle(color: Color(0xff3AB14B),fontSize: 17,fontWeight: FontWeight.w900),),
                  Text('$stage',style: TextStyle(color: Colors.pink,fontSize: 17,)),
                ],
              ),
            ],
          ),


          Divider(),
          Text('Students',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w900),),
          FutureBuilder(
              future: getStudents_fu,
              builder: (_,snap){
            if(snap.hasData){
              return Expanded(
                child: ListView.builder(
                  itemCount: snap.data.length,
                    shrinkWrap: true,
                    itemBuilder: (_,i){
                  return Card(
                    child: ListTile(
                      title: Text('Name : ${snap.data[i]["name"]}'),
                      subtitle: Text('ID : ${snap.data[i]["id"]} / Stage : ${snap.data[i]["stage"]}'),
                      trailing: IconButton(icon: Icon(Icons.delete_forever,color: Colors.red,), onPressed: (){
                        db.deleteStudents(id: snap.data[i]["id"]).whenComplete((){
                          setState(() {
                            getStudents_fu = db.getAllStudents();
                          });
                        });
                      }),
                    ),
                  );
                }),
              );
            }else{
              return Text('No Data In Students');
            }
          })
        ],
      ),
    );
  }
}
