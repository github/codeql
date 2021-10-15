package successors;

public class TestLoopBranch {
	int xx = 12;
	int yy = 13;
	
	public void f()
	{
		int x = 1;
		int y = 2;
		System.out.println("foo");
		
		do
		{
			System.out.println("bar");
			System.out.println("foobar");
		} while (x == 2);
		
		{
			System.out.println("shazam");
			System.out.println("boogie");
		}
		
		while (x == 1)
		{
			System.out.println("wonderland");
			System.out.println("shodan");
			x = x + 1;
		}
		
		for (int i = 0; i < 10; i++)
		{
			System.out.println("rapture");
			y = x - 2;
		}
		
		;
		;
		
		for (int j : new int[20])
		{
			System.out.println("Zero : " + j);
			j = j + x;
		}
		
		if (y == -1)
		{
			System.out.println("i squared");
		}
		
		if (x == 42)
		{
			System.out.println("rat");
			x = 6 * 9;
		} else
		{
			System.out.println("arr");
			x = y * x;
			return;
		}
		
		switch (x)
		{
		case 1:
			x = x + 1;
			y = y + 1;
		case 2:
			x = x + 2;
			y = y + 2;
			break;
		case 3:
		case 4:
			x = x + 3;
			y = y + 4;
			break;
		case 5:
		case 6:
			x = x + 5;
			y = y + 6;
		default:
			x = y;
			y = x;
		}
		
		//no default
		switch(x)
		{
		case 1:
			x = 1;
			break;
		case 2:
			x = 2;
			break;
		}
		
		Comparable<String> b = new Comparable<String>() {
			@Override
			public int compareTo(String o)
			{
				return 0;
			}
		};
		b.compareTo("Foo");
		
		x = x + y;
		return;
	}
	
	public TestLoopBranch()
	{
		xx = 33;
		yy = 44;
	}
	
	public TestLoopBranch(int i)
	{
		xx = i;
		yy = i;
	}
}