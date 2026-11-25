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

    pb = new ProcessBuilder(new String[]{"./customTool", arg});
    pb.start();

    List<String> cmd = new ArrayList<String>();
    cmd.add("./customTool");
    cmd.add(arg);

    pb = new ProcessBuilder(cmd);
    pb.start();

    String[] cmd1 = new String[]{"./customTool", "<arg>"};
    cmd1[1] = arg;

    pb = new ProcessBuilder(cmd1);
    pb.start();
  }

  private static final String TOOL = "/bin/cp";

  private static String getTool() {
    return "/bin/cp";
  }

  public static String[] returnedSafeDelegatedCommand(String arg) {
    return new String[]{"/usr/bin/env", "/bin/cp", arg};
  }

  public static String[] returnedUnsafeDelegatedCommand(String arg) {
    return new String[]{"/usr/bin/env", arg};
  }

  public static void delegatingLauncherLiterals(String arg) throws java.io.IOException {
    Runtime.getRuntime().exec(new String[]{"env", arg}); // $ Alert[java/command-line-injection] Alert[java/relative-path-command]
    new ProcessBuilder(new String[]{"/usr/bin/env", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"C:\\cygwin64\\bin\\env.exe", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/sudo", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/xargs", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/sbin/chroot", "/tmp/root", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/nice", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/nohup", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/setsid", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/stdbuf", "-oL", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/timeout", "10", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/env", "/bin/sh", "-c", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/sudo", "/usr/bin/env", arg}).start(); // $ Alert[java/command-line-injection]
    new ProcessBuilder(returnedUnsafeDelegatedCommand(arg)).start(); // $ Alert[java/command-line-injection]
  }

  public static void safeDelegatingLauncherArrays(String arg, boolean condition)
      throws java.io.IOException {
    new ProcessBuilder(new String[]{"/usr/bin/env", "/bin/cp", arg, "/tmp/destination"}).start(); // GOOD
    new ProcessBuilder(new String[]{"C:\\cygwin64\\bin\\env.exe", "/bin/cp", arg, "/tmp/destination"}).start(); // GOOD
    new ProcessBuilder(new String[]{"/usr/bin/timeout", "10", "/bin/cp", arg, "/tmp/destination"}).start(); // GOOD
    new ProcessBuilder(new String[]{"/usr/bin/env", getTool(), arg}).start(); // GOOD
    new ProcessBuilder(new String[]{"/usr/bin/env", TOOL, arg}).start(); // GOOD
    new ProcessBuilder(returnedSafeDelegatedCommand(arg)).start(); // GOOD
    new ProcessBuilder(
        condition
            ? new String[]{"/usr/bin/env", "/bin/cp", arg}
            : new String[]{"/usr/bin/nice", "/bin/cp", arg})
        .start(); // GOOD

    String[] fixedArray = new String[]{"/usr/bin/env", "/bin/cp", "<arg>", "/tmp/destination"};
    fixedArray[2] = arg;
    new ProcessBuilder(fixedArray).start(); // GOOD

    String[] copiedArray = Arrays.copyOf(fixedArray, 4);
    copiedArray[2] = arg;
    new ProcessBuilder(copiedArray).start(); // GOOD
  }

  public static void delegatingLauncherListAlerts(String arg, boolean condition)
      throws java.io.IOException {
    List<String> delegatedList = new ArrayList<String>();
    delegatedList.add("/usr/bin/env");
    delegatedList.add(arg);
    new ProcessBuilder(delegatedList).start(); // $ Alert[java/command-line-injection]

    List<String> delegatedShellList = new ArrayList<String>();
    delegatedShellList.add("/usr/bin/env");
    delegatedShellList.add("/bin/sh");
    delegatedShellList.add("-c");
    delegatedShellList.add(arg);
    new ProcessBuilder(delegatedShellList).start(); // $ Alert[java/command-line-injection]

    List<String> delegatedAddAllList = new ArrayList<String>();
    delegatedAddAllList.add("/usr/bin/env");
    delegatedAddAllList.addAll(Arrays.asList(arg, "/tmp/destination"));
    new ProcessBuilder(delegatedAddAllList).start(); // $ Alert[java/command-line-injection]

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

  public static void safeDelegatingLauncherLists(String arg, boolean condition)
      throws java.io.IOException {
    List<String> fixedList = new ArrayList<String>();
    fixedList.add("/usr/bin/env");
    fixedList.add("/bin/cp");
    fixedList.add(arg);
    fixedList.add("/tmp/destination");
    new ProcessBuilder(fixedList).start(); // GOOD

    List<String> laterArgumentList = new ArrayList<String>();
    laterArgumentList.add("/usr/bin/timeout");
    laterArgumentList.add("10");
    laterArgumentList.add("/bin/cp");
    laterArgumentList.add(arg);
    laterArgumentList.add("/tmp/destination");
    new ProcessBuilder(laterArgumentList).start(); // GOOD

    List<String> loopList = new ArrayList<String>();
    loopList.add("/usr/bin/env");
    loopList.add("/bin/cp");
    for (String value : Arrays.asList(arg)) {
      loopList.add(value);
    }
    new ProcessBuilder(loopList).start(); // GOOD

    List<String> readList = new ArrayList<String>();
    readList.add("/usr/bin/env");
    readList.size();
    readList.add("/bin/cp");
    readList.add(arg);
    new ProcessBuilder(readList).start(); // GOOD

    List<String> addAllList = new ArrayList<String>();
    addAllList.add("/usr/bin/env");
    addAllList.add("/bin/cp");
    addAllList.addAll(Arrays.asList("-r"));
    addAllList.add(arg);
    new ProcessBuilder(addAllList).start(); // GOOD

    List<String> branchingFlagList = new ArrayList<String>();
    branchingFlagList.add("/usr/bin/sudo");
    if (condition) {
      branchingFlagList.add("-n");
    }
    branchingFlagList.add("/bin/cp");
    branchingFlagList.add(arg);
    new ProcessBuilder(branchingFlagList).start(); // GOOD
  }

  public static void delegatingLauncherArrayAlerts(String arg, boolean condition)
      throws java.io.IOException {
    String[] delegatedArray = new String[2];
    delegatedArray[0] = "/usr/bin/env";
    delegatedArray[1] = arg;
    new ProcessBuilder(delegatedArray).start(); // $ Alert[java/command-line-injection]

    String[] changedCommand = new String[]{"/usr/bin/env", "/bin/cp", "-c", "<arg>"};
    changedCommand[1] = "/bin/sh";
    changedCommand[3] = arg;
    new ProcessBuilder(changedCommand).start(); // $ Alert[java/command-line-injection]

    String launcher;
    if (condition) {
      launcher = "/usr/bin/env";
    } else {
      launcher = "/usr/bin/timeout";
    }
    new ProcessBuilder(new String[]{launcher, "10", arg}).start(); // $ Alert[java/command-line-injection]
  }

  public static void launcherMayBeShell(String arg, boolean condition)
      throws java.io.IOException {
    String launcher;
    if (condition) {
      launcher = "/usr/bin/env";
    } else {
      launcher = "/bin/sh";
    }
    new ProcessBuilder(new String[]{launcher, "-c", arg}).start(); // $ Alert[java/command-line-injection]

    String[] command = new String[3];
    command[0] = launcher;
    command[1] = "-c";
    command[2] = arg;
    new ProcessBuilder(command).start(); // $ Alert[java/command-line-injection]

    List<String> list = new ArrayList<String>();
    list.add(launcher);
    list.add("-c");
    list.add(arg);
    new ProcessBuilder(list).start(); // $ Alert[java/command-line-injection]
  }

  public static void unsupportedCases(String arg, String command) throws java.io.IOException {
    new ProcessBuilder(new String[]{"/usr/bin/env", "LANG=C", arg}).start(); // $ MISSING: Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/sudo", "-u", "nobody", arg}).start(); // $ MISSING: Alert[java/command-line-injection]
    new ProcessBuilder(new String[]{"/usr/bin/env", command, "-c", arg}).start(); // $ MISSING: Alert[java/command-line-injection]

    String[] mutatedInline = new String[]{"/usr/bin/env", "/bin/cp", "-c", arg};
    mutatedInline[1] = "/bin/sh";
    new ProcessBuilder(mutatedInline).start(); // $ MISSING: Alert[java/command-line-injection]
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
      delegatingLauncherLiterals(arg);
      safeDelegatingLauncherArrays(arg, args.length > 2);
      delegatingLauncherListAlerts(arg, args.length > 2);
      safeDelegatingLauncherLists(arg, args.length > 2);
      delegatingLauncherArrayAlerts(arg, args.length > 2);
      launcherMayBeShell(arg, args.length > 2);
      unsupportedCases(arg, "/bin/sh");
      relativeCommand();
  }
}
