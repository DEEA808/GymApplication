package com.example.mygymapplication.repository

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.example.mygymapplication.model.Gym

class GymClassRepository {
    private val _gymClassesLiveData = MutableLiveData<List<Gym>>(
        listOf(
            Gym(
                id = "1",
                className = "Yoga Basics",
                description = "aaa",
                trainerName = "Alice",
                startTime = "6:00",
                endTime = "7:00",
                availableSpots = 20
            ),
            Gym(
                id = "2",
                className = "HIIT Workout",
                trainerName = "Bob",
                description = "bbb",
                startTime = "4:00",
                endTime = "5:00",
                availableSpots = 15
            ),
            Gym(
                id = "3",
                className = "Pilates",
                description = "aaa",
                trainerName = "Cathy",
                startTime = "2024-11-12",
                endTime = "2024-11-12",
                availableSpots = 10
            )
        )
    )

    // Expose LiveData for read-only access
    val gymClassesLiveData: LiveData<List<Gym>> get() = _gymClassesLiveData

    // Function to add a new class
    fun addGymClass(gymClass: Gym) {
        val updatedList = _gymClassesLiveData.value?.toMutableList() ?: mutableListOf()
        updatedList.add(gymClass)
        _gymClassesLiveData.value = updatedList  // Modify internal MutableLiveData directly
    }

    // Function to delete a class
    fun deleteGymClass(gymClass: Gym) {
        val updatedList = _gymClassesLiveData.value?.toMutableList() ?: mutableListOf()
        updatedList.remove(gymClass)
        _gymClassesLiveData.value = updatedList
    }

    // Function to update an existing class
    fun updateGymClass(updatedGymClass: Gym) {
        val updatedList = _gymClassesLiveData.value?.map {
            if (it.id == updatedGymClass.id) updatedGymClass else it
        } ?: listOf()
        _gymClassesLiveData.value = updatedList
    }

}