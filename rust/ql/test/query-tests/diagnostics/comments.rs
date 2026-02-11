/**
 * total lines in this file: 61
 * of which code: 16
 * of which only comments: 33
 * of which blank: 12
 */

// a comment

/**
 * Comment attached to a struct.
 */
struct StructWithComments
{
    /**
     * Another attached comment.
     */
    a: i32,

    // And another attached comment.
    b: i32,

    /*
     * And yet another attached comment.
     */
    c: i32,

    // informal
    // comment
    // block.
    cd: i32,

    // Just a comment.
}

pub fn my_simple_func()
{
}

/**
 * Comment attached to a function.
 */
pub fn my_func_with_comments()
{
    // comment
    let a = 1; // comment
    // comment
    let b = 2;

    // comment

    /*
     * Comment.
     */
    my_simple_func();
}

/*
 * Comment.
 */
