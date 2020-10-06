import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {


  TextEditingController _nameController,_numberController; // controllers for TextFormField
  String _typeSelected='';
  bool isUserNameValidate = false;
  bool isUserPhoneValidate =false;
  DatabaseReference _ref;
  DatabaseReference _rnd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('Contacts');
  }

  Widget _buildContactType(String title)
  {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,

        decoration: BoxDecoration(
          color: _typeSelected == title ? Colors.green : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(title,style: TextStyle(fontSize: 18,color: Colors.white),),
        ),
      ),

      onTap: (){
        setState(() {
          _typeSelected=title;
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Contacts'),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                  prefixIcon: Icon(Icons.account_circle,size: 30.0),
                  fillColor: Colors.white,
                  filled: true,
                  errorText: isUserNameValidate ? 'Please enter a valid Username' : null,
      ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _numberController,
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number',
                  prefixIcon: Icon(Icons.phone_iphone,size: 30.0),
                  fillColor: Colors.white,
                  filled: true,
                    errorText: isUserPhoneValidate ? 'Please enter a valid Phone number' : null,
                ),
              ),

              SizedBox(height: 20,),
              Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildContactType('Work'),
                    SizedBox(width: 5),
                    _buildContactType('Family'),
                    SizedBox(width: 5),
                    _buildContactType('Friends'),
                    SizedBox(width: 5),
                    _buildContactType('Others'),
                  ],
                ),

              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                //width: 10,
                //padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    //side: BorderSide(color: Colors.red)
                  ),
                  child: Text(
                    'Update',style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  ),
                  onPressed: (){
                    validateTextField(_nameController.text);
                    validatePhoneField(_numberController.text);
                    updateContact();
                  },
                  color: Colors.black26,
                ),
              ),

              SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.red)
                  ),
                  child: Text(
                    'Save Contact',style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  ),
                  onPressed: (){
                    validateTextField(_nameController.text);
                    validatePhoneField(_numberController.text);
                    saveContact();
                  },
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        isUserNameValidate = true;
      });
      return false;
    }
    setState(() {
      isUserNameValidate = false;
    });
    return true;
  }

  bool validatePhoneField(String userInput) {
    if (userInput.isEmpty || userInput.length!=10) {
      setState(() {
        isUserPhoneValidate = true;
      });
      return false;
    }
    setState(() {
      isUserPhoneValidate = false;
    });
    return true;
  }



  void updateContact() {
    String name = _nameController.text;
    String number = _numberController.text;
    
    Map<String,String> contact = {
      'name':name,
      'number':'+91' + number,
      'type': _typeSelected,
    };

    _rnd=FirebaseDatabase.instance.reference().child("Contacts");
    _rnd.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values=snapshot.value;
      //print(values.toString());
      values.forEach((k,v) {
        //print(k);
        //print(v['name']);
        v['name']==name ? _ref.child(k).update(contact) : null;
      });
    });


  }

  void saveContact()
  {
    String name = _nameController.text;
    String number = _numberController.text;


    Map<String,String> contact = {
      'name':name,
      'number':'+91' + number,
      'type': _typeSelected,
    };

    if(name!='' && number!='' && number.length==10)
      {
        _ref.push().set(contact).then((value){
          Navigator.pop(context);

        });
      }


  }


}
