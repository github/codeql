typedef enum {
	CASE_VAL1,
	CASE_VAL2
} caseVals;

void f() {
	int caseVal;
	//Wrong: switch statement uses an integer
	switch(caseVal) {
	case 1:
		//...
	case 0xFF:
		//...
	default:
		//...
	}

	//Correct: switch statement uses enum. It is easier to see if a case 
	//has been left out, and that all cases are valid values
	caseVals caseVal2;
	switch (caseVal2) {
	case CASE_VAL1:
		//...
	case CASE_VAL2:
		//...
	default:
	}
}
