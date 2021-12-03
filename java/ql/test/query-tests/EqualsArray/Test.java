public class Test {
	private final int[] numbers = { 1, 2, 3 };

	// NOT OK
	public boolean areTheseMyNumbers(int[] numbers) {
		return this.numbers.equals(numbers);
	}

	// OK
	public boolean honestAreTheseMyNumbers(int[] numbers) {
		return this.numbers == numbers;
	}

	// NOT OK, but shouldn't be flagged by this query
	public boolean incomparable(String s) {
		return numbers.equals(s);
	}

	{
		numbers.hashCode();
	}
}