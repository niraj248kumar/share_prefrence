import 'package:flutter/material.dart';
import 'package:flutter_share_pre/register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var loginEmail = TextEditingController();
  var loginPassword = TextEditingController();

  bool  isLogin = false;

  void getSharePref() async {
    setState(() {
      isLogin = true;
    });
    var loginEmailId = loginEmail.text;
    var loginId = loginPassword.text;
    var perfLogin = await SharedPreferences.getInstance();
    var userId = perfLogin.getString("email");
    var userPassword = perfLogin.getString("pass");

    perfLogin.setBool('isLogin', isLogin);

    if (loginEmailId == userId && loginId == userPassword) {
      Fluttertoast.showToast(msg: "Login Success");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    } else {
      Fluttertoast.showToast(msg: "Login Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(30),
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.green)),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  // const CircleAvatar(
                  //   backgroundColor: Colors.white,
                  //   radius: 50,
                  //   backgroundImage: NetworkImage(),
                  // ),
                  const SizedBox(
                    height: 18,
                  ),
                  TextField(
                    controller: loginEmail,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 15),
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
                    controller: loginPassword,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 15),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                    padding:  EdgeInsets.only(right: 18),
                    child:
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>RegisterPage()),
                              (route) => false,);
                      },
                      child:  Container(
                        height: 40,
                        width: 200,
                        child: Center(child: Text("Register?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green),)),
                      ),
                    )
                ),
              ],
            ),

            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green)),
                  onPressed: () {
                    getSharePref();
                  },
                  child: Text("Login")),
            ),
          ],
        ),
      ),
    );
  }
}