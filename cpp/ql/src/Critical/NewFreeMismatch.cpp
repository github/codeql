Record *ptr = new Record(...);

...

free(ptr); // BAD: ptr was created using 'new', but is being freed using 'free'
