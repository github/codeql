package com.semmle.util.files;


import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FilePermission;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.lang.reflect.UndeclaredThrowableException;
import java.net.Socket;
import java.nio.charset.Charset;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.BitSet;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Random;
import java.util.Set;
import java.util.Stack;
import java.util.regex.Pattern;

import com.github.codeql.Logger;
import com.github.codeql.Severity;

import com.semmle.util.basic.ObjectUtil;
import com.semmle.util.data.Pair;
import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.Exceptions;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.files.PathMatcher.Mode;
import com.semmle.util.io.StreamUtil;
import com.semmle.util.io.csv.CSVReader;
import com.semmle.util.io.csv.CSVWriter;
import com.semmle.util.process.Env;
import com.semmle.util.process.Env.OS;


public class FileUtil
{
	public static Logger logger = null;

	/**
	 * Regular expression pattern for invalid filename characters
	 */
	private final static Pattern rpInvalidFilenameCharacters = Pattern.compile("[\\\\/:*?\"'<>|@]");

	/**
	 * The UTF-8 Charset
	 */
	public static final Charset UTF8   = Charset.forName("UTF-8");


	/**
	 * List all children of a directory. This throws sensible errors if there is a problem listing the
	 * directory, unlike Java's <code>listFiles</code> method (which just returns <code>null</code>).
	 * Equivalent to <code>list(f, null)</code>.
	 *
	 * @param f the directory in which to list children
	 * @return the children of <code>f</code> (empty if <code>f</code> is an empty directory)
	 * @throws ResourceError with an appropriate message if <code>f</code> does not exist, is not a
	 *           directory, cannot be read, or some other error occurred.
	 */
	public static File[] list (File f)
	{
		return list(f, null);
	}

	/**
	 * List all children of a directory, with an optional filter. This throws sensible errors if there
	 * is a problem listing the directory, unlike Java's <code>listFiles</code> method (which just
	 * returns <code>null</code>). It also sorts the files by their file name, so that the result is
	 * stable.
	 *
	 * @param f the directory in which to list children
	 * @param filter the filter to use for selecting which files to return, or <code>null</code>
	 * @return the children of <code>f</code> (empty if <code>f</code> is an empty directory)
	 * @throws ResourceError with an appropriate message if <code>f</code> does not exist, is not a
	 *           directory, cannot be read, or some other error occurred.
	 */
	public static File[] list (File f, FileFilter filter)
	{
		File[] files = filter == null ? f.listFiles() : f.listFiles(filter);
		if (files == null) {
			boolean exists = f.exists();
			boolean isDirectory = f.isDirectory();
			boolean canRead = f.canRead();
			throw new ResourceError("Could not list the contents of directory "
			                        + f
			                        + " - "
			                        + (!exists
			                                  ? "file does not exist."
			                                  : !isDirectory
			                                                ? "file is not a directory."
			                                                : !canRead
			                                                          ? "cannot read - permission denied."
			                                                          : "unknown I/O error."));
		}
		Arrays.sort(files);
		return files;
	}

	/**
	 * Traverse a directory and collect all files selected by the given filter, returning them as a
	 * set. The filter should not be null; files will be added using a pre-order depth-first
	 * traversal.
	 *
	 * @deprecated Use <code>FileUtil8.CollectingFileVisitor</code> instead.
	 * @param dir the directory to traverse
	 * @param filter a filter selecting files of interest
	 * @return a set of transitively contained files matched by the filter
	 * @throws ResourceError with an appropriate message upon some error during traversal
	 */
	@Deprecated
	public static Set<File> recursiveFind (File dir, FileFilter filter)
	{
		Set<File> result = new LinkedHashSet<>();
		recursiveFind(dir, filter, result);
		return result;
	}

	/**
	 * Traverse a directory and collect all files selected by the given filter, returning them as a
	 * set. The filter should not be null; files will be added using a pre-order depth-first
	 * traversal.  Unlike {@link #recursiveFind(File, FileFilter)}, this version
	 * applies a second filter to directories as well, and only recurses into directories that are
	 * accepted by that filter.
	 *
	 * @deprecated Use <code>FileUtil8.CollectingFileVisitor</code> instead.
	 * @param dir the directory to traverse
	 * @param filter a filter selecting files of interest
	 * @param recurseFilter a filter selecting directories to recurse into.
	 * @return a set of transitively contained files matched by the filter
	 * @throws ResourceError with an appropriate message upon some error during traversal
	 */
	@Deprecated
	public static Set<File> recursiveFind (File dir, FileFilter filter, FileFilter recurseFilter)
	{
		Set<File> result = new LinkedHashSet<>();
		recursiveFind(dir, filter, recurseFilter, result);
		return result;
	}

	/**
	 * Traverse a directory and collect all files selected by the given filter, adding them to the
	 * given set. The filter should not be null; files will be added using a pre-order depth-first
	 * traversal.
	 *
	 * @deprecated Use <code>FileUtil8.CollectingFileVisitor</code> instead.
	 * @param dir the directory to traverse
	 * @param filter a filter selecting files of interest
	 * @param result the set to which transitively contained files matched by the filter should be
	 *          added
	 * @throws ResourceError with an appropriate message upon some error during traversal
	 */
	@Deprecated
	public static void recursiveFind (File dir, FileFilter filter, Set<File> result)
	{
		recursiveFind(dir, filter, null, result);
	}

	/**
	 * Traverse a directory and collect all files selected by the given filter, adding them to the
	 * given set. The filter should not be null; files will be added using a pre-order depth-first
	 * traversal. Unlike {@link #recursiveFind(File, FileFilter, Set)}, this version
	 * applies a second filter to directories as well, and only recurses into directories that are
	 * accepted by that filter.
	 *
	 * @deprecated Use <code>FileUtil8.CollectingFileVisitor</code> instead.
	 * @param dir the directory to traverse
	 * @param filter a filter selecting files of interest
	 * @param recurseFilter a filter selecting directories to recurse into.
	 * @param result the set to which transitively contained files matched by the filter should be
	 *          added
	 * @throws ResourceError with an appropriate message upon some error during traversal
	 */
	@Deprecated
	public static void recursiveFind (File dir, FileFilter filter, FileFilter recurseFilter, Set<File> result)
	{
		for (File f : list(dir, filter))
			result.add(f);

		FileFilter recurseDirFilter = recurseFilter == null ?
		                              FileUtil.kindFilter(false) :
		                              FileUtil.andFilters(FileUtil.kindFilter(false), recurseFilter);

		for (File f : list(dir, recurseDirFilter)) {
			recursiveFind(f, filter, recurseFilter, result);
		}
	}

	/**
	 * Ensure the specified directory exists (as a directory), creating parent directories if
	 * necessary.
	 *
	 * @param dir The directory to create.
	 * @throws ResourceError if the desired directory already exists (but isn't a directory), or if
	 *           the creation of it or one of its parents fails.
	 */
	public static void mkdirs (File dir)
	{
		if (dir.exists()) {
			if (dir.isDirectory())
				return;
			else
				throw new ResourceError("Can't create " + dir + " -- it exists as a non-directory.");
		}
		if (dir.mkdirs())
			return;
		/*
		 * There is a possible time-of-check time-of-use race condition where someone creates the directory
		 * between our existence check and our attempt to create it.
		 *
		 * In this case our goal is to ensure the existence of the directory, so it's okay if this happens.
		 *
		 * There are other possible race conditions, e.g. if someone deletes the directory after we create it,
		 * but we want to handle this one in particular, since multiple creations of the same directory is
		 * especially likely when running multiple instances of a process that use a shared directory.
		 */
		if (dir.isDirectory())
			return;
		File child = dir;
		File parent = dir.getParentFile();
		while (parent != null) {
			if (parent.exists())
				throw new ResourceError("Couldn't create child directory " + child.getName() + " of "
				                        + (parent.isDirectory() ? "" : "non-directory ") + parent + ".");
			child = parent;
			parent = child.getParentFile();
		}
		throw new ResourceError("Couldn't create "+dir.getPath()+": no ancestor even exists.");
	}

