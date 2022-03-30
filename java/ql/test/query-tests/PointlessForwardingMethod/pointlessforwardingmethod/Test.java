package pointlessforwardingmethod;

public class Test {
	// A method that is only called by a forwarder
	int addOne(int x, int one) {
		return x + one;
	}

	int addOne(byte x) {
		return addOne(x, 1);
	}

	// A method that is called by a forwarder and also used
	// in a separate way
	int addTwo(int x, int two) {
		return x + two;
	}

	int addTwo(byte x) {
		return addTwo(x, 2);
	}

	int addOneTwice(int x) {
		return addTwo(x, 2);
	}
}
