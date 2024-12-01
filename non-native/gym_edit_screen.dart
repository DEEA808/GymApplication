import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'gym.dart';
import 'gym_view_model.dart';

class GymEditScreen extends StatefulWidget {
  final Gym? gym;

  GymEditScreen({this.gym});

  @override
  _GymEditScreenState createState() => _GymEditScreenState();
}

class _GymEditScreenState extends State<GymEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _className;
  late String _trainerName;
  late String _description;
  late String _startTime;
  late String _endTime;
  late int _availableSpots;

  @override
  void initState() {
    super.initState();
    _className = widget.gym?.className ?? '';
    _trainerName = widget.gym?.trainerName ?? '';
    _description = widget.gym?.description ?? '';
    _startTime = widget.gym?.startTime ?? '';
    _endTime = widget.gym?.endTime ?? '';
    _availableSpots = widget.gym?.availableSpots ?? 0;
  }

  void _saveGym(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final gymViewModel = Provider.of<GymViewModel>(context, listen: false);

      if (widget.gym == null) {
        // Add new gym
        final newGym = Gym(
          id: const Uuid().v4(),
          //here
          className: _className,
          trainerName: _trainerName,
          description: _description,
          startTime: _startTime,
          endTime: _endTime,
          availableSpots: _availableSpots,
        );
        gymViewModel.addGym(newGym);
      } else {
        // Update existing gym
        final updatedGym = Gym(
          id: widget.gym!.id,
          className: _className,
          trainerName: _trainerName,
          description: _description,
          startTime: _startTime,
          endTime: _endTime,
          availableSpots: _availableSpots,
        );
        gymViewModel.updateGym(widget.gym!.id, updatedGym);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gym == null ? 'Add Gym' : 'Edit Gym'),
        titleTextStyle: TextStyle(
          color: Colors.purple.shade100, // Set the title color
          fontSize: 25, // Optional: Set the font size
          fontWeight: FontWeight.bold, // Optional: Set font weight
        ),
      ),
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
            TextFormField(
            initialValue: _className,
            decoration: InputDecoration(labelText: 'Class Name'),
            validator: (value) =>
            value!.isEmpty ? 'Class Name is required' : null,
            onSaved: (value) => _className = value!,
          ),
          TextFormField(
            initialValue: _trainerName,
            decoration: InputDecoration(labelText: 'Trainer Name'),
            validator: (value) =>
            value!.isEmpty ? 'Trainer Name is required' : null,
            onSaved: (value) => _trainerName = value!,
          ),
          TextFormField(
            initialValue: _description,
            decoration: InputDecoration(labelText: 'Description'),
            validator: (value) =>
            value!.isEmpty ? 'Description is required' : null,
            onSaved: (value) => _description = value!,
          ),
          TextFormField(
            initialValue: _startTime,
            decoration: InputDecoration(labelText: 'Start time'),
            validator: (value) =>
            value!.isEmpty ? 'Start time' : null,
            onSaved: (value) => _startTime = value!,
          ),
          TextFormField(
            initialValue: _endTime,
            decoration: InputDecoration(labelText: 'End time'),
            validator: (value) =>
            value!.isEmpty ? 'End time' : null,
            onSaved: (value) => _endTime = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Available Spots'),
            keyboardType: TextInputType.number, // Makes the keyboard numeric
            onSaved: (value) {
              _availableSpots = int.tryParse(value!) ??
                  0; // Parses to int, defaults to 0 if parsing fails
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a number';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () => _saveGym(context),
            child: Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade100,
              // Background color
              foregroundColor: Colors.white,
              // Text color for the button
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              // Optional: Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    8), // Optional: Rounded corners
              ),
            ),
          ),
          ],
        ),
      ),
    ),
    );
  }
}
