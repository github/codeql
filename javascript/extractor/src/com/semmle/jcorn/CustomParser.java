package com.semmle.jcorn;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;

import com.semmle.jcorn.flow.FlowParser;
import com.semmle.js.ast.ArrayExpression;
import com.semmle.js.ast.AssignmentExpression;
import com.semmle.js.ast.BlockStatement;
import com.semmle.js.ast.CallExpression;
import com.semmle.js.ast.CatchClause;
import com.semmle.js.ast.ComprehensionBlock;
import com.semmle.js.ast.ComprehensionExpression;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.ExpressionStatement;
import com.semmle.js.ast.ForInStatement;
import com.semmle.js.ast.FunctionDeclaration;
import com.semmle.js.ast.IFunction;
import com.semmle.js.ast.INode;
import com.semmle.js.ast.IPattern;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.LetExpression;
import com.semmle.js.ast.LetStatement;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.NewExpression;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.TryStatement;
import com.semmle.js.ast.VariableDeclaration;
import com.semmle.util.data.Pair;

/**
 * An extension of the standard jcorn parser with support for Mozilla-specific
 * language extension (most of JavaScript 1.8.5) and JScript language extensions.
 */
public class CustomParser extends FlowParser {
	public CustomParser(Options options, String input, int startPos) {
		super(options, input, startPos);

		// recognise `const` as a keyword, irrespective of options.ecmaVersion
		this.keywords.add("const");
	}

	// add parsing of guarded `catch` clauses
	@Override
	protected TryStatement parseTryStatement(Position startLoc) {
		if (!options.mozExtensions())
			return super.parseTryStatement(startLoc);

		this.next();
		BlockStatement block = this.parseBlock(false);
		CatchClause handler = null;
		List<CatchClause> guardedHandlers = new ArrayList<CatchClause>();
		while (this.type == TokenType._catch) {
			Position catchStartLoc = this.startLoc;
			CatchClause katch = this.parseCatchClause(catchStartLoc);
			if (handler != null)
				this.raise(catchStartLoc, "Catch after unconditional catch");
			if (katch.getGuard() != null)
				guardedHandlers.add(katch);
			else
				handler = katch;
		}
		BlockStatement finalizer = this.eat(TokenType._finally) ? this.parseBlock(false) : null;
		if (handler == null && finalizer == null && guardedHandlers.isEmpty())
			this.raise(startLoc, "Missing catch or finally clause");
		return this.finishNode(new TryStatement(new SourceLocation(startLoc), block, handler, guardedHandlers, finalizer));
	}

	/*
	 * Support for guarded `catch` clauses and omitted catch bindings.
	 */
	@Override
	protected CatchClause parseCatchClause(Position startLoc) {
		if (!options.mozExtensions())
			return super.parseCatchClause(startLoc);

		this.next();
		Expression param = null;
		Expression guard = null;
		if (this.eat(TokenType.parenL)) {
			param = this.parseBindingAtom();
			this.checkLVal(param, true, null);
			if (this.eat(TokenType._if))
				guard = this.parseExpression(false, null);
			this.expect(TokenType.parenR);
		} else if (!options.esnext()) {
			this.unexpected();
		}
		BlockStatement catchBody = this.parseBlock(false);
		return this.finishNode(new CatchClause(new SourceLocation(startLoc), (IPattern)param, guard, catchBody));
	}

	// add parsing of `let` statements and expressions
	@Override
	protected boolean mayFollowLet(int c) {
		return options.mozExtensions() && c == '(' || super.mayFollowLet(c);
	}

	@Override
	protected Statement parseVarStatement(Position startLoc, String kind) {
		if (!options.mozExtensions())
			return super.parseVarStatement(startLoc, kind);

		this.next();

		if ("let".equals(kind) && this.eat(TokenType.parenL)) {
			// this is a `let` statement or expression
			return (LetStatement) this.parseLetExpression(startLoc, true);
		}

		VariableDeclaration node = this.parseVar(startLoc, false, kind);
		this.semicolon();
		return this.finishNode(node);
	}