	/**
	 * Determines whether or not the specified string represents an absolute path on either a
	 * Windows-based or UNIX-based system. Absolute paths are those that start with either /, \ or
	 * X:\, for some letter X.
	 *
	 * @param path The string containing the path to check (can safely be null or empty).
	 * @return true, if the string represents an absolute path, or false otherwise.
	 */
	public static boolean isAbsolute (String path)
	{
		// Handle invalid paths gracefully.
		if (path == null || path.length() == 0)
			return false;

		return    path.charAt(0) == '/'                 // Starts with /
		       || path.charAt(0) == '\\'                // Starts with \
		       || (  path.length() >= 3                 // Starts with X:/ or X:\ for some character X
		          && Character.isLetter(path.charAt(0))
		          && path.charAt(1) == ':'
		          && (  path.charAt(2) == '/'
		             || path.charAt(2) == '\\'));
	}

	/**
	 * Write the contents of the given string to the file, creating it if it does not exist and overwriting it if it does.
	 *
	 * @param file the target file
	 * @param content the string to write
	 */
	public static void write (File file, String content)
	{
		Writer writer = null;
		try {
			writer = openWriterUTF8(file, true, false);
			writer.write(content);
		}
		catch (IOException e) {
			throw new ResourceError("Failed to write to file " + file, e);
		}
		finally {
			close(writer);
		}
	}

	/**
	 * Append the contents of the given string to the file, creating it if it does not exist.
	 *
	 * @param file the target file
	 * @param content the string to write
	 */
	public static void append (File file, String content)
	{
		Writer writer = null;
		try {
			writer = openWriterUTF8(file, false, true);
			writer.write(content);
		}
		catch (IOException e) {
			throw new ResourceError("Failed to append to file " + file, e);
		}
		finally {
			close(writer);
		}
	}

	/**
	 * Read a text file in its entirety.
	 */
	public static String readText (File f) throws IOException
	{
		char[] cbuf = new char[10240];
		StringBuilder buf = new StringBuilder();
		InputStreamReader reader = new InputStreamReader(new FileInputStream(f), "UTF8");
		try {
			int n = reader.read(cbuf);
			while (n > 0) {
				buf.append(cbuf, 0, n);
				n = reader.read(cbuf);
			}
		}
		finally {
			reader.close();
		}
		return buf.toString();
	}

	/**
	 * Read a text file in its entirety.
	 */
	public static String readText (Path f) throws IOException
	{
		char[] cbuf = new char[10240];
		StringBuilder buf = new StringBuilder();
		InputStreamReader reader = new InputStreamReader(Files.newInputStream(f), "UTF8");
		try {
			int n = reader.read(cbuf);
			while (n > 0) {
				buf.append(cbuf, 0, n);
				n = reader.read(cbuf);
			}
		}
		finally {
			reader.close();
		}
		return buf.toString();
	}

	/**
	 * Load the given file as a standard Java {@link Properties} definition. The parsing is done using
	 * Properties.load(), which allows comments and accepts both '=' and ':' as the key/value
	 * separator.
	 *
	 * @param f the file to load.
	 * @return a {@link Properties} object containing the loaded content of the file.
	 * @throws ResourceError if an IO exception occurs.
	 */
	public static Properties loadProperties (File f)
	{
		Properties result = new Properties();
		try (FileInputStream fis = new FileInputStream(f);
				Reader reader = new InputStreamReader(new BufferedInputStream(fis), UTF8)) {
			result.load(reader);
			return result;
		} catch (IOException e) {
			throw new ResourceError("Failed to read properties from " + f, e);
		}
	}

	/**
	 * Save the given {@link Properties} to a file, UTF-8 encoded, with the proper
	 * escaping.
	 *
	 * @param props the {@link Properties} to save.
	 * @param f the file in which the properties should be saved.
	 * @throws ResourceError if an IO exception occurs.
	 */
	public static void writeProperties (Properties props, File f)
	{
		try (OutputStream os = new FileOutputStream(f);
				Writer writer = new OutputStreamWriter(new BufferedOutputStream(os), UTF8)) {
			props.store(writer, null);
		} catch (IOException ioe) {
			throw new ResourceError("Failed to write properties to " + f, ioe);
		}
	}

	/**
	 * Writes the entire contents of a stream to a file. Closes input stream when writing is done
	 *
	 * @return true on success, false otherwise
	 */
	public static boolean writeStreamToFile (InputStream in, File fileOut)
	{
		if (in == null) {
			return false;
		}
		FileOutputStream out = null;
		try {
			out = new FileOutputStream(fileOut);

			byte[] buf = new byte[16 * 1024];
			int count;
			while ((count = in.read(buf)) > 0) {
				out.write(buf, 0, count);
			}
			out.flush();
			out.close();
		}
		catch (IOException e) {
			logger.error("Error writing stream to file", e);
			return false;
		}
		finally {
			if (out != null) {
				try {
					out.close();
				}
				catch (IOException e) {
					Exceptions.ignore(e, "We don't care about exceptions during closing");
				}
			}
			if (in != null) {
				try {
					in.close();
				}
				catch (IOException e) {
					Exceptions.ignore(e, "We don't care about exceptions during closing");
				}
			}
		}
		return true;
	}


	public static void writeStreamToFile(InputStream inStream, Path resolve) throws IOException {
		try (OutputStream out = Files.newOutputStream(resolve)) {
			StreamUtil.copy(inStream, out);
		}
	}

	/**
	 * Convenience method that handles exception handling for creating a FileInputStream
	 *
	 * @return inputstream from file, or null on exception
	 */
	public static InputStream getFileInputStream (File file)
	{
		try {
			return new FileInputStream(file);
		}
		catch (FileNotFoundException e) {
			logger.trace("Could not open file for input stream", e);
			return null;
		}
	}

	private static final BitSet allowedCharacters = new BitSet(256);
	static {
		for (int i = 'a'; i <= 'z'; i++)
			allowedCharacters.set(i);
		for (int i = 'A'; i <= 'Z'; i++)
			allowedCharacters.set(i);
		for (int i = '0'; i <= '9'; i++)
			allowedCharacters.set(i);
		allowedCharacters.set('-');
		allowedCharacters.set('_');
		allowedCharacters.set(' ');
		allowedCharacters.set('[');
		allowedCharacters.set(']');
	}


	public static final String sanitizeFilename (String name)
	{
		StringBuffer safe = new StringBuffer();
		for (int i = 0; i < name.length(); i++) {
			char c = name.charAt(i);
			if (allowedCharacters.get(c))
				safe.append(c);
		}
		return safe.toString();
	}

	/**
	 * Create a unique file in the given directory. Takes a base name and the directory to put it in,
	 * and returns the file that was created. Attempts to preserve the extensions (if any) - so
	 * "foo.trap.gz" would become "foo-5.trap.gz", not "foo.trap.gz-5". Guarantees that the file it
	 * returns was successfully created by this call - so in a multithreaded / multiprocess
	 * environment can be used to create a globally unique file.
	 *
	 * @param baseDirectory the directory that will eventually contain the file. This must exist.
	 * @param fileName the simple name of the file to create. It should not contain any directory
	 *          separators.
	 * @return a file in <code>baseDirectory</code> with a name based on <code>fileName</code> that
	 *         did not exist when created.
	 * @throws IllegalArgumentException if <code>baseDirectory</code> does not exist or
	 *           <code>fileName</code> is not a simple file name.
	 */
	public static final File createUniqueFile (File baseDirectory, String fileName)
	{
		return createUniqueFileImpl(baseDirectory, fileName, false);
	}

