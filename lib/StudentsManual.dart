import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';


class StudentsManual extends StatefulWidget {
  @override
  _StudentsManualState createState() => _StudentsManualState();
}

class _StudentsManualState extends State<StudentsManual> {



  TextEditingController _nameController;
  TextEditingController _stageController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseHelper db = DatabaseHelper.instance;
  Future getStudents_fu;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController(text: '');
    _stageController = TextEditingController(text: '');
    getStudents_fu = db.getAllStudents();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _stageController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10.0),
              PhysicalModel(
                color: Colors.transparent,
                shadowColor: Colors.black87,
                elevation: 5,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  padding: EdgeInsets.only(top: 20.0,bottom: 40.0,left: 20.0,right: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onChanged: (v){
                          setState(() {

                          });
                        },
                        controller: _nameController,
                        validator: validateName,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffA62D26),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        onChanged: (v){
                          setState(() {

                          });
                        },
                        controller: _stageController,
                        validator: validateStage,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Stage',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffA62D26),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
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
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        Map<String, dynamic> map = {
                          'name' : _nameController.text,
                          'stage' : _stageController.text
                        };
                        db.insertToStudents(map).whenComplete(()async{
                          setState(() {
                            _nameController.text = '';
                            _stageController.text = '';
                            getStudents_fu = db.getAllStudents();
                          });
                        });
                      }
                    },
                    padding: EdgeInsets.all(10.0),
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text("Insert",style: TextStyle(fontSize: 15)),
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
                    Text('${_nameController.text}',style: TextStyle(color: Colors.pink,fontSize: 17,)),
                  ],
                ),
                Row(
                  children: [
                    Text('Stage : ',style: TextStyle(color: Color(0xff3AB14B),fontSize: 17,fontWeight: FontWeight.w900),),
                    Text('${_stageController.text}',style: TextStyle(color: Colors.pink,fontSize: 17,)),
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
                return ListView.builder(
                    itemCount: snap.data.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                    });
              }else{
                return Text('No Data In Students');
              }
            })
          ],
        ),
      ),
    );
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'error name';
    else
      return null;
  }
  String validateStage(String value) {
    if (value.length < 3)
      return 'error stage';
    else
      return null;
  }

}
