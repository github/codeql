import cpp
import semmle.code.cpp.commons.unix.Constants as UnixConstants

/**
 * Gets the number corresponding to the contents of `input` in base-16.
 * Note: the first two characters of `input` must be `0x`. For example:
 * `parseHex("0x123abc") = 1194684`.
 */
bindingset[input]
int parseHex(string input) {
  exists(string lowerCaseInput | lowerCaseInput = input.toLowerCase() |
    lowerCaseInput.regexpMatch("0x[0-9a-f]+") and
    result =
      strictsum(int ix |
        ix in [2 .. input.length()]
      |
        16.pow(input.length() - (ix + 1)) * "0123456789abcdef".indexOf(lowerCaseInput.charAt(ix))
      )
  )
}

/**
 * Gets the value defined by the `O_CREAT` macro if the macro
 * exists and if every definition defines the same value.
 */
int o_creat() {
  result =
    unique(int v |
      exists(Macro m | m.getName() = "O_CREAT" |
        v = parseHex(m.getBody()) or v = UnixConstants::parseOctal(m.getBody())
      )
    )
}

/**
 * Gets the value defined by the `O_TMPFILE` macro if the macro
 * exists and if every definition defines the same value.
 */
int o_tmpfile() {
  result =
    unique(int v |
      exists(Macro m | m.getName() = "O_TMPFILE" |
        v = parseHex(m.getBody()) or v = UnixConstants::parseOctal(m.getBody())
      )
    )
}

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
 * Holds if the bitmask `value` sets the bits in `flag`.
 */
bindingset[value, flag]
predicate setsFlag(int value, int flag) { value.bitAnd(flag) = flag }

/**
 * Holds if the bitmask `mask` sets any of the bit fields in `fields`.
 */
bindingset[mask, fields]
predicate setsAnyBits(int mask, int fields) { mask.bitAnd(fields) != 0 }

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

abstract class FileCreationWithOptionalModeExpr extends FileCreationExpr {
  abstract predicate hasModeArgument();
}

class OpenCreationExpr extends FileCreationWithOptionalModeExpr {
  OpenCreationExpr() {
    this.getTarget().hasGlobalOrStdName(["open", "_open", "_wopen"]) and
    exists(int flag | flag = this.getArgument(1).getValue().toInt() |
      setsFlag(flag, o_creat()) or setsFlag(flag, o_tmpfile())
    )
  }

  override Expr getPath() { result = this.getArgument(0) }

  override predicate hasModeArgument() { exists(this.getArgument(2)) }

  override int getMode() {
    if this.hasModeArgument()
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

class OpenatCreationExpr extends FileCreationWithOptionalModeExpr {
  OpenatCreationExpr() {
    this.getTarget().hasGlobalOrStdName("openat") and
    exists(int flag | flag = this.getArgument(2).getValue().toInt() |
      setsFlag(flag, o_creat()) or setsFlag(flag, o_tmpfile())
    )
  }

  override Expr getPath() { result = this.getArgument(1) }

  override predicate hasModeArgument() { exists(this.getArgument(3)) }

  override int getMode() {
    if this.hasModeArgument()
    then result = this.getArgument(3).getValue().toInt()
    else
      // assume anything is permitted
      result = 0.bitNot()
  }
}

private int fopenMode() {
  result =
    UnixConstants::s_irusr()
        .bitOr(UnixConstants::s_irgrp())
        .bitOr(UnixConstants::s_iroth())
        .bitOr(UnixConstants::s_iwusr())
        .bitOr(UnixConstants::s_iwgrp())
        .bitOr(UnixConstants::s_iwoth())
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
    this.getTarget().getName() = ["fopen_s", "_wfopen_s"] and
    exists(string mode |
      mode = ["w", "a"] and
      this.getArgument(2).getValue().matches(mode + "%")
    )
  }

  override Expr getPath() { result = this.getArgument(1) }

  override int getMode() {
    // fopen_s has restrictive permissions unless you have "u" in the mode
    if this.getArgument(2).getValue().charAt(_) = "u"
    then result = fopenMode()
    else result = UnixConstants::s_irusr().bitOr(UnixConstants::s_iwusr())
  }
}
