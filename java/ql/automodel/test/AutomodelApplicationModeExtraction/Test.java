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
import java.io.FileFilter;
import java.nio.file.FileVisitOption;
import java.net.URLConnection;
import java.util.concurrent.FutureTask;

class Test {
	public static void main(String[] args) throws Exception {
		AtomicReference<String> reference = new AtomicReference<>(); // uninteresting (parameterless constructor)
		reference.set( // $ sinkModelCandidate=set(Object):Argument[this]
			args[0] // $ negativeSinkExample=set(Object):Argument[0] // modeled as a flow step
		);  // not a source candidate (return type is void)
	}

	public static void callSupplier(Supplier<String> supplier) {
		supplier.get(); // not a source candidate (lambda flow)
	}

	public static void copyFiles(Path source, Path target, CopyOption option) throws Exception {
		Files.copy(
			source, // $ positiveSinkExample=copy(Path,Path,CopyOption[]):Argument[0](path-injection)
			target, // $ positiveSinkExample=copy(Path,Path,CopyOption[]):Argument[1](path-injection)
			option // no candidate (not modeled, but source and target are modeled)
		); // $ sourceModelCandidate=copy(Path,Path,CopyOption[]):ReturnValue
	}

	public static InputStream getInputStream(Path openPath) throws Exception {
		return Files.newInputStream(
			openPath // $ sinkModelCandidate=newInputStream(Path,OpenOption[]):Argument[0] positiveSinkExample=newInputStream(Path,OpenOption[]):Argument[0](path-injection) // sink candidate because "only" ai-modeled, and useful as a candidate in regression testing
		); // $ sourceModelCandidate=newInputStream(Path,OpenOption[]):ReturnValue
	}

	public static InputStream getInputStream(String openPath, String otherPath) throws Exception {
		return Test.getInputStream( // the call is not a source candidate (argument to local call)
			Paths.get(
				openPath, // $ negativeSinkExample=get(String,String[]):Argument[0] // modeled as a flow step
				otherPath
			) // $ sourceModelCandidate=get(String,String[]):ReturnValue negativeSinkExample=get(String,String[]):Argument[1]
		);
	}

	public static int compareFiles(File f1, File f2) {
		return f1.compareTo( // $ negativeSinkExample=compareTo(File):Argument[this]
			f2 // $ negativeSinkExample=compareTo(File):Argument[0] // modeled as not a sink
		); // not a source candidate (return type is int)
	}

	public static void FilesWalkExample(Path p, FileVisitOption o) throws Exception {
		Files.walk(
			p, // $ negativeSinkExample=walk(Path,FileVisitOption[]):Argument[0] // modeled as a flow step
			o, // the implicit varargs array is a candidate, annotated on the last line of the call
			o // not a candidate (only the first arg corresponding to a varargs array
			  // is extracted)
		); // $ sourceModelCandidate=walk(Path,FileVisitOption[]):ReturnValue sinkModelCandidate=walk(Path,FileVisitOption[]):Argument[1]
	}

	public static void WebSocketExample(URLConnection c) throws Exception {
		c.getInputStream(); // $ sinkModelCandidate=getInputStream():Argument[this] positiveSourceExample=getInputStream():ReturnValue(remote) // not a source candidate (manual modeling)
		c.connect(); // $ sinkModelCandidate=connect():Argument[this] // not a source candidate (return type is void)
	}

	public static void fileFilterExample(File f, FileFilter ff) {
		f.listFiles( // $ sinkModelCandidate=listFiles(FileFilter):Argument[this]
			ff
		); // $ sourceModelCandidate=listFiles(FileFilter):ReturnValue
	}
}

class OverrideTest extends Exception {
	public void printStackTrace(PrintWriter writer) { // $ sourceModelCandidate=printStackTrace(PrintWriter):Parameter[0]
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
			Files.createDirectories(
				p // $ positiveSinkExample=createDirectories(Path,FileAttribute[]):Argument[0](path-injection)
			) // $ sourceModelCandidate=createDirectories(Path,FileAttribute[]):ReturnValue negativeSinkExample=list(Path):Argument[0] // modeled as a flow step
		); // $ sourceModelCandidate=list(Path):ReturnValue

		Files.delete(
			p // $ sinkModelCandidate=delete(Path):Argument[0] positiveSinkExample=delete(Path):Argument[0](path-injection)
		); // not a source candidate (return type is void)

		Files.deleteIfExists(
			p // $ sinkModelCandidate=deleteIfExists(Path):Argument[0] positiveSinkExample=deleteIfExists(Path):Argument[0](path-injection)
		); // not a source candidate (return type is boolean)
	}
}