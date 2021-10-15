package unreachableblocks;

public class Unreachable {
	private boolean privateFalse = false;
	public void method() {
		if (false) {
			// unreachable
		}
		if (privateFalse) {
			// unreachable
		}
		if (methodFalse()) {
			// unreachable
		}

		switch (7) {
		case 5: // unreachable
			break;
		case 6: // unreachable
			System.out.println("dead"); // unreachable
		case 7:
		case 8: // reachable from 7
			break; // reachable
		case 9: //unreachable
			break;
		case 10: // unreachable
		default:
			break; //unreachable
		}
	}

	private boolean methodFalse() {
		return privateFalse;
	}
}