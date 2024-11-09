package com.example.mygymapplication.model

import java.time.LocalDate
import java.time.LocalTime

data class Gym (
    val id:String,
    var className:String,
    var trainerName:String,
    var description:String,
    var startTime:String,
    var endTime:String,
    var availableSpots:Int
)