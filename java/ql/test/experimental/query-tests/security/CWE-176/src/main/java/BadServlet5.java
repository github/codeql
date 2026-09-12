package net.codejava.javaee;

import java.io.IOException;
import java.io.PrintWriter;

import org.springframework.web.util.HtmlUtils;
import java.text.Normalizer;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class HelloServlet
 */
public class BadServlet5 extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String BAD_REGEX = "*<xss>*";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public BadServlet5() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String inputEncoded = request.getParameter("input");
		String output = "";
		if (!Pattern.matches(BAD_REGEX, inputEncoded)) {
			output = Normalizer.normalize(inputEncoded, Normalizer.Form.NFKC); // $result=BAD
		} else {
			output = "BAD characters identified";
		}
		PrintWriter writer = response.getWriter();
		writer.println("Output: " + output + " .");
		writer.close();
	}

}