	/**
	 * Create a unique subdirectory in the given directory. Takes a base name and the directory to put
	 * it in, and returns the directory that was created. Attempts to preserve the extensions (if any)
	 * - so "foo.d" would become "foo-5.d", not "foo.d-5". Guarantees that the directory it returns
	 * was successfully created by this call - so in a multithreaded / multiprocess environment can be
	 * used to create a globally unique directory.
	 *
	 * @param baseDirectory the directory that will eventually contain the file. This must exist.
	 * @param dirName the simple name of the directory to create. It should not contain any directory
	 *          separators.
	 * @return a directory in <code>baseDirectory</code> with a name based on <code>dirName</code>
	 *         that did not exist when created.
	 * @throws ResourceError if there was a problem creating the file
	 * @throws IllegalArgumentException if <code>baseDirectory</code> does not exist or
	 *           <code>dirName</code> is not a simple name.
	 */
	public static final File createUniqueDirectory (File baseDirectory, String dirName)
	{
		return createUniqueFileImpl(baseDirectory, dirName, true);
	}

	private static final File createUniqueFileImpl (File baseDirectory, String fileName, boolean directory)
	{

		if (!baseDirectory.exists())
			throw new IllegalArgumentException("FileUtil.makeUniqueName(" + baseDirectory + ",\"" + fileName + "\"): "
			                                   + " directory " + baseDirectory + " does not exist.");
		if (!baseDirectory.isDirectory())
			throw new IllegalArgumentException("FileUtil.makeUniqueName(" + baseDirectory + ",\"" + fileName + "\"): "
			                                   + " file " + baseDirectory + " is not a directory.");
		if (fileName.contains("/"))
			throw new IllegalArgumentException("FileUtil.makeUniqueName(" + baseDirectory + ",\"" + fileName + "\"): "
			                                   + " file name \"" + fileName + "\" is not a simple file name.");

		fileName = replaceInvalidFilenameChars(fileName);

		String baseName = fileName;
		String name = baseName;
		File candidateFile = new File(baseDirectory, name);
		String extension = extension(new File(baseName));

		int i = 1;

		try {
			while (!(directory ? candidateFile.mkdir() : candidateFile.createNewFile())) {
				// Add a suffix, trying to do that before the extension
				if (extension.length() > 0)
					name = baseName.substring(0, baseName.length() - extension.length()) + "-" + i + extension;
				else
					name = baseName + "-" + i;

				candidateFile = new File(baseDirectory, name);
				i++;
			}
		}
		catch (IOException e) {
			throw new ResourceError("Failed to create a unique file in " + baseDirectory, e);
		}

		return candidateFile;
	}

	public static boolean containsInvalidFilenameChars (String filename)
	{
		return rpInvalidFilenameCharacters.matcher(filename).find();
	}

	public static String replaceInvalidFilenameChars (String fileName)
	{
		// This method gets called from all over the code base. Compile the regex only once (but only
		// when it is actually needed) by using a LazyRegexPatternHolder
		return rpInvalidFilenameCharacters.matcher(fileName).replaceAll("_");
	}

	/**
	 * Append a number to a file name, with the intention of making it unique. Similar to
	 * <code>makeUniqueName</code>, but does not actually make the name unique: it relies on the
	 * client calling it with a unique number. Attempts to preserve the extensions of files - so
	 * "foo.tar.gz" would become "foo-5.tar.gz", not "foo.tar.gz-5".
	 *
	 * @param file the filename to modify
	 * @param indexToAdd the number to append at the end of the filename
	 * @return the modified filename with <code>indexToAdd</code> appended at the end
	 */
	public static final File appendToName (File file, int indexToAdd)
	{
		String path = file.getPath();
		String extension = extension(file);
		if (extension.length() > 0)
			path = path.substring(0, path.length() - extension.length()) + "-" + indexToAdd + extension;
		else
			path = path + "-" + indexToAdd;
		return new File(path);
	}

	/**
	 * Get the extension of the file. Results are of the form: ".java", ".C", "." or "" (no
	 * extension). The '.gz' extension is treated specially - if there is another extension before it
	 * the two extensions are lumped together (eg. '.trap.gz', '.tar.gz'). We add another special case
	 * for '.xml.zip', just to support our own conventions.
	 */
	public static String extension (File f)
	{
		return extension(f.getName());
	}


	/**
	 * Get the extension of the file. Results are of the form: ".java", ".C", "." or "" (no
	 * extension). The '.gz' extension is treated specially - if there is another extension before it
	 * the two extensions are lumped together (eg. '.trap.gz', '.tar.gz'). We add another special case
	 * for '.xml.zip', just to support our own conventions.
	 */
	public static String extension (Path f)
	{
		return extension(f.getFileName().toString());
	}

	/**
	 * Return the extension of the file name.
	 *
	 * @see FileUtil#extension(File)
	 */
	public static String extension (String name)
	{
		int i = name.lastIndexOf('.');
		if (i == -1)
			return "";
		String extension = name.substring(i);
		if (extension.equals(".gz") || extension.equals(".br")) {
			// Try to find another extension
			int before = name.lastIndexOf('.', i - 1);
			if (before == -1)
				return extension;
			String combinedExtension = name.substring(before);
			return combinedExtension;
		}
		else if (extension.equals(".zip")) {
			// Just special-case .xml.zip
			if (name.endsWith(".xml.zip"))
				return ".xml.zip";
		}

		return extension;
	}

	/**
	 * Return the base name of the file obtained by stripping off leading directories and the
	 * extension.
	 */
	public static String basename (File f)
	{
		return stripExtension(f.getName());
	}

	/**
	 * Return the base name of the file obtained by stripping off leading directories and the
	 * extension. Returns the empty string if the path has no components.
	 */
	public static String basename(Path path) {
		Path filename = path.getFileName();
		return filename == null ? "" : stripExtension(filename.toString());
	}

	/**
	 * Strips the extension off a file name. E.g.: 'MyFile.java' becomes 'MyFile'. Note that
	 * there are some special cases (see definition of {@link #extension(String)}). For example,
	 * 'MyFile.tar.gz' becomes 'MyFile' (.tar.gz is considered the extension), but
	 * 'MyFile.foo.bar' becomes 'MyFile.foo'.
	 *
	 * Note that this method retains an optional path prefix. E.g.:
	 * '/foo/bar/MyFile.java' becomes '/foo/bar/MyFile'. If a completely stripped filename
	 * (without path, without extension) is desired, then use {@link #basename(File)}.
	 *
	 * @param name name of a file (with or without fully qualified path)
	 * @return input without the file extension
	 */
	public static String stripExtension (String name)
	{
		return name.substring(0, name.length() - extension(name).length());
	}

	/**
	 * Return a file with the same name and in the same directory as a given file, but with a
	 * different extension.
	 */
	public static File withExtension (File f, String extension)
	{
		return new File(withExtension(f.getPath(), extension));
	}

	/**
	 * Given a string denoting a file name, change its extension.
	 */
	public static String withExtension (String path, String extension)
	{
		String oldExtension = extension(path);
		return path.substring(0, path.length() - oldExtension.length()) + extension;
	}

	/**
	 * A file filter that searches for files (not directories) by any of the given names. Can do
	 * case-sensitive or case-insensitive matching
	 */
	public static FileFilter nameFilter (final boolean caseSensitive, final String ... names)
	{
		return new FileFilterImpl(names, caseSensitive, false);
	}

