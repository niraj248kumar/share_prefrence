import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  final _picker = ImagePicker();
  bool _isLoading = false;
  String? base64Image;
  late List<String> itemList = [];
  TextEditingController itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  void loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
      itemList = prefs.getStringList('items') ?? [];
    });
  }

  void addNewUser(String item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    itemList.add(item);
    prefs.setStringList('items', itemList);

    if (_imageFile != null) {
      List<int> imagesBytes = await _imageFile!.readAsBytes();
      base64Image = base64Encode(imagesBytes);
    }
    setState(() {});
  }

  // void pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //     });
  //   } else {
  //     Fluttertoast.showToast(msg: 'Image is not selected');
  //   }
  // }

  void updateUser(int index, String newItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    itemList[index] = newItem;
    prefs.setStringList('items', itemList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: const Text(
          "Crude SharePref",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Fluttertoast.showToast(msg: "Notification");
            },
          ),
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLogin', false);
              Fluttertoast.showToast(msg: "User LogOut");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showBottomSheetModal,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.blue,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: ClipOval(
                        child: base64Image != null
                            ? Image.memory(base64Decode(base64Image!))
                            : const Icon(Icons.person),
                      ),
                    ),
                    title: Text(itemList[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showEditDialog(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            simpleAlertDialog(
                              title: "Delete Cache",
                              description: "Are You Sure You Want to Delete?",
                              index: index,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showEditDialog(int index) {
    TextEditingController editController =
    TextEditingController(text: itemList[index]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit User"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(labelText: "New Name"),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  updateUser(index, editController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Update"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void simpleAlertDialog({
    required String title,
    required String description,
    required int index,
  }) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title, style: TextStyle(color: Colors.orange, fontSize: 30)),
        content: Text(description, style: TextStyle(color: Colors.orange)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, "Canceled"),
            child: Text("No", style: TextStyle(color: Colors.red, fontSize: 20)),
          ),
          TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Delete Success");
              _deleteUser(index);
              Navigator.pop(context);
            },
            child: Text("Yes", style: TextStyle(color: Colors.green, fontSize: 20)),
          ),
        ],
      ),
    );
  }

  void _deleteUser(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    itemList.removeAt(index);
    prefs.setStringList('items', itemList);
    setState(() {});
  }

  void showBottomSheetModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
              ),
              TextField(
                controller: itemController,
                decoration: const InputDecoration(
                  labelText: 'Enter Your Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () {
                    if (itemController.text.isNotEmpty) {
                      addNewUser(itemController.text);
                      itemController.clear();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save User",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
