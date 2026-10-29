package successors;

public class LoopVarReadTest {
	public static void testLoop()
	{
		int x = 2;
		for (int y = 0; y < 10; y += x)
		{
			System.out.println("Foo");
		}
		
		int q = 10;
		
		System.out.println("foo");
	}
}
