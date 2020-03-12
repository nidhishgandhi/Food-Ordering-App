import 'package:demo/services/auth.dart';
import 'package:demo/shared/constants.dart';
import 'package:demo/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color.fromARGB(25,2, 6, 15),
     appBar: GradientAppBar(
          //title: Text('LogOut'),
          backgroundColorStart: Colors.redAccent,
          backgroundColorEnd: Colors.redAccent,
          elevation: 0.0,
        title: Text('Sign In'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign Up'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/1.jpg'),
          fit: BoxFit.cover
        ) ,
      ),
        
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'E-mail'),
                validator: (val) => val.isEmpty ? 'Enter an E-mail' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: true,
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                
                side: BorderSide(color: Colors.red)),
                child: Text(
                  'Sign In',
                  style: TextStyle(
            fontSize: 14.0,
          ),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                        loading = false;
                        error = 'Could not sign in with those credentials';
                      });
                    }
                  }
                },
                color: Colors.red,
                textColor: Colors.white,
                
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Color(0xffed6565), fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}