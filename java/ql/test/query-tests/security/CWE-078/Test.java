import java.lang.ProcessBuilder;
import java.util.List;
import java.util.ArrayList;

class Test {
  public static void shellCommand(String arg) throws java.io.IOException {
    ProcessBuilder pb = new ProcessBuilder("/bin/bash -c echo " + arg);
    pb.start();

    pb = new ProcessBuilder(new String[]{"/bin/bash", "-c", "echo " + arg});
    pb.start();

    List<String> cmd = new ArrayList<String>();
    cmd.add("/bin/bash");
    cmd.add("-c");
    cmd.add("echo " + arg);

    pb = new ProcessBuilder(cmd);
    pb.start();

    String[] cmd1 = new String[]{"/bin/bash", "-c", "<cmd>"};
    cmd1[1] = "echo " + arg;

    pb = new ProcessBuilder(cmd1);
    pb.start();
  }

  public static void nonShellCommand(String arg) throws java.io.IOException {
    ProcessBuilder pb = new ProcessBuilder("./customTool " + arg);
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

  public static void relativeCommand() throws java.io.IOException {
      ProcessBuilder pb = new ProcessBuilder("ls");
      pb.start();

      pb = new ProcessBuilder("/bin/ls");
      pb.start();
  }

  public static void main(String[] args) throws java.io.IOException {
      String arg = args.length > 1 ? args[1] : "default";

      shellCommand(arg);
      nonShellCommand(arg);
      relativeCommand();
  }
}
