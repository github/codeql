import java.math.BigDecimal;
import java.sql.ResultSet;

public class Test {

    void sink(Object o) { }

    Object source() { return null; }

    public void test() throws Exception {

        Exception e1 = new RuntimeException((String)source());
        sink((String)e1.getMessage()); // $hasValueFlow

        Exception e2 = new RuntimeException((Throwable)source());
        sink((Throwable)e2.getCause()); // $hasValueFlow

        Exception e3 = new IllegalArgumentException((String)source());
        sink((String)e3.getMessage()); // $hasValueFlow

        Exception e4 = new IllegalStateException((String)source());
        sink((String)e4.getMessage()); // $hasValueFlow

        Throwable t = new Throwable((Throwable)source());
        sink((Throwable)t.getCause()); // $hasValueFlow

        Integer x = (Integer)source();
        int y = x;
        sink(String.valueOf(y)); // $hasTaintFlow

        String s1 = (String)source();
        sink(Integer.parseInt(s1)); // $hasTaintFlow

        String s2 = (String)source();
        int i = 0;
        sink(s2.charAt(i)); // $hasTaintFlow

        String s3 = (String)source();
        sink(new BigDecimal(s3)); // $hasTaintFlow

        ResultSet rs = (ResultSet)source();
        sink(rs.getString("")); // $hasTaintFlow

    }
}
