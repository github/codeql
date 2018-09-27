package successors;

public class TestFinallyBreakContinue {
	public void f()
	{
		int x = 1;
		a:
		for (;;)
		{
			try
			{
				if (x == 1)
				{
					break;
				} else
				{
					continue;
				}
			} catch (Exception e)
			{
				if (x == 1)
				{
					break;
				} else
				{
					continue;
				}
			} finally
			{
				System.out.println("finally");
			}
		}
		
		while (true)
		{
			try
			{
				try
				{
					if (x == 1)
					{
						break;
					} else
					{
						continue;
					}
				} catch (Exception e)
				{
					if (x == 1)
					{
						break;
					} else
					{
						continue;
					}
				} finally
				{
					System.out.println("finally");
				}
			} catch (Exception e)
			{
				System.out.println("Exception");
			} finally
			{
				System.out.println("finally");
			}
		}
		
		b:
		do
		{
			try
			{
				for (int i : new int[20])
				{
					try
					{
						if (x == 1)
						{
							break;
						} else
						{
							continue;
						}
					} catch (Exception e)
					{
						if (x == 1)
						{
							break b;
						} else
						{
							continue b;
						}
					} finally
					{
						System.out.println("finally");
					}
				}
			} catch (Exception e)
			{
				System.out.println("Exception");
			} finally
			{
				System.out.println("finally");
			}
		} while (true);
	}
}
