package successors;

public class TestBreak {
	public void f()
	{
		//loop breaks
		a:
			for (;;)
			{
				int x = 1;
				x = x + 1;
				if (x == 1)
				{
					break;
				} else
				{
					for (int q : new int[20])
					{
						if (q == 1)
						{
							break;
						} else
						{
							break a;
						}
					}
				}
			}
		int y = 12;
		while (true)
		{
			if (y == 1)
			{
				break;
			} else
			{
				do
				{
					if (y == 2)
					{
						break;
					}
					y = y + 2;
				} while (y == 1);
				y = 12;
			}
		}
		y = 13;

		//switch breaks
		int x =12;
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
	}
}
