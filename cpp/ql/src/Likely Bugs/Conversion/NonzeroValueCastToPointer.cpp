void* p = (void*) 42; //Wrong: non-zero constant assigned to pointer. Is unportable 
                      //and will likely lead to a segfault.

void* p2 = NULL; //Correct: NULL (which is 0) assigned to a pointer
