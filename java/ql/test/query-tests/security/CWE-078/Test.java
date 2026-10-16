import java.lang.ProcessBuilder;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

class Test {
  public static void shellCommand(String arg) throws java.io.IOException {
    ProcessBuilder pb = new ProcessBuilder("/bin/bash -c echo " + arg); // $ Alert[java/concatenated-command-line] Alert[java/command-line-injection]
    pb.start();

    pb = new ProcessBuilder(new String[]{"/bin/bash", "-c", "echo " + arg}); // $ Alert[java/command-line-injection]
    pb.start();

    List<String> cmd = new ArrayList<String>();
    cmd.add("/bin/bash");
    cmd.add("-c");
    cmd.add("echo " + arg);

    pb = new ProcessBuilder(cmd); // $ Alert[java/command-line-injection]
    pb.start();

    String[] cmd1 = new String[]{"/bin/bash", "-c", "<cmd>"};
    cmd1[1] = "echo " + arg;

    pb = new ProcessBuilder(cmd1); // $ Alert[java/command-line-injection]
    pb.start();
  }

  public static void nonShellCommand(String arg) throws java.io.IOException {
    ProcessBuilder pb = new ProcessBuilder("./customTool " + arg); // $ Alert[java/concatenated-command-line] Alert[java/command-line-injection]
    pb.start();
  }

  public static void nonShellCommandLiteralArguments(String arg) throws java.io.IOException {
    new ProcessBuilder(new String[]{"./customTool", arg}).start(); // GOOD
  }

  public static void nonShellCommandListArguments(String arg) throws java.io.IOException {
    List<String> cmd = new ArrayList<String>();
    cmd.add("./customTool");
    cmd.add(arg);
    new ProcessBuilder(cmd).start(); // GOOD
  }

  public static void nonShellCommandArrayArguments(String arg) throws java.io.IOException {
    String[] cmd1 = new String[]{"./customTool", "<arg>"};
    cmd1[1] = arg;
    new ProcessBuilder(cmd1).start(); // GOOD
  }

  public static void nonShellCommandWithIntermediateRead(String arg) throws java.io.IOException {
    List<String> readList = new ArrayList<String>();
    readList.add("./customTool");
    readList.size();
    readList.add(arg);
    new ProcessBuilder(readList).start(); // GOOD
  }

  public static void nonShellCommandWithAddAll(String arg) throws java.io.IOException {
    List<String> addAllList = new ArrayList<String>();
    addAllList.add("./customTool");
    addAllList.addAll(Arrays.asList("-v"));
    addAllList.add(arg);
    new ProcessBuilder(addAllList).start(); // GOOD
  }

