package com.github.codeql.comments

import com.github.codeql.Location

data class Comment(val rawText: String, val startOffset: Int, val endOffset: Int, val type: CommentType){
    fun getLocation() : Location {
        return Location(this.startOffset, this.endOffset)
    }

    override fun toString(): String {
        return "Comment: $rawText [$startOffset-$endOffset]"
    }
}