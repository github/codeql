package testProject

import kotlinx.serialization.*
import kotlinx.serialization.json.*
import kotlinx.serialization.Serializable

@Serializable
data class Project(val name: String, val language: Int)

interface Base {
    val id: String
}

@Serializable
class X private constructor() : Base {
    override val id: String = "X"
}
