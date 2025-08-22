package generatedtest; // for java.util.ResourceBundle.getString test

import java.awt.*;
import java.io.*;
import java.math.BigDecimal;
import java.net.URL;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.EventObject;
import java.util.ResourceBundle;
import java.util.StringJoiner;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class Test {

    void sink(Object o) { }

    Object source() { return null; }

    Object newWithMapValueDefault(Object element) { return null; } // for java.util.ResourceBundle.getString test

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

            Exception e5 = new UnsupportedOperationException((String)source());
            sink((String)e5.getMessage()); // $hasValueFlow

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
            sink(ps1); // safe

            // java.util.concurrent.atomic
            AtomicReference ar = new AtomicReference(source());
            sink(ar.get());  // $hasValueFlow

            // java.util
            StringJoiner sj1 = new StringJoiner(",");
            sink(sj1.add((CharSequence)source())); // $hasTaintFlow

            StringJoiner sj2 = (StringJoiner)source();
            sink(sj2.add("test")); // $hasValueFlow
        }

        // top 300-500 JDK APIs tests
        {

            // java.awt
            Container container = new Container();
            sink(container.add((Component)source())); // $hasValueFlow

            // java.io
            File f1 = (File)source();
            sink(f1.getParentFile()); // $hasTaintFlow

            File f2 = (File)source();
            sink(f2.getPath()); // $hasTaintFlow

            StringWriter sw = (StringWriter)source();
            sink(sw.toString()); // $hasTaintFlow

            Exception e = new UncheckedIOException((IOException)source());
            sink((Throwable)e.getCause()); // $hasValueFlow

            // java.net
            URL url = (URL)source();
            sink(url.toURI()); // $hasTaintFlow

            // java.nio.file
            Path p = (Path)source();
            sink(p.getFileName()); // $hasTaintFlow

            // java.util.concurrent.atomic
            AtomicReference ar = new AtomicReference();
            ar.set(source());
            sink(ar.get()); // $hasValueFlow

            // java.util.concurrent
            // `ThreadPoolExecutor` implements the `java.util.concurrent.ExecutorService` interface
            ThreadPoolExecutor tpe = new ThreadPoolExecutor(0, 0, 0, null, null);
            sink(tpe.submit((Runnable)source())); // $hasTaintFlow

            CompletionStage cs = (CompletionStage)source();
            sink(cs.toCompletableFuture()); // $hasTaintFlow

            CompletableFuture cf1 = new CompletableFuture();
            cf1.complete(source());
            sink(cf1.get()); // $hasValueFlow
            sink(cf1.join()); // $hasValueFlow

            CompletableFuture cf2 = CompletableFuture.completedFuture(source());
            sink(cf2.get()); // $hasValueFlow
            sink(cf2.join()); // $hasValueFlow

            // java.util.logging
            Logger logger = Logger.getLogger((String)source());
            sink(logger.getName()); // $hasValueFlow

            // java.util.regex
            Pattern pattern = Pattern.compile((String)source());
            sink(pattern); // $hasTaintFlow

            // java.util
            EventObject eventObj = new EventObject(source());
            sink(eventObj.getSource()); // $hasValueFlow

            // "java.util;ResourceBundle;true;getString;(String);;Argument[-1].MapValue;ReturnValue;value;manual"
            String out = null;
            ResourceBundle in = (ResourceBundle)newWithMapValueDefault(source());
            out = in.getString(null);
            sink(out); // $ hasValueFlow

            // java.lang
            AssertionError assertErr = new AssertionError(source());
            sink((String)assertErr.getMessage()); // $hasValueFlow

            sink(Test.class.cast(source())); // $hasValueFlow

            Exception excep1 = new Exception((String)source(), (Throwable)source());
            sink((String)excep1.getMessage());  // $hasValueFlow
            sink((Throwable)excep1.getCause()); // $hasValueFlow

            Exception excep2 = new NullPointerException((String)source());
            sink((String)excep2.getMessage());  // $hasValueFlow

            StringBuilder sb = (StringBuilder)source();
            sink(sb.delete(0, 1)); // $hasValueFlow

            Thread thread1 = new Thread((Runnable)source());
            sink(thread1); // $hasTaintFlow

            Thread thread2 = new Thread((String)source());
            sink(thread2.getName()); // $hasValueFlow

            ThreadLocal threadloc = new ThreadLocal();
            threadloc.set(source());
            sink(threadloc.get()); // $hasValueFlow

            Throwable th = new Throwable((String)source());
            sink((String)th.getLocalizedMessage()); // $hasValueFlow
            sink(th.toString()); // $hasTaintFlow
        }
    }
}
