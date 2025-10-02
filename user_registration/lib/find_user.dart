import 'package:flutter/material.dart';
import 'package:user_registration/api_handler.dart';
import 'package:user_registration/user.dart';

class FindUser extends StatefulWidget {
  const FindUser({super.key});

  @override
  State<FindUser> createState() => _FindUserState();
}

class _FindUserState extends State<FindUser> {
  ApiHandler apiHandler = ApiHandler();
  User user = User.empty();
  TextEditingController textEditingController = TextEditingController();

  void findUser(String id) async {
    user = await apiHandler.getUserById(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find User'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: MaterialButton(
        color: Colors.teal,
        textColor: Colors.white,
        onPressed: () {
          findUser(textEditingController.text);
        },
        padding: EdgeInsets.all(20),
        child: const Text('Find'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(user.name),
              subtitle: Text(user.address),
              // trailing: IconButton(
              //   onPressed: () {
              //     deleteUser(user.userId);
              //   },
              //   icon: const Icon(Icons.delete_outline),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
