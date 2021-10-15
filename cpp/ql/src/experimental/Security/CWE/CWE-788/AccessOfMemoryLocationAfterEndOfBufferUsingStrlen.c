// BAD: if buffer does not have a terminal zero, then access outside the allocated memory is possible.

buffer[strlen(buffer)] = 0;


// GOOD: we will eliminate dangerous behavior if we use a different method of calculating the length. 
size_t len;
...
buffer[len] = 0
