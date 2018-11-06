package com.semmle.js.parser;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.mozilla.javascript.Function;
import org.mozilla.javascript.NativeArray;
import org.mozilla.javascript.NativeObject;
import org.mozilla.javascript.ScriptableObject;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.regexp.BackReference;
import com.semmle.js.ast.regexp.Caret;
import com.semmle.js.ast.regexp.CharacterClass;
import com.semmle.js.ast.regexp.CharacterClassEscape;
import com.semmle.js.ast.regexp.CharacterClassRange;
import com.semmle.js.ast.regexp.Constant;
import com.semmle.js.ast.regexp.ControlEscape;
import com.semmle.js.ast.regexp.ControlLetter;
import com.semmle.js.ast.regexp.DecimalEscape;
import com.semmle.js.ast.regexp.Disjunction;
import com.semmle.js.ast.regexp.Dollar;
import com.semmle.js.ast.regexp.Dot;
import com.semmle.js.ast.regexp.Error;
import com.semmle.js.ast.regexp.Group;
import com.semmle.js.ast.regexp.HexEscapeSequence;
import com.semmle.js.ast.regexp.IdentityEscape;
import com.semmle.js.ast.regexp.NamedBackReference;
import com.semmle.js.ast.regexp.NonWordBoundary;
import com.semmle.js.ast.regexp.OctalEscape;
import com.semmle.js.ast.regexp.Opt;
import com.semmle.js.ast.regexp.Plus;
import com.semmle.js.ast.regexp.Range;
import com.semmle.js.ast.regexp.RegExpTerm;
import com.semmle.js.ast.regexp.Sequence;
import com.semmle.js.ast.regexp.Star;
import com.semmle.js.ast.regexp.UnicodeEscapeSequence;
import com.semmle.js.ast.regexp.UnicodePropertyEscape;
import com.semmle.js.ast.regexp.WordBoundary;
import com.semmle.js.ast.regexp.ZeroWidthNegativeLookahead;
import com.semmle.js.ast.regexp.ZeroWidthNegativeLookbehind;
import com.semmle.js.ast.regexp.ZeroWidthPositiveLookahead;
import com.semmle.js.ast.regexp.ZeroWidthPositiveLookbehind;

/**
 * Wrapper for invoking esregex through Rhino.
 */
public class RegExpParser extends ScriptLoader {
	/**
	 * Specification for esregex AST types.
	 */
	private static final Map<Class<? extends RegExpTerm>, List<String>> spec = new LinkedHashMap<Class<? extends RegExpTerm>, List<String>>();
	static {
		spec.put(BackReference.class, Arrays.asList("value", "raw"));
		spec.put(Caret.class, Collections.<String>emptyList());
		spec.put(CharacterClass.class, Arrays.asList("elements", "inverted"));
		spec.put(CharacterClassEscape.class, Arrays.asList("class", "raw"));
		spec.put(CharacterClassRange.class, Arrays.asList("left", "right"));
		spec.put(Constant.class, Arrays.asList("value"));
		spec.put(ControlEscape.class, Arrays.asList("value", "codepoint", "raw"));
		spec.put(ControlLetter.class, Arrays.asList("value", "codepoint", "raw"));
		spec.put(DecimalEscape.class, Arrays.asList("value", "codepoint", "raw"));
		spec.put(Disjunction.class, Arrays.asList("disjuncts"));
		spec.put(Dollar.class, Collections.<String>emptyList());
		spec.put(Dot.class, Collections.<String>emptyList());
		spec.put(Group.class, Arrays.asList("capture", "number", "name", "operand"));
		spec.put(HexEscapeSequence.class, Arrays.asList("value", "codepoint", "raw"));
		spec.put(IdentityEscape.class, Arrays.asList("value", "codepoint", "raw"));
		spec.put(NamedBackReference.class, Arrays.asList("name", "raw"));
		spec.put(NonWordBoundary.class, Collections.<String>emptyList());
		spec.put(OctalEscape.class, Arrays.asList("value", "codepoint", "raw"));
		spec.put(Opt.class, Arrays.asList("operand", "greedy"));
		spec.put(Plus.class, Arrays.asList("operand", "greedy"));
		spec.put(Range.class, Arrays.asList("operand", "greedy", "lo", "hi"));
		spec.put(Sequence.class, Arrays.asList("elements"));
		spec.put(Star.class, Arrays.asList("operand", "greedy"));
		spec.put(UnicodeEscapeSequence.class, Arrays.asList("value", "codepoint", "raw"));
		spec.put(WordBoundary.class, Collections.<String>emptyList());
		spec.put(ZeroWidthNegativeLookahead.class, Arrays.asList("operand"));
		spec.put(ZeroWidthPositiveLookahead.class, Arrays.asList("operand"));
		spec.put(ZeroWidthNegativeLookbehind.class, Arrays.asList("operand"));
		spec.put(ZeroWidthPositiveLookbehind.class, Arrays.asList("operand"));
		spec.put(UnicodePropertyEscape.class, Arrays.asList("name", "value", "raw"));
	}

	/**
	 * Specification for esregex parse errors.
	 */
	private static final Map<Class<? extends Error>, List<String>> errspec = new LinkedHashMap<Class<? extends Error>, List<String>>();
	static {
		errspec.put(Error.class, Arrays.asList("code"));
	}

	/**
	 * The result of a parse.
	 */
	public static class Result {
		/**
		 * The root of the parsed AST.
		 */
		private final RegExpTerm ast;

		/**
		 * A list of errors encountered during parsing.
		 */
		private final List<Error> errors;

		public Result(RegExpTerm ast, List<Error> errors) {
			this.ast = ast;
			this.errors = errors;
		}

		public RegExpTerm getAST() {
			return ast;
		}

		public List<Error> getErrors() {
			return errors;
		}
	}

	public RegExpParser() {
		super("/regexparser.js");
	}

	/**
	 * Parse the given string as a regular expression.
	 */
	public Result parse(String src) {
		Function ctor = (Function)readGlobal("RegExpParser");
		ScriptableObject parser = construct(ctor, src);
		NativeObject ast = (NativeObject)callMethod(parser, "Pattern");
		NativeArray errors = (NativeArray)readProperty(parser, "errors");
		JSObjectDecoder<RegExpTerm> decoder = new JSObjectDecoder<RegExpTerm>(src, this, "com.semmle.js.ast.regexp", spec);
		List<Error> errs = null;
		RegExpTerm term = null;
		try {
			term = decoder.decodeObject(ast);
			errs = new JSObjectDecoder<Error>(src, this, "com.semmle.js.ast.regexp", errspec).decodeObjects(errors);
		} catch (ParseError e) {
			errs = new ArrayList<Error>();
			errs.add(new Error(new SourceLocation("", e.getPosition(), e.getPosition()), 1));
		}
		return new Result(term, errs);
	}
}
