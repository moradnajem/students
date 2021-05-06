import 'package:flutter/material.dart';
import 'Students.dart';
import 'classes.dart';
import 'classes_students.dart';
import 'database_helper.dart';





void main() {
  runApp(new MaterialApp(
    home: new MyHomePage(),
    debugShowCheckedModeBanner: false,
    title: 'CLASSES STUDENTS',
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  DatabaseHelper db = DatabaseHelper.instance;
  Future classes_students_fu;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classes_students_fu = db.getAllClassesStudents();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
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
                  Navigator.of(context).push(PageRouteBuilder(opaque: true,pageBuilder: (BuildContext context, _, __) => Students()));
                },
                padding: EdgeInsets.all(10.0),
                color: Colors.white,
                textColor: Colors.black,
                child: Text("Insert To Students",
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
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(opaque: true,pageBuilder: (BuildContext context, _, __) => Classes()));
                },
                padding: EdgeInsets.all(10.0),
                color: Colors.white,
                textColor: Colors.black,
                child: Text("Insert To Classes",
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
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(opaque: true,pageBuilder: (BuildContext context, _, __) => classes_students())).then((value){
                    setState(() {
                      classes_students_fu = db.getAllClassesStudents();
                    });
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
            Text('CLASSES STUDENTS',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.w900),),
            FutureBuilder(
                future: classes_students_fu,
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
                                      title: Text('Name : ${snap.data[i]["studentsName"]} / ${snap.data[i]["classesName"]}'),
                                      subtitle: Text('ID : ${snap.data[i]["id"]}'),
                                      trailing: IconButton(icon: Icon(Icons.delete_forever,color: Colors.red,), onPressed: (){
                                        db.deleteClassesStudents(id: snap.data[i]["id"]).whenComplete((){
                                          setState(() {
                                            classes_students_fu = db.getAllClassesStudents();
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
                                          Flexible(child: Text('${snap.data[i]["classesDecryption"]}',style: TextStyle(color: Colors.pink,fontSize: 17,))),
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
                    return Text('NO DATA IN CLASSES STUDENTS');
                  }
                })


          ],
        ),
      ),
    );
  }
}
