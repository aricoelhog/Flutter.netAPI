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
  bool isLoading = false;

  void getData() async {
    setState(() {
      isLoading = true;
    });

    data = await apiHandler.getUserData();

    setState(() {
      isLoading = false;
    });
  }

  void filter(String text) async {
    data = await apiHandler.getUserData(filter: text);
    setState(() {});
  }

  void deleteUser(String userId) async {
    setState(() {
      isLoading = true;
    });

    final msg;
    final response = await apiHandler.deleteUser(userId: userId);

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      msg = "User deleted successfuly!";
      getData();
    } else {
      msg = "An error occured at delete: ${response.statusMessage}";
      setState(() {
        isLoading = false;
      });
    }

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
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
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: MaterialButton(
        color: Colors.blueGrey,
        textColor: Colors.white,
        onPressed: isLoading ? null : getData,
        padding: EdgeInsets.all(20),
        child: const Text('Refresh'),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 2,
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            onPressed: isLoading
                ? null
                : () async {
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
              prefixIcon: Icon(Icons.search),
              hintText: 'Tap the user name',
              border: OutlineInputBorder(),
            ),
            controller: textEditingController,
            onChanged: (text) => filter(text),
            enabled: !isLoading,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueGrey,
                    ),
                  )
                : ListView.builder(
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
