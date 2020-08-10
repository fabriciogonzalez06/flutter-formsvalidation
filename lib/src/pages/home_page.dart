import 'package:flutter/material.dart';
import 'package:formsvalidation/src/pages/bloc/provider.dart';
// import 'package:formsvalidation/src/pages/bloc/provider.dart';
import 'package:formsvalidation/src/pages/models/producto_model.dart';

class HomePage extends StatelessWidget {
  // final productosPrivider = ProductosProvider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);
    final productosBloc= Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return  StreamBuilder(
      stream: productosBloc.productosStream ,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        
        if (snapshot.hasData) {
        final productos = snapshot.data;
          return ListView.builder(
          //  padding: EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: productos.length,
            itemBuilder: (BuildContext context, i) {
              return _crearItem(context,productosBloc, productos[i]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    
  
  }

  Widget _crearItem(BuildContext context,ProductosBloc productoBloc, ProductoModel producto) {
    print(producto.fotoUrl);
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          //borrar producto
          productoBloc.borrarProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              
              (producto.fotoUrl == null)
                  ? Image(
                      image: AssetImage('assets/no-image.png'),
                    )
                  : FadeInImage(
                      image: NetworkImage(producto.fotoUrl),
                      placeholder: AssetImage('assets/loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor} '),
                subtitle: Text('${producto.id}'),
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto),
              )
            ],
          ),
        ));
  }

  FloatingActionButton _crearBoton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.pushNamed(context, 'producto');
      },
    );
  }
}
