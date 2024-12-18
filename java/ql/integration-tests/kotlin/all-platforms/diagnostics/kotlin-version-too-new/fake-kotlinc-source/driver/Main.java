package driver;

import java.util.ArrayList;
import java.util.List;
import org.jetbrains.kotlin.cli.common.arguments.K2JVMCompilerArguments;
import org.jetbrains.kotlin.cli.common.arguments.ParseCommandLineArgumentsKt;
import org.jetbrains.kotlin.cli.jvm.K2JVMCompiler;

public class Main {

  public static void main(String[] args) {

    List<String> compilerArgs = new ArrayList<String>();
    K2JVMCompilerArguments parsedArgs = new K2JVMCompilerArguments();
    (new ParseCommandLineArgumentsKt()).parseCommandLineArguments(compilerArgs, parsedArgs);
    (new K2JVMCompiler()).doExecute(parsedArgs, null, null, null);

  }

}
