package com.semmle.js.parser;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mozilla.javascript.NativeArray;
import org.mozilla.javascript.NativeObject;
import org.mozilla.javascript.UniqueTag;

import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.SourceLocation;
import com.semmle.util.exception.CatastrophicError;

/**
 * Decode SpiderMonkey AST objects into their Java equivalents.
 *
 * We assume that every AST node has a <code>type</code> property uniquely identifying its
 * type, which is also the name of the corresponding Java class.
 *
 * For each Java class, a list of properties to read from the SpiderMonkey AST object has to be provided.
 * It is assumed that the Java class has a single constructor which takes exactly those
 * properties as arguments.
 */
public class JSObjectDecoder<T extends SourceElement> {
	private final ScriptLoader loader;
	private final String source;
	private final String pkg;
	private final Map<Class<? extends T>, List<String>> spec;

	/**
	 * Construct a new object decoder.
	 *
	 * @param source the source code from which the AST was parsed
	 * @param loader the Rhino instance to use
	 * @param pkg the package in which to look for Java classes
	 * @param spec a mapping from Java classes to properties
	 */
	public JSObjectDecoder(String source, ScriptLoader loader, String pkg, Map<Class<? extends T>, List<String>> spec) {
		this.source = source;
		this.loader = loader;
		this.pkg = pkg;
		this.spec = spec;
	}

	/**
	 * Decode a given SpiderMonkey AST object.
	 *
	 * Any exceptions that occur during conversion are caught and re-thrown as {@link CatastrophicError},
	 * except for {@link ClassNotFoundException}s resulting from unsupported AST node types, which are
	 * re-thrown as {@link ParseError}s.
	 */
	@SuppressWarnings("unchecked")
	public T decodeObject(NativeObject object) throws ParseError {
		String type = (String) loader.readProperty(object, "type");
		try {
			Class<? extends T> clazz = (Class<? extends T>)Class.forName(pkg + "." + type);
			return decodeObject(object, clazz);
		} catch (ClassNotFoundException e) {
			throw new ParseError("Unexpected node type " + e, decodeLocation(object).getStart());
		}
	}

	/**
	 * Decode a given SpiderMonkey AST object as an instance of a given class.
	 *
	 * Any exceptions that occur during conversion are caught and re-thrown as {@link CatastrophicError},
	 * except for {@link ClassNotFoundException}s resulting from unsupported AST node types, which are
	 * re-thrown as {@link ParseError}s.
	 */
	@SuppressWarnings("unchecked")
	public <V> V decodeObject(NativeObject object, Class<V> clazz) throws ParseError {
		SourceLocation loc = decodeLocation(object);
		Object[] ctorArgs = null;
		try {
			List<String> props = spec.get(clazz);
			if (props == null)
				throw new CatastrophicError("Unsupported node type " + clazz.getName());
			ctorArgs = new Object[props.size()+1];
			ctorArgs[0] = loc;
			for (int i=1; i<ctorArgs.length; ++i) {
				String argName = props.get(i-1);
				Object arg = loader.readProperty(object, argName);
				if (arg instanceof NativeObject) {
					ctorArgs[i] = decodeObject((NativeObject)arg);
				} else if (arg instanceof NativeArray) {
					ctorArgs[i] = decodeObjects((NativeArray)arg);
				} else if (arg == UniqueTag.NOT_FOUND) {
					ctorArgs[i] = null;
				} else if (arg instanceof CharSequence) {
					// Rhino has its own funny string types; normalise
					ctorArgs[i] = arg.toString();
				} else {
					ctorArgs[i] = arg;
				}
			}
			return (V)clazz.getConstructors()[0].newInstance(ctorArgs);
		} catch (InstantiationException e) {
			throw new CatastrophicError(e);
		} catch (IllegalAccessException e) {
			throw new CatastrophicError(e);
		} catch (IllegalArgumentException e) {
			throw new CatastrophicError(e);
		} catch (InvocationTargetException e) {
			throw new CatastrophicError(e);
		} catch (SecurityException e) {
			throw new CatastrophicError(e);
		}
	}

	/**
	 * Decode an array of SpiderMonkey AST objects.
	 */
	public List<T> decodeObjects(NativeArray objects) throws ParseError {
		List<T> result = new ArrayList<T>(objects.size());
		for (Object object : objects) {
			if (object == null)
				result.add(null);
			else
				result.add(decodeObject((NativeObject)object));
		}
		return result;
	}

	/**
	 * Decode an array of SpiderMonkey AST objects as instances of a given class.
	 */
	public <V> List<V> decodeObjects(Class<V> clazz, NativeArray objects) throws ParseError {
		List<V> result = new ArrayList<V>(objects.size());
		for (Object object : objects) {
			if (object == null)
				result.add(null);
			else
				result.add(decodeObject((NativeObject)object, clazz));
		}
		return result;
	}

	/**
	 * Bound <code>x</code> between <code>lo</code> and <code>hi</code>, inclusive.
	 */
	private int bound(int x, int lo, int hi) {
		if (x < lo)
			return lo;
		if (x > hi)
			return hi;
		return x;
	}

	/**
	 * Decode a SpiderMonkey location object into a {@link SourceLocation}.
	 */
	public SourceLocation decodeLocation(NativeObject object) {
		Integer startOffset, endOffset;
		Position start, end;
		Object loc = loader.readProperty(object, "loc");

		if (loc == null) {
			// no 'loc' property; check whether we have 'range'
			Object range = loader.readProperty(object, "range");
			if (range instanceof NativeArray) {
				// good; make up a source location on line 0
				startOffset = loader.readIntProperty(range, 0);
				endOffset = loader.readIntProperty(range, 1);
				start = new Position(1, startOffset, startOffset);
				end = new Position(1, endOffset, endOffset);
				return new SourceLocation(getSource(startOffset, endOffset), start, end);
			}
			return null;
		}

		startOffset = loader.readIntProperty(object, "start");
		endOffset = loader.readIntProperty(object, "end");
		start = decodePosition((NativeObject)loader.readProperty(loc, "start"), startOffset);
		end = decodePosition((NativeObject)loader.readProperty(loc, "end"), endOffset);
		return new SourceLocation(getSource(startOffset, endOffset), start, end);
	}

	/**
	 * Extract the source code between a given start and end offset.
	 */
	public String getSource(Integer startOffset, Integer endOffset) {
		if (startOffset == null || endOffset == null || startOffset > endOffset)
			return "";
		return source.substring(bound(startOffset, 0, source.length()), bound(endOffset, 0, source.length()));
	}

	/**
	 * Decode a SpiderMonkey position object into a {@link SourceLocation}.
	 */
	private Position decodePosition(NativeObject object, int offset) {
		return new Position(loader.readIntProperty(object, "line"), loader.readIntProperty(object, "column"), offset);
	}
}
