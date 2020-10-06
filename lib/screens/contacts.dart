import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_contact.dart';


class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Query _ref;
  DatabaseReference _rnd;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance.reference().child('Contacts').orderByChild('name');

  }

  Widget _buildContactItem ({Map contact}){
    Color typeColor = getTypeColor(contact['type']);
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        height: 100,
        color: Colors.white,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Icon(Icons.person,color: Theme.of(context).primaryColor,size: 20,),
                SizedBox(width: 6,),
                Text(contact['name'],style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600),),
              ],
            ),
            SizedBox(height: 12,),
            SafeArea(
              child: Row(
                children: [
                  Icon(Icons.phone_iphone,color: Theme.of(context).primaryColor,size: 20,),
                  SizedBox(width: 6,),
                  Text(contact['number'],style: TextStyle(fontSize: 16,color: Theme.of(context).accentColor,fontWeight: FontWeight.w600),),

                  SizedBox(width: 10,),

                  Icon(Icons.group_work,color: typeColor,size: 20,),
                  SizedBox(width: 6,),
                  Text(contact['type'],style: TextStyle(fontSize: 16,color: typeColor,fontWeight: FontWeight.w600),),

                  SizedBox(width:(MediaQuery. of(context). size. width)/7,),

                  Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        alignment: Alignment.bottomRight,
                        icon: Icon(Icons.update,color: Colors.green,size: 30,),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_){
                            return AddContact();
                          }));
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        alignment: Alignment.bottomRight,
                        icon: Icon(Icons.delete_forever,color: Colors.red,size: 30,),
                        onPressed: (){
                          //Todo: delete

                          deleteContact(contact['name']);
                        },
                      ),
                    ],
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
  void deleteContact(String name){
    _rnd=FirebaseDatabase.instance.reference().child("Contacts");
    _rnd.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      //print(values.toString());
      values.forEach((k,v) {
        //print(k);
        //print(v['name']);
        v['name']== name?  _rnd.child(k).remove() : null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Contacts'),
        //backgroundColor: Colors.black26,
        centerTitle: true,
      ),

      body: Container(
        height: double.infinity,

        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double>animation, int index){
            Map contact = snapshot.value;
            return _buildContactItem(contact: contact);
          },

        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (_){
          return AddContact();
        }));
      },
      child: Icon(Icons.add,color: Colors.white,size: 30.0),
      ),
    );
  }

  Color getTypeColor(String type){
    Color color = Theme.of(context).primaryColor;

    if(type=='Work'){
      color = Colors.brown;
    }
    if(type=='Family'){
      color = Colors.green;
    }
    if(type=='Friends'){
      color = Colors.teal;
    }
    return color;
  }


}
