import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // EditText Controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text("New User Register ",style: TextStyle(fontSize: 21, color: Colors.blue,fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(30),
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.green)),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                        hintText: "Enter Your Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.green,
                        )),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                        hintText: "Enter Your Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.green,
                        )),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  TextField(
                    controller: passController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                        hintText: "Enter Your Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.green,
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
                  onPressed: () {
                    registerUserSharePrefrence();
                  },
                  child: const Text("Register")),
            ),
          ],
        ),
      ),
    );
  }
  // Set Register for  NewUser set User Data
  void registerUserSharePrefrence() async {
    var name = nameController.text;
    var email = emailController.text;
    var password = passController.text;
    var pref = await SharedPreferences.getInstance();
    if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty){
      pref.setString("name", name);
      pref.setString("email", email);
      pref.setString("pass", password);
      Fluttertoast.showToast(msg: "Registation Success");
      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
    }
    else{
      Fluttertoast.showToast(msg: "Registation Not Success");
    }
  }
}