	/**
	 * A file filter that matches a set of ant-like patterns against files in a given directory.
	 *
	 * @param cwd The current directory -- the patterns are matched against relative paths under this
	 *          directory, and files outside of it are considered to not match the patterns (though
	 *          they will still be accepted by the filter if {@code exclude == true}).
	 * @param exclude Flag indicating whether files matching the patterns should be included or
	 *          excluded by the filter.
	 * @param patterns A list of patterns.
	 * @return The new filter.
	 */
	public static FileFilter antlikeFilter (File cwd, boolean exclude, String ... patterns)
	{
		return new PatternFilter(cwd, Mode.Ant, exclude, patterns);
	}

	/**
	 * A file filter that matches file by regular expression.
	 */
	public static FileFilter regexNameFilter (String regex, boolean matchFiles)
	{
		return new RegexFileFilter(Pattern.compile(regex), matchFiles);
	}

	/**
	 * A file filter that finds files (not directories) by a list of extensions. Can do case-sensitive
	 * or case-insensitive matching on the extensions. A sample extension should be, for instance,
	 * ".ql".
	 */
	public static FileFilter extensionFilter (final boolean caseSensitive, final String ... extensions)
	{
		return new FileFilterImpl(extensions, caseSensitive, true);
	}

	/**
	 * Check whether the given directory contains any files or directories
	 * as defined by the given FileFilter.
	 */
	public static boolean containsAny(File dir, FileFilter filter){
		if(!dir.isDirectory())
			return false;

		Stack<File> search = new Stack<>();
		search.push(dir);

		while (!search.isEmpty()) {
			File f = search.pop();

			for (File c : list(f)) {
				if(filter.accept(c))
					return true;
				if (f.isDirectory())
					search.push(c);
			}
		}
		return false;
	}

	/** A filter that does not accept any file or directory */
	public static final FileFilter falseFilter = new FileFilter() {
		@Override
		public boolean accept(File pathname) {
			return false;
		}
	};

	/**
	 * A file filter that either picks all files or all directories
	 */
	public static FileFilter kindFilter (final boolean files)
	{
		return new FileFilter() {
			@Override
			public boolean accept (File pathname)
			{
				if (pathname.isFile() && files)
					return true;
				if (pathname.isDirectory() && !files)
					return true;
				return false;
			}
		};
	}

	/**
	 * A file filter that accepts precisely the set of files specified as an argument to this method
	 * (using the set's {@link Set#contains(Object)} method, so up to {@link File}'s equals/hashCode).
	 */
	public static FileFilter setFilter (final Set<File> acceptedFiles)
	{
		return new FileFilter() {
			@Override
			public boolean accept (File pathname)
			{
				return acceptedFiles.contains(pathname);
			}
		};
	}

	/**
	 * Negate a file filter
	 */
	public static FileFilter negateFilter (final FileFilter filter)
	{
		return new FileFilter() {
			@Override
			public boolean accept (File pathname)
			{
				return !filter.accept(pathname);
			}
		};
	}

	/**
	 * Take the conjunction of several file filters
	 */
	public static FileFilter andFilters(final FileFilter... filters) {
		return new FileFilter() {
			@Override
			public boolean accept (File pathname)
			{
				for (FileFilter filter : filters) {
					if (!filter.accept(pathname)) {
						return false;
					}
				}
				return true;
			}
		};
	}

	/**
	 * Sanitize path string To handle windows drive letters and cross-platform builds.
	 * @param pathString to be sanitized
	 * @return sanitized path string
	 */
	private static String sanitizePathString(String pathString) {
		// Replace ':' by '_', as the extractor does - to handle Windows drive letters
		pathString = pathString.replace(':', '_');

		// To support cross-platform builds: if the build is done on one system (eg. Windows, with \)
		// but the path is then read in another system (ie with /) then the separators will be
		// interpreted incorrectly. Normalise all possible separators to the current one
		pathString = pathString.replace('\\', File.separatorChar).replace('/', File.separatorChar);
		return pathString;
	}

	/**
	 * Add an absolute path as a suffix to a given directory. This is used to create source archives.
	 * For instance, <code>appendAbsolutePath("/home/foo/bar", "/usr/include/stdio.h")</code> produces
	 * <code>"/home/foo/bar/usr/include/stdio.h"</code>. Various transformations on the paths are done
	 * to avoid special characters and to give cross-platform compatibility.
	 *
	 * @param root the File to use as a root; the result will be a child of that (or itself)
	 * @param absolutePath the path to append, which should be a Windows or Unix absolute path
	 */
	public static File appendAbsolutePath (File root, String absolutePath)
	{
		absolutePath = sanitizePathString(absolutePath);

		return new File(root, absolutePath).getAbsoluteFile();
	}

	/**
	 * Add an absolute path as a suffix to a given directory. This is used to create source archives.
	 * For instance, <code>appendAbsolutePath("/home/foo/bar", "/usr/include/stdio.h")</code> produces
	 * <code>"/home/foo/bar/usr/include/stdio.h"</code>. Various transformations on the paths are done
	 * to avoid special characters and to give cross-platform compatibility.
	 *
	 * @param root the Path to use as a root; the result will be a child of that (or itself)
	 * @param absolutePath the path to append, which should be a Windows or Unix absolute path
	 */
	public static Path appendAbsolutePath(Path root, String absolutePathString){

		absolutePathString = sanitizePathString(absolutePathString);

		Path path = Paths.get(absolutePathString);

		if (path.getRoot() != null)
			path = path.getRoot().relativize(path);

		return root.resolve(path);
	}

	/**
	 * Close a resource if it is non-null and has been successfully created. Silently catches
	 * exceptions that can occur during close.
	 */
	public static void close (Closeable resourceToClose)
	{
		if (resourceToClose != null) {
			try {
				resourceToClose.close();
			}
			catch (IOException ignored) {
				Exceptions.ignore(ignored, "Contract is to ignore");
			}
			/*
			 * Under rare circumstances classes may lie about checked exceptions that they throw.
			 * Since the intention of this method is to catch all exceptions that are the result
			 * of IO problems, we check whether the (real) exception that was thrown was an IOException,
			 * and if so we ignore it.
			 */
			catch (UndeclaredThrowableException maybeIgnored) {
				if (maybeIgnored.getCause() instanceof IOException) {
					Exceptions.ignore(maybeIgnored, "Undeclared exception was an IOException, ignoring");
				} else {
					throw maybeIgnored;
				}
			}
		}
	}

	/**
	 * Close a socket if it is non-null. Silently catches exceptions that can occur during close.
	 * <p>
	 * This method is necessary because a {@link Socket} is not {@link Closeable} until Java 7.
	 */
	public static void close (Socket socket)
	{
		if (socket != null) {
			try {
				socket.close();
			}
			catch (IOException ignored) {
				Exceptions.ignore(ignored, "Contract is to ignore");
			}
		}
	}

	public static class ResolvedCompressedSourceArchivePaths {
		public final String srcArchivePath;
		public final String sourceLocationPrefix;
		public ResolvedCompressedSourceArchivePaths(String srcArchivePath, String sourceLocationPrefix) {
			this.srcArchivePath = srcArchivePath;
			this.sourceLocationPrefix = sourceLocationPrefix;
		}
	}

	/**
	 * Resolve the paths in the compressed source archive.
	 *
	 * @param srcArchiveZip
	 *            - the zip containing the compressed source archive.
	 * @param convertedSourceLocationPrefix
	 *            - the source location prefix, converted to a source archive
	 *            compatible format using
	 *            {@link FileUtil#convertAbsolutePathForSourceArchive(String)}.
	 * @return a {@link ResolvedCompressedSourceArchivePaths} class wit
	 */
	public static ResolvedCompressedSourceArchivePaths resolveCompressedSourceArchivePaths(File srcArchiveZip, String convertedSourceLocationPrefix) {
		String srcArchivePath = "";
		String sourcePath;
		boolean legacyZip = srcArchiveZip.getName().equals("src_archive.zip");
		if (legacyZip) {
			// Location of the source archive in the zip
			srcArchivePath = FileUtil.convertPathForSourceArchiveZip("");
			// Location of the source directory within the source archive.
			sourcePath = srcArchivePath + convertedSourceLocationPrefix;
		} else if (convertedSourceLocationPrefix.startsWith("/")) {
			sourcePath = convertedSourceLocationPrefix.substring(1);
		} else {
			sourcePath = convertedSourceLocationPrefix;
		}
		return new ResolvedCompressedSourceArchivePaths(srcArchivePath, sourcePath);
	}

