import java.io.IOException;
import java.io.File;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.StringJoiner;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collectors;

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

            String s2 = (String)source();
            int i = 0;
            sink(s2.charAt(i)); // $hasTaintFlow

            ResultSet rs = (ResultSet)source();
            sink(rs.getString("")); // $hasTaintFlow
        }

        // top 200 JDK APIs tests
        {
            // java.io
            Exception e1 = new IOException((String)source());
            sink((String)e1.getMessage()); // $hasValueFlow

            File f = (File)source();
            sink(f.getName()); // $hasTaintFlow

            // java.lang
            Exception e2 = new Exception((String)source());
            sink((String)e2.getMessage()); // $hasValueFlow

            Exception e3 = new IndexOutOfBoundsException((String)source());
            sink((String)e3.getMessage()); // $hasValueFlow

            Exception e4 = new RuntimeException((String)source(), (Throwable)source());
            sink((String)e4.getMessage());  // $hasValueFlow
            sink((Throwable)e4.getCause()); // $hasValueFlow

            // java.sql
            Connection con = DriverManager.getConnection("");
            PreparedStatement ps1 = con.prepareStatement("UPDATE EMPLOYEES SET NAME = ? WHERE ID = ?");
            ps1.setString(1, (String)source());
            sink(ps1); // $hasValueFlow

            // java.util.concurrent.atomic
            AtomicReference ar = new AtomicReference(source());
            sink(ar.get());  // $hasValueFlow

            // java.util
            StringJoiner sj1 = new StringJoiner(",");
            sink(sj1.add((CharSequence)source())); // $hasTaintFlow

            StringJoiner sj2 = (StringJoiner)source();
            sink(sj2.add("test")); // $hasTaintFlow
        }
    }
}
