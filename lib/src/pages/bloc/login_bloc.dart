
import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:formsvalidation/src/pages/bloc/validators.dart';

/* static LoginBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
} */

/* Stream<bool> get formValidStream => 
    CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);
 */
class LoginBloc with Validators{


  /*   final _emailController=  StreamController<String>.broadcast();

    final _passwordController= StreamController<String>.broadcast(); */
    final _emailController=  BehaviorSubject<String>();

    final _passwordController= BehaviorSubject<String>();

    //recuperar los datos del stream
     Stream<String> get emailStream   => _emailController.stream.transform(validarEmail);
     Stream<String> get passwordStream=> _passwordController.stream.transform(validarPassword);

     Stream<bool> get formValidStream=>
            CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);



    //insertar valores al stream
    Function(String) get changeEmail=> _emailController.sink.add;
    Function(String) get changePassword=> _passwordController.sink.add;

    //obtener el ultimo valor ingresado en los streams

    String get email=>_emailController.value;
    String get password => _passwordController.value;

   disponse(){
     _emailController?.close();
     _passwordController?.close();
   }



}