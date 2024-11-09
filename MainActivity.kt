package com.example.mygymapplication

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.mygymapplication.model.Gym
import com.example.mygymapplication.ui.theme.AddGymClassScreen
import com.example.mygymapplication.ui.theme.GymClassListScreen
import com.example.mygymapplication.ui.theme.MyGymApplicationTheme
import com.example.mygymapplication.ui.theme.UpdateGymScreen
import com.example.mygymapplication.viewmodel.GymViewModel

class MainActivity : ComponentActivity() {
    private val gymViewModel: GymViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MyGymApplicationTheme {
                val navController = rememberNavController()
                var selectedGymClass by remember { mutableStateOf<Gym?>(null) }

                NavHost(navController, startDestination = "gymClassList") {
                    composable("gymClassList") {
                        GymClassListScreen(
                            gymViewModel = gymViewModel,
                            onAddClass = { navController.navigate("addGymClass") },
                            onUpdateClass = { gymClass ->
                                selectedGymClass = gymClass
                                navController.navigate("updateGymClass")
                            }
                        )
                    }
                    composable("addGymClass") {
                        AddGymClassScreen(
                            onAddClass = { newClass ->
                                gymViewModel.addGymClass(newClass)
                                navController.popBackStack()
                            },
                            onCancel = { navController.navigate("gymClassList") }
                        )
                    }
                    composable("updateGymClass") {
                        selectedGymClass?.let { gymClass ->
                            UpdateGymScreen(
                                gymClass = gymClass,
                                onUpdateClass = { updatedClass ->
                                    gymViewModel.updateGymClass(updatedClass)
                                    navController.popBackStack()
                                },
                                onCancel = { navController.navigate("gymClassList") }
                            )
                        }
                    }
                }
            }
        }
    }
}





