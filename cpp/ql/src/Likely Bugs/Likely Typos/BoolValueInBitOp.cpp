if (!flags & SOME_BIT) { //wrong: '!' has higher precedence than '&', so this
                         // is bracketed as '(!flags) & SOME_BIT', and does not
                         // check whether a particular bit is set.
    // ...
}

if ((p != NULL) & p->f()) { //wrong: The use of '&' rather than '&&' will still
                            // de-reference the pointer even if it is NULL.
    // ...
}

int bits = (s > 8) & 0xff; //wrong: Invalid attempt to get the 8 most significant
                           // bits of a short.