	/**
	 * Converts an absolute path to a path that can be used in the source archive. This involves
	 * normalising (and canonicalising) the path, stripping any trailing slash, and
	 * prepending a slash if the path is non-empty.
	 *
	 * @param absolutePath The absolute path to convert (must be non-null).
	 * @return The converted path.
	 * @throws CatastrophicError If absolutePath is null.
	 */
	public static String convertAbsolutePathForSourceArchive(String absolutePath)
	{
		// Enforce preconditions.
		if (absolutePath == null) {
			throw new CatastrophicError("FileUtil.convertPathForSourceArchiveZip: absolutePath must be non-null");
		}

		// Normalise the path and replace any instances of the Windows-specific path character ':'.
		absolutePath = normalisePath(absolutePath);
		absolutePath = absolutePath.replace(':', '_');

		// Make sure that the path starts with a forward slash (to separate it from "src_archive")
		// and then strip any trailing forward slash. (Note that if the original path starts off
		// empty, the net result of these two operations is still empty.)
		if (!absolutePath.startsWith("/"))
			absolutePath = "/" + absolutePath;
		if (absolutePath.endsWith("/"))
			absolutePath = absolutePath.substring(0, absolutePath.length() - 1);

		return absolutePath;
	}

	/**
	 * Converts an absolute path to a path that can be used in the source archive .zip. This involves
	 * normalising (and canonicalising) the path, stripping any trailing slash and prepending the
	 * string "src_archive/" (unless the path is empty, when the slash after "src_archive" is
	 * dropped).
	 *
	 * @param absolutePath The absolute path to convert (must be non-null).
	 * @return The converted path.
	 * @throws CatastrophicError If absolutePath is null.
	 */
	public static String convertPathForSourceArchiveZip(String absolutePath) {
		return "src_archive" + convertAbsolutePathForSourceArchive(absolutePath);
	}

	/**
	 * Construct a child of base by appending a relative path. For example: with base="/usr" and
	 * relativePath="local/bin/foo", the result is "/usr/local/bin/foo"; if base="C:\odasa" and
	 * relativePath="projects/foo", then the result is "C:\odasa\projects\foo". The relative path must
	 * not start with a slash. Normalisation: treat both "/" and "\" as the path separator. As a
	 * special case, if {@code base} is <code>null</code>, a file representing just the
	 * {@code relativePath} is constructed.
	 */
	public static File fileRelativeTo (File base, String relativePath)
	{
		if (!isRelativePath(relativePath))
			throw new CatastrophicError("Invalid relative path '" + relativePath + "'.");

		return new File(base, relativePath);
	}

	/**
	 * Is the given path a relative path suitable for {@link #fileRelativeTo(File, String)}?
	 */
	public static boolean isRelativePath (String path)
	{
		if (path.startsWith("/")) {
			return false;
		}
		if (path.startsWith("\\")) {
			return false;
		}
		if (Env.getOS() == OS.WINDOWS && path.contains(":")) {
			return false;
		}
		return true;
	}

	/**
	 * Converts a path to a normalised form. This involves converting any initial lowercase drive
	 * letter to uppercase, and converting backslashes to forward slashes.
	 *
	 * @param path The path to normalise (must be non-null).
	 * @return The normalised version of the path.
	 * @throws CatastrophicError If {@code path} is null.
	 */
	public static String normalisePath (String path)
	{
		// Enforce preconditions.
		if (path == null) {
			throw new CatastrophicError("FileUtil.normalisePath: path must be non-null");
		}

		// Convert any initial lowercase driver letter to uppercase.
		if (path.length() >= 2 && path.charAt(1) == ':') {
			char driveLetter = path.charAt(0);
			if (driveLetter >= 'a' && driveLetter <= 'z') {
				path = Character.toUpperCase(driveLetter) + path.substring(1);
			}
		}

		// Convert any backslashes to forward slashes.
		path = path.replace('\\', '/');

		return path;
	}

	/**
	 * Compute the nearest common parent for two files.
	 *
	 * @return The most nested directory which is both a parent of {@code a} and a parent of {@code b}
	 *         .
	 * @throws ResourceError if no common parent can be found. This can happen if, for example, the
	 *           two files are on different Windows drive letters.
	 */
	public static File commonParent (File a, File b)
	{
		Set<File> parents = new LinkedHashSet<>();
		for (File cur = a; cur != null; cur = cur.getParentFile())
			parents.add(cur);
		for (File cur = b; cur != null; cur = cur.getParentFile())
			if (!parents.add(cur))
				return cur;
		throw new ResourceError("Could not determine a common parent for " + a + " and " + b + ".");
	}

	/**
	 * Compute the nearest common parent for a set of files.
	 *
	 * @return The most nested directory which is a parent of all files in {@code fs}.
	 * @throws ResourceError if no common parent can be found. This can happen if, for example, two of
	 *           the files are on different Windows drive letters, or the list is empty.
	 */
	public static File commonParent (List<File> fs)
	{
		if (fs.isEmpty()) {
			throw new CatastrophicError("No files to find common parent of");
		}
		File cur = fs.get(0);
		for (File f : fs) {
			cur = commonParent(cur, f);
		}
		return cur;
	}

	/**
	 * Compute the relative path to <code>file</code> from <code>baseDirectory</code>. Fails with a
	 * {@link ResourceError} if <code>file</code> is not a child of <code>baseDirectory</code>. Tries
	 * canonical paths and comparing normal file paths. The returned path is relative (ie does not
	 * start with a slash).
	 *
	 * @throws ResourceError if a relative path cannot be determined
	 */
	public static String relativePath (File file, File baseDirectory)
	{
		String candidate = relativePathOpt(file, baseDirectory);
		if (candidate != null)
			return candidate;

		throw new ResourceError("Could not determine a relative path to " + file + " from " + baseDirectory);
	}

	/**
	 * Compute the relative path to <code>file</code> from <code>baseDirectory</code>. Returns
	 * <code>file.getAbsolutePath()</code> if <code>file</code> is not a child of
	 * <code>baseDirectory</code>. Tries canonical paths and comparing normal file paths.
	 */
	public static String tryMakeRelativePath (File file, File baseDirectory)
	{
		String candidate = relativePathOpt(file, baseDirectory);
		return candidate != null ? candidate : file.getAbsolutePath();
	}

	public static String relativePathOpt (File file, File baseDirectory)
	{
		try {
			File canonicalToFile = file.getCanonicalFile();
			File canonicalToBase = baseDirectory.getCanonicalFile();
			String canonicalRelative = relativePathAsIsOpt(canonicalToFile, canonicalToBase);
			if (canonicalRelative != null)
				return canonicalRelative;
		}
		catch (IOException ignored) {
			Exceptions.ignore(ignored, "Fall through to comparing standard paths");
		}

		String relative = relativePathAsIsOpt(file, baseDirectory);
		return relative;
	}

	/**
	 * The same as {@link #relativePathOpt(File, File)}, but it does not canonicalize its arguments.
	 */
	public static String relativePathAsIsOpt (File childFile, File parentFile)
	{
		String child = childFile.getPath();
		String parent = parentFile.getPath();
		int parentLength = parent.length();
		// Is the child too short?
		if (child.length() <= parentLength)
			return null;
		// Is the parent not even a prefix?
		if (!child.startsWith(parent))
			return null;
		// Is the parent prefix a full dir name? (catches child=/home and parent=/ho)
		if (child.charAt(parentLength) == File.separatorChar)
			return child.substring(parentLength + 1);
		// We also need to check the previous character to handle
		// cases like parent=/ or parent=c:\
		if (parentLength > 0 && child.charAt(parentLength - 1) == File.separatorChar)
			return child.substring(parentLength);
		return null;
	}

