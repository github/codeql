/*
 * Copyright (c) 2006-2011 Christian Plattner. All rights reserved.
 * Please refer to the LICENSE.txt for licensing details.
 */
package ch.ethz.ssh2;

import java.io.IOException;

public class Connection
{
	public synchronized boolean authenticateWithPassword(String user, String password) throws IOException
	{
		return true;
	}
}
