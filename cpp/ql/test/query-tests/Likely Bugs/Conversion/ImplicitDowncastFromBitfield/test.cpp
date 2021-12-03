typedef struct {
	int x : 24;
} my_struct;

int getX1(my_struct m) {
	return m.x; // GOOD
}

short getX2(my_struct m) {
	return m.x; // BAD
}

short getX3(my_struct m) {
	return (short) m.x; // GOOD
}

bool getX4(my_struct m) {
	return m.x; // GOOD
}

short getX5(my_struct m) {
	return (char) m.x; // GOOD
}

const char& getx6(my_struct& m) {
	const char& result = m.x; // BAD
	return result;
}

const short& getx7(my_struct& m) {
	const short& result = (short) m.x; // GOOD
	return result;
}

const int& getx8(my_struct& m) {
	const int& result = m.x; // GOOD
	return result;
}

const bool& getx9(my_struct& m) {
	const bool& result = m.x; // GOOD
	return result;
}
