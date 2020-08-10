import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formsvalidation/src/pages/bloc/provider.dart';
import 'package:formsvalidation/src/pages/models/producto_model.dart';
import 'package:formsvalidation/src/pages/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';
/* 
_mostrarFoto() {
 
    if (producto.fotoUrl != null) {
 
      return Container();
 
    } else {
 
      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  } */

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductosBloc productoBloc;
  ProductoModel producto = new ProductoModel();
  // final productoProvider = new ProductosProvider();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    productoBloc = Provider.productosBloc(context);

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      this.producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }


  _mostrarFoto(){

   
  /*   if(producto.fotoUrl != null){
      //Todo tengo que hacer eso
      return Container();
    }else{
      return Image(
        image: AssetImage( foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    } */
    if (producto.fotoUrl != null) {
 
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/loading.gif'),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.contain,
      );
 
    } else {
 
      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }

  }


  _seleccionarFoto()async{

     this._procesarImagen(ImageSource.gallery);
  }

  _tomarFoto()async{
        _procesarImagen(ImageSource.camera);
  }


  _procesarImagen(ImageSource origen)async{
     if(foto!=null){
       //limpieza
       this.producto.fotoUrl=null;
     }
      this.foto= await  ImagePicker.pickImage(
        source:origen
        );

     setState(() {});
  }


  Widget _crearDisponible() {
    return SwitchListTile(
      activeColor: Colors.deepPurple,
      value: producto.disponible,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        return (value.length < 3) ? 'Ingrese el nombre del producto' : null;
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      //keyboardType: TextInputType.number,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
    );
  }

  RaisedButton _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: (this._guardando) ? null : _submit,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  void _submit() async {

    if (!formKey.currentState.validate()) return;

    //disparar el save de todos los  text form fild que estan en el formulario
    formKey.currentState.save();

    _guardando= true;
    setState(() {});

    if(foto!=null){
      producto.fotoUrl=  await productoBloc.subirFoto(foto);
    }else{
      producto.fotoUrl=null;
    }

    if (producto.id == null) {
      productoBloc.agregarProducto(producto);
    } else {
      productoBloc.editarProducto(producto);
    }

    _mostrarSnackbar('Registro guardado');
        _guardando= false;
    setState(() {});

    Navigator.pop(context);

  }


  void _mostrarSnackbar(String mensaje){
      final snackbar= SnackBar(
        
        content: Text(mensaje),

        duration: Duration(milliseconds: 1500),
      );

      scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
