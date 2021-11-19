package com.github.codeql

import java.io.PrintWriter
import java.io.StringWriter

interface Label<T>

class IntLabel<T>(val name: Int): Label<T> {
    override fun toString(): String = "#$name"
}

class StringLabel<T>(val name: String): Label<T> {
    override fun toString(): String = "#$name"
}

class StarLabel<T>: Label<T> {
    override fun toString(): String = "*"
}

fun <T> fakeLabel(): Label<T> {
    if (false) {
        println("Fake label")
    } else {
        val sw = StringWriter()
        Exception().printStackTrace(PrintWriter(sw))
        println("Fake label from:\n$sw")
    }
    return IntLabel(0)
}
