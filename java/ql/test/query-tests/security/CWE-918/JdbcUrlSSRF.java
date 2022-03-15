import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.DriverManager;
import java.sql.Driver;
import java.sql.SQLException;
import java.io.IOException;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.util.*;
import org.springframework.jdbc.datasource.*;
import org.jdbi.v3.core.Jdbi;
import org.springframework.boot.jdbc.DataSourceBuilder;

public class JdbcUrlSSRF extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    
        String jdbcUrl = request.getParameter("jdbcUrl");
        Driver driver = new org.postgresql.Driver();
        DataSourceBuilder dsBuilder = new DataSourceBuilder();
        
        try {
            driver.connect(jdbcUrl, null); // $ SSRF

            DriverManager.getConnection(jdbcUrl); // $ SSRF
            DriverManager.getConnection(jdbcUrl, "user", "password"); // $ SSRF
            DriverManager.getConnection(jdbcUrl, null); // $ SSRF

            dsBuilder.url(jdbcUrl); // $ SSRF
        }
        catch(SQLException e) {}
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    
        String jdbcUrl = request.getParameter("jdbcUrl");
        HikariConfig config = new HikariConfig();

        config.setJdbcUrl(jdbcUrl); // $ SSRF
        config.setUsername("database_username");
        config.setPassword("database_password");

        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl(jdbcUrl); // $ SSRF

        Properties props = new Properties();
        props.setProperty("driverClassName", "org.postgresql.Driver");
        props.setProperty("jdbcUrl", jdbcUrl);

        HikariConfig config2 = new HikariConfig(props); // $ SSRF
    }

    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String jdbcUrl = request.getParameter("jdbcUrl");
    
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
    
        dataSource.setDriverClassName("org.postgresql.Driver");
        dataSource.setUrl(jdbcUrl); // $ SSRF

        DriverManagerDataSource dataSource2 = new DriverManagerDataSource(jdbcUrl); // $ SSRF
        dataSource2.setDriverClassName("org.postgresql.Driver");

        DriverManagerDataSource dataSource3 = new DriverManagerDataSource(jdbcUrl, "user", "pass"); // $ SSRF
        dataSource3.setDriverClassName("org.postgresql.Driver");

        DriverManagerDataSource dataSource4 = new DriverManagerDataSource(jdbcUrl, null); // $ SSRF
        dataSource4.setDriverClassName("org.postgresql.Driver");
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String jdbcUrl = request.getParameter("jdbcUrl");

        Jdbi.create(jdbcUrl); // $ SSRF
        Jdbi.create(jdbcUrl, null); // $ SSRF
        Jdbi.create(jdbcUrl, "user", "pass"); // $ SSRF

        Jdbi.open(jdbcUrl); // $ SSRF
        Jdbi.open(jdbcUrl, null); // $ SSRF
        Jdbi.open(jdbcUrl, "user", "pass"); // $ SSRF
    }
    
}