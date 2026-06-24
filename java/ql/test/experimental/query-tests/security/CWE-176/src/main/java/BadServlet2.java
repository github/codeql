package net.codejava.javaee;

import java.io.IOException;
import java.io.PrintWriter;

import org.springframework.web.util.HtmlUtils;
import java.text.Normalizer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class HelloServlet
 */
public class BadServlet2 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public BadServlet2() {
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
		Boolean isAMatch = inputEncoded.matches("^(https?|ftp)://.*$");

		String output = "";
		if (isAMatch == true) {
			output = Normalizer.normalize(inputEncoded, Normalizer.Form.NFKC); // $result=BAD
		}

		PrintWriter writer = response.getWriter();
		writer.println("Output: " + output + " .");
		writer.close();
	}

}
