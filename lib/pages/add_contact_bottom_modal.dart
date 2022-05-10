import 'package:flutter/material.dart';
import 'package:my_contacts/models/contact.dart';
import 'package:my_contacts/pages/home_page.dart';
import 'package:my_contacts/providers/contacts_provider.dart';
import 'package:provider/provider.dart';

class AddContactBottomModal extends StatefulWidget {
  Contact? contact;

  AddContactBottomModal({this.contact});

  @override
  State<AddContactBottomModal> createState() => _AddContactBottomModalState();
}

class _AddContactBottomModalState extends State<AddContactBottomModal> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneController = TextEditingController();
  late String genderController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: widget.contact != null ? widget.contact!.name : "");
    lastNameController = TextEditingController(
        text: widget.contact != null ? widget.contact!.lastName : "");
    phoneController = TextEditingController(
        text: widget.contact != null ? widget.contact!.phoneNumber : "");
    genderController = widget.contact != null ? widget.contact!.gender : "Male";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      reverse: true,
      child: Container(
        padding: EdgeInsets.only(
          top: 5,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 10,
          right: 10,
        ),
        child: Form(
            key: _formKey,
            child: Container(
              width: size.width * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                      left: 5,
                    ),
                    child: const Text(
                      "Add a new Contact",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(thickness: 2),
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: size.width * 0.95,
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: size.width * 0.95,
                    child: TextFormField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: size.width * 0.95,
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Phone Number",
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 10) {
                          return 'Please enter a valid phone number';
                        }
                      },
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(5),
                      width: size.width * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text(
                              "Gender",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          ListTile(
                            title: const Text("Male"),
                            leading: Radio(
                                value: "Male",
                                groupValue: genderController,
                                onChanged: (value) => setState(() {
                                      genderController = value.toString();
                                    })),
                          ),
                          ListTile(
                            title: const Text("Female"),
                            leading: Radio(
                                value: "Female",
                                groupValue: genderController,
                                onChanged: (value) => setState(() {
                                      genderController = value.toString();
                                    })),
                          ),
                        ],
                      )),
                  Container(
                      width: size.width * 1,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var contactToAdd = Contact(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                name: nameController.value.text,
                                lastName: lastNameController.value.text,
                                phoneNumber: phoneController.value.text,
                                gender: genderController,
                              );
                              if (widget.contact != null) {
                                Provider.of<ContactProvider>(
                                  context,
                                  listen: false,
                                ).updateContact(
                                    widget.contact!.id, contactToAdd);
                              } else {
                                Provider.of<ContactProvider>(
                                  context,
                                  listen: false,
                                ).addContact(contactToAdd);
                              }
                              Navigator.pop(context);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text("SAVE"),
                          )))
                ],
              ),
            )),
      ),
    );
  }
}
