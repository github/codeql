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
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import org.kohsuke.stapler.WebMethod;
import org.kohsuke.stapler.interceptor.RequirePOST;
import org.kohsuke.stapler.verb.POST;
import org.kohsuke.stapler.verb.GET;
import org.kohsuke.stapler.verb.PUT;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.QueryParameter;
import org.kohsuke.stapler.HttpRedirect;
import org.kohsuke.stapler.HttpResponses;
import org.apache.ibatis.jdbc.SqlRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import java.util.Map;

@Controller
public class CsrfUnprotectedRequestTypeTest {
    public static Connection connection;

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

    // GOOD: uses OPTIONS or TRACE, which are unlikely to be exploitable via CSRF
    @RequestMapping(value = "", method = { OPTIONS, TRACE })
    public void good0() {
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

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `Statement.executeUpdate`
    @RequestMapping("/")
    public void badStatementExecuteUpdate() { // $ hasCsrfUnprotectedRequestType
        try {
            String item = "item";
            String price = "price";
            Statement statement = connection.createStatement();
            String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
            int count = statement.executeUpdate(sql);
        } catch (SQLException e) { }
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `Statement.executeLargeUpdate`
    @RequestMapping("/")
    public void badStatementExecuteLargeUpdate() { // $ hasCsrfUnprotectedRequestType
        try {
            String item = "item";
            String price = "price";
            Statement statement = connection.createStatement();
            String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
            long count = statement.executeLargeUpdate(sql);
        } catch (SQLException e) { }
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `Statement.execute` with SQL UPDATE
    @RequestMapping("/")
    public void badStatementExecute() { // $ hasCsrfUnprotectedRequestType
        try {
            String item = "item";
            String price = "price";
            Statement statement = connection.createStatement();
            String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
            boolean bool = statement.execute(sql);
        } catch (SQLException e) { }
    }

    // GOOD: does not update a database, queries with SELECT
    @RequestMapping("/")
    public void goodStatementExecute() {
        try {
            String category = "category";
            Statement statement = connection.createStatement();
            String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                    + category + "' ORDER BY PRICE";
            boolean bool = statement.execute(query);
        } catch (SQLException e) { }
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `SqlRunner.insert`
    @RequestMapping("/")
    public void badSqlRunnerInsert() { // $ hasCsrfUnprotectedRequestType
        try {
            String item = "item";
            String price = "price";
            String sql = "INSERT PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
            SqlRunner sqlRunner = new SqlRunner(connection);
            sqlRunner.insert(sql);
        } catch (SQLException e) { }
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `SqlRunner.update`
    @RequestMapping("/")
    public void badSqlRunnerUpdate() { // $ hasCsrfUnprotectedRequestType
        try {
            String item = "item";
            String price = "price";
            String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
            SqlRunner sqlRunner = new SqlRunner(connection);
            sqlRunner.update(sql);
        } catch (SQLException e) { }
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `SqlRunner.delete`
    @RequestMapping("/")
    public void badSqlRunnerDelete() { // $ hasCsrfUnprotectedRequestType
        try {
            String item = "item";
            String price = "price";
            String sql = "DELETE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
            SqlRunner sqlRunner = new SqlRunner(connection);
            sqlRunner.delete(sql);
        } catch (SQLException e) { }
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `JdbcTemplate.update`
    @RequestMapping("/")
    public void badJdbcTemplateUpdate() { // $ hasCsrfUnprotectedRequestType
        String item = "item";
        String price = "price";
        String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        jdbcTemplate.update(sql);
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `JdbcTemplate.batchUpdate`
    @RequestMapping("/")
    public void badJdbcTemplateBatchUpdate() { // $ hasCsrfUnprotectedRequestType
        String item = "item";
        String price = "price";
        String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        jdbcTemplate.batchUpdate(sql, null, null);
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `JdbcTemplate.execute`
    @RequestMapping("/")
    public void badJdbcTemplateExecute() { // $ hasCsrfUnprotectedRequestType
        String item = "item";
        String price = "price";
        String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        jdbcTemplate.execute(sql);
    }

    // GOOD: does not update a database, queries with SELECT
    @RequestMapping("/")
    public void goodJdbcTemplateExecute() {
        String category = "category";
        String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                + category + "' ORDER BY PRICE";
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        jdbcTemplate.execute(query);
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `NamedParameterJdbcTemplate.update`
    @RequestMapping("/")
    public void badNamedParameterJdbcTemplateUpdate() { // $ hasCsrfUnprotectedRequestType
        String item = "item";
        String price = "price";
        String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        NamedParameterJdbcTemplate namedParamJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate);
        namedParamJdbcTemplate.update(sql, null, null);
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `NamedParameterJdbcTemplate.batchUpdate`
    @RequestMapping("/")
    public void badNamedParameterJdbcTemplateBatchUpdate() { // $ hasCsrfUnprotectedRequestType
        String item = "item";
        String price = "price";
        String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        NamedParameterJdbcTemplate namedParamJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate);
        namedParamJdbcTemplate.batchUpdate(sql, (Map<String,?>[]) null);
    }

    // BAD: allows request type not default-protected from CSRF when
    // updating a database using `NamedParameterJdbcTemplate.execute`
    @RequestMapping("/")
    public void badNamedParameterJdbcTemplateExecute() { // $ hasCsrfUnprotectedRequestType
        String item = "item";
        String price = "price";
        String sql = "UPDATE PRODUCT SET PRICE='" + price + "' WHERE ITEM='" + item + "'";
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        NamedParameterJdbcTemplate namedParamJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate);
        namedParamJdbcTemplate.execute(sql, null);
    }

    // GOOD: does not update a database, queries with SELECT
    @RequestMapping("/")
    public void goodNamedParameterJdbcTemplateExecute() {
        String category = "category";
        String query = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
                + category + "' ORDER BY PRICE";
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        NamedParameterJdbcTemplate namedParamJdbcTemplate = new NamedParameterJdbcTemplate(jdbcTemplate);
        namedParamJdbcTemplate.execute(query, null);
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

    // Test name-based heuristic for method names that imply a state-change
    @GetMapping(value = "transfer")
	public String transfer(@RequestParam String user) { return "transfer"; } // $ hasCsrfUnprotectedRequestType

    @GetMapping(value = "transfer")
	public String transferData(@RequestParam String user) { return "transfer"; } // $ hasCsrfUnprotectedRequestType

    @GetMapping(value = "transfer")
	public String doTransfer(@RequestParam String user) { return "transfer"; } // $ hasCsrfUnprotectedRequestType

    @GetMapping(value = "transfer")
	public String doTransferAllData(@RequestParam String user) { return "transfer"; } // $ hasCsrfUnprotectedRequestType

    @GetMapping(value = "transfer")
	public String doDataTransfer(@RequestParam String user) { return "transfer"; } // $ hasCsrfUnprotectedRequestType

    @GetMapping(value = "transfer")
	public String transfered(@RequestParam String user) { return "transfer"; } // OK: we look for 'transfer' only

    @GetMapping(value = "transfer")
	public String dotransfer(@RequestParam String user) { return "transfer"; } // OK: we look for 'transfer' within camelCase only

    @GetMapping(value = "transfer")
	public String doTransferdata(@RequestParam String user) { return "transfer"; } // OK: we look for 'transfer' within camelCase only

    @GetMapping(value = "transfer")
	public String getTransfer(@RequestParam String user) { return "transfer"; } // OK: starts with 'get'

    // Test Stapler web methods with name-based heuristic

    // BAD: Stapler web method annotated with `@WebMethod` and method name that implies a state-change
    @WebMethod(name = "post")
	public String doPost(String user) { // $ hasCsrfUnprotectedRequestType
		return "post";
	}

    // GOOD: nothing to indicate that this is a Stapler web method
	public String postNotAWebMethod(String user) {
		return "post";
	}

    // GOOD: Stapler web method annotated with `@RequirePOST` and method name that implies a state-change
    @RequirePOST
	public String doPost1(String user) {
		return "post";
	}

    // GOOD: Stapler web method annotated with `@POST` and method name that implies a state-change
    @POST
	public String doPost2(String user) {
		return "post";
	}

    // BAD: Stapler web method annotated with `@GET` and method name that implies a state-change
    @GET
	public String doPost3(String user) { // $ hasCsrfUnprotectedRequestType
		return "post";
	}

    // GOOD: Stapler web method annotated with `@PUT` and method name that implies a state-change
    // We treat this case as good since PUT is only exploitable if there is a CORS issue.
    @PUT
	public String doPut(String user) {
		return "put";
	}

    // BAD: Stapler web method parameter of type `StaplerRequest` and method name that implies a state-change
	public String doPost4(StaplerRequest request) { // $ hasCsrfUnprotectedRequestType
		return "post";
	}

    // BAD: Stapler web method parameter annotated with `@QueryParameter` and method name that implies a state-change
	public String doPost5(@QueryParameter(value="user", fixEmpty=false, required=false) String user) { // $ hasCsrfUnprotectedRequestType
		return "post";
	}

    // BAD: Stapler web method with declared exception type implementing HttpResponse and method name that implies a state-change
	public String doPost6(String user) throws HttpResponses.HttpResponseException { // $ hasCsrfUnprotectedRequestType
		return "post";
	}

    // BAD: Stapler web method with return type implementing HttpResponse and method name that implies a state-change
	public HttpRedirect doPost7(String url) { // $ hasCsrfUnprotectedRequestType
        HttpRedirect redirect = new HttpRedirect(url);
		return redirect;
	}
}
