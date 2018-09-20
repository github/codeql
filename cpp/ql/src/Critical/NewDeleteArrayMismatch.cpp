Record *ptr = new Record(...);

...

delete [] ptr; // ptr was created using 'new', but was freed using 'delete[]'
