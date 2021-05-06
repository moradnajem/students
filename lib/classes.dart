import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';


class Classes extends StatefulWidget {
  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {

  /// =========================== Random Text For Insert ========================================
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  /// =========================== Random Text For Insert ========================================


  var name;
  var stage;
  var decryption;
  DatabaseHelper db = DatabaseHelper.instance;
  Future getClasses_fu;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = getRandomString(5);
    stage = getRandomString(5);
    decryption = getRandomString(50);
    getClasses_fu = db.getAllClasses();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
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
                  onPressed: name == null || stage == null || decryption == null ? null :() {
                    Map<String, dynamic> map = {
                      'name' : name,
                      'stage' : stage,
                      'decryption' : decryption,
                    };
                    db.insertToClasses(map).whenComplete(()async{
                      setState(() {
                        name = getRandomString(5);
                        stage = getRandomString(5);
                        decryption = getRandomString(50);
                        getClasses_fu = db.getAllClasses();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Decryption : ',style: TextStyle(color: Color(0xff3AB14B),fontSize: 17,fontWeight: FontWeight.w900),),
                Flexible(child: Text('$decryption',style: TextStyle(color: Colors.pink,fontSize: 17,))),
              ],
            ),
          ),

          Divider(),
          Text('Classes',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w900),),
          FutureBuilder(
              future: getClasses_fu,
              builder: (_,snap){
                if(snap.hasData){
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snap.data.length,
                        shrinkWrap: true,
                        itemBuilder: (_,i){
                          return Card(
                            child: Container(
                              height: 150,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('Name : ${snap.data[i]["name"]}'),
                                    subtitle: Text('ID : ${snap.data[i]["id"]} / Stage : ${snap.data[i]["stage"]}'),
                                    trailing: IconButton(icon: Icon(Icons.delete_forever,color: Colors.red,), onPressed: (){
                                      db.deleteClasses(id: snap.data[i]["id"]).whenComplete((){
                                        setState(() {
                                          getClasses_fu = db.getAllClasses();
                                        });
                                      });
                                    }),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(child: Text('${snap.data[i]["decryption"]}',style: TextStyle(color: Colors.pink,fontSize: 17,))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }else{
                  return Text('No Data In Classes');
                }
              })
        ],
      ),
    );
  }
}
