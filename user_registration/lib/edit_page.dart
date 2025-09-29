import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:user_registration/api_handler.dart';
import 'package:user_registration/user.dart';
import 'package:uuid/uuid.dart';

class EditPage extends StatefulWidget {
  final User user;
  final bool isEdition;
  const EditPage({super.key, required this.user, this.isEdition = false});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  ApiHandler _apiHandler = ApiHandler();
  late http.Response response;

  void updateData() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;

      final user = User(
        userId: widget.user.userId,
        name: data['name'],
        address: data['address'],
      );

      response =
          await _apiHandler.updateUser(id: widget.user.userId, user: user);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  void insertData() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;
      const Uuid guid = Uuid();

      final user = User(
        userId: guid.v4().toString(),
        name: data['name'],
        address: data['address'],
      );

      response = await _apiHandler.addUser(user: user);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isEdition ? 'Edit' : 'Add'} Page"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: MaterialButton(
        color: Colors.teal,
        textColor: Colors.white,
        onPressed: widget.isEdition ? updateData : insertData,
        padding: EdgeInsets.all(20),
        child: Text(widget.isEdition ? 'Update' : 'Add'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'name': widget.user.name,
            'address': widget.user.address
          },
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(labelText: 'Name'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'address',
                decoration: const InputDecoration(labelText: 'Address'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
