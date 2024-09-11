import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentTableScreen extends StatefulWidget {
  const StudentTableScreen({super.key});

  @override
  _StudentTableScreenState createState() => _StudentTableScreenState();
}

class _StudentTableScreenState extends State<StudentTableScreen> {
  // Datos de los estudiantes en el equipo E12
  final List<Map<String, String>> _students = [
    {'name': 'Darinel', 'phone': '9613021060', 'matricula': '221192'},
    {'name': 'Ulises', 'phone': '9651032159', 'matricula': '213691'},
    {'name': 'Merlin', 'phone': '9515271070', 'matricula': '221255'},
  ];

  void _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      print('Could not send SMS to $phoneNumber');
      throw 'Could not send SMS to $phoneNumber';
    }
  }

  // Función para abrir URLs en el navegador
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Contact List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo y título E12 en la misma fila
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/LOGOUP.png', // Ruta de la imagen
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 20),
                const Text(
                  'E12',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tabla centrada de estudiantes
            Center(
              child: _students.isNotEmpty
                  ? Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20.0,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Phone Number',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Matricula',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Send Message',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: _students.map((student) {
                            return _buildDataRow(
                              student['name']!,
                              student['phone']!,
                              student['matricula']!,
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : const Text('No hay estudiantes en este equipo.'),
            ),
            const SizedBox(height: 20),

            // Sección de enlaces de GitHub con H2 y URLs como links
            const Text(
              'ACT 1',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () =>
                  _launchURL('https://github.com/DarinelGuillen/phone_app.git'),
              child: const Text(
                'https://github.com/DarinelGuillen/phone_app',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ACT 2',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () => _launchURL(
                  'https://github.com/DarinelGuillen/phone_app/tree/ACT2'), // Ejemplo de ACT 2
              child: const Text(
                'https://github.com/DarinelGuillen/ACT2',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String name, String phoneNumber, String matricula) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(
          TextButton(
            onPressed: () => _makePhoneCall(phoneNumber),
            child: Text(
              phoneNumber,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ),
        DataCell(Text(matricula)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.sms, color: Colors.blue),
            onPressed: () => _sendSMS(phoneNumber),
          ),
        ),
      ],
    );
  }
}
