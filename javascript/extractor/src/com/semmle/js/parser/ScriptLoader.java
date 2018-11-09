package com.semmle.js.parser;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;

import org.mozilla.javascript.Context;
import org.mozilla.javascript.Function;
import org.mozilla.javascript.NativeArray;
import org.mozilla.javascript.NativeJSON;
import org.mozilla.javascript.NativeObject;
import org.mozilla.javascript.ScriptableObject;
import org.mozilla.javascript.Undefined;
import org.mozilla.javascript.UniqueTag;

import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.files.FileUtil;

/**
 * Helper class for executing JavaScript programs through Rhino and reading out values from the
 * resulting environment.
 */
public class ScriptLoader {
	private final Context cx;
	private final ScriptableObject scope;
	
	public ScriptLoader(String scriptPath) {
		InputStreamReader inputStreamReader = null;

		this.cx = Context.enter();
		this.scope = cx.initStandardObjects();
		try {
			URL script = ScriptLoader.class.getResource(scriptPath);
			if (script == null)
				throw new IOException();
			InputStream scriptStream = script.openStream();
			inputStreamReader = new InputStreamReader(scriptStream, FileUtil.UTF8);
			cx.evaluateReader(scope, inputStreamReader, scriptPath, 1, null);
		} catch (IOException e) {
			throw new CatastrophicError("Could not load script " + scriptPath + ".", e);
		} finally {
			if (inputStreamReader != null)
				FileUtil.close(inputStreamReader);
		}
	}

	/**
	 * Read a global variable.
	 */
	public Object readGlobal(String name) {
		return scope.get(name, scope);
	}

	/**
	 * Read an object property; the property name may be a path of several individual
	 * names separated by dots.
	 *
	 * @return The value of the property, or {@literal null} if it could not be found.
	 */
	public Object readProperty(Object obj, String prop) {
		Object res = obj;
		for (String p : prop.split("\\."))
			res = ScriptableObject.getProperty((ScriptableObject)res, p);
		if (res == UniqueTag.NOT_FOUND)
			return null;
		return res;
	}

	/**
	 * Read an array element.
	 *
	 * @return The value of the element, or {@literal null} if it could not be found.
	 */
	public Object readProperty(Object obj, int idx) {
		Object res = ((ScriptableObject)obj).get(idx, scope);
		if (res == UniqueTag.NOT_FOUND)
			return null;
		return res;
	}

	/**
	 * Read an object property and return its value cast to an integer.
	 */
	public Integer readIntProperty(Object obj, String prop) {
		Object res = readProperty(obj, prop);
		if (res == null || res == Undefined.instance)
			return null;
		return ((Number)res).intValue();
	}

	/**
	 * Read an array element and return its value cast to an integer.
	 */
	public Integer readIntProperty(Object obj, int idx) {
		Object res = readProperty(obj, idx);
		if (res == null || res == Undefined.instance)
			return null;
		return ((Number)res).intValue();
	}

	/**
	 * Read an object property and return its value cast to a string.
	 */
	public String readStringProperty(Object obj, String prop) {
		Object val = readProperty(obj, prop);
		if (val == null || val == Undefined.instance)
			return null;
		return String.valueOf(val);
	}

	/**
	 * Create an empty JavaScript array.
	 */
	public NativeArray mkArray() {
		return (NativeArray)cx.newArray(scope, 0);
	}

	/**
	 * Create a JavaScript object.
	 *
	 * @param properties a list of alternating keys and values to populate the object with
	 */
	public NativeObject mkObject(Object... properties) {
		NativeObject obj = new NativeObject();
		for (int i=0; i+1<properties.length; i += 2)
			obj.defineProperty((String)properties[i], properties[i+1], 0);
		return obj;
	}

	/**
	 * Call a method on an object.
	 */
	public Object callMethod(ScriptableObject obj, String method, Object... args) {
		Function f = (Function)readProperty(obj, method);
		return f.call(cx, scope, obj, args);
	}

	/**
	 * Construct an instance of a JavaScript constructor function.
	 */
	public ScriptableObject construct(Function ctor, Object... args) {
		return (ScriptableObject)ctor.construct(cx, scope, args);
	}

	/**
	 * Pretty-print an object as JSON.
	 */
	public String stringify(Object obj) {
		return (String) NativeJSON.stringify(cx, scope, obj, null, 2);
	}
}
