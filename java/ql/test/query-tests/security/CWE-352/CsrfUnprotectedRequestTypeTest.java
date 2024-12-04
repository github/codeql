import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import static org.springframework.web.bind.annotation.RequestMethod.*;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Autowired;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@Controller
public class CsrfUnprotectedRequestTypeTest {

    // Test Spring sources with `PreparedStatement.executeUpdate()` as a default database update method call

    // BAD: allows request type not default-protected from CSRF when updating a database
    @RequestMapping("/")
    public void bad1() { // $ hasCsrfUnprotectedRequestType
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    // BAD: uses GET request when updating a database
    @RequestMapping(value = "", method = RequestMethod.GET)
    public void bad2() { // $ hasCsrfUnprotectedRequestType
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    // BAD: uses GET request when updating a database
    @GetMapping(value = "")
    public void bad3() { // $ hasCsrfUnprotectedRequestType
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    // BAD: allows GET request when updating a database
    @RequestMapping(value = "", method = { RequestMethod.GET, RequestMethod.POST })
    public void bad4() { // $ hasCsrfUnprotectedRequestType
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    // BAD: uses request type not default-protected from CSRF when updating a database
    @RequestMapping(value = "", method = { GET, HEAD, OPTIONS, TRACE })
    public void bad5() { // $ hasCsrfUnprotectedRequestType
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    // GOOD: uses POST request when updating a database
    @RequestMapping(value = "", method = RequestMethod.POST)
    public void good1() {
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    // GOOD: uses POST request when updating a database
    @RequestMapping(value = "", method = POST)
    public void good2() {
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    // GOOD: uses POST request when updating a database
    @PostMapping(value = "")
    public void good3() {
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    // GOOD: uses a request type that is default-protected from CSRF when updating a database
    @RequestMapping(value = "", method = { POST, PUT, PATCH, DELETE })
    public void good4() {
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    // Test database update method calls other than `PreparedStatement.executeUpdate()`

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `PreparedStatement.executeLargeUpdate()`
    @RequestMapping("/")
    public void bad6() { // $ hasCsrfUnprotectedRequestType
        try {
            String sql = "DELETE";
            Connection conn = DriverManager.getConnection("url");
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.executeLargeUpdate(); // database update method call
        } catch (SQLException e) { }
    }

    @Autowired
	private MyBatisService myBatisService;

    // BAD: uses GET request when updating a database with MyBatis XML mapper method
    @GetMapping(value = "")
	public void bad7(@RequestParam String name) { // $ hasCsrfUnprotectedRequestType
		myBatisService.bad7(name);
	}

    // BAD: uses GET request when updating a database with MyBatis `@DeleteProvider`
    @GetMapping(value = "badDelete")
	public void badDelete(@RequestParam String name) { // $ hasCsrfUnprotectedRequestType
		myBatisService.badDelete(name);
	}

    // BAD: uses GET request when updating a database with MyBatis `@UpdateProvider`
	@GetMapping(value = "badUpdate")
	public void badUpdate(@RequestParam String name) { // $ hasCsrfUnprotectedRequestType
		myBatisService.badUpdate(name);
	}

    // BAD: uses GET request when updating a database with MyBatis `@InsertProvider`
	@GetMapping(value = "badInsert")
	public void badInsert(@RequestParam String name) { // $ hasCsrfUnprotectedRequestType
		myBatisService.badInsert(name);
	}

    // BAD: uses GET request when updating a database with MyBatis `@Delete`
    @GetMapping(value = "bad8")
	public void bad8(@RequestParam int id) { // $ hasCsrfUnprotectedRequestType
		myBatisService.bad8(id);
	}

    // BAD: uses GET request when updating a database with MyBatis `@Insert`
    @GetMapping(value = "bad9")
	public void bad9(@RequestParam String user) { // $ hasCsrfUnprotectedRequestType
		myBatisService.bad9(user);
	}

    // BAD: uses GET request when updating a database with MyBatis `@Update`
    @GetMapping(value = "bad10")
	public void bad10(@RequestParam String user) { // $ hasCsrfUnprotectedRequestType
		myBatisService.bad10(user);
	}
}
