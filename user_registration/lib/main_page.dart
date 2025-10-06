import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  TextEditingController textEditingController = TextEditingController();

  void getData() async {
    data = await apiHandler.getUserData();
    setState(() {});
  }

  void filter(String text) async {
    data = await apiHandler.getUserData(filter: text);
    setState(() {});
  }

  void deleteUser(String userId) async {
    final msg;
    final response = await apiHandler.deleteUser(userId: userId);

    if (response.statusCode >= 200 && response.statusCode <= 299) {
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 2,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            onPressed: () async {
              await Navigator.push(
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
              );
              textEditingController.clear();
              getData();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), // Ícone no início
              hintText: 'Tap the user name',
              border: OutlineInputBorder(),
            ),
            controller: textEditingController,
            onChanged: (text) => filter(text),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(
                          user: data[index],
                          isEdition: true,
                        ),
                      ),
                    );
                    textEditingController.clear();
                    getData();
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
