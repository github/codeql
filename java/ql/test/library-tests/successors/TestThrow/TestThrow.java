package successors;

import java.io.IOException;
import java.security.InvalidParameterException;

public class TestThrow {
	private TestThrow() throws IOException
	{
	}
	
	private void thrower() throws InvalidParameterException
	{
	}
	
	public void f() throws Exception
	{
		int z = 0;
		try
		{
			throw new RuntimeException();
		} catch (RuntimeException e)
		{
			z = 1;
		} catch (Exception e)
		{
			z = 2;
		}
		
		z = -1;
		
		try
		{
			if (z == 1)
			{
				throw new RuntimeException();
			} else if (z == 2)
			{
				throw new Exception();
			} else if (z == 3)
			{
				new TestThrow();
			} else
			{
				thrower();
			}
		} catch (RuntimeException e)
		{
			z = 1;
		} finally
		{
			z = 2;
		}
		
		z = -1;
		
		try
		{
			if (z == 1)
			{
				throw new Exception();
			}
			else if (z == 2)
			{
				new TestThrow();
			} else
			{
				thrower();
			}
		} catch (RuntimeException e)
		{
			z = 1;
		}
		
		z = -1;
		
		try
		{
			if (z == 1)
				throw new Exception();
		} finally
		{
			z = 1;
		}
		
		try
		{
			try
			{
				if (z == 1)
				{
					throw new Exception();
				} else if (z == 2)
				{ 
					throw new RuntimeException();
				} else
				{
					throw new IOException("Foo bar", null);
				}
			} catch (RuntimeException e)
			{
				z = 1;
			}
			try
			{
				z = -2;
			} finally
			{
				if (z == 1)
				{
					throw new Exception();
				} else if (z == 2)
				{ 
					throw new RuntimeException();
				} else if (z == 3)
				{
					throw new IOException("Foo bar", null);
				}
			}
		} catch (IOException e)
		{
			z = 2;
		}
		finally
		{
			z = 3;
		}
		
		if (z == 1)
		{
			throw new Exception();
		}
		
		z = -1;
	}
}
