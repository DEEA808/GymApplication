package com.example.mygymapplication.viewmodel

import androidx.compose.runtime.mutableStateListOf
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.example.mygymapplication.model.Gym
import com.example.mygymapplication.repository.GymClassRepository

class GymViewModel : ViewModel() {
    private val repository = GymClassRepository()

    val gymClasses: LiveData<List<Gym>> = repository.gymClassesLiveData


    fun addGymClass(newClass: Gym) {
        repository.addGymClass(newClass)
    }

    fun updateGymClass(gymClass: Gym) {
        repository.updateGymClass(gymClass)
    }


    fun deleteGymClass(gymClass: Gym) {
        repository.deleteGymClass(gymClass)
    }

}