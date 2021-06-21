package bsh;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.PrintStream;
import java.io.Reader;
import java.io.Serializable;
import java.io.StringReader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class Interpreter implements Runnable, ConsoleInterface, Serializable {

    public Interpreter(Reader in, PrintStream out, PrintStream err, boolean interactive, NameSpace namespace, Interpreter parent, String sourceFileInfo) { }

    public Interpreter(Reader in, PrintStream out, PrintStream err, boolean interactive, NameSpace namespace) { }

    public Interpreter(Reader in, PrintStream out, PrintStream err, boolean interactive) { }

    public Interpreter(ConsoleInterface console, NameSpace globalNameSpace) { }

    public Interpreter(ConsoleInterface console) { }

    public Interpreter() { }

    public void setConsole(ConsoleInterface console) { }

    private void initRootSystemObject() { }

    public void setNameSpace(NameSpace globalNameSpace) { }

    public NameSpace getNameSpace() {
        return null;
    }

    public static void main(String[] args) { }

    public static void invokeMain(Class clas, String[] args) throws Exception { }

    public void run() { }

    public Object source(String filename, NameSpace nameSpace) throws FileNotFoundException, IOException, EvalError {
        return null;
    }

    public Object source(String filename) throws FileNotFoundException, IOException, EvalError {
        return null;
    }

    public Object eval(Reader in, NameSpace nameSpace, String sourceFileInfo) throws EvalError {
        return null;
    }

    public Object eval(Reader in) throws EvalError {
        return null;
    }

    public Object eval(String statements) throws EvalError {
        return null;
    }

    public Object eval(String statements, NameSpace nameSpace) throws EvalError {
        return null;
    }

    private String showEvalString(String s) {
        return null;
    }

    public final void error(Object o) { }

    public Reader getIn() {
        return null;
    }

    public PrintStream getOut() {
        return null;
    }

    public PrintStream getErr() {
        return null;
    }

    public final void println(Object o) { }

    public final void print(Object o) { }

    public static final void debug(String s) { }

    public Object get(String name) throws EvalError {
        return null;
    }

    Object getu(String name) {
        return null;
    }

    public void set(String name, Object value) throws EvalError { }

    void setu(String name, Object value) { }

    public void set(String name, long value) throws EvalError { }

    public void set(String name, int value) throws EvalError { }

    public void set(String name, double value) throws EvalError { }

    public void set(String name, float value) throws EvalError { }

    public void set(String name, boolean value) throws EvalError { }

    public void unset(String name) throws EvalError { }

    public Object getInterface(Class interf) throws EvalError {
        return null;
    }
}
