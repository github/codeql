typedef struct {
	int x : 24;
} my_struct;

int getX1(my_struct m) {
	return m.x;
}

short getX2(my_struct m) {
	return m.x;
}

short getX3(my_struct m) {
	return (short) m.x;
}

bool getX4(my_struct m) {
	return m.x;
}

short getX5(my_struct m) {
	return (char) m.x;
}
