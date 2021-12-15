int f(void){
	int i = 0;
	char arr[20];
	int size = sizeof(arr[i++]); //wrong: sizeof expression has side effect
	cout << i; //would output 0 instead of 1
}
