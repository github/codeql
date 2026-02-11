import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.jdbc.SQL;

public class MyBatisProvider {

    public String badDelete(@Param("input") final String input) {
        return "DELETE FROM users WHERE username = '" + input + "';";
    }

    public String badUpdate(@Param("input") final String input) {
        String s = (new SQL() {
            {
                this.UPDATE("users");
                this.SET("balance = 0");
                this.WHERE("username = '" + input + "'");
            }
        }).toString();
        return s;
    }

    public String badInsert(@Param("input") final String input) {
        return "INSERT INTO users VALUES (1, '" + input + "', 'hunter2');";
    }
}