	@Override
	protected Expression parseExprAtom(DestructuringErrors refDestructuringErrors) {
		Position startLoc = this.startLoc;
		if (options.mozExtensions() && this.isContextual("let")) {
			this.next();
			this.expect(TokenType.parenL);
			return (Expression) this.parseLetExpression(startLoc, false);
		} else if (options.mozExtensions() && this.type == TokenType.bracketL) {
			this.next();
			// check whether this is array comprehension or regular array
			if (this.type == TokenType._for) {
				return (Expression) this.parseComprehension(startLoc, false, null);
			}
			List<Expression> elements;
			if (this.type == TokenType.comma || this.type == TokenType.bracketR ||
					this.type == TokenType.ellipsis) {
				elements = this.parseExprList(TokenType.bracketR, true, true, refDestructuringErrors);
			} else {
				Expression firstExpr = this.parseMaybeAssign(true, refDestructuringErrors, null);
				// check whether this is a postfix array comprehension
				if (this.type == TokenType._for || this.type == TokenType._if) {
					return (Expression) this.parseComprehension(startLoc, false, firstExpr);
				} else {
					this.eat(TokenType.comma);
					elements = new ArrayList<Expression>();
					elements.add(firstExpr);
					elements.addAll(this.parseExprList(TokenType.bracketR, true, true, refDestructuringErrors));
				}
			}
			return this.finishNode(new ArrayExpression(new SourceLocation(startLoc), elements));
		} else if (options.v8Extensions() && this.type == TokenType.modulo) {
			// parse V8 native
			this.next();
			Identifier name = this.parseIdent(true);
			this.expect(TokenType.parenL);
			List<Expression> args = this.parseExprList(TokenType.parenR, false, false, null);
			CallExpression node = new CallExpression(new SourceLocation(startLoc), name, new ArrayList<>(), args, false, false);
			return this.finishNode(node);
		} else {
			return super.parseExprAtom(refDestructuringErrors);
		}
	}

	protected Node parseLetExpression(Position startLoc, boolean maybeStatement) {
		// this method assumes that the keyword `let` and the opening parenthesis have already been
		// consumed
		VariableDeclaration decl = this.parseVar(startLoc, false, "let");
		this.expect(TokenType.parenR);

		if (this.type == TokenType.braceL) {
			if (!maybeStatement)
				this.unexpected();
			BlockStatement body = this.parseBlock(false);
			return this.finishNode(new LetStatement(new SourceLocation(startLoc), decl.getDeclarations(), body));
		} else if (maybeStatement) {
			Position pos = startLoc;
			Statement body = this.parseStatement(true, false);
			if (body == null)
				this.unexpected(pos);
			return this.finishNode(new LetStatement(new SourceLocation(startLoc), decl.getDeclarations(), body));
		} else {
			Expression body = this.parseExpression(false, null);
			return this.finishNode(new LetExpression(new SourceLocation(startLoc), decl.getDeclarations(), body));
		}
	}

	// add parsing of expression closures and JScript methods
	@Override
	protected INode parseFunction(Position startLoc, boolean isStatement, boolean allowExpressionBody, boolean isAsync) {
		if (isFunctionSent(isStatement))
			return super.parseFunction(startLoc, isStatement, allowExpressionBody, isAsync);
		allowExpressionBody = allowExpressionBody || options.mozExtensions() && !isStatement;
		boolean oldInGen = this.inGenerator, oldInAsync = this.inAsync;
		int oldYieldPos = this.yieldPos, oldAwaitPos = this.awaitPos;
		Pair<Boolean, Identifier> p = parseFunctionName(isStatement, isAsync);
		boolean generator = p.fst();
		Identifier id = p.snd(), iface = null;
		if (options.jscript()) {
			if (isStatement && this.eatDoubleColon()) {
				iface = p.snd();
				id = this.parseIdent(false);
			}
		}
		IFunction result = parseFunctionRest(startLoc, isStatement, allowExpressionBody, oldInGen, oldInAsync,
				oldYieldPos, oldAwaitPos, generator, id);
		if (iface != null) {
			/* Translate JScript double colon method declarations into normal method definitions:
			 *
			 *   function A::f(...) { ... }
			 *
			 * becomes
			 *
			 *   A.f = function f(...) { ... };
			 */
			SourceLocation memloc = new SourceLocation(iface.getName() + "::" + id.getName(), iface.getLoc().getStart(), id.getLoc().getEnd());
			MemberExpression mem = new MemberExpression(memloc, iface, new Identifier(id.getLoc(), id.getName()), false, false, false);
			AssignmentExpression assgn = new AssignmentExpression(result.getLoc(), "=", mem, ((FunctionDeclaration)result).asFunctionExpression());
			return new ExpressionStatement(result.getLoc(), assgn);
		}
		return result;
	}

