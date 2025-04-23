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
    if (_controller.text == "*#06#*") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Información del Dispositivo',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinea a la izquierda
              children: [
                Text(
                  'IMEI (ranura de SIM 1)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '866400054690883/00',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Image.asset('lib/assets/IMEI1.jpeg'),
                SizedBox(height: 20),
                Text(
                  'IMEI (ranura de SIM 2)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '866400055668573/00',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Image.asset('lib/assets/IMEI2.jpeg'),
                SizedBox(height: 20),
                Text(
                  'ICCID (ranura de SIM 2)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '89571017024080819910',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Image.asset('lib/assets/ICCID.jpeg'),
                SizedBox(height: 20),
                Text(
                  'Número de serie',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  '27285/60XA04157',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Image.asset('lib/assets/No_serie.jpeg'),
                SizedBox(height: 20),
              ],
            ),
          ),
          backgroundColor: Color(0xFF2B2B2B),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: Text('', style: TextStyle(color: Colors.black)),
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
              style: TextStyle(fontSize: 32, color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Número de teléfono',
                hintStyle: TextStyle(color: Colors.black54),
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

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  splashColor: Colors.blueAccent.withOpacity(0.3),
                  onTap: () => _addDigit(buttons[index]['number']!),
                  child: Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFFA9B8C7).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttons[index]['number']!,
                          style: TextStyle(fontSize: 28, color: Colors.black54, fontWeight: FontWeight.bold),
                        ),
                        if (buttons[index]['letters']!.isNotEmpty)
                          Text(
                            buttons[index]['letters']!,
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                      ],
                    ),
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
                icon: Icon(Icons.backspace, color: Colors.black54, size: 32),
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
                icon: Icon(Icons.contacts, color: Colors.black54, size: 32),
                onPressed: _openContacts,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
