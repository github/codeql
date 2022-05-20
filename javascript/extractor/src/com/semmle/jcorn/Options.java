package com.semmle.jcorn;

import com.semmle.jcorn.Identifiers.Dialect;
import com.semmle.js.ast.Comment;
import com.semmle.js.ast.Position;
import com.semmle.js.ast.Program;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Token;
import java.util.List;
import java.util.function.BiFunction;
import java.util.function.Function;

/// options.js
public class Options {
  public enum AllowReserved {
    YES(true),
    NO(false),
    NEVER(false);

    private final boolean isTrue;

    private AllowReserved(boolean isTrue) {
      this.isTrue = isTrue;
    }

    public boolean isTrue() {
      return isTrue;
    }
  }

  public interface OnCommentCallback {
    public void call(
        boolean block,
        String input,
        String text,
        int start,
        int end,
        Position startLoc,
        Position endLoc);
  }

  private boolean allowHashBang, allowReturnOutsideFunction, allowImportExportEverywhere, allowGeneratedCodeExprs;
  private boolean preserveParens, mozExtensions, jscript, esnext, v8Extensions, e4x;
  private int ecmaVersion;
  private AllowReserved allowReserved;
  private String sourceType;
  private BiFunction<Integer, Position, Void> onInsertedSemicolon, onTrailingComma;
  private Function<Token, Void> onToken;
  private OnCommentCallback onComment;
  private Program program;
  private Function<SyntaxError, ?> onRecoverableError;

  public Options() {
    this.ecmaVersion = 10;
    this.sourceType = "script";
    this.onInsertedSemicolon = null;
    this.onTrailingComma = null;
    this.allowReserved = AllowReserved.YES;
    this.allowReturnOutsideFunction = false;
    this.allowImportExportEverywhere = false;
    this.allowGeneratedCodeExprs = true;
    this.allowHashBang = false;
    this.onToken = null;
    this.onComment = null;
    this.program = null;
    this.preserveParens = false;
    this.mozExtensions = false;
    this.jscript = false;
    this.esnext = false;
    this.v8Extensions = false;
    this.e4x = false;
    this.onRecoverableError = null;
  }

  public Options(Options that) {
    this.allowHashBang = that.allowHashBang;
    this.allowReturnOutsideFunction = that.allowReturnOutsideFunction;
    this.allowImportExportEverywhere = that.allowImportExportEverywhere;
    this.allowGeneratedCodeExprs = that.allowGeneratedCodeExprs;
    this.preserveParens = that.preserveParens;
    this.mozExtensions = that.mozExtensions;
    this.jscript = that.jscript;
    this.esnext = that.esnext;
    this.v8Extensions = that.v8Extensions;
    this.e4x = that.e4x;
    this.ecmaVersion = that.ecmaVersion;
    this.allowReserved = that.allowReserved;
    this.sourceType = that.sourceType;
    this.onInsertedSemicolon = that.onInsertedSemicolon;
    this.onTrailingComma = that.onTrailingComma;
    this.onToken = that.onToken;
    this.onComment = that.onComment;
    this.program = that.program;
    this.onRecoverableError = that.onRecoverableError;
  }

  public boolean allowHashBang() {
    return allowHashBang;
  }

  public boolean allowReturnOutsideFunction() {
    return allowReturnOutsideFunction;
  }

  public boolean allowImportExportEverywhere() {
    return allowImportExportEverywhere;
  }

  public boolean allowGeneratedCodeExprs() {
    return allowGeneratedCodeExprs;
  }

  public boolean preserveParens() {
    return preserveParens;
  }

  public boolean mozExtensions() {
    return mozExtensions;
  }

  public boolean jscript() {
    return jscript;
  }

  public boolean esnext() {
    return esnext;
  }

  public boolean v8Extensions() {
    return v8Extensions;
  }

  public boolean e4x() {
    return e4x;
  }

  public Identifiers.Dialect getDialect() {
    switch (ecmaVersion) {
      case 3:
        return Dialect.ECMA_3;
      case 5:
        return Dialect.ECMA_5;
      case 6:
        return Dialect.ECMA_6;
      case 8:
        return Dialect.ECMA_8;
      default:
        return Dialect.ECMA_7;
    }
  }

  public int ecmaVersion() {
    return ecmaVersion;
  }

  public Options ecmaVersion(int ecmaVersion) {
    if (ecmaVersion >= 2015) ecmaVersion -= 2009;

    this.ecmaVersion = ecmaVersion;
    if (ecmaVersion >= 5) this.allowReserved = AllowReserved.NO;
    return this;
  }

  public AllowReserved allowReserved() {
    return allowReserved;
  }

  public Options onComment(List<Comment> comments) {
    this.onComment =
        (block, input, text, start, end, startLoc, endLoc) -> {
          String src = input.substring(start, end);
          comments.add(new Comment(new SourceLocation(src, startLoc, endLoc), text));
        };
    return this;
  }

  public String sourceType() {
    return sourceType;
  }

  public Options sourceType(String sourceType) {
    this.sourceType = sourceType;
    return this;
  }

  public Options mozExtensions(boolean mozExtensions) {
    this.mozExtensions = mozExtensions;
    return this;
  }

  public Options jscript(boolean jscript) {
    this.jscript = jscript;
    return this;
  }

  public Options esnext(boolean esnext) {
    this.esnext = esnext;
    return this;
  }

  public void v8Extensions(boolean v8Extensions) {
    this.v8Extensions = v8Extensions;
  }

  public void e4x(boolean e4x) {
    this.e4x = e4x;
  }

  public Options preserveParens(boolean preserveParens) {
    this.preserveParens = preserveParens;
    return this;
  }

  public Options allowReturnOutsideFunction(boolean allowReturnOutsideFunction) {
    this.allowReturnOutsideFunction = allowReturnOutsideFunction;
    return this;
  }

  public Options allowImportExportEverywhere(boolean allowImportExportEverywhere) {
    this.allowImportExportEverywhere = allowImportExportEverywhere;
    return this;
  }

  public BiFunction<Integer, Position, Void> onInsertedSemicolon() {
    return onInsertedSemicolon;
  }

  public BiFunction<Integer, Position, Void> onTrailingComma() {
    return onTrailingComma;
  }

  public Function<Token, Void> onToken() {
    return onToken;
  }

  public Options onToken(List<Token> tokens) {
    return onToken(
        (tk) -> {
          tokens.add(tk);
          return null;
        });
  }

  public Options onToken(Function<Token, Void> tmp) {
    this.onToken = tmp;
    return this;
  }

  public OnCommentCallback onComment() {
    return onComment;
  }

  public Program program() {
    return program;
  }

  public Options onRecoverableError(Function<SyntaxError, ?> onRecoverableError) {
    this.onRecoverableError = onRecoverableError;
    return this;
  }

  public Function<SyntaxError, ?> onRecoverableError() {
    return onRecoverableError;
  }
}
