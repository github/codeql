package com.github.codeql.test;

import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Supplier;
import java.io.File;
import java.nio.file.FileVisitOption;
import java.net.URLConnection;
import java.util.concurrent.FutureTask;

class Test {
	public static void main(String[] args) throws Exception {
		AtomicReference<String> reference = new AtomicReference<>(); // uninteresting (parameterless constructor)
		reference.set( // $ sinkModel=set(Object):Argument[this]
			args[0] // $ negativeExample=set(Object):Argument[0] // modeled as a flow step
		);  // $ negativeExample=set(Object):ReturnValue // return type is void
	}

	public static void callSupplier(Supplier<String> supplier) {
		supplier.get(); // $ sourceModel=get():ReturnValue sinkModel=get():Argument[this]
	}

	public static void copyFiles(Path source, Path target, CopyOption option) throws Exception {
		Files.copy(
			source, // positive example (known sink)
			target, // positive example (known sink)
			option // no candidate (not modeled, but source and target are modeled)
		); // $ sourceModel=copy(Path,Path,CopyOption[]):ReturnValue
	}

	public static InputStream getInputStream(Path openPath) throws Exception {
		return Files.newInputStream(
			openPath // $ sinkModel=newInputStream(Path,OpenOption[]):Argument[0] // positive example (known sink), candidate ("only" ai-modeled, and useful as a candidate in regression testing)
		); // $ sourceModel=newInputStream(Path,OpenOption[]):ReturnValue
	}

	public static InputStream getInputStream(String openPath) throws Exception {
		return Test.getInputStream( // the call is not a source candidate (argument to local call)
			Paths.get(
				openPath // $ negativeExample=get(String,String[]):Argument[0] // modeled as a flow step
			) // $ sourceModel=get(String,String[]):ReturnValue
		);
	}

	public static int compareFiles(File f1, File f2) {
		return f1.compareTo( // $ negativeExample=compareTo(File):Argument[this]
			f2 // $ negativeExample=compareTo(File):Argument[0] // modeled as not a sink
		); // $ negativeExample=compareTo(File):ReturnValue // return type is int
	}

	public static void FilesWalkExample(Path p, FileVisitOption o) throws Exception {
		Files.walk(
			p, // $ negativeExample=walk(Path,FileVisitOption[]):Argument[0] // modeled as a flow step
			o, // the implicit varargs array is a candidate, annotated on the last line of the call
			o // not a candidate (only the first arg corresponding to a varargs array
			  // is extracted)
		); // $ sourceModel=walk(Path,FileVisitOption[]):ReturnValue sinkModel=walk(Path,FileVisitOption[]):Argument[1]
	}

	public static void WebSocketExample(URLConnection c) throws Exception {
		c.getInputStream(); // $ sinkModel=getInputStream():Argument[this] // not a source candidate (manual modeling)
	}
}

class OverrideTest extends Exception {
	public void printStackTrace(PrintWriter writer) { // $ sourceModel=printStackTrace(PrintWriter):Parameter[0]
		return;
	}

}

class TaskUtils {
	public FutureTask getTask() {
		FutureTask ft = new FutureTask(() -> {
			//           ^-- no sink candidate for the `this` qualifier of a constructor
			return 42;
		});
		return ft;
	}
}

class MoreTests {
	public static void FilesListExample(Path p) throws Exception {
		Files.list(
			Files.createDirectories(p) // $ sourceModel=createDirectories(Path,FileAttribute[]):ReturnValue negativeExample=list(Path):Argument[0] // modeled as a flow step
		); // $ sourceModel=list(Path):ReturnValue

		Files.delete(
			p // $ sinkModel=delete(Path):Argument[0]
		); // $ negativeExample=delete(Path):ReturnValue // return type is void

		Files.deleteIfExists(
			p // $ sinkModel=deleteIfExists(Path):Argument[0]
		); // $ negativeExample=deleteIfExists(Path):ReturnValue // return type is boolean
	}
}