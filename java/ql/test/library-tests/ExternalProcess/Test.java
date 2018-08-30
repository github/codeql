import java.io.IOException;
import java.util.ArrayList;
import org.apache.commons.exec.*;

class Test {
	void pbuilderConstructor2() {
		new ProcessBuilder("cmd", "arg1", "arg2");
	}

	void pbuilderConstructorList() {
		ArrayList args = new ArrayList();
		args.add("cmd");
		args.add("arg1");
		new ProcessBuilder(args);
	}

	void pbuilderSetter() {
		ProcessBuilder pbuilder = new ProcessBuilder();
		pbuilder.command("cmd", "arg1", "arg2");
	}

	void pbuilderSetterList() {
		ArrayList args = new ArrayList();
		args.add("cmd");
		args.add("arg1");
		ProcessBuilder pbuilder = new ProcessBuilder();
		pbuilder.command(args);
	}

	void runtimeExec() throws IOException {
		Runtime.getRuntime().exec("cmd arg1 arg2");
	}

	void runtimeExecArray() throws IOException {
		Runtime.getRuntime().exec(new String[] { "cmd", "arg1", "arg2" });
	}

	void execOnOtherClass() {
		class Bogus {
			void exec(String command) {
			}
		}
		new Bogus().exec("Irrelevant version of exec");
	}

	void apacheExecute1() {
		String line = "AcroRd32.exe /p /h some.file";
		CommandLine cmdLine = CommandLine.parse(line);
		DefaultExecutor executor = new DefaultExecutor();
		int exitValue = executor.execute(cmdLine);
	}

	void apacheExecute2() {
		String line = "AcroRd32.exe /p /h some.file";
		CommandLine cmdLine = CommandLine.parse(line, null);
		DefaultExecutor executor = new DefaultExecutor();
		int exitValue = executor.execute(cmdLine);
	}

	void apacheExecute3() {
		CommandLine cmdLine = new CommandLine("AcroRd32.exe");
		cmdLine.addArguments("/p /h some.file");
		DefaultExecutor executor = new DefaultExecutor();
		int exitValue = executor.execute(cmdLine);
	}

	void apacheExecute4() {
		CommandLine cmdLine = new CommandLine("AcroRd32.exe");
		cmdLine.addArguments("/p /h some.file", false);
		DefaultExecutor executor = new DefaultExecutor();
		int exitValue = executor.execute(cmdLine);
	}
}
