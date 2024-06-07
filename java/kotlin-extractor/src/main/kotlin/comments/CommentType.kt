package com.github.codeql.comments

enum class CommentType(val value: Int) {
    SingleLine(1),
    Block(2),
    Doc(3)
}
