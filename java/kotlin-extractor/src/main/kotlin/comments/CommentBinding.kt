package com.github.codeql.comments

enum class CommentBinding { // from C#
    Parent,  // The parent element of a comment
    Best,  // The most likely element associated with a comment
    Before,  // The element before the comment
    After // The element after the comment
}