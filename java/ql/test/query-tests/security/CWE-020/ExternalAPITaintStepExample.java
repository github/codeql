import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;

public class ExternalAPITaintStepExample extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {

		StringBuilder sqlQueryBuilder = new StringBuilder();
		sqlQueryBuilder.append("SELECT * FROM user WHERE user_id='");
		// BAD: a request parameter is concatenated directly into a SQL query
		sqlQueryBuilder.append(request.getParameter("user_id"));
		sqlQueryBuilder.append("'");

		// ...
	}
}
