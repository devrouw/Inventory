import 'dart:convert';
import 'dart:io';

import 'package:bankinventory/api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStock extends StatefulWidget {
  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {

  bool _isLoading = false;

  Future<File> _image;
  File tmpFile;
  String status = '';
  String base64Image;

  Future getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      tmpFile = image;
      base64Image = base64Encode(image.readAsBytesSync());
//      print(base64Image);
    });
  }

//  chooseImage(){
//    setState(() {
//      _image = ImagePicker.pickImage(source: ImageSource.camera);
//    });
//  }

  String _nama;
  String _qty;
  String _price;
  String _berat;
  String _distributor;
  String _deskripsi;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildCamera(){
    return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              tmpFile == null ? CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://i.pinimg.com/originals/a1/97/da/a197da41e229b0d38b9b856dff6b8518.png'),
              ): new Image.file(tmpFile,width: 100, height: 100,)
            ],
          ),
        );
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Nama Barang'
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Nama Barang is required';
        }
      },
      onSaved: (String value){
        _nama = value;
      },
    );
  }

  Widget _buildQtyField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: 'Quantity'
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Quantity is required';
        }
      },
      onSaved: (String value){
        _qty = value;
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: 'Harga'
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Harga is required';
        }
      },
      onSaved: (String value){
        _price = value;
      },
    );
  }

  Widget _buildBeratField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: 'Berat'
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Berat is required';
        }
      },
      onSaved: (String value){
        _berat = value;
      },
    );
  }

  Widget _buildDistField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Distributor'
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Distributor is required';
        }
      },
      onSaved: (String value){
        _distributor = value;
      },
    );
  }

  Widget _buildDescField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Deskripsi'
      ),
      validator: (String value){
        if(value.isEmpty){
          return 'Deskripsi is required';
        }
      },
      onSaved: (String value){
        _deskripsi = value;
      },
    );
  }

  inputData(String nama, String image, String namabarang, String qty, String harga, String berat, String distributor, String deskripsi) async {
    var rsp = await inputStock(nama.trim(), image.trim(),namabarang.trim(),qty.trim(),harga.trim(),berat.trim(),distributor.trim(),deskripsi.trim());
    print(rsp['status']);

    if (rsp['status'] == '200') {
      setState(() {
        _isLoading = false;
      });
      print('Success');
    } else {
      setState(() {
        _isLoading = false;
      });
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text("Input Data Barang"),
          ),
          body: Container(
            margin: EdgeInsets.all(24),
            child: _isLoading ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            ):Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: getImage,
                      child: _buildCamera()),
                  _buildNameField(),
                  _buildQtyField(),
                  _buildPriceField(),
                  _buildBeratField(),
                  _buildDistField(),
                  _buildDescField(),
                  SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    color: Colors.teal,
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      if(!_formKey.currentState.validate()){
                        return;
                      }
                      _formKey.currentState.save();
                      inputData(tmpFile.path.split('/').last, base64Image,_nama,_qty,_price,_berat,_distributor,_deskripsi);

//                      print(_nama);
//                      print(_qty);
//                      print(_price);
//                      print(_berat);
//                      print(_distributor);
//                      print(_deskripsi);
                    },
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }
}
