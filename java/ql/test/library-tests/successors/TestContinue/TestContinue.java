package successors;

public class TestContinue {
	public void f()
	{
		//loop breaks
		a:
			for (int p = 0; p < 10;)
			{
				int x = 1;
				x = x + 1;
				if (x == 1)
				{
					continue;
				} else
				{
					for (int q : new int[20])
					{
						if (q == 1)
						{
							continue;
						} else if (q == 2)
						{
							continue a;
						}
						q = 12;
					}
				}
			}
		int y = 12;
		while (y != 13)
		{
			if (y == 1)
			{
				continue;
			} else
			{
				do
				{
					if (y == 2)
					{
						continue;
					}
					y = y + 2;
				} while (y == 1);
				y = 12;
			}
			y = 15;
		}
		y = 13;
		while (y != 12)
		{
			if (y != 6)
				continue;
			else
				break;
		}
	}
}