  public static void delegatingLauncherLiterals(String arg) throws java.io.IOException {
    new ProcessBuilder(new String[]{"/usr/bin/env", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/sudo", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/xargs", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/sbin/chroot", "/tmp/root", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/nice", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/nohup", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/setsid", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/stdbuf", "-oL", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/timeout", "10", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/env", "/bin/sh", "-c", arg}).start(); // $ Alert[java/command-line-injection]
  }

  public static void fixedDelegatingLauncherLiteral(String arg) throws java.io.IOException {
    new ProcessBuilder(new String[]{"/usr/bin/env", "/bin/cp", arg, "/tmp/destination"}).start(); // GOOD
  }

  public static void fixedDelegatingLauncherLiteralWithPrefix(String arg)
      throws java.io.IOException {
    new ProcessBuilder(new String[]{"/usr/bin/timeout", "10", "/bin/cp", arg, "/tmp/destination"}).start(); // GOOD
  }

  public static void delegatingLauncherListAlerts(String arg, boolean condition)
      throws java.io.IOException {
    List<String> delegatedList = new ArrayList<String>();
    delegatedList.add("/usr/bin/env");
    delegatedList.add(arg);
    new ProcessBuilder(delegatedList).start(); // $ Alert[java/command-line-injection]

    List<String> branchingPosition = new ArrayList<String>();
    branchingPosition.add("/usr/bin/timeout");
    if (condition) {
      branchingPosition.add("10");
    }
    branchingPosition.add(arg);
    new ProcessBuilder(branchingPosition).start(); // $ Alert[java/command-line-injection]

    List<String> branchingLauncher = new ArrayList<String>();
    if (condition) {
      branchingLauncher.add("/usr/bin/env");
    } else {
      branchingLauncher.add("/usr/bin/timeout");
    }
    branchingLauncher.add("10");
    branchingLauncher.add(arg);
    new ProcessBuilder(branchingLauncher).start(); // $ Alert[java/command-line-injection]
  }

  public static void fixedDelegatingLauncherLaterListArgument(String arg)
      throws java.io.IOException {
    List<String> laterArgumentList = new ArrayList<String>();
    laterArgumentList.add("/usr/bin/timeout");
    laterArgumentList.add("10");
    laterArgumentList.add("/bin/cp");
    laterArgumentList.add(arg);
    laterArgumentList.add("/tmp/destination");
    new ProcessBuilder(laterArgumentList).start(); // GOOD
  }

  public static void fixedDelegatingLauncherList(String arg) throws java.io.IOException {
    List<String> fixedList = new ArrayList<String>();
    fixedList.add("/usr/bin/env");
    fixedList.add("/bin/cp");
    fixedList.add(arg);
    fixedList.add("/tmp/destination");
    new ProcessBuilder(fixedList).start(); // GOOD
  }

  public static void fixedDelegatingLauncherLoopList(String arg) throws java.io.IOException {
    List<String> loopList = new ArrayList<String>();
    loopList.add("/usr/bin/env");
    loopList.add("/bin/cp");
    for (String value : Arrays.asList(arg)) {
      loopList.add(value);
    }
    new ProcessBuilder(loopList).start(); // GOOD
  }

  public static void delegatingLauncherArrayAlerts(String arg, boolean condition)
      throws java.io.IOException {
    String[] delegatedArray = new String[2];
    delegatedArray[0] = "/usr/bin/env";
    delegatedArray[1] = arg;
    new ProcessBuilder(delegatedArray).start(); // $ Alert[java/command-line-injection]

    String launcher;
    if (condition) {
      launcher = "/usr/bin/env";
    } else {
      launcher = "/usr/bin/timeout";
    }
    new ProcessBuilder(new String[]{launcher, "10", arg}).start(); // $ Alert[java/command-line-injection]
  }

  public static void fixedDelegatingLauncherArray(String arg) throws java.io.IOException {
    String[] fixedArray = new String[]{"/usr/bin/env", "/bin/cp", "<arg>", "/tmp/destination"};
    fixedArray[2] = arg;
    new ProcessBuilder(fixedArray).start(); // GOOD
  }

  public static void changedDelegatedCommand(String arg) throws java.io.IOException {
    String[] command = new String[]{"/usr/bin/env", "/bin/cp", "-c", arg};
    command[1] = "/bin/sh";
    new ProcessBuilder(command).start(); // $ Alert[java/command-line-injection]

    String[] copiedInline =
        Arrays.copyOf(new String[]{"/usr/bin/env", "/bin/cp", "-c", arg}, 4);
    copiedInline[1] = "/bin/sh";
    new ProcessBuilder(copiedInline).start(); // $ Alert[java/command-line-injection]

    String[] base = new String[]{"/usr/bin/env", "/bin/cp", "-c", arg};
    String[] copiedStored = Arrays.copyOf(base, 4);
    copiedStored[1] = "/bin/sh";
    new ProcessBuilder(copiedStored).start(); // $ Alert[java/command-line-injection]
  }

  public static String[] returnedNonShellCommand(String arg) {
    return new String[]{"./customTool", arg};
  }

  public static void nestedNonShellCommand(String arg) throws java.io.IOException {
    new ProcessBuilder(
        arg.isEmpty()
            ? new String[]{"./customTool", arg}
            : new String[]{"./otherCustomTool", arg})
        .start(); // GOOD
  }

  public static void useReturnedNonShellCommand(String arg) throws java.io.IOException {
    new ProcessBuilder(returnedNonShellCommand(arg)).start(); // GOOD
  }

  public static void unknownDelegatedCommand(String arg, String command) throws java.io.IOException {
    new ProcessBuilder(new String[]{"/usr/bin/env", command, "-c", arg}).start(); // $ Alert[java/command-line-injection]
  }

  public static void unsupportedEnvAssignment(String arg) throws java.io.IOException {
    new ProcessBuilder(new String[]{"/usr/bin/env", "LANG=C", arg}).start(); // $ MISSING: Alert[java/command-line-injection]
  }

  public static void unsupportedSudoOption(String arg) throws java.io.IOException {
    new ProcessBuilder(new String[]{"/usr/bin/sudo", "-u", "nobody", arg}).start(); // $ MISSING: Alert[java/command-line-injection]
  }

  public static void changedDelegatedCommandThroughAlias(String arg) throws java.io.IOException {
    String[] command = new String[]{"/usr/bin/env", "/bin/cp", "-c", arg};
    String[] alias = command;
    alias[1] = "/bin/sh";
    new ProcessBuilder(command).start(); // $ Alert[java/command-line-injection]
  }

  public static void relativeCommand() throws java.io.IOException {
      ProcessBuilder pb = new ProcessBuilder("ls"); // $ Alert[java/relative-path-command]
      pb.start();

      pb = new ProcessBuilder("/bin/ls");
      pb.start();
  }

  public static void main(String[] args) throws java.io.IOException { // $ Source[java/command-line-injection]
      String arg = args.length > 1 ? args[1] : "default";

      shellCommand(arg);
      nonShellCommand(arg);
      nonShellCommandLiteralArguments(arg);
      nonShellCommandListArguments(arg);
      nonShellCommandArrayArguments(arg);
      nonShellCommandWithIntermediateRead(arg);
      nonShellCommandWithAddAll(arg);
      delegatingLauncherLiterals(arg);
      fixedDelegatingLauncherLiteral(arg);
      fixedDelegatingLauncherLiteralWithPrefix(arg);
      delegatingLauncherListAlerts(arg, args.length > 2);
      fixedDelegatingLauncherLaterListArgument(arg);
      fixedDelegatingLauncherList(arg);
      fixedDelegatingLauncherLoopList(arg);
      delegatingLauncherArrayAlerts(arg, args.length > 2);
      fixedDelegatingLauncherArray(arg);
      changedDelegatedCommand(arg);
      nestedNonShellCommand(arg);
      useReturnedNonShellCommand(arg);
      unknownDelegatedCommand(arg, "/bin/sh");
      unsupportedEnvAssignment(arg);
      unsupportedSudoOption(arg);
      changedDelegatedCommandThroughAlias(arg);
      relativeCommand();
  }
}
