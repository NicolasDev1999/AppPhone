import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

Future<void> _getContacts() async {
  if (await FlutterContacts.requestPermission()) {
    List<Contact> _contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
    setState(() {
      contacts = _contacts;
      
    });

    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontraron contactos')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Permiso denegado')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contactos')),
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? 'Sin Nombre'),
                  subtitle: contact.phones!.isNotEmpty
                      ? Text(contact.phones!.first.number!)
                      : Text('Sin número'),
                  trailing: IconButton(
                    icon: Icon(Icons.phone),
                    onPressed: () {
                      _makeCall(contact.phones!.isNotEmpty
                          ? contact.phones!.first.number!
                          : '');
                    },
                  ),
                );
              },
            ),
    );
  }

  void _makeCall(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo realizar la llamada')),
      );
    }
  }
}
