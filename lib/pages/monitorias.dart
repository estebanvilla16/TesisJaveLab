import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegistrationAndBookingPage extends StatefulWidget {
  const RegistrationAndBookingPage({super.key});

  @override
  _RegistrationAndBookingPageState createState() => _RegistrationAndBookingPageState();
}

class _RegistrationAndBookingPageState extends State<RegistrationAndBookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  final Map<String, bool> _timeSlots = {
    "8:00 AM": true,
    "9:00 AM": false,
    "10:00 AM": true,
    "11:00 AM": true,
    "12:00 PM": false,
    "1:00 PM": true,
    "2:00 PM": true,
    "3:00 PM": true,
    "4:00 PM": false,
    "5:00 PM": true,
  };
  String? _selectedTime;
  final List<Monitor> _monitors = [
    Monitor(name: "Juan Pérez", email: "juan.perez@example.com", expertiseSubjects: ["Programación I", "Cálculo Diferencial"]),
    Monitor(name: "Ana Gómez", email: "ana.gomez@example.com", expertiseSubjects: ["Física Mecánica"]),
  ];
  Monitor? _selectedMonitor;

  final Map<String, bool> _validationErrors = {
    "name": false,
    "email": false,
    "details": false,
    "time": false
  };

  bool get _isEmailValid => _emailController.text.endsWith('@javeriana.edu.co');
  bool get _isBookingComplete =>
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _detailsController.text.isNotEmpty &&
      _isEmailValid &&
      _selectedDay != null &&
      _selectedTime != null &&
      _selectedMonitor != null &&
      (_timeSlots[_selectedTime] ?? false);

  void _attemptBooking() {
    setState(() {
      _validationErrors["email"] = !_isEmailValid;
      if (_isBookingComplete) {
        Fluttertoast.showToast(
          msg: "Monitoría reservada con éxito! Enviando correo a: ${_emailController.text}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
        // Simulate sending email
      } else {
        Fluttertoast.showToast(
          msg: "Por favor completa todos los campos requeridos y asegúrate de que el correo sea válido (@javeriana.edu.co).",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.blue,
        titleTextStyle:const TextStyle (color:Colors.white, fontSize: 30,),
        title: const Text("Monitorías"),
        actions: const <Widget>[
        
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                suffixText: '*',
                suffixStyle: TextStyle(color: Colors.red),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                suffixText: '*',
                suffixStyle: TextStyle(color: Colors.red),
              ),
            ),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(
                labelText: 'Detalles sobre problemas o dificultades',
                suffixText: '*',
                suffixStyle: TextStyle(color: Colors.red),
              ),
              maxLines: 3,
            ),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _selectedTime = null;
                  _selectedMonitor = null;
                });
              },
            ),
            Wrap(
              children: _timeSlots.entries.map((entry) => ChoiceChip(
                label: Text(entry.key),
                selected: _selectedTime == entry.key,
                selectedColor: entry.value ? Colors.green : Colors.red,
                onSelected: entry.value ? (selected) {
                  setState(() {
                    _selectedTime = entry.key;
                  });
                } : null,
              )).toList(),
            ),
            if (_selectedTime != null && (_timeSlots[_selectedTime] ?? false)) DropdownButton<Monitor>(
              value: _selectedMonitor,
              hint: const Text('Seleccione un monitor'),
              onChanged: (Monitor? newValue) {
                setState(() {
                  _selectedMonitor = newValue;
                });
              },
              items: _monitors.map<DropdownMenuItem<Monitor>>((Monitor monitor) {
                return DropdownMenuItem<Monitor>(
                  value: monitor,
                  child: Text("${monitor.name} - ${monitor.expertiseSubjects.join(', ')}"),
                );
              }).toList(),
            ),
            if (_selectedMonitor != null) Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Monitor Seleccionado:\n'
                'Nombre: ${_selectedMonitor!.name}\n'
                'Correo: ${_selectedMonitor!.email}\n'
                'Materias Experto: ${_selectedMonitor!.expertiseSubjects.join(", ")}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: _isBookingComplete ? _attemptBooking : null,
              child: const Text('Agendar Monitoría'),
            ),
          ],
        ),
      ),
    );
  }
}

class Monitor {
  final String name;
  final String email;
  final List<String> expertiseSubjects;

  Monitor({
    required this.name,
    required this.email,
    required this.expertiseSubjects,
  });
}

bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}