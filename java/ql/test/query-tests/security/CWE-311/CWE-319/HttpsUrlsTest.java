// Semmle test case for CWE-319: Cleartext Transmission of Sensitive Data
// http://cwe.mitre.org/data/definitions/319.html
package test.cwe319.cwe.examples;

import java.net.URL;
import java.io.*;
import java.rmi.*;
import java.rmi.server.*;
import java.rmi.registry.*;

import javax.net.ssl.HttpsURLConnection;
import javax.rmi.ssl.*;

interface Hello extends java.rmi.Remote {
	String sayHello() throws java.rmi.RemoteException;
}

class HelloImpl implements Hello {
	public static void main(String[] args) {
		try {	
			// HttpsUrls
			{
				String protocol = "http://";
				URL u = new URL(protocol + "www.secret.example.org/");
				// using HttpsURLConnections to enforce SSL is desirable
				// BAD: this will give a ClassCastException at runtime, as the
				// http URL cannot be used to make an HttpsURLConnection
				HttpsURLConnection hu = (HttpsURLConnection) u.openConnection();
				hu.setRequestMethod("PUT");
				hu.connect();
				OutputStream os = hu.getOutputStream();
				hu.disconnect();
			}
			
			{
				String protocol = "http";
				URL u = new URL(protocol, "www.secret.example.org", "foo");
				// using HttpsURLConnections to enforce SSL is desirable
				// BAD: this will give a ClassCastException at runtime, as the
				// http URL cannot be used to make an HttpsURLConnection
				HttpsURLConnection hu = (HttpsURLConnection) u.openConnection();
				hu.setRequestMethod("PUT");
				hu.connect();
				OutputStream os = hu.getOutputStream();
				hu.disconnect();
			}
			
			{
				String protocol = "http://";
				// the second URL overwrites the first, as it has a protocol
				URL u = new URL(new URL("https://www.secret.example.org"), protocol + "www.secret.example.org");
				// using HttpsURLConnections to enforce SSL is desirable
				// BAD: this will give a ClassCastException at runtime, as the
				// http URL cannot be used to make an HttpsURLConnection
				HttpsURLConnection hu = (HttpsURLConnection) u.openConnection();
				hu.setRequestMethod("PUT");
				hu.connect();
				OutputStream os = hu.getOutputStream();
				hu.disconnect();
			}
			
			{
				String protocol = "https://";
				URL u = new URL(protocol + "www.secret.example.org/");
				// using HttpsURLConnections to enforce SSL is desirable
				// GOOD: open connection to URL using HTTPS
				HttpsURLConnection hu = (HttpsURLConnection) u.openConnection();
				hu.setRequestMethod("PUT");
				hu.connect();
				OutputStream os = hu.getOutputStream();
				hu.disconnect();
			}
			
			{
				String protocol = "https";
				URL u = new URL(protocol, "www.secret.example.org", "foo");
				// using HttpsURLConnections to enforce SSL is desirable
				// GOOD: open connection to URL using HTTPS
				HttpsURLConnection hu = (HttpsURLConnection) u.openConnection();
				hu.setRequestMethod("PUT");
				hu.connect();
				OutputStream os = hu.getOutputStream();
				hu.disconnect();
			}
			
			{
				String protocol = "http";
				URL u = new URL(protocol, "internal-url", "foo");
				// FALSE POSITIVE: the query has no way of knowing whether the url will
				// resolve to somewhere outside the internal network, where there
				// are unlikely to be interception attempts
				HttpsURLConnection hu = (HttpsURLConnection) u.openConnection();
				hu.setRequestMethod("PUT");
				hu.connect();
				OutputStream os = hu.getOutputStream();
				hu.disconnect();
			}
			
			{
				String input = "URL is: http://www.secret-example.org";
				String url = input.substring(8);
				URL u = new URL(url);
				// FALSE NEGATIVE: we cannot tell that the substring results in a url
				// string
				HttpsURLConnection hu = (HttpsURLConnection) u.openConnection();
				hu.setRequestMethod("PUT");
				hu.connect();
				OutputStream os = hu.getOutputStream();
				hu.disconnect();
			}
		} catch (Exception e) {
			// fail
		}
	}

	public String sayHello() {
		return "Hello";
	}
}