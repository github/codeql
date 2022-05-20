public class Container
{
	private int[] values; // Field called 'values'
	
	public Container (int... values) {
		this.values = values;
	}

	public Container dup() {
		int length = values.length;
		int[] values = new int[length];  // Local variable called 'values'
		Container result = new Container(values);
		return result;
	}
}
