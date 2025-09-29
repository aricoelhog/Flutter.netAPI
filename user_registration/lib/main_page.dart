import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:user_registration/api_handler.dart';
import 'package:user_registration/edit_page.dart';
import 'package:user_registration/http/http_extensions.dart';
import 'package:user_registration/user.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ApiHandler apiHandler = ApiHandler();
  late List<User> data = [];

  void getData() async {
    try {
      data = await apiHandler.getUserData();
      setState(() {});
    } catch (e) {
      print('Error when refreshing page: $e');
    }
  }

  void deleteUser(String userId) async {
    try {
      final msg;
      final response = await apiHandler.deleteUser(userId: userId);
      print("Response: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        msg = "User deleted successfuly!";
        getData();
      } else {
        msg = "An error occured at delete: ${response.statusMessage}";
      }
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print('Error when deleting user: $e');
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: MaterialButton(
        color: Colors.teal,
        textColor: Colors.white,
        onPressed: getData,
        padding: EdgeInsets.all(20),
        child: const Text('Refresh'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPage(
              user: const User(
                userId: '',
                name: '',
                address: '',
              ),
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(
                          user: data[index],
                          isEdition: true,
                        ),
                      ),
                    );
                  },
                  //leading: Text("${data[index].userId}"),
                  title: Text(data[index].name),
                  subtitle: Text(data[index].address),
                  trailing: IconButton(
                    onPressed: () {
                      deleteUser(data[index].userId);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
