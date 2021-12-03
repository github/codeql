import go

/**
 * Holds if there exists a comment on the same line as `l`
 * that contains the substring "`kind`,`dep`,`ver`".
 */
predicate metadata(Locatable l, string kind, string mod, string dep, string ver) {
  exists(string f, int line, Comment c, string text |
    l.hasLocationInfo(f, line, _, _, _) and
    c.hasLocationInfo(f, line, _, _, _)
  |
    text = c.getText().regexpFind("\\b([^,\\s]+,[^,]+,[^,]+,[^,\\s]+)", _, _) and
    kind = text.regexpCapture("([^,]+),([^,]+),([^,]+),([^,]+)", 1) and
    mod = text.regexpCapture("([^,]+),([^,]+),([^,]+),([^,]+)", 2) and
    dep = text.regexpCapture("([^,]+),([^,]+),([^,]+),([^,]+)", 3) and
    ver = text.regexpCapture("([^,]+),([^,]+),([^,]+),([^,]+)", 4)
  )
}

query predicate missingRequire(string mod, string dep, string ver, int line) {
  exists(Locatable l | metadata(l, "RequireLine", mod, dep, ver) |
    l.hasLocationInfo(_, line, _, _, _)
  ) and
  not exists(GoModRequireLine req |
    req.getModulePath() = mod and
    req.getPath() = dep and
    req.getVersion() = ver and
    metadata(req, "RequireLine", mod, dep, ver) and
    req.hasLocationInfo(_, line, _, _, _)
  )
}

query predicate missingExclude(string mod, string dep, string ver, int line) {
  exists(Locatable l | metadata(l, "ExcludeLine", mod, dep, ver) |
    l.hasLocationInfo(_, line, _, _, _)
  ) and
  not exists(GoModExcludeLine exc |
    exc.getModulePath() = mod and
    exc.getPath() = dep and
    exc.getVersion() = ver and
    metadata(exc, "ExcludeLine", mod, dep, ver) and
    exc.hasLocationInfo(_, line, _, _, _)
  )
}

/**
 * Holds if there exists a comment on the same line as `l`
 * that contains the substring "ReplaceLine,`mod`,`dep`,`dver`,`rep`,`rver`".
 */
predicate repmetadata(Locatable l, string mod, string dep, string dver, string rep, string rver) {
  exists(string f, int line, Comment c, string text |
    l.hasLocationInfo(f, line, _, _, _) and
    c.hasLocationInfo(f, line, _, _, _)
  |
    text = c.getText().regexpFind("\\b(ReplaceLine,[^,]*,[^,]*,[^,]*,[^,]*,[^,\\s]*)", _, _) and
    mod = text.regexpCapture("ReplaceLine,([^,]*),([^,]*),([^,]*),([^,]*),([^,]*)", 1) and
    dep = text.regexpCapture("ReplaceLine,([^,]*),([^,]*),([^,]*),([^,]*),([^,]*)", 2) and
    dver = text.regexpCapture("ReplaceLine,([^,]*),([^,]*),([^,]*),([^,]*),([^,]*)", 3) and
    rep = text.regexpCapture("ReplaceLine,([^,]*),([^,]*),([^,]*),([^,]*),([^,]*)", 4) and
    rver = text.regexpCapture("ReplaceLine,([^,]*),([^,]*),([^,]*),([^,]*),([^,]*)", 5)
  )
}

query predicate missingReplace(
  string mod, string dep, string dver, string rep, string rver, int line
) {
  exists(Locatable l | repmetadata(l, mod, dep, dver, rep, rver) |
    l.hasLocationInfo(_, line, _, _, _)
  ) and
  not exists(GoModReplaceLine repl |
    (
      rver = repl.getReplacementVersion()
      or
      not exists(repl.getReplacementVersion()) and
      rver = ""
    ) and
    (
      dver = repl.getOriginalVersion()
      or
      not exists(repl.getOriginalVersion()) and
      dver = ""
    )
  |
    repl.getModulePath() = mod and
    repl.getOriginalPath() = dep and
    repl.getReplacementPath() = rep and
    repmetadata(repl, mod, dep, dver, rep, rver) and
    repl.hasLocationInfo(_, line, _, _, _)
  )
}
