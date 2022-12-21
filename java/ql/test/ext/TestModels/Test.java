import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.math.BigDecimal;
import java.io.IOException;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.concurrent.CountDownLatch;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.StringJoiner;

public class Test {

    void sink(Object o) { }

    Object source() { return null; }

    public void test() throws Exception {

        // top 100 JDK APIs tests
        {
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

        // top 200 JDK APIs tests
        {
            // java.io
            Exception e1 = new IOException((String)source());
            sink((String)e1.getMessage()); // $hasValueFlow

            // java.lang
            Exception e2 = new Exception((String)source());
            sink((String)e2.getMessage()); // $hasValueFlow

            Exception e3 = new IndexOutOfBoundsException((String)source());
            sink((String)e3.getMessage()); // $hasValueFlow

            Exception e4 = new RuntimeException((String)source(), (Throwable)source());
            sink((String)e4.getMessage());  // $hasValueFlow
            sink((Throwable)e4.getCause()); // $hasValueFlow

            Integer i1 = (Integer)source();
            sink(i1.intValue()); // $hasTaintFlow

            int i2 = (int)source();
            sink(Integer.toString(i2)); // $hasTaintFlow

            int i3 = (int)source();
            sink(Integer.valueOf(i3)); // $hasTaintFlow

            Long l1 = (Long)source();
            sink(l1.longValue()); // $hasTaintFlow

            String s1 = (String)source();
            sink(Long.parseLong(s1)); // $hasTaintFlow

            Long l2 = (Long)source();
            sink(l2.toString()); // $hasTaintFlow

            long l3 = (long)source();
            sink(String.valueOf(l3)); // $hasTaintFlow

            // System sys = (System)source();
            // sink(sys.getProperty("")); // $hasValueFlow

            // java.math
            long l4 = (long)source();
            sink(BigDecimal.valueOf(l4)); // $hasTaintFlow

            double d1 = (double)source();
            sink(BigDecimal.valueOf(d1)); // $hasTaintFlow

            int i4 = (int)source();
            int i5 = (int)source();
            sink(Math.min(i4, i5)); // $hasValueFlow

            // java.sql
            // Connection con = DriverManager.getConnection("");
            // PreparedStatement ps = con.prepareStatement("UPDATE EMPLOYEES SET NAME = ? WHERE ID = ?");
            // ps.setString(1, "testName"); // $hasValueFlow
            // ps.setInt(2, 110592);        // $hasValueFlow

            ResultSet rs = (ResultSet)source();
            sink(rs.getInt("")); // $hasTaintFlow

            // java.util.concurrent.atomic
            // AtomicInteger ai = new AtomicInteger((int)source());
            // sink((int)ai.get());  // $hasValueFlow

            // AtomicReference ar = new AtomicReference(source());
            // sink(ar.get());  // $hasValueFlow

            // java.util.concurrent
            CountDownLatch cdl = new CountDownLatch((int)source());
            sink(cdl.getCount()); // $hasValueFlow

            // java.util.function
            // Function<Object, Object> func = a -> a + "";
            // sink(func.apply(source()));  // $hasTaintFlow

            Supplier<Double> sup = (Supplier)source();
            sink(sup.get()); // $hasValueFlow

            // java.util
            // StringJoiner sj = new StringJoiner(",");
            // sink(sj.add((CharSequence)source())); // $hasTaintFlow
        }

    }
}
