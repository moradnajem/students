import 'package:flutter/material.dart';

import 'database_helper.dart';


class classes_students extends StatefulWidget {
  @override
  _classes_studentsState createState() => _classes_studentsState();
}

class _classes_studentsState extends State<classes_students> {



  DatabaseHelper db = DatabaseHelper.instance;
  Future getClasses_fu;
  Future getStudents_fu;
  var selectedStudents;
  var selectedClasses;
  var studentsName;
  var studentsId;
  var classesName;
  var classesId;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClasses_fu = db.getAllClasses();
    getStudents_fu = db.getAllStudents();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('CLASSES STUDENTS'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('STUDENTS NAME',style: TextStyle(color: Color(0xff3AB14B),fontSize: 17,fontWeight: FontWeight.w900),),
                    Text('$studentsName',style: TextStyle(color: Colors.pink,fontSize: 17,)),
                  ],
                ),
                Column(
                  children: [
                    Text('CLASSES NAME',style: TextStyle(color: Color(0xff3AB14B),fontSize: 17,fontWeight: FontWeight.w900),),
                    Text('$classesName',style: TextStyle(color: Colors.pink,fontSize: 17,)),
                  ],
                ),
              ],
            ),
          ),


          Container(
            margin: EdgeInsets.all(10),
            height: 50.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.pink,)),
              onPressed: studentsId == null || classesId == null ? null : () {
                Map<String, dynamic> map = {
                  'students_id' : studentsId,
                  'classes_id' : classesId
                };
                db.insertToClassesStudents(map).then((v){
                  v ? scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Processing Data'))) : null;
                });
              },
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              textColor: Colors.black,
              child: Text("Insert To Classes Students",
                  style: TextStyle(fontSize: 15)),
            ),
          ),


          Divider(),
          Text('Choose from the two lists',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w900),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Text('Students',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w900),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Text('Classes',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w900),),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: getStudents_fu,
                    builder: (_,snap){
                      if(snap.hasData){
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snap.data.length,
                              shrinkWrap: true,
                              itemBuilder: (_,i){
                                return Stack(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: (){
                                        setState(() {
                                          studentsName = snap.data[i]["name"];
                                          studentsId = snap.data[i]["id"];
                                          selectedStudents = i;
                                        });
                                      },
                                      child: Card(
                                        color: i.isOdd ? Colors.white.withOpacity(0.8) : Colors.white,
                                        child: ListTile(
                                          title: Text('Name : ${snap.data[i]["name"]}'),
                                          subtitle: Text('ID : ${snap.data[i]["id"]} / Stage : ${snap.data[i]["stage"]}'),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Icon(Icons.check_outlined , color: selectedStudents == i ? Colors.black : Colors.transparent,),
                                    )
                                  ],
                                );
                              }),
                        );
                      }else{
                        return Text('No Data In Students');
                      }
                    }),

                FutureBuilder(
                    future: getClasses_fu,
                    builder: (_,snap){
                      if(snap.hasData){
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snap.data.length,
                              shrinkWrap: true,
                              itemBuilder: (_,i){
                                return Stack(
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: (){
                                        setState(() {
                                          classesName = snap.data[i]["name"];
                                          classesId = snap.data[i]["id"];
                                          selectedClasses = i;
                                        });
                                      },
                                      child: Card(
                                        color: i.isEven ? Colors.white.withOpacity(0.8) : Colors.white,
                                        child: Container(
                                         // height: 150,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text('Name : ${snap.data[i]["name"]}'),
                                                subtitle: Text('ID : ${snap.data[i]["id"]} / Stage : ${snap.data[i]["stage"]}'),
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
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Icon(Icons.check_outlined , color: selectedClasses == i ? Colors.black : Colors.transparent,),
                                    )
                                  ],
                                );
                              }),
                        );
                      }else{
                        return Text('No Data In Students');
                      }
                    })

              ],
            ),
          ),
        ],
      ),
    );
  }
}
