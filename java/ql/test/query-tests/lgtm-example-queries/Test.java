
public class Test {

	int array() {
		int[] arr = new int[]{1,2,3};
		int i = 0;
		arr[i++] = 4; // arrayaccess.ql
		return arr[i];
	}

	void test() { // voidreturntype.ql
	}

	Object test2() {
		return null; // returnstatement.ql
	}
}
