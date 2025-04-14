package com.example;

import java.util.regex.Pattern;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Hello world!
 *
 */
public class App2 
{
    public static void main( String[] args )
    {
        System.out.println( "Hello World!" );
        String expectedVersion = System.getenv("EXPECT_MAVEN");
        Path mavenHome = Paths.get(System.getProperty("maven.home")).normalize();
        String observedVersion = mavenHome.getFileName().toString();
        if (expectedVersion != null && !expectedVersion.equals(observedVersion)) {
                System.err.println("Wrong maven version, expected '" + expectedVersion + "' but got '" + observedVersion + "'" + mavenHome);
                System.exit(1);
        }
        String commandMatcher = System.getenv("EXPECT_COMMAND_REGEX");
        String command = System.getProperty("sun.java.command");
        if (commandMatcher != null && !Pattern.matches(commandMatcher, command)) {
                System.err.println("Wrong command line, '" + command + "' does not match '" + commandMatcher + "'");
                System.exit(1);
        }
    }
}
