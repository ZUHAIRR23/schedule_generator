import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final _controllerName = TextEditingController();
  final _controllerDuration = TextEditingController();
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

  Future<void> _selectDate(BuildContext context, bool isForm) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isForm) {
          _fromDate = picked;
        } else {
          _untilDate = picked;
        }
      });
    }
  }

  Future<void> generateSchedule() async {
    setState(() {
      _isLoading = true;
    });

    final DateFormat formatter = DateFormat('yyy-MM-dd');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Generator"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _textField("Schedule Name", _controllerName),
            SizedBox(height: 10),
            _dropDown(),
            SizedBox(height: 10),
            _textField("Duration", _controllerDuration, isNumber: true),
            SizedBox(height: 10),
            _datePicker(
                "From Date", _fromDate, () => _selectDate(context, true)),
            SizedBox(height: 10),
            _datePicker(
                "Until Date", _untilDate, () => _selectDate(context, false))
          ],
        ),
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  Widget _dropDown() {
    return DropdownButtonFormField<String>(
      value: _selectedPriority,
      items: ["High", "Medium", "Low"]
          .map(
            (element) => DropdownMenuItem(
              value: element,
              child: Text(element),
            ),
          )
          .toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedPriority = value!;
        });
      },
      decoration: InputDecoration(labelText: "Priority"),
    );
  }

  Widget _datePicker(String label, DateTime? date, VoidCallback onTap) {
    return ListTile(
      title: Text(
        date == null
            ? '$label pilih tanggal'
            : "$label ${DateFormat('yyyy-MM-dd').format(date)}",
      ),
      onTap: onTap,
    );
  }
}
