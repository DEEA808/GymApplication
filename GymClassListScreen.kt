package com.example.mygymapplication.ui.theme

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import com.example.mygymapplication.ui.theme.MyGymApplicationTheme
import com.example.mygymapplication.model.Gym
import com.example.mygymapplication.viewmodel.GymViewModel
import java.time.LocalDate
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import java.time.LocalDateTime
import java.time.LocalTime
import java.util.UUID


@Composable
fun GymClassListScreen(
    gymViewModel: GymViewModel = viewModel(), onAddClass: () -> Unit,
    onUpdateClass: (Gym) -> Unit
) {


    val gymClasses by gymViewModel.gymClasses.observeAsState(emptyList())

    Column(modifier = Modifier.fillMaxSize()) {
        Text(
            text = "Gym Classes",
            style = MaterialTheme.typography.headlineMedium,
            modifier = Modifier.padding(16.dp)
        )


        LazyColumn(modifier = Modifier.weight(1f)) {
            items(gymClasses) { gymClass ->
                GymClassItem(
                    gymClass = gymClass,
                    onDelete = { gymViewModel.deleteGymClass(gymClass) },
                    onUpdate = { onUpdateClass(gymClass) }
                )
            }
        }


        Button(
            onClick = onAddClass,
            modifier = Modifier.padding(16.dp)
        ) {
            Text("Add Gym Class")
        }

    }
}

@Composable
fun AddGymClassScreen(
    onAddClass: (Gym) -> Unit,
    onCancel: () -> Unit
) {
    var className by remember { mutableStateOf("") }
    var trainerName by remember { mutableStateOf("") }
    var description by remember { mutableStateOf("") }
    var startTime by remember { mutableStateOf("") }
    var endTime by remember { mutableStateOf("") }
    var availableSpots by remember { mutableStateOf("") }

    Column(modifier = Modifier.padding(16.dp)) {
        Text(text = "Add New Gym Class", style = MaterialTheme.typography.headlineSmall)

        Spacer(modifier = Modifier.height(8.dp))


        OutlinedTextField(
            value = className,
            onValueChange = { className = it },
            label = { Text("Class Name") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = trainerName,
            onValueChange = { trainerName = it },
            label = { Text("Trainer Name") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = description,
            onValueChange = { description = it },
            label = { Text("Description") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = startTime,
            onValueChange = { startTime = it },
            label = { Text("Start Time") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = endTime,
            onValueChange = { endTime = it },
            label = { Text("End Time") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = availableSpots,
            onValueChange = { availableSpots = it },
            label = { Text("Available Spots") }
        )

        Spacer(modifier = Modifier.height(16.dp))


        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(
                onClick = {
                    val newClass = Gym(
                        id = UUID.randomUUID().toString(),  // Unique ID for the new class
                        className = className,
                        trainerName = trainerName,
                        description = description,
                        startTime = startTime,
                        endTime = endTime,
                        availableSpots = availableSpots.toIntOrNull() ?: 0
                    )
                    onAddClass(newClass)
                }
            ) {
                Text("Add Class")
            }

            Button(onClick = onCancel) {
                Text("Cancel")
            }
        }
    }
}

@Composable
fun UpdateGymScreen(
    gymClass: Gym,
    onUpdateClass: (Gym) -> Unit,
    onCancel: () -> Unit
) {


    var className by remember { mutableStateOf(gymClass.className) }
    var trainerName by remember { mutableStateOf(gymClass.trainerName) }
    var description by remember { mutableStateOf(gymClass.description) }
    var startTime by remember { mutableStateOf(gymClass.startTime) }
    var endTime by remember { mutableStateOf(gymClass.endTime) }
    var availableSpots by remember { mutableStateOf(gymClass.availableSpots.toString()) }

    Column(modifier = Modifier.padding(16.dp)) {
        Text(text = "Update Gym Class", style = MaterialTheme.typography.headlineSmall)

        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = className,
            onValueChange = { className = it },
            label = { Text("Class Name") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = trainerName,
            onValueChange = { trainerName = it },
            label = { Text("Trainer Name") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = description,
            onValueChange = { description = it },
            label = { Text("Description") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = startTime,
            onValueChange = { startTime = it },
            label = { Text("Start Time") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = endTime,
            onValueChange = { endTime = it },
            label = { Text("End Time") }
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = availableSpots,
            onValueChange = { availableSpots = it },
            label = { Text("Available Spots") }
        )

        Spacer(modifier = Modifier.height(16.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(
                onClick = {
                    val updatedClass = gymClass.copy(
                        className = className,
                        trainerName = trainerName,
                        description = description,
                        startTime = startTime,
                        endTime = endTime,
                        availableSpots = availableSpots.toIntOrNull() ?: 0
                    )
                    onUpdateClass(updatedClass)

                }
            ) {
                Text("Update Class")
            }

            Button(onClick = onCancel) {
                Text("Cancel")
            }
        }
    }
}


@Composable
fun GymClassItem(gymClass: Gym, onDelete: () -> Unit, onUpdate: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        Text("Class: ${gymClass.className}")
        Text("Instructor: ${gymClass.trainerName}")
        Text("Description: ${gymClass.description}")
        Text("Start Date: ${gymClass.startTime}")
        Text("End Date: ${gymClass.endTime}")
        Text("Available Spots: ${gymClass.availableSpots}")

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            // Update Button
            Button(onClick = onUpdate) {
                Text("Update")
            }
            // Delete Button
            Button(onClick = onDelete) {
                Text("Delete")
            }
        }
    }
}