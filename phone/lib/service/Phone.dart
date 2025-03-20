import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // Asegura importar esto
import 'package:url_launcher/url_launcher.dart';
import 'package:phone/service/contacts_screen.dart';

class Phone extends StatefulWidget {
  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _makeCall() async {
    String phoneNumber = _controller.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingresa un número de teléfono')),
      );
      return;
    }

    if (!phoneNumber.startsWith('+57') && phoneNumber.length == 10) {
      phoneNumber = '+57$phoneNumber';
    }

    try {
      const platform = MethodChannel('com.example.call_phone');
      await platform.invokeMethod('callPhone', {'number': phoneNumber});
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  void _addDigit(String digit) {
    setState(() {
      _controller.text += digit;
    });
    _checkSpecialCode();
  }

  void _deleteDigit() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _controller.text =
            _controller.text.substring(0, _controller.text.length - 1);
      }
    });
  }

  void _checkSpecialCode() {
    if (_controller.text == "*#06#") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Información del Desarrollador'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/developer.png'),
              SizedBox(height: 20),
              Text(
                'Desarrollado por [Tu Nombre]',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  void _openContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Marcador Telefónico')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.none,
              textAlign: TextAlign.center,
              decoration: InputDecoration(labelText: 'Número de teléfono'),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.0,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              List<String> buttons = [
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '*',
                '0',
                '#'
              ];
              return ElevatedButton(
                onPressed: () => _addDigit(buttons[index]),
                child: Text(buttons[index], style: TextStyle(fontSize: 24)),
              );
            },
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _deleteDigit,
                child: Icon(Icons.backspace),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _makeCall,
                child: Text('Llamar'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _openContacts,
                child: Text('Contactos'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
