import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:schedule_generator/service/services.dart';
import 'package:schedule_generator/ui/list_schedule.dart';
import 'list_schedule.dart';

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDuration = TextEditingController();
  String _selectedPriority = 'High';
  DateTime? _fromDate;
  DateTime? _untilDate;
  String _result = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    dotenv.load();
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _untilDate = picked;
        }
      });
    }
  }

  Future<void> _generateSchedule() async {
    setState(() => _isLoading = true);

    final String fromDate = _fromDate != null
        ? DateFormat('yyyy-MM-dd').format(_fromDate!)
        : "Pilih tanggal";
    final String untilDate = _untilDate != null
        ? DateFormat('yyyy-MM-dd').format(_untilDate!)
        : "Pilih tanggal";

    final String result = await GeminiServices.generateSchedule(
      _controllerName.text,
      _controllerDuration.text,
      _selectedPriority,
      fromDate,
      untilDate,
    );

    setState(() {
      _result = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Generator"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField("Schedule Name", _controllerName, Icons.text_fields),
            const SizedBox(height: 12),
            _buildDropdown(),
            const SizedBox(height: 12),
            _buildTextField("Duration", _controllerDuration, Icons.timer, isNumber: true),
            const SizedBox(height: 12),
            _buildDatePicker("From Date", _fromDate, () => _selectDate(context, true)),
            const SizedBox(height: 12),
            _buildDatePicker("Until Date", _untilDate, () => _selectDate(context, false)),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _generateSchedule,
              child: const Text("Generate"),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ListSchedule()),
          );
        },
        child: const Icon(Icons.list),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPriority,
      items: ["High", "Medium", "Low"]
          .map((element) => DropdownMenuItem(
        value: element,
        child: Text(element),
      ))
          .toList(),
      onChanged: (String? value) {
        if (value != null) {
          setState(() => _selectedPriority = value);
        }
      },
      decoration: const InputDecoration(
        labelText: "Priority",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 24),
          const SizedBox(width: 12),
          Text(
            date == null
                ? '$label pilih tanggal'
                : "$label ${DateFormat('yyyy-MM-dd').format(date)}",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
