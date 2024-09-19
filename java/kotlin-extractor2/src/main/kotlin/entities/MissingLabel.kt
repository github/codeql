package com.github.codeql.entities

import com.github.codeql.AnyDbType
import com.github.codeql.Label

class MissingLabel<T : AnyDbType> : Label<T> {
    override fun toString(): String {
        return "#MISSING_LABEL"
    }
}