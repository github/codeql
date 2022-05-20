
void myFirstFunction();

void mySecondFunction()
{
}

void myThirdFunction()
{
	myFirstFunction();
	mySecondFunction();
	myThirdFunction();
	myFourthFunction(); // implicit FDE
	myFifthFunction(); // implicit FDE
}

void myFourthFunction();
