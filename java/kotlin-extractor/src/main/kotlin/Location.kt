package com.github.codeql

import org.jetbrains.kotlin.ir.IrElement

data class Location(val startOffset: Int, val endOffset: Int){
    fun contains(location: Location) : Boolean {
        return this.startOffset <= location.startOffset &&
                this.endOffset >= location.endOffset
    }
}

fun IrElement.getLocation() : Location {
    return Location(this.startOffset, this.endOffset)
}