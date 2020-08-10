import 'package:flutter/material.dart';
import 'package:formsvalidation/src/pages/bloc/login_bloc.dart';
import 'package:formsvalidation/src/pages/bloc/productos_bloc.dart';
export 'package:formsvalidation/src/pages/bloc/login_bloc.dart';
export 'package:formsvalidation/src/pages/bloc/productos_bloc.dart';


class Provider extends InheritedWidget{
  
  final loginBloc= new LoginBloc();
  final _productosBloc = new ProductosBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia==null){
      _instancia= new Provider._internal(key: key,child: child,);
    }

    return _instancia;
  }


  Provider._internal({Key key, Widget child})
          :super(key:key,child:child);


/*   Provider({Key key,Widget child})
    :super(key:key,child:child); */

  //notificar hijos
  @override
  bool updateShouldNotify(InheritedWidget oldWidget)=>true;

//toma todo el contexto y va a buscar un widget 
 static LoginBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
} 
 static ProductosBloc productosBloc ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
} 


}