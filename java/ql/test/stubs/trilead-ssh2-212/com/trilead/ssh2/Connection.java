package com.trilead.ssh2;

import java.io.File;
import java.io.IOException;

public class Connection
{

	public synchronized boolean authenticateWithDSA(String user, String pem, String password) throws IOException
	{
		return true;
	}

	public synchronized boolean authenticateWithPassword(String user, String password) throws IOException
	{
		return true;
	}

	public synchronized boolean authenticateWithNone(String user) throws IOException
	{
                return true;
        }

	public synchronized boolean authenticateWithPublicKey(String user, char[] pemPrivateKey, String password)
			throws IOException
	{
                return true;
        }

	public synchronized boolean authenticateWithPublicKey(String user, File pemFile, String password)
			throws IOException
	{
                return true;
        }

	public synchronized String[] getRemainingAuthMethods(String user) throws IOException
	{
		return null;
	}

	public synchronized boolean isAuthMethodAvailable(String user, String method) throws IOException
	{
		return true;
	}

}