	public static boolean isWithin (File file, File baseDirectory)
	{
		return (relativePathOpt(file, baseDirectory) != null)
		       || (tryMakeCanonical(file).equals(tryMakeCanonical(baseDirectory)));
	}

	/**
	 * Constructs the relative path to the target {@code f} from {@code base}. The base file or
	 * directory does not need to be a parent of the target but a common parent needs to exist.
	 *
	 * @param f the target file
	 * @param base the working directory (or a file within the working directory)
	 * @return the relative path from {@code base} to {@code f}
	 * @throws ResourceError if there is no common parent according to {@link FileUtil#commonParent}
	 */
	public static String relativePathLink (File f, File base)
	{
		f = f.getAbsoluteFile();
		base = base.getAbsoluteFile();
		File parent = commonParent(f, base);
		StringBuilder path = new StringBuilder();
		for (File cur = base; !cur.equals(parent); cur = cur.getParentFile())
			path.append(".." + File.separator);
		path.append(relativePath(f, parent));
		return path.toString();
	}

	/**
	 * Try to convert a file into a canonical file. Handles the possible IO exception by just making
	 * the path absolute.
	 */
	public static File tryMakeCanonical (File f)
	{
		try {
			return f.getCanonicalFile();
		}
		catch (IOException ignored) {
			Exceptions.ignore(ignored, "Can't log error: Could be too verbose.");
			return new File(simplifyPath(f));
		}
	}


	private static class FileFilterImpl implements FileFilter
	{
		private final String[] names;
		private final boolean  caseSensitive;
		private final boolean  extensionOnly;


		private FileFilterImpl (String[] names, boolean caseSensitive, boolean extensionOnly)
		{
			this.names = Arrays.copyOf(names, names.length);
			this.caseSensitive = caseSensitive;
			this.extensionOnly = extensionOnly;

			if (!caseSensitive)
				for (int i = 0; i < this.names.length; i++)
					this.names[i] = StringUtil.lc(this.names[i]);
		}

		@Override
		public boolean accept (File pathname)
		{
			if (!pathname.isFile())
				return false;

			String nameToMatch = caseSensitive ? pathname.getName() : StringUtil.lc(pathname.getName());
			for (String s : names) {
				if (extensionOnly && nameToMatch.endsWith(s))
					return true;
				if (!extensionOnly && nameToMatch.equals(s))
					return true;
			}
			return false;
		}
	}

	private static class PatternFilter implements FileFilter
	{
		private final PathMatcher matcher;
		private final boolean     exclude;
		private final File        cwd;


		private PatternFilter (File cwd, Mode mode, boolean exclude, String ... patterns)
		{
			this.cwd = cwd;
			this.exclude = exclude;
			matcher = new PathMatcher(mode, Arrays.asList(patterns));
		}

		@Override
		public boolean accept (File f)
		{
			String path = relativePathOpt(f, cwd);
			if (path == null)
				return exclude;
			else
				return exclude ^ matcher.matches(path);
		}
	}

	private static class RegexFileFilter implements FileFilter
	{
		private final Pattern pattern;
		private final boolean matchFiles;


		private RegexFileFilter (Pattern pattern, boolean matchFiles)
		{
			this.pattern = pattern;
			this.matchFiles = matchFiles;
		}

		@Override
		public boolean accept (File pathname)
		{
			if (pathname.isFile() != matchFiles) {
				return false;
			}
			return pattern.matcher(pathname.getName()).matches();
		}
	}


	/**
	 * Is <code>parent</code> a (recursive) parent of <code>child</code>? The case where parent is the
	 * same as child is <strong>not</strong> counted. This could return the wrong result in odd
	 * situations involving links, but tries to make paths canonical if possible.
	 */
	public static boolean recursiveParentOf (File parent, File child)
	{
		return relativePathOpt(child, parent) != null;
	}

	/**
	 * Delete the given file, even if it is a non-empty directory -- in which case it is traversed and
	 * all contents are removed. This method makes a best-effort attempt to avoid infinite loops
	 * through symlinks, though that part is largely untested at the time of writing.
	 *
	 * @deprecated use <code>FileUtil8.recursiveDelete</code> instead.
	 * @param file The file or directory that should be deleted
	 * @return true, if the file or directory was successfully deleted, or false otherwise.
	 */
	@Deprecated
	public static boolean recursiveDelete (File file)
	{
		return recursiveDelete(file, falseFilter) == DeletionResult.Deleted;
	}


	public enum DeletionResult
	{
		Deleted, SkippedSomeFiles, Failed
	};


	/**
	 * Delete the given file, even if it is a non-empty directory; however, preserve files (or
	 * directories) that match the given {@link FileFilter} for exceptions. This method makes a
	 * best-effort attempt to avoid infinite loops through symlinks, though that part is largely
	 * untested at time of writing [in particular, a loop of read-only symlinks may lead to infinite
	 * recursion].
	 *
	 * @deprecated use <code>FileUtil8.recursiveDelete</code> instead.
	 * @param file the file or folder to delete
	 * @param exceptions a {@link FileFilter} that will be consulted before attempting to delete
	 *          anything; if it accepts, the current file is not deleted (which means its parent
	 *          directories will be preserved, too).
	 * @return A {@link DeletionResult} indicating the status: Deleted if the file has been
	 *         successfully deleted (and no longer exists), SkippedSomeFiles if the file exists either
	 *         because it was skipped or because it's the parent directory of some skipped files, and
	 *         Failed if a file we tried to delete could not be removed.
	 */
	@Deprecated
	public static DeletionResult recursiveDelete (File file, FileFilter exceptions)
	{
		if (exceptions.accept(file))
			return DeletionResult.SkippedSomeFiles;
		if (file.delete())
			return DeletionResult.Deleted;
		if (file.isDirectory()) {
			File[] children = file.listFiles();
			if (children == null)
				return DeletionResult.Failed;
			boolean skippedSomeChildren = false;
			for (File f : children) {
				DeletionResult childResult = recursiveDelete(f, exceptions);
				if (childResult == DeletionResult.Failed)
					return DeletionResult.Failed;
				else if (childResult == DeletionResult.SkippedSomeFiles)
					skippedSomeChildren = true;
			}
			if (file.delete())
				return DeletionResult.Deleted;
			else
				return skippedSomeChildren ? DeletionResult.SkippedSomeFiles : DeletionResult.Failed;
		}
		else
			return DeletionResult.Failed;
	}

	/**
	 * Takes a File path and return another File path that has a different extension. Notice that this
	 * operation works on the path name represented by the File object. No attempt to resolve
	 * symlinks, or otherwise canonicalize the path name, is made. The file referenced by the file
	 * path may or may not exist.
	 *
	 * @param file the path from which to generate the new path
	 * @param newExtension the desired extension
	 * @return a file path with a different extension
	 */
	public static File replaceFileExtension (File file, String newExtension)
	{
		String name = file.getName();
		int index = name.lastIndexOf('.');
		if (index != -1) {
			name = name.substring(0, index);
		}
		return new File(file.getParentFile(), name + newExtension);
	}

