package successors;

public class TestFinally {
	public void f()
	{
		int z = 12;
		try
		{
			try
			{
				System.out.println("Try1");
				if (z == 1)
				{
					return;
				}
				try
				{
					System.out.println("Try1");
					if (z == 1)
					{
						return;
					}
					System.out.println("Try2");
				} catch (Exception ex)
				{
					System.out.println("Exception");
					if (z == 1)
					{
						return;
					}
				} finally
				{
					System.out.println("Finally");
					if (z == 1)
					{
						return;
					}
					System.out.println("Finally2");
				}
				System.out.println("Try2");
			} catch (Exception ex)
			{
				System.out.println("Exception");
				try
				{
					System.out.println("Try1");
					if (z == 1)
					{
						return;
					}
					System.out.println("Try2");
				} catch (Exception ex2)
				{
					System.out.println("Exception");
					if (z == 1)
					{
						return;
					}
				} finally
				{
					System.out.println("Finally");
					if (z == 1)
					{
						return;
					}
					System.out.println("Finally2");
				}
				if (z == 1)
				{
					return;
				}
			} finally
			{
				System.out.println("Finally");
				if (z == 1)
				{
					return;
				}
				System.out.println("Finally2");
			}
			System.out.println("Foo");
			int y = 12 + 3;
			System.out.println("Bar");
			y = y + 1;
			return;
		} catch (Exception e)
		{
			try
			{
				System.out.println("Try1");
				if (z == 1)
				{
					return;
				}
				System.out.println("Try2");
			} catch (Exception ex)
			{
				System.out.println("Exception");
				if (z == 1)
				{
					return;
				}
			} finally
			{
				System.out.println("Finally");
				if (z == 1)
				{
					return;
				}
				System.out.println("Finally2");
			}
			int x = 1;
			System.out.println("Error: " + e);
			x = x + 1;
		} finally
		{
			int y = 12;
			System.out.println("Finally");
			y = y + 1;
		}
		z = z + 1;
		
		try
		{
			System.out.println("Try1");
			if (z == 1)
			{
				return;
			}
			System.out.println("Try2");
		} catch (Exception ex)
		{
			System.out.println("Exception");
			if (z == 1)
			{
				return;
			}
		} finally
		{
			System.out.println("Finally");
			if (z == 1)
			{
				return;
			}
			System.out.println("Finally2");
		}
		
		z = z + 2;
	}
}
