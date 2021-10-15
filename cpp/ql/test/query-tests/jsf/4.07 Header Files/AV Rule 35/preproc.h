// header notices etc
// GOOD: this does not require a header guard. [FALSE POSITIVE]

#ifdef NOTDEFINED
#error An error.
#endif

#ifndef PREPROC_H
#define PREPROC_H

struct MyPreprocHStruct
{
	int a, b, c, d, e;
};

#endif // PREPROC_H
