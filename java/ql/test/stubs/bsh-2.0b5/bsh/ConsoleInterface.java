package bsh;

import java.io.PrintStream;
import java.io.Reader;

public interface ConsoleInterface {
    Reader getIn();

    PrintStream getOut();

    PrintStream getErr();

    void println(Object var1);

    void print(Object var1);

    void error(Object var1);
}
