package com.semmle.js.parser;

import ch.qos.logback.classic.Level;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;
import com.semmle.js.parser.JSParser.Result;
import com.semmle.ts.extractor.TypeTable;
import com.semmle.util.data.StringUtil;
import com.semmle.util.data.UnitParser;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.Exceptions;
import com.semmle.util.exception.InterruptedError;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.exception.UserError;
import com.semmle.util.io.WholeIO;
import com.semmle.util.logging.LogbackUtils;
import com.semmle.util.process.AbstractProcessBuilder;
import com.semmle.util.process.Builder;
import com.semmle.util.process.Env;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.lang.ProcessBuilder.Redirect;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * The Java half of our wrapper for invoking the TypeScript parser.
 *
 * <p>The Node.js half of the wrapper is expected to live at {@code
 * $SEMMLE_DIST/tools/typescript-parser-wrapper/main.js}; non-standard locations can be configured
 * using the property {@value #PARSER_WRAPPER_PATH_ENV_VAR}.
 *
 * <p>The script launches the Node.js wrapper in the Node.js runtime, looking for {@code node} on
 * the {@code PATH} by default. Non-standard locations can be configured using the property {@value
 * #TYPESCRIPT_NODE_RUNTIME_VAR}, and additional arguments can be configured using the property
 * {@value #TYPESCRIPT_NODE_RUNTIME_EXTRA_ARGS_VAR}.
 *
 * <p>The script is started upon parsing the first TypeScript file and then is kept running in the
 * background, passing it requests for parsing files and getting JSON-encoded ASTs as responses.
 */
public class TypeScriptParser {
  /**
   * An environment variable that can be set to indicate the location of the TypeScript parser
   * wrapper when running without SEMMLE_DIST.
   */
  public static final String PARSER_WRAPPER_PATH_ENV_VAR = "SEMMLE_TYPESCRIPT_PARSER_WRAPPER";

  /**
   * An environment variable that can be set to indicate the location of the Node.js runtime, as an
   * alternative to adding Node to the PATH.
   */
  public static final String TYPESCRIPT_NODE_RUNTIME_VAR = "SEMMLE_TYPESCRIPT_NODE_RUNTIME";

  /**
   * An environment variable that can be set to provide additional arguments to the Node.js runtime
   * each time it is invoked. Arguments should be separated by spaces.
   */
  public static final String TYPESCRIPT_NODE_RUNTIME_EXTRA_ARGS_VAR =
      "SEMMLE_TYPESCRIPT_NODE_RUNTIME_EXTRA_ARGS";

  /**
   * An environment variable that can be set to specify a timeout to use when verifying the
   * TypeScript installation, in milliseconds. Default is 10000.
   */
  public static final String TYPESCRIPT_TIMEOUT_VAR = "SEMMLE_TYPESCRIPT_TIMEOUT";

  /**
   * An environment variable (without the <tt>SEMMLE_</tt> or <tt>LGTM_</tt> prefix), that can be
   * set to indicate the maximum heap space usable by the Node.js process, in addition to its
   * "reserve memory".
   *
   * <p>Defaults to 1.0 GB (for a total heap space of 1.4 GB by default).
   */
  public static final String TYPESCRIPT_RAM_SUFFIX = "TYPESCRIPT_RAM";

  /**
   * An environment variable (without the <tt>SEMMLE_</tt> or <tt>LGTM_</tt> prefix), that can be
   * set to indicate the amount of heap space the Node.js process should reserve for extracting
   * individual files.
   *
   * <p>When less than this amount of memory is available, the TypeScript compiler instance is
   * restarted to free space.
   *
   * <p>Defaults to 400 MB (for a total heap space of 1.4 GB by default).
   */
  public static final String TYPESCRIPT_RAM_RESERVE_SUFFIX = "TYPESCRIPT_RAM_RESERVE";

  /**
   * An environment variable with additional VM arguments to pass to the Node process.
   *
   * <p>Only <code>--inspect</code> or <code>--inspect-brk</code> may be used at the moment.
   */
  public static final String TYPESCRIPT_NODE_FLAGS = "SEMMLE_TYPESCRIPT_NODE_FLAGS";

  /** The Node.js parser wrapper process, if it has been started already. */
  private Process parserWrapperProcess;

  private String parserWrapperCommand;

  /** Streams for communicating with the Node.js parser wrapper process. */
  private BufferedWriter toParserWrapper;

  private BufferedReader fromParserWrapper;

  private String nodeJsVersionString;

  /** Command to launch the Node.js runtime. Initialised by {@link #verifyNodeInstallation}. */
  private String nodeJsRuntime;

  /**
   * Arguments to pass to the Node.js runtime each time it is invoked. Initialised by {@link
   * #verifyNodeInstallation}.
   */
  private List<String> nodeJsRuntimeExtraArgs = Collections.emptyList();

  /** If non-zero, we use this instead of relying on the corresponding environment variable. */
  private int typescriptRam = 0;

  /** Sets the amount of RAM to allocate to the TypeScript compiler.s */
  public void setTypescriptRam(int megabytes) {
    this.typescriptRam = megabytes;
  }

  /**
   * Verifies that Node.js and TypeScript are installed and throws an exception otherwise.
   *
   * @param verbose if true, log the Node.js executable path, version strings, and any additional
   *     arguments.
   */
  public void verifyInstallation(boolean verbose) {
    verifyNodeInstallation();
    if (verbose) {
      System.out.println("Found Node.js at: " + nodeJsRuntime);
      System.out.println("Found Node.js version: " + nodeJsVersionString);
      if (!nodeJsRuntimeExtraArgs.isEmpty()) {
        System.out.println("Additional arguments for Node.js: " + nodeJsRuntimeExtraArgs);
      }
    }
  }

  /** Checks that Node.js is installed and can be run and returns its version string. */
  public String verifyNodeInstallation() {
    if (nodeJsVersionString != null) return nodeJsVersionString;

    ByteArrayOutputStream out = new ByteArrayOutputStream();
    ByteArrayOutputStream err = new ByteArrayOutputStream();

    // Determine where to find the Node.js runtime.
    String explicitNodeJsRuntime = Env.systemEnv().get(TYPESCRIPT_NODE_RUNTIME_VAR);
    if (explicitNodeJsRuntime != null) {
      // Use the specified Node.js executable.
      nodeJsRuntime = explicitNodeJsRuntime;
    } else {
      // Look for `node` on the PATH.
      nodeJsRuntime = "node";
    }

    // Determine any additional arguments to be passed to Node.js each time it's called.
    String extraArgs = Env.systemEnv().get(TYPESCRIPT_NODE_RUNTIME_EXTRA_ARGS_VAR);
    if (extraArgs != null) {
      nodeJsRuntimeExtraArgs = Arrays.asList(extraArgs.split("\\s+"));
    }

    Builder b =
        new Builder(
            getNodeJsRuntimeInvocation("--version"), out, err, getParserWrapper().getParentFile());
    b.expectFailure(); // We want to do our own logging in case of an error.

    int timeout = Env.systemEnv().getInt(TYPESCRIPT_TIMEOUT_VAR, 10000);
    try {
      int r = b.execute(timeout);
      String stdout = new String(out.toByteArray());
      String stderr = new String(err.toByteArray());
      if (r != 0 || stdout.length() == 0) {
        throw new CatastrophicError(
            "Could not start Node.js. It is required for TypeScript extraction.\n" + stderr);
      }
      return nodeJsVersionString = stdout;
    } catch (InterruptedError e) {
      Exceptions.ignore(e, "Exception details are not important.");
      throw new CatastrophicError(
          "Could not start Node.js (timed out after " + (timeout / 1000) + "s).");
    } catch (ResourceError e) {
      // In case 'node' is not found, the process builder converts the IOException
      // into a ResourceError.
      Exceptions.ignore(e, "We rewrite this into a UserError");
      throw new UserError(
          "Could not start Node.js. It is required for TypeScript extraction."
              + "\nPlease install Node.js and ensure 'node' is on the PATH.");
    }
  }

  /**
   * Gets a command line to invoke the Node.js runtime. Any arguments in {@link
   * TypeScriptParser#nodeJsRuntimeExtraArgs} are passed first, followed by those in {@code args}.
   */
  private List<String> getNodeJsRuntimeInvocation(String... args) {
    List<String> result = new ArrayList<>();
    result.add(nodeJsRuntime);
    result.addAll(nodeJsRuntimeExtraArgs);
    for (String arg : args) {
      result.add(arg);
    }
    return result;
  }

  private static int getMegabyteCountFromPrefixedEnv(String suffix, int defaultValue) {
    String envVar = "SEMMLE_" + suffix;
    String value = Env.systemEnv().get(envVar);
    if (value == null || value.length() == 0) {
      envVar = "LGTM_" + suffix;
      value = Env.systemEnv().get(envVar);
    }
    if (value == null || value.length() == 0) {
      return defaultValue;
    }
    Integer amount = UnitParser.parseOpt(value, UnitParser.MEGABYTES);
    if (amount == null) {
      throw new UserError("Invalid value for " + envVar + ": '" + value + "'");
    }
    return amount;
  }

  /** Start the Node.js parser wrapper process. */
  private void setupParserWrapper() {
    verifyNodeInstallation();

    int mainMemoryMb =
        typescriptRam != 0
            ? typescriptRam
            : getMegabyteCountFromPrefixedEnv(TYPESCRIPT_RAM_SUFFIX, 1000);
    int reserveMemoryMb = getMegabyteCountFromPrefixedEnv(TYPESCRIPT_RAM_RESERVE_SUFFIX, 400);

    File parserWrapper = getParserWrapper();

    String debugFlagString = Env.systemEnv().getNonEmpty(TYPESCRIPT_NODE_FLAGS);
    List<String> debugFlags = new ArrayList<>();
    if (debugFlagString != null) {
      for (String flag : debugFlagString.split(" ")) {
        if (!flag.startsWith("--inspect") || flag.contains(":")) {
          System.err.println("Ignoring unrecognized Node flag: '" + flag + "'");
        } else {
          debugFlags.add(flag);
        }
      }
    }

    List<String> cmd = getNodeJsRuntimeInvocation();
    cmd.add("--max_old_space_size=" + (mainMemoryMb + reserveMemoryMb));
    cmd.addAll(debugFlags);
    cmd.add(parserWrapper.getAbsolutePath());

    ProcessBuilder pb = new ProcessBuilder(cmd);
    parserWrapperCommand = StringUtil.glue(" ", cmd);
    pb.environment().put("SEMMLE_TYPESCRIPT_MEMORY_THRESHOLD", "" + mainMemoryMb);

    try {
      pb.redirectError(Redirect.INHERIT); // Forward stderr to our own stderr.
      parserWrapperProcess = pb.start();
      OutputStream os = parserWrapperProcess.getOutputStream();
      OutputStreamWriter osw = new OutputStreamWriter(os, "UTF-8");
      toParserWrapper = new BufferedWriter(osw);
      InputStream is = parserWrapperProcess.getInputStream();
      InputStreamReader isr = new InputStreamReader(is, "UTF-8");
      fromParserWrapper = new BufferedReader(isr);
    } catch (IOException e) {
      throw new CatastrophicError(
          "Could not start TypeScript parser wrapper " + "(command: ." + parserWrapperCommand + ")",
          e);
    }
  }

  /** Get the location of the Node.js parser wrapper script. */
  private File getParserWrapper() {
    File parserWrapper;
    LogbackUtils.getLogger(AbstractProcessBuilder.class).setLevel(Level.INFO);
    String explicitPath = Env.systemEnv().get(PARSER_WRAPPER_PATH_ENV_VAR);
    String semmleDistVar = Env.systemEnv().get(Env.Var.SEMMLE_DIST.name());
    if (semmleDistVar != null && !semmleDistVar.isEmpty()) {
      parserWrapper = new File(semmleDistVar, "tools/typescript-parser-wrapper/main.js");
    } else if (explicitPath != null) {
      parserWrapper = new File(explicitPath);
    } else {
      throw new CatastrophicError(
          "Could not find TypeScript parser: " + Env.Var.SEMMLE_DIST.name() + " is not set.");
    }
    if (!parserWrapper.isFile())
      throw new ResourceError(
          "Could not find TypeScript parser: " + parserWrapper + " does not exist.");
    return parserWrapper;
  }

  /**
   * Send a {@code request} to the Node.js parser wrapper process, and return the response it
   * replies with.
   */
  private JsonObject talkToParserWrapper(JsonObject request) {
    if (parserWrapperProcess == null) setupParserWrapper();

    if (!parserWrapperProcess.isAlive()) {
      int exitCode = 0;
      try {
        exitCode = parserWrapperProcess.waitFor();
      } catch (InterruptedException e) {
        Exceptions.ignore(e, "This is for diagnostic purposes only.");
      }
      String err = new WholeIO().strictReadString(parserWrapperProcess.getErrorStream());
      throw new CatastrophicError(
          "TypeScript parser wrapper terminated with exit code " + exitCode + "; stderr: " + err);
    }

    String response = null;
    try {
      toParserWrapper.write(request.toString());
      toParserWrapper.newLine();
      toParserWrapper.flush();
      response = fromParserWrapper.readLine();
      if (response == null)
        throw new CatastrophicError(
            "Could not communicate with TypeScript parser wrapper "
                + "(command: "
                + parserWrapperCommand
                + ").");
      return new JsonParser().parse(response).getAsJsonObject();
    } catch (IOException e) {
      throw new CatastrophicError(
          "Could not communicate with TypeScript parser wrapper "
              + "(command: ."
              + parserWrapperCommand
              + ").",
          e);
    } catch (JsonParseException | IllegalStateException e) {
      throw new CatastrophicError(
          "TypeScript parser wrapper sent unexpected response: "
              + response
              + " (command: "
              + parserWrapperCommand
              + ").",
          e);
    }
  }

  /**
   * Returns the AST for a given source file.
   *
   * <p>Type information will be available if the file is part of a currently open project, although
   * this is not yet implemented.
   *
   * <p>If the file is not part of a project, only syntactic information will be extracted.
   */
  public Result parse(File sourceFile, String source) {
    JsonObject request = new JsonObject();
    request.add("command", new JsonPrimitive("parse"));
    request.add("filename", new JsonPrimitive(sourceFile.getAbsolutePath()));
    JsonObject response = talkToParserWrapper(request);
    try {
      checkResponseType(response, "ast");
      JsonObject nodeFlags = response.get("nodeFlags").getAsJsonObject();
      JsonObject syntaxKinds = response.get("syntaxKinds").getAsJsonObject();
      JsonObject ast = response.get("ast").getAsJsonObject();
      return new TypeScriptASTConverter(nodeFlags, syntaxKinds).convertAST(ast, source);
    } catch (IllegalStateException e) {
      throw new CatastrophicError(
          "TypeScript parser wrapper sent unexpected response: " + response, e);
    }
  }

  /**
   * Informs the parser process that the following files are going to be requested, in that order.
   *
   * <p>The parser process uses this list to start work on the next file before it is requested.
   */
  public void prepareFiles(List<File> files) {
    JsonObject request = new JsonObject();
    request.add("command", new JsonPrimitive("prepare-files"));
    JsonArray filenames = new JsonArray();
    for (File file : files) {
      filenames.add(new JsonPrimitive(file.getAbsolutePath()));
    }
    request.add("filenames", filenames);
    JsonObject response = talkToParserWrapper(request);
    checkResponseType(response, "ok");
  }

  /**
   * Opens a new project based on a tsconfig.json file. The compiler will analyze all files in the
   * project.
   *
   * <p>Call {@link #parse} to access individual files in the project.
   *
   * <p>Only one project should be opened at once.
   */
  public ParsedProject openProject(File tsConfigFile) {
    JsonObject request = new JsonObject();
    request.add("command", new JsonPrimitive("open-project"));
    request.add("tsConfig", new JsonPrimitive(tsConfigFile.getPath()));
    JsonObject response = talkToParserWrapper(request);
    try {
      checkResponseType(response, "project-opened");
      ParsedProject project = new ParsedProject(tsConfigFile);
      JsonArray filesJson = response.get("files").getAsJsonArray();
      for (JsonElement elm : filesJson) {
        project.addSourceFile(new File(elm.getAsString()));
      }
      return project;
    } catch (IllegalStateException e) {
      throw new CatastrophicError(
          "TypeScript parser wrapper sent unexpected response: " + response, e);
    }
  }

  /**
   * Closes a project previously opened.
   *
   * <p>This main purpose is to free heap space in the Node.js process.
   */
  public void closeProject(File tsConfigFile) {
    JsonObject request = new JsonObject();
    request.add("command", new JsonPrimitive("close-project"));
    request.add("tsConfig", new JsonPrimitive(tsConfigFile.getPath()));
    JsonObject response = talkToParserWrapper(request);
    try {
      checkResponseType(response, "project-closed");
    } catch (IllegalStateException e) {
      throw new CatastrophicError(
          "TypeScript parser wrapper sent unexpected response: " + response, e);
    }
  }

  public TypeTable getTypeTable() {
    JsonObject request = new JsonObject();
    request.add("command", new JsonPrimitive("get-type-table"));
    JsonObject response = talkToParserWrapper(request);
    try {
      checkResponseType(response, "type-table");
      return new TypeTable(response.get("typeTable").getAsJsonObject());
    } catch (IllegalStateException e) {
      throw new CatastrophicError(
          "TypeScript parser wrapper sent unexpected response: " + response, e);
    }
  }

  /**
   * Closes any open project, and in general, brings the TypeScript wrapper to a fresh state as if
   * it had just been restarted.
   *
   * <p>This is to ensure tests are isolated but without the cost of restarting the Node.js process.
   */
  public void reset() {
    try {
      resetInternal();
    } catch (CatastrophicError e) {
      Exceptions.ignore(e, "Restarting process instead");
      killProcess();
    }
  }

  private void resetInternal() {
    if (parserWrapperProcess == null) {
      return; // Ignore reset requests if the process is not running.
    }
    JsonObject request = new JsonObject();
    request.add("command", new JsonPrimitive("reset"));
    JsonObject response = talkToParserWrapper(request);
    try {
      checkResponseType(response, "reset-done");
    } catch (IllegalStateException e) {
      throw new CatastrophicError(
          "TypeScript parser wrapper sent unexpected response: " + response, e);
    }
  }

  private void checkResponseType(JsonObject response, String type) {
    JsonElement typeElm = response.get("type");
    // Report unexpected response types as an internal error.
    if (typeElm == null || !typeElm.getAsString().equals(type)) {
      throw new CatastrophicError(
          "TypeScript parser sent unexpected response: " + response + ". Expected " + type);
    }
  }

  private void tryClose(Closeable stream) {
    if (stream == null) return;
    try {
      stream.close();
    } catch (IOException e) {
      Exceptions.ignore(e, "Closing stream");
    }
  }

  /**
   * Forcibly closes the Node.js process.
   *
   * <p>A new process will be started the next time a request is made.
   */
  public void killProcess() {
    if (parserWrapperProcess != null) {
      parserWrapperProcess.destroy();
      parserWrapperProcess = null;
    }
    tryClose(toParserWrapper);
    tryClose(fromParserWrapper);
    toParserWrapper = null;
    fromParserWrapper = null;
  }
}
