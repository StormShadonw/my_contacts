import 'package:flutter/cupertino.dart';
import 'package:my_contacts/models/contact.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }

  void deleteContact(String id) {
    _contacts.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void updateContact(String id, Contact contact) {
    var index = _contacts.indexWhere((element) {
      return element.id == id;
    });
    print("Index ${index}");
    _contacts[index].name = contact.name;
    _contacts[index].lastName = contact.lastName;
    _contacts[index].phoneNumber = contact.phoneNumber;
    _contacts[index].gender = contact.gender;
    notifyListeners();
  }
}