	/**
	 * Return the SHA-1 hash for a file.
	 *
	 * @param file the file to hash
	 * @return a <code>String</code> representation of the hash in hexadecimal
	 */
	public static String sha1 (File file)
	{
		byte[] buf = new byte[4096];
		FileInputStream fio = null;
		try {
			fio = new FileInputStream(file);
			MessageDigest digest = MessageDigest.getInstance("SHA-1");
			int read;
			while ((read = fio.read(buf)) > 0)
				digest.update(buf, 0, read);
			return StringUtil.toHex(digest.digest());
		} catch (IOException e) {
			throw new ResourceError("Could not read file for hashing: " + file, e);
		}
		catch (NoSuchAlgorithmException e) {
			throw new ResourceError("Could not find SHA-1 algorithm", e);
		}
		finally {
			close(fio);
		}
	}

	/**
	 * Append the given set of properties to a specified file, taking care of proper escaping of
	 * special characters.
	 *
	 * @param target the file to write -- content is appended
	 * @param extraVariables A string/value mapping of properties
	 * @param extraComment A properties-file commend to prepend to the new values, to trace
	 *          provenance. Can be {@code null} to disable.
	 */
	public static void appendProperties (File target, Set<Pair<String, String>> extraVariables, String extraComment)
	{
		if (extraVariables.isEmpty())
			return;

		Properties props = new Properties();

		for (Pair<String, String> var : extraVariables)
			props.put(var.fst(), var.snd());

		StringWriter writer = new StringWriter();
		writer.append('\n');
		try {
			props.store(writer, extraComment);
		}
		catch (IOException e) {
			throw new ResourceError("Failed to convert properties to string while appending to file " + target, e);
		}

		append(target, writer.toString());
	}

	/**
	 * Append the given set of properties to a specified file, taking care of proper escaping of
	 * special characters.
	 *
	 * @param target the file to write -- content is appended
	 * @param extraVariables A string/value mapping of properties
	 * @param extraComment A properties-file commend to prepend to the new values, to trace
	 *          provenance. Can be {@code null} to disable.
	 */
	public static void appendProperties (File target, Map<String, String> extraVariables, String extraComment)
	{
		Set<Pair<String, String>> vars = new LinkedHashSet<>();
		for (Entry<String, String> e : extraVariables.entrySet())
			vars.add(Pair.make(e.getKey(), e.getValue()));
		appendProperties(target, vars, extraComment);
	}


	/**
	 * A pattern matching "logical" path separators, i.e. runs of forward or back slashes, possibly
	 * interspersed with single dots. A string matched by this pattern is equivalent to a single
	 * occurrence of the separator.
	 */
	private static final Pattern ANY_PATH_SEPARATOR = Pattern.compile("[\\\\/]+(\\.[\\\\/]+)*");

	/**
	 * Normalise a string representing a path by replacing sequences that match
	 * {@link #ANY_PATH_SEPARATOR} with a single forward slash. <b>The transformation makes no
	 * reference to a file system.</b> Example transformations:
	 * <ul>
	 * <li><b>a/./b</b> to <b>a/b</b></li>
	 * <li><b>a\b</b> to <b>a/b</b></li>
	 * <li><b>a\b/c</b> to <b>a/b/c</b></li>
	 * <li><b>C:\a\b</b> to <b>C:/a/b</b></li>
	 * <li><b>/a/b</b> to <b>/a/b</b></li>
	 * <li><b>.</b> to <b>.</b>
	 * <li><b>./</b> to <b>./</b>
	 * </ul>
	 */
	public static String normalizePathSeparators(String path)
	{
		return ANY_PATH_SEPARATOR.matcher(path).replaceAll("/");
	}

	/**
	 * Normalise a file name without incurring the cost of filesystem access that
	 * {@link File#getCanonicalFile()} would. In particular, remove redundant "./"
	 * components from the path, and simplify "foo/.." to nothing. The path is made
	 * absolute in the process.
	 *
	 * @param file
	 *            the file path to normalise.
	 * @return A string representing the path of the file, with obviously redundant
	 *         components stripped off.
	 */
	public static String simplifyPath (File file)
	{
		return file.toPath().toAbsolutePath().normalize().toString();
	}

	/**
	 * Read properties from a CSV file into a Map
	 *
	 * @param file CSV file, each row containing a key and value
	 * @return Map containing key-value bindings
	 */
	public static Map<String, String> readPropertiesCSV (File file)
	{
		Map<String, String> result = new LinkedHashMap<>();
		Reader reader = null;
		InputStream input = null;
		CSVReader csv = null;
		try {
			input = new FileInputStream(file);
			reader = new InputStreamReader(input, "UTF-8");
			csv = new CSVReader(reader);
			for (String[] line : csv.readAll()) {
				if (line.length >= 1) {
					String key = line[0];
					String value = null;
					if (line.length >= 2) {
						value = line[1];
					}
					result.put(key, value);
				}
			}
			return Collections.unmodifiableMap(result);
		}
		catch (UnsupportedEncodingException e) {
			throw new CatastrophicError(e);
		}
		catch (IOException e) {
			throw new ResourceError("Could not read data from " + file, e);
		}
		finally {
			FileUtil.close(reader);
			FileUtil.close(input);
			FileUtil.close(csv);
		}
	}

	/**
	 * Write properties to a CSV file
	 *
	 * @param file CSV file
	 * @param data Map containing key-value bindings
	 */
	public static void writePropertiesCSV (File file, Map<String, String> data) throws IOException
	{
		OutputStream out = null;
		Writer writer = null;
		CSVWriter csvWriter = null;
		try {
			out = new FileOutputStream(file);
			writer = new OutputStreamWriter(out, "UTF-8");
			csvWriter = new CSVWriter(writer);

			for (Entry<String, String> e : data.entrySet()) {
				csvWriter.writeNext(e.getKey(), e.getValue());
			}
		}
		catch (FileNotFoundException e) {
			throw new ResourceError("Could not find file '" + file + "'", e);
		}
		catch (UnsupportedEncodingException e) {
			throw new CatastrophicError(e);
		}
		finally {
			FileUtil.close(csvWriter);
			FileUtil.close(writer);
			FileUtil.close(out);
		}
	}

	/**
	 * Obtain a File that does not exist, returning the given {@code path} if it does not exist, or
	 * the given {@code path} with a randomly generated numerical suffix if it does.
	 *
	 * @throws ResourceError if the {@code path} could not be accessed.
	 */
	public static final File ensureUnique (File path)
	{
		try {
			if (path.exists()) {
				Random random = new Random();
				File uniquePath;
				do {
					uniquePath = new File(path.toString() + "." + random.nextInt());
				}
				while (uniquePath.exists());
				return uniquePath;
			}
			return path;
		}
		catch (SecurityException se) {
			throw new ResourceError("Could not access file " + path, se);
		}
	}

	/**
	 * Open the specified {@code file} with a new {@link Writer}.
	 *
	 * @param file The file to open
	 * @param overwrite Flag indicating whether the file may be overwritten if it already exists.
	 * @param append Flag indicating whether the file should be appended if it already exists (
	 *          {@code overwrite} is ignored if this flag is true).
	 */
	public static Writer openWriterUTF8 (File file, boolean overwrite, boolean append)
	{
		try {
			FileOutputStream ostream;
			if (file.exists()) {
				if (append) {
					ostream = new FileOutputStream(file, true);
				}
				else if (overwrite) {
					if (!file.delete()) {
						throw new ResourceError("Could not delete existing file: " + file);
					}
					ostream = new FileOutputStream(file, false);
				}
				else {
					throw new ResourceError("File already exists: " + file);
				}
			}
			else {
				ostream = new FileOutputStream(file, false);
			}
			return new OutputStreamWriter(ostream, UTF8);
		}
		catch (SecurityException se) {
			throw new ResourceError("Could not access file " + file, se);
		}
		catch (IOException ioe) {
			throw new ResourceError("Failed to open FileWriter for " + file, ioe);
		}
	}

