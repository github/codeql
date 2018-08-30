

import java.io.IOException;
import java.sql.SQLException;

public class MultiCatch {
	public void multiCatch(boolean b) throws IOException, SQLException
	{
		try
		{
			if(b)
				throw new IOException();
			else
				throw new SQLException();
		} catch(IOException|SQLException e)
		{
			e.printStackTrace();
			throw e;
		}
	}
	
	public void multiCatch2(boolean b, boolean c) throws Exception
	{
		try
		{
			if(b)
				throw new IOException();
			else if(c)
				throw new SQLException();
			throw new Exception();
		} catch(IOException|SQLException e)
		{}
	}
	
	public void ordinaryCatch()
	{
		try
		{
			throw new IOException();
		} catch(Exception e)
		{}
	}
}
