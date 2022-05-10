import 'package:flutter/material.dart';
import 'package:my_contacts/pages/add_contact_bottom_modal.dart';
import 'package:my_contacts/providers/contacts_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _showAddContactModal(context, contact) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        // backgroundColor: const Color.fromARGB(255, 41, 41, 41),
        elevation: 10,
        // barrierColor: Color.fromARGB(150, 194, 0, 255),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        builder: (BuildContext _) {
          return AddContactBottomModal(
            contact: contact,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var contact_provider = Provider.of<ContactProvider>(
      context,
      listen: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Contacts!"),
      ),
      body: Container(
        child: contact_provider.contacts.isEmpty
            ? const Center(
                child: Text("There is no data to show here."),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  var contact = contact_provider.contacts[index];
                  return Dismissible(
                    key: Key(contact.id),
                    secondaryBackground: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerRight,
                      color: Colors.redAccent,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      color: Colors.amberAccent,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("My Contacts"),
                                content: const Text(
                                    "Are you sure you want to remove this contact?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        contact_provider
                                            .deleteContact(contact.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("YES")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("NO")),
                                ],
                              );
                            });
                      } else {
                        _showAddContactModal(context, contact);
                        return false;
                      }
                    },
                    child: ListTile(
                      title: Text("${contact.name} ${contact.lastName}"),
                      subtitle: Text(contact.phoneNumber),
                      trailing: Text(contact.gender),
                    ),
                  );
                },
                itemCount: contact_provider.contacts.length,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactModal(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
