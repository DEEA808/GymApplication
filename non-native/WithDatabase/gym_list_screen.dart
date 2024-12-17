import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gym_view_model.dart';
import 'gym_edit_screen.dart';

class GymListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gymViewModel = Provider.of<GymViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
        titleTextStyle: TextStyle(
          color: Colors.purple.shade100,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: gymViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : gymViewModel.errorMessage != null
          ? Center(child: Text(gymViewModel.errorMessage!))
          : ListView.builder(
        itemCount: gymViewModel.gyms.length,
        itemBuilder: (context, index) {
          final gym = gymViewModel.gyms[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                iconColor: Colors.purple.shade100,
                title: Text(gym.className),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Trainer: ${gym.trainerName}"),
                    Text("Description: ${gym.description}"),
                    Text("Start Time: ${gym.startTime}"),
                    Text("End Time: ${gym.endTime}"),
                    Text("Available Spots: ${gym.availableSpots}"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Call deleteGym from the ViewModel
                    gymViewModel.deleteGym(gym.id);
                  },
                ),
                onTap: () {
                  // Navigate to edit gym screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GymEditScreen(gym: gym),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GymEditScreen(),
            ),
          );
        },
      ),
    );
  }
}
