// Semmle test cases for rule CWE-209: Information Exposure Through an Error Message
// https://cwe.mitre.org/data/definitions/209.html

package test.cwe209.semmle.tests;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

class Test extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			doSomeWork();
		} catch (Throwable ex) {
			// BAD: Exception message seldom contains stack traces so wont trigger that query, but will trigger exposing sensitive information query
			response.sendError(
				HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
				ex.getMessage());
		}

		try {
			doSomeWork();
		} catch (NullPointerException ex) {
			// GOOD: log the error message, and send back a non-revealing response 
			System.out.println("Exception occurred: " + ex.getMessage());
			response.sendError(
				HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
				"Exception occurred");
			return;
		}
	}

	private void doSomeWork() {

	}
}
