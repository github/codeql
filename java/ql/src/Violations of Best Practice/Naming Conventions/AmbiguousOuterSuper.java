public class Outer
{
	void printMessage() {
		System.out.println("Outer");
	}
	
	class Inner extends Super
	{
		void ambiguous() {
			printMessage();  // Ambiguous call
		}
	}
	
	public static void main(String[] args) {
		new Outer().new Inner().ambiguous();
	}
}

class Super
{
	void printMessage() {
		System.out.println("Super");
	}
}
