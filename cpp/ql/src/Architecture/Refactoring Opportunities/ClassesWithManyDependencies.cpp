// an include declaration just adds one source dependency, it does not automatically
// add a dependency from this file to all the declarations in stdio.h
#include <stdio.h>
#include <myfile.h> // contains non-static global myfile_err

extern int myfile_err; // this external declaration adds a dependency on myfile.h

class C {
public:
	C() {
		// one dependency for printf:
		printf("Hello world!");
		// one dependency for FILE type, and one for NULL macro:
		FILE fp = NULL;
	}
};

