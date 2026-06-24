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
public class BadServlet1 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public BadServlet1() {
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
		String escaped = HtmlUtils.htmlEscape(inputEncoded);
		String output = Normalizer.normalize(escaped, Normalizer.Form.NFKC); // $result=BAD

		PrintWriter writer = response.getWriter();
		writer.println("Output: " + output + " .");
		writer.close();
	}

}