	/**
	 * Rename a file, creating any directories as needed. If the destination file (or directory)
	 * exists, it is overwritten.
	 *
	 * @param src The file to be renamed. Must be non-null and must exist.
	 * @param dest The file's new name. Must be non-null. Will be overwritten if it already exists.
	 */
	public static void forceRename (File src, File dest)
	{
		final String errorPrefix = "FileUtil.forceRename: ";
		if (src == null)
			throw new CatastrophicError(errorPrefix + "source File is null.");
		if (dest == null)
			throw new CatastrophicError(errorPrefix + "destination File is null.");
		if (!src.exists())
			throw new ResourceError(errorPrefix + "source File '" + src.toString() + "' does not exist.");

		// File.renameTo(foo) requires that foo's parent directory exists.
		mkdirs(dest.getAbsoluteFile().getParentFile());
		if (dest.exists() && !recursiveDelete(dest))
			throw new ResourceError(errorPrefix + "Couldn't overwrite destination file '" + dest.toString() + "'.");
		if (!src.renameTo(dest))
			throw new ResourceError(errorPrefix + "Couldn't rename file '" + src.toString() + "' to '" + dest.toString()
			                        + "'.");
	}

	/**
	 * Query whether a {@link File} is non-null, and represents an existing <b>file</b> that can be
	 * read.
	 */
	public static boolean isReadableFile (File path)
	{
		return path != null && path.isFile() && path.canRead();
	}

	/**
	 * Compare a pair of paths using their canonical form to determine if they resolve to identical
	 * paths. Returns false if either is null.
	 */
	public static boolean isSamePath (File path1, File path2)
	{
		// Quick break-out if either path is null
		if (path1 == null || path2 == null) {
			return false;
		}
		// Compare the canonical paths
		return ObjectUtil.equals(tryMakeCanonical(path1), tryMakeCanonical(path2));
	}

	/**
	 * Add the extension {@code extension} to the {@link File} {@code file}.
	 *
	 * @param file - the File to which we want to add the {@code extension}.
	 * @param extension - the extension, without the dot, which will be appended.
	 * @return a copy of {@code file} with the extension added.
	 */
	public static File addExtension (File file, String extension)
	{
		return new File(file.getPath() + "." + extension);
	}

	/**
	 * Ensures the existence of a given file. The method does nothing if the file already exists and creates a
	 * new one if it does not.
	 * @throws ResourceError if <code>f</code> already exists and is not a file.
	 */
	public static void ensureFileExists(File f){
		try{
			if(!f.exists()){
				mkdirs(f.getAbsoluteFile().getParentFile());
				if(!f.createNewFile()) {
					throw new ResourceError("Cannot create file '" + f + "', since a directory with the same name already exists!");
				}
			}else if(f.isDirectory()){
				throw new ResourceError("Cannot create file '" + f + "', since a directory with the same name already exists!");
			}
		}catch(IOException ioe){
		  throw new ResourceError("Could not create file '" + f + "'", ioe);
		}
	}

	/**
	 * Copy a resource within a class into a file.
	 * @param clazz The class responsible for the resource.
	 * @param resourceName The resource's name.
	 * @param target The file to copy the resource to.
	 */
	/*
	public static void resourceToFile(Class<?> clazz, String resourceName, File target){
		try {
			Files.createDirectories(target.toPath().getParent());
			try (InputStream is = clazz.getResourceAsStream(resourceName);
					AtomicFileOutputStream afos = new AtomicFileOutputStream(target.toPath());
					BufferedOutputStream bos = new BufferedOutputStream(afos)) {
				StreamUtil.copy(is, bos);
			}
		} catch (IOException e) {
			throw new ResourceError("Error copying resource '" + clazz.getName() + "' '" + resourceName + "' to '" + target + "'", e);
		}
	}
	*/

	/**
	 * Attempts to create a temporary directory.
	 */
	public static File createTempDir(){
		File globalTempDir = new File(System.getProperty("java.io.tmpdir"));
		return createUniqueDirectory(globalTempDir, "semmleTempDir");
	}

	/**
	 * Magic constant: the maximum number of file operation attempts in
	 * {@link #performWithRetries}.
	 */
	private static final int FILE_OPERATION_ATTEMPTS_LIMIT = 30;
	/**
	 * Magic constant: the delay between file operation attempts in
	 * {@link #performWithRetries}. Chosen to overapproximate the time Windows
	 * Defender takes to scan directories our code creates.
	 */
	private static final int FILE_OPERATION_ATTEMPTS_DELAY_MS = 1000;

	/**
	 * Functional interface resembling a {@link BiConsumer} of {@link Path}s,
	 * but whose {@code accept} method may throw an {@link IOException}.
	 */
	private static interface RetryablePathConsumer {
		void accept(Path source, Path target) throws IOException;
	}

	/**
	 * In Java 8, this would just be BiFunction<Path, Path, String>.
	 */
	private static interface ErrorMessageCreator {
		String apply(Path source, Path target);
	}

	/**
	 * Attempts to perform the given {@code operation} on the {@code source} and
	 * {@code target} paths.
	 *
	 * If the operation fails, it is attempted again after a
	 * {@value #FILE_OPERATION_ATTEMPTS_DELAY_MS} ms delay. This process is
	 * repeated until the operation succeeds, or a total of
	 * {@value #FILE_OPERATION_ATTEMPTS_LIMIT} attempts are made, at which point
	 * an error is thrown. The given {@code errorMessageCreator} is used to
	 * construct suitable messages upon retries or failure.
	 * <p>
	 * This is useful when either the source or the target has been created just
	 * before the attempted operation. (For example, atomic directory creation
	 * usually involves creating a temporary directory with the desired contents
	 * and then moving it to the desired location, or temporary directories may
	 * be created, populated, and then deleted after use.)
	 *
	 * Aggressive variants of Windows Defender (ATP) tend to scan such newly-created
	 * files immediately, and the operation will only succeed if attempted again
	 * after Defender releases the files.
	 *
	 * @throws IOException
	 *             if the operation does not succeed after
	 *             {@value #FILE_OPERATION_ATTEMPTS_LIMIT} attempts
	 */
	private static void performWithRetries(RetryablePathConsumer operation, Path source, Path target,
			ErrorMessageCreator errorMessageCreator) throws IOException {
		for (int i = 1;; i++) {
			try {
				operation.accept(source, target);
				return;
			} catch (AtomicMoveNotSupportedException e) {
				// Allow this to propagate, since retrying won't help.
				throw e;
			} catch (IOException e) {
				String message = errorMessageCreator.apply(source, target);
				logger.warn(message + " (attempt " + i + ")", e);
				if (i == FILE_OPERATION_ATTEMPTS_LIMIT)
					throw new IOException(message + "(" + FILE_OPERATION_ATTEMPTS_LIMIT + " attempts made)", e);
			}
			try {
				logger.trace("Waiting for " + FILE_OPERATION_ATTEMPTS_DELAY_MS + " ms before making another attempt.");
				Thread.sleep(FILE_OPERATION_ATTEMPTS_DELAY_MS);
			} catch (InterruptedException e) {
				logger.warn("Thread interrupted before making another attempt.", e);
			}
		}
	}

	/**
	 * Attempts to move the {@code source} file to the {@code target} file.
	 * Wraps {@link #performWithRetries} around
	 * {@link java.nio.file.Files#move} to retry the move if it fails.
	 *
	 * @see #performWithRetries
	 */
	public static void moveWithRetries(Path source, Path target, final CopyOption... options) throws IOException {
		performWithRetries(
				new RetryablePathConsumer() {
					@Override
					public void accept(Path source, Path target) throws IOException { Files.move(source, target, options); }
				},
				source, target,
				new ErrorMessageCreator() {
					@Override
					public String apply(Path s, Path t) { return "Failed to perform move from " + s.toAbsolutePath() + " to " + t.toAbsolutePath(); }
				});
	}
}
