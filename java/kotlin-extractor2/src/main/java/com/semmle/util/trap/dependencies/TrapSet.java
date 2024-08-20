package com.semmle.util.trap.dependencies;

import java.nio.file.Path;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

import com.semmle.util.exception.ResourceError;

/**
 * A set of source files and the TRAP files that were generated when
 * compiling them.
 * <p>
 * The set of TRAP files is not necessarily sufficient to create a
 * consistent database, unless combined with inter-TRAP dependency
 * information from .dep files (see {@link TrapDependencies}).
 */
public class TrapSet extends TextFile
{
	static final String HEADER = "TRAP dependencies";
	static final String LATEST_VERSION = "1.2";
	static final String SOURCES = "SOURCES";
	static final String INCLUDES = "INCLUDES";
	static final String OBJECTS = "OBJECTS";
	static final String INPUT_OBJECTS = "INPUT_OBJECTS";

	// state
	private final Set<String> sources = new LinkedHashSet<String>();
	private final Set<String> includes = new LinkedHashSet<String>();
	private final Set<String> objects = new LinkedHashSet<String>();
	private final Set<String> inputObjects = new LinkedHashSet<String>();

	private Path file;

	/**
	 * Create an empty TRAP set
	 */
	public TrapSet() {
		super(LATEST_VERSION);
	}
	
	@Override
	protected Set<String> getSet(Path file, String label) {
		if (label.equals(SOURCES)) return sources;
		if (label.equals(INCLUDES)) return includes;
		if (label.equals(OBJECTS)) return objects;
		if (label.equals(INPUT_OBJECTS)) return inputObjects;
		if (label.equals(TRAPS)) return traps;
		return null;
	}

	/**
	 * Load a TRAP set (.set) file
	 * 
	 * @param path the file to load
	 */
	public TrapSet(Path path) {
		super(null);
		load(HEADER, path);
		this.file = path;
	}

	/**
	 * Return the most recent file used when loading or saving this
	 * trap set. If this set was constructed, rather than loaded, and
	 * has not been saved then the result is <code>null</code>.
	 *
	 * @return the file or <code>null</code>
	 */
	public Path getFile() {
		return file;
	}
	
	@Override
	protected void parseError(Path file) {
		throw new ResourceError("Corrupt TRAP set: " + file);
	}

	/**
	 * @return the paths of the source files contained in this TRAP set
	 */
	public Set<String> sourceFiles() {
		return Collections.unmodifiableSet(sources);
	}

	/**
	 * @return the paths to the include files contained in this TRAP set
	 */
	public Set<String> includeFiles() {
		return Collections.unmodifiableSet(includes);
	}

	/**
	 * @return the paths of the TRAP files contained in this TRAP set
	 *         (relative to the trap directory)
	 *         
	 */
	public Set<String> trapFiles() {
		return Collections.unmodifiableSet(traps);
	}
	
	/**
	 * @return the object names in this TRAP set
	 *
	 */
	public Set<String> objectNames() {
		return Collections.unmodifiableSet(objects);
	}

	/**
	 * @return the object names in this TRAP set
	 *
	 */
	public Set<String> inputObjectNames() {
		return Collections.unmodifiableSet(inputObjects);
	}

	/**
	 * Add a fully-qualified path to a source-file.
	 * 
	 * @param source the path to the source file to add
	 */
	public void addSource(String source) {
		sources.add(source);
	}

	/**
	 * Add a fully-qualified path to an include-file.
	 *
	 * @param include the path to the include file to add
	 */
	public void addInclude(String include) {
		includes.add(include);
	}

	/**
	 * Add a path to a TRAP file (relative to the trap directory).
	 * 
	 * @param trap the path to the trap file to add
	 * @return true if the path was not already present
	 */
	public boolean addTrap(String trap) {
		return traps.add(trap);
	}

	/**
	 * Check if this set contains a TRAP path
	 * 
	 * @param trap the path to check
	 * @return true if this set contains the path
	 */
	public boolean containsTrap(String trap) {
		return trap.contains(trap);
	}

	/**
	 * Are the sources mentioned in this TRAP set disjoint from the given
	 * set of paths?
	 * 
	 * @param paths the set of paths to check disjointness with 
	 * @return true if and only if the paths are disjoint
	 */
	public boolean sourcesDisjointFrom(Set<String> paths) {
		for (String source : sources)
			if (paths.contains(source))
				return false;
		return true;
	}

	/**
	 * Save this TRAP set to a .set file (or throw a ResourceError on failure)
	 * 
	 * @param file the file in which to save this set
	 */
	@Override
	public void save(Path file) {
		super.save(file);
		this.file = file;
	}

	/*
	 * (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		appendHeaderString(sb, HEADER, LATEST_VERSION);
		appendSet(sb, SOURCES, sources);
		appendSet(sb, INCLUDES, includes);
		appendSet(sb, OBJECTS, objects);
		appendSet(sb, INPUT_OBJECTS, inputObjects);
		appendSet(sb, TRAPS, traps);
		return sb.toString();
	}
}
