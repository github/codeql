import cpp
import semmle.code.cpp.commons.unix.Constants

bindingset[n, digit]
private string octalDigit(int n, int digit) {
  result = n.bitShiftRight(digit * 3).bitAnd(7).toString()
}

bindingset[n, digit]
private string octalDigitOpt(int n, int digit) {
  exists(string s | s = octalDigit(n, digit) | if s = "0" then result = "" else result = s)
}

bindingset[mode]
string octalFileMode(int mode) {
  if mode >= 0 and mode <= 4095
  then
    /* octal 07777 */ result =
      "0" + octalDigitOpt(mode, 3) + octalDigit(mode, 2) + octalDigit(mode, 1) + octalDigit(mode, 0)
  else result = "[non-standard mode: decimal " + mode + "]"
}

/**
 * Holds if the bitmask `mask` sets any of the bit fields in `fields`.
 */
bindingset[mask, fields]
predicate sets(int mask, int fields) { mask.bitAnd(fields) != 0 }

/**
 * Gets the value that `fc` sets the umask to, if `fc` is a call to
 * one of the `umask` family of functions.
 */
private int umask(FunctionCall fc) {
  fc.getTarget().getName() = ["umask", "_umask", "_umask_s"] and
  result = fc.getArgument(0).getValue().toInt()
}

class Umask extends int {
  Umask() { this = 0 or this = umask(_) }

  bindingset[mode, this]
  int mask(int mode) { result = mode.bitAnd(this.bitNot()) }
}

Umask defaultUmask() { result = 0 }

/**
 * Gets the last umask set in `block`.
 */
private Umask lastUmask(BasicBlock block) {
  exists(int i |
    result = umask(block.getNode(i)) and
    not exists(int j | j > i | exists(umask(block.getNode(j))))
  )
}

private Umask umaskStrictlyReaches(BasicBlock block) {
  exists(BasicBlock pred | pred = block.getAPredecessor() |
    if exists(umask(pred.getNode(_)))
    then result = lastUmask(pred)
    else result = umaskStrictlyReaches(pred)
  )
}

private Umask localDefinedUmask(FileCreationExpr e) {
  exists(BasicBlock b, int i | e = b.getNode(i) |
    not exists(umask(b.getNode(_))) and result = umaskStrictlyReaches(b)
    or
    exists(Expr um, int j | um = b.getNode(j) and j <= i |
      result = umask(um) and
      not exists(int k | k in [j + 1 .. i] | exists(umask(b.getNode(k))))
    )
  )
}

Umask localUmask(FileCreationExpr e) {
  if exists(localDefinedUmask(e)) then result = localDefinedUmask(e) else result = defaultUmask()
}

abstract class FileCreationExpr extends FunctionCall {
  abstract Expr getPath();

  abstract int getMode();
}

class OpenCreationExpr extends FileCreationExpr {
  OpenCreationExpr() {
    this.getTarget().getName() = ["open", "_open", "_wopen"] and
    sets(this.getArgument(1).getValue().toInt(), o_creat())
  }

  override Expr getPath() { result = this.getArgument(0) }

  override int getMode() {
    if exists(this.getArgument(2))
    then result = this.getArgument(2).getValue().toInt()
    else
      // assume anything is permitted
      result = 0.bitNot()
  }
}

class CreatCreationExpr extends FileCreationExpr {
  CreatCreationExpr() { this.getTarget().getName() = "creat" }

  override Expr getPath() { result = this.getArgument(0) }

  override int getMode() { result = this.getArgument(1).getValue().toInt() }
}

class OpenatCreationExpr extends FileCreationExpr {
  OpenatCreationExpr() {
    this.getTarget().getName() = "openat" and
    this.getNumberOfArguments() = 4
  }

  override Expr getPath() { result = this.getArgument(1) }

  override int getMode() { result = this.getArgument(3).getValue().toInt() }
}

private int fopenMode() {
  result =
    s_irusr().bitOr(s_irgrp()).bitOr(s_iroth()).bitOr(s_iwusr()).bitOr(s_iwgrp()).bitOr(s_iwoth())
}

class FopenCreationExpr extends FileCreationExpr {
  FopenCreationExpr() {
    this.getTarget().getName() = ["fopen", "_wfopen", "fsopen", "_wfsopen"] and
    exists(string mode |
      mode = ["w", "a"] and
      this.getArgument(1).getValue().matches(mode + "%")
    )
  }

  override Expr getPath() { result = this.getArgument(0) }

  override int getMode() { result = fopenMode() }
}

class FopensCreationExpr extends FileCreationExpr {
  FopensCreationExpr() {
    exists(string name | name = this.getTarget().getName() |
      name = "fopen_s" or
      name = "_wfopen_s"
    ) and
    exists(string mode |
      (mode = "w" or mode = "a") and
      this.getArgument(2).getValue().matches(mode + "%")
    )
  }

  override Expr getPath() { result = this.getArgument(1) }

  override int getMode() {
    // fopen_s has restrictive permissions unless you have "u" in the mode
    if this.getArgument(2).getValue().charAt(_) = "u"
    then result = fopenMode()
    else result = s_irusr().bitOr(s_iwusr())
  }
}
