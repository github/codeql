package successors;

public class TestTryCatch {
	public void f()
	{
		try
		{
			System.out.println("Foo");
			int y = 12 + 3;
			System.out.println("Bar");
			y = y + 1;
		} catch (Exception e)
		{
			int x = 1;
			System.out.println("Error: " + e);
			x = x + 1;
			return;
		} finally
		{
			int y = 12;
			System.out.println("Finally");
			y = y + 1;
		}
		int z = 12;
		z = z + 1;
		
		for (int q = 0; q < 10; q++)
		{
			try
			{
				System.out.println("Foo");
				int y = 12 + 3;
				System.out.println("Bar");
				y = y + 1;
			} catch (RuntimeException e)
			{
				int x = 1;
				System.out.println("Error: " + e);
				x = x + 1;
			}
		}
		z = z + 2;
	}
}
