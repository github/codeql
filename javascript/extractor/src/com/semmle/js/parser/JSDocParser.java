package com.semmle.js.parser;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.mozilla.javascript.NativeArray;
import org.mozilla.javascript.NativeObject;
import org.mozilla.javascript.Undefined;

import com.semmle.js.ast.Comment;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.jsdoc.AllLiteral;
import com.semmle.js.ast.jsdoc.ArrayType;
import com.semmle.js.ast.jsdoc.FieldType;
import com.semmle.js.ast.jsdoc.FunctionType;
import com.semmle.js.ast.jsdoc.JSDocComment;
import com.semmle.js.ast.jsdoc.JSDocTag;
import com.semmle.js.ast.jsdoc.JSDocTypeExpression;
import com.semmle.js.ast.jsdoc.NameExpression;
import com.semmle.js.ast.jsdoc.NonNullableType;
import com.semmle.js.ast.jsdoc.NullLiteral;
import com.semmle.js.ast.jsdoc.NullableLiteral;
import com.semmle.js.ast.jsdoc.NullableType;
import com.semmle.js.ast.jsdoc.OptionalType;
import com.semmle.js.ast.jsdoc.ParameterType;
import com.semmle.js.ast.jsdoc.RecordType;
import com.semmle.js.ast.jsdoc.RestType;
import com.semmle.js.ast.jsdoc.TypeApplication;
import com.semmle.js.ast.jsdoc.UndefinedLiteral;
import com.semmle.js.ast.jsdoc.UnionType;
import com.semmle.js.ast.jsdoc.VoidLiteral;
import com.semmle.util.exception.Exceptions;

/**
 * A wrapper for invoking <a href="https://github.com/Constellation/doctrine">doctrine</a> through Rhino.
 */
public class JSDocParser extends ScriptLoader {
	public JSDocParser() {
		super("/doctrine.js");
	}

	/**
	 * Parse the given string as a JSDoc comment.
	 */
	public JSDocComment parse(Comment comment) {
		NativeObject doctrine = (NativeObject)readGlobal("doctrine");
		NativeObject opts = mkObject("unwrap", true, "recoverable", true,
				"sloppy", true, "lineNumbers", true);
		NativeObject res = (NativeObject)callMethod(doctrine, "parse", comment.getText().substring(1), opts);
		return decodeJSDocComment(res, comment);
	}

	private JSDocComment decodeJSDocComment(NativeObject obj, Comment comment) {
		String description = (String)readProperty(obj, "description");
		NativeArray tags = (NativeArray)readProperty(obj, "tags");
		return new JSDocComment(comment, description, decodeJSDocTags(tags, comment));
	}

	private List<JSDocTag> decodeJSDocTags(NativeArray tags, Comment comment) {
		String src = comment.getText().substring(1);
		List<JSDocTag> result = new ArrayList<JSDocTag>(tags.size());
		for (Object tag : tags) {
			String title = readStringProperty(tag, "title");
			String description = readStringProperty(tag, "description");
			String name = readStringProperty(tag, "name");
			int startLine = readIntProperty(tag, "startLine");
			int startColumn = readIntProperty(tag, "startColumn");

			Object type = readProperty(tag, "type");
			JSDocTypeExpression jsdocType;
			if (type == null || type == Undefined.instance) {
				jsdocType = null;
			} else {
				JSObjectDecoder<JSDocTypeExpression> typeDecoder = new JSObjectDecoder<JSDocTypeExpression>(src, this, "com.semmle.js.ast.jsdoc", spec);
				try {
					jsdocType = typeDecoder.decodeObject((NativeObject)type);
				} catch (ParseError e) {
					Exceptions.ignore(e, "Exceptions in JSDoc should always be ignored.");
					jsdocType = null;
				}
			}

			NativeArray err = (NativeArray)readProperty(tag, "errors");
			List<String> errors = new ArrayList<String>();
			if (err != null) {
				for (Object msg : err) {
					errors.add(String.valueOf(msg));
				}
			}

			int realStartLine = comment.getLoc().getStart().getLine() + startLine;
			int realStartColumn = (startLine == 0 ? comment.getLoc().getStart().getColumn() + 3 : 0) + startColumn;
			SourceLocation loc = new SourceLocation(src, new Position(realStartLine, realStartColumn, -1), new Position(realStartLine, realStartColumn + 1 + title.length(), -1));
			result.add(new JSDocTag(loc, title, description, name, jsdocType, errors));
		}
		return result;
	}

	/**
	 * Specification of Doctrine AST types for JSDoc type expressions.
	 */
	private static final Map<Class<? extends JSDocTypeExpression>, List<String>> spec = new LinkedHashMap<Class<? extends JSDocTypeExpression>, List<String>>();
	static {
		spec.put(AllLiteral.class, Arrays.<String>asList());
		spec.put(ArrayType.class, Arrays.asList("elements"));
		spec.put(FieldType.class, Arrays.asList("key", "value"));
		spec.put(FunctionType.class, Arrays.asList("this", "new", "params", "result"));
		spec.put(NameExpression.class, Arrays.asList("name"));
		spec.put(NonNullableType.class, Arrays.asList("expression", "prefix"));
		spec.put(NullableLiteral.class, Arrays.<String>asList());
		spec.put(NullLiteral.class, Arrays.<String>asList());
		spec.put(NullableType.class, Arrays.asList("expression", "prefix"));
		spec.put(OptionalType.class, Arrays.asList("expression"));
		spec.put(ParameterType.class, Arrays.asList("name", "expression"));
		spec.put(RecordType.class, Arrays.asList("fields"));
		spec.put(RestType.class, Arrays.asList("expression"));
		spec.put(TypeApplication.class, Arrays.asList("expression", "applications"));
		spec.put(UndefinedLiteral.class, Arrays.<String>asList());
		spec.put(UnionType.class, Arrays.asList("elements"));
		spec.put(VoidLiteral.class, Arrays.<String>asList());
	}
}
