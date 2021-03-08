import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SpringControllerTest {

    @GetMapping(value = "testMysql")
    public void bad1(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String url = "jdbc:mysql://localhost:3306/testdatabase";
        String name = "test";
        String pas = "test";
        Connection conn = null;
        Statement stmt = null;
        try{
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, name, pas);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException sqlException) {
            sqlException.printStackTrace();
        }
    }

    @GetMapping(value = "testUrl")
    public void bad2(HttpServletRequest request, HttpServletResponse response) throws Exception {
        URL url = new URL(request.getParameter("url"));
        url.openStream();
    }
}