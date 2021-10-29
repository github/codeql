import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class AddUser {
    public static Connection connect() {
        Connection conn = null;
        try {
            String url = "jdbc:sqlite:users.sqlite";
            conn = DriverManager.getConnection(url);
            System.out.println("Connected...");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return conn;
    }

    static String get_user_info() {
        System.out.println("Enter name:");
        return System.console().readLine();
    }

    static void write_info(int id, String info) {
        try (Connection conn = connect()) { 
            String query = String.format("INSERT INTO users VALUES (%d, '%s')", id, info);
            conn.createStatement().executeUpdate(query);
            System.err.printf("Sent: %s", query);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    
    static int get_new_id() {
        return (int)(Math.random()*100000);
    }

    public static void main(String[] args) {
        String info;
        int id;

        info = get_user_info();
        id = get_new_id();
        write_info(id, info);
    }
}
