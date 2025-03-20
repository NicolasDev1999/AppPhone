import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  

  void _deleteDigit() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _controller.text =
            _controller.text.substring(0, _controller.text.length - 1);
      }
    });
  }

  void _addDigit(String digit) {
    setState(() {
      _controller.text += digit;
    });
    _checkSpecialCode();
  }

  void _openContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactsScreen()),
    );
  }

void _checkSpecialCode() {
  if (_controller.text == "*#06#") {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Información del Dispositivo'),
        content: Container(
          width: double.maxFinite, // Asegura que el contenido se expanda correctamente
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Desarrollado por [Tu Nombre]',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Image.asset('assets/developer.png'),
                SizedBox(height: 20),
                Text(
                  'Más información sobre el proyecto:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Image.asset('assets/developer.png'),
                SizedBox(height: 20),
                Text(
                  'Detalles adicionales del desarrollador...',
                  style: TextStyle(fontSize: 16),
                ),
                Image.asset('assets/developer.png'),
                SizedBox(height: 20),
                Text(
                  'Gracias por usar esta aplicación.',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Marcador Telefónico', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.none,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Número de teléfono',
                hintStyle: TextStyle(color: Colors.white38),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.4,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
             List<Map<String, String>> buttons = [
              {'number': '1', 'letters': ''},
              {'number': '2', 'letters': 'ABC'},
              {'number': '3', 'letters': 'DEF'},
              {'number': '4', 'letters': 'GHI'},
              {'number': '5', 'letters': 'JKL'},
              {'number': '6', 'letters': 'MNO'},
              {'number': '7', 'letters': 'PQRS'},
              {'number': '8', 'letters': 'TUV'},
              {'number': '9', 'letters': 'WXYZ'},
              {'number': '*', 'letters': ''},
              {'number': '0', 'letters': '+'},
              {'number': '#', 'letters': ''},
            ];

            return GestureDetector(
              onTap: () => _addDigit(buttons[index]['number']!),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white54, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttons[index]['number']!,
                      style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    if (buttons[index]['letters']!.isNotEmpty)
                      Text(
                        buttons[index]['letters']!,
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                  ],
                ),
              ),
            );
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.backspace, color: Colors.white, size: 32),
                onPressed: _deleteDigit,
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: _makeCall,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.call, color: Colors.white, size: 32),
                ),
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.contacts, color: Colors.white, size: 32),
                onPressed: _openContacts,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