	private boolean eatDoubleColon() {
		if (this.eat(TokenType.colon)) {
			this.expect(TokenType.colon);
			return true;
		} else {
			return this.eat(doubleColon);
		}
	}

	// accept `yield` in non-generator functions
	@Override
	protected Expression parseMaybeAssign(boolean noIn,
			DestructuringErrors refDestructuringErrors,
			AfterLeftParse afterLeftParse) {
		if (options.mozExtensions() && isContextual("yield")) {
			if (!this.inFunction)
				this.raise(this.startLoc, "Yield not in function");
			return this.parseYield();
		}
		return super.parseMaybeAssign(noIn, refDestructuringErrors, afterLeftParse);
	}

	// add parsing of comprehensions
	protected Node parseComprehension(Position startLoc, boolean isGenerator, Expression body) {
		List<ComprehensionBlock> blocks = new ArrayList<ComprehensionBlock>();
		while (this.type == TokenType._for) {
			SourceLocation blockStart = new SourceLocation(this.startLoc);
			this.next();
			this.expect(TokenType.parenL);
			Expression left = this.parseBindingAtom();
			this.checkLVal(left, true, null);
			boolean of;
			if (this.eatContextual("of")) {
				of = true;
			} else {
				this.expect(TokenType._in);
				of = false;
			}
			Expression right = this.parseExpression(false, null);
			this.expect(TokenType.parenR);
			blocks.add(this.finishNode(new ComprehensionBlock(blockStart, (IPattern)left, right, of)));
		}
		Expression filter = this.eat(TokenType._if) ? this.parseParenExpression() : null;
		if (body == null)
			body = this.parseExpression(false, null);
		this.expect(isGenerator ? TokenType.parenR : TokenType.bracketR);

		return this.finishNode(new ComprehensionExpression(new SourceLocation(startLoc), body, blocks, filter, isGenerator));
	}

	@Override
	protected Expression parseParenAndDistinguishExpression(boolean canBeArrow) {
		if (options.mozExtensions()) {
			// check whether next token is `for`, suggesting a generator comprehension
			Position startLoc = this.startLoc;
			Matcher m = Whitespace.skipWhiteSpace.matcher(this.input);
			if (m.find(this.pos)) {
				if (m.end()+3 < input.length() &&
						"for".equals(input.substring(m.end(), m.end()+3)) &&
						!Identifiers.isIdentifierChar(input.charAt(m.end()+3), true)) {
					next();
					return (Expression) parseComprehension(startLoc, true, null);
				}
			}
		}

		return super.parseParenAndDistinguishExpression(canBeArrow);
	}

	// add parsing of for-each loops
	@Override
	protected Statement parseForStatement(Position startLoc) {
		boolean each = false;
		if (options.mozExtensions() && this.isContextual("each")) {
			this.next();
			each = true;
		}
		Position afterEach = this.startLoc;
		Statement result = super.parseForStatement(startLoc);
		if (each) {
			if (result instanceof ForInStatement) {
				ForInStatement fis = (ForInStatement) result;
				result = new ForInStatement(fis.getLoc(), fis.getLeft(), fis.getRight(), fis.getBody(), true);
			} else {
				raise(afterEach, "Bad for-each statement.");
			}
		}
		return result;
	}

	// add parsing of Rhino/Nashorn-style `new` expressions with last argument after `)`
	@Override
	protected Expression parseNew() {
		Expression res = super.parseNew();
		if (res instanceof NewExpression &&
				options.mozExtensions() && !canInsertSemicolon() && this.type == TokenType.braceL) {
			((NewExpression) res).getArguments().add(this.parseObj(false, null));
			res = this.finishNode(res);
		}
		return res;
	}
}
