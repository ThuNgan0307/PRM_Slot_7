import 'package:flutter/material.dart';
import '../models/plan.dart';
import '../widgets/primary_button.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _titleController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      helpText: 'Select a plan Date',
    );
    if (pickedDate == null) return;
    setState(() {
      _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    });
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Select a plan Time',
    );
    if (pickedTime == null) return;
    setState(() {
      _selectedTime = pickedTime;
    });
  }

  String _dateLabel() {
    if (_selectedDate == null) return 'Choose a Date';
    final d = _selectedDate!;
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }


  String _timeLabel() {
    if (_selectedTime == null) return 'Choose a Time';
    final t = _selectedTime!;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _save(){
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a Date')),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a Time')),
      );
      return;
    }

  final plan = Plan(
    title: title,
    date: _selectedDate!,
    time: _selectedTime!,
  );

  Navigator.pop(context, plan);
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Create Plan'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Plan Title',
              hintText: 'e.g. Study Flutter',
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _pickDate,
                  child: Text(_dateLabel()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: _pickTime,
                  child: Text(_timeLabel()),
                ),
              ),
            ],
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Save Plan',
            onPressed: _save,
          ),
        ],
      ),
    ),
  );
}
}