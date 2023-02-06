package com.semmle.util.trap.dependencies;

import java.io.File;
import java.nio.file.Path;
import java.util.AbstractSet;
import java.util.Collections;
import java.util.Iterator;
import java.util.Set;

import com.semmle.util.exception.ResourceError;

/**
 * The immediate dependencies of a particular TRAP file
 */
public class TrapDependencies extends TextFile
{
	static final String TRAP = "TRAP";

	private String trap;

	/**
	 * Create an empty dependencies node for a TRAP file
	 */
	public TrapDependencies(String trap) {
		super(TrapSet.LATEST_VERSION);
		this.trap = trap;
	}

	/**
	 * Load a TRAP dependencies (.dep) file
	 * 
	 * @param file the file to load
	 */
	public TrapDependencies(Path file) {
		super(null);
		load(TrapSet.HEADER, file);
		if(trap == null)
			parseError(file);
	}
	
	@Override
	protected Set<String> getSet(final Path file, String label) {
		if(label.equals(TRAP)) {
			return new AbstractSet<String>() {
				@Override
				public Iterator<String> iterator() {
					return null;
				}
				@Override
				public int size() {
					return 0;
				}
				@Override
				public boolean add(String s) {
					if(trap != null)
						parseError(file);
					trap = s;
					return true;
				}
			};
		}
		if(label.equals(TRAPS)) return traps;
		return null;
	}
	
	@Override
	protected void parseError(Path file) {
		throw new ResourceError("Corrupt TRAP dependencies: " + file);
	}

	/**
	 * @return the path of the TRAP with the dependencies stored in this object
	 *         (relative to the source location)
	 */
	public String trapFile() {
		return trap;
	}

	/**
	 * @return the paths of the TRAP file dependencies
	 *         (relative to the trap directory)
	 *         
	 */
	public Set<String> dependencies() {
		return Collections.unmodifiableSet(traps);
	}

	/**
	 * Add a path to a TRAP file (relative to the trap directory).
	 * 
	 * @param trap the path to the trap file to add
	 */
	public void addDependency(String trap) {
		traps.add(trap);
	}

	/*
	 * (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		appendHeaderString(sb, TrapSet.HEADER, TrapSet.LATEST_VERSION);
		appendSingleton(sb, TRAP, trap);
		appendSet(sb, TRAPS, traps);
		return sb.toString();
	}
}
