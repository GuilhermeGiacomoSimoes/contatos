import 'dart:io';

import 'package:contatos/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  Contact _editedContact;

  bool _usedEdited = false;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null){
      _editedContact = Contact();
    }
    else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,

      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "novo contato",),
          centerTitle: true,
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(_editedContact.name != null && _editedContact.name.isNotEmpty){
              Navigator.pop(context, _editedContact);
            }
            else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[

              GestureDetector(
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) {
                      return;
                    }
                    else {
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    }

                  });
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/person.png"),
                      )
                  ),
                ),
              ),

              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "nome"),
                onChanged: (text) {
                  _usedEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "email"),
                onChanged: (text) {
                  _usedEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),

              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "telefone"),
                onChanged: (text) {
                  _usedEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),

            ],
          ),
        ),

      ),

    );
  }

  Future<bool> _requestPop() {
    if(_usedEdited){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("descartar alterações?"),
            content: Text("se sair as alterações serão perdidas."),
            actions: <Widget>[

              FlatButton(
                child: Text("cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              FlatButton(
                child: Text("sim"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )

            ],
          );
        }
      );

      return Future.value(false);
    }
    else {
      return Future.value(true);
    }
  }

}
