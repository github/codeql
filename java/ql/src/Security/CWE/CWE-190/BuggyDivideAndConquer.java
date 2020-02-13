public static int binarySearchIterative(int[] a, int value) {
	int low = 0;
	int high = a.length - 1;
	while (low <= high) {
		// BAD: low + high may overflow before division takes place leading to an
		// ArrayIndexOutOfBoundsException
		int mid = (low + high) / 2;
		
		// GOOD: (high - low) can not overflow
		int mid = low + (high - low) / 2;
		
		// GOOD: (low + high) overflows, but when viewed as an unsigned number, the
		// value is still the correct sum.
		// Dividing an unsigned number by 2 is the same as logically right shifting by 1.
		int mid = (low + high) >>> 1;
		if (a[mid] > value)
			high = mid - 1;
		else if (a[mid] < value)
			low = mid + 1;
		else
			return mid;
	}
	return -1; // not found
}
