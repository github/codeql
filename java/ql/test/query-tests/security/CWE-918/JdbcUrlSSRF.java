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

        String jdbcUrl = request.getParameter("jdbcUrl"); // $ Source
        Driver driver = new org.postgresql.Driver();
        DataSourceBuilder dsBuilder = DataSourceBuilder.create();

        try {
            driver.connect(jdbcUrl, null); // $ Alert

            DriverManager.getConnection(jdbcUrl); // $ Alert
            DriverManager.getConnection(jdbcUrl, "user", "password"); // $ Alert
            DriverManager.getConnection(jdbcUrl, null); // $ Alert

            dsBuilder.url(jdbcUrl); // $ Alert
        }
        catch(SQLException e) {}
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String jdbcUrl = request.getParameter("jdbcUrl"); // $ Source
        HikariConfig config = new HikariConfig();

        config.setJdbcUrl(jdbcUrl); // $ Alert
        config.setUsername("database_username");
        config.setPassword("database_password");

        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl(jdbcUrl); // $ Alert

        Properties props = new Properties();
        props.setProperty("driverClassName", "org.postgresql.Driver");
        props.setProperty("jdbcUrl", jdbcUrl);

        HikariConfig config2 = new HikariConfig(props); // $ Alert
    }

    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String jdbcUrl = request.getParameter("jdbcUrl"); // $ Source

        DriverManagerDataSource dataSource = new DriverManagerDataSource();

        dataSource.setDriverClassName("org.postgresql.Driver");
        dataSource.setUrl(jdbcUrl); // $ Alert

        DriverManagerDataSource dataSource2 = new DriverManagerDataSource(jdbcUrl); // $ Alert
        dataSource2.setDriverClassName("org.postgresql.Driver");

        DriverManagerDataSource dataSource3 = new DriverManagerDataSource(jdbcUrl, "user", "pass"); // $ Alert
        dataSource3.setDriverClassName("org.postgresql.Driver");

        DriverManagerDataSource dataSource4 = new DriverManagerDataSource(jdbcUrl, null); // $ Alert
        dataSource4.setDriverClassName("org.postgresql.Driver");
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String jdbcUrl = request.getParameter("jdbcUrl"); // $ Source

        Jdbi.create(jdbcUrl); // $ Alert
        Jdbi.create(jdbcUrl, null); // $ Alert
        Jdbi.create(jdbcUrl, "user", "pass"); // $ Alert

        Jdbi.open(jdbcUrl); // $ Alert
        Jdbi.open(jdbcUrl, null); // $ Alert
        Jdbi.open(jdbcUrl, "user", "pass"); // $ Alert
    }

}
