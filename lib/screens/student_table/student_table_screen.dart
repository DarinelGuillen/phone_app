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
          children: [
            // Título en lugar del Dropdown
            const Text(
              'E12',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Tabla de estudiantes que se ajusta automáticamente a su contenido
            _students.isNotEmpty
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
                              label: Text('Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Phone Number',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Matricula',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Send Message',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
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
            child: Text(phoneNumber, style: const TextStyle(color: Colors.blue)),
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
