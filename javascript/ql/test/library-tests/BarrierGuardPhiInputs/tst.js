function overwriteOnFailure() {
  let x = SOURCE("overwrite");
  if (!BARRIER(x)) {
    x = "safe";
  }
  SINK(x); // $ SPURIOUS: flow=overwrite
}

function explicitElse() {
  let x = SOURCE("else");
  if (BARRIER(x)) {
    use(x);
  } else {
    x = "safe";
  }
  SINK(x); // $ SPURIOUS: flow=else
}

function preserveUnguardedInput() {
  let x = SOURCE("guarded");
  if (!BARRIER(x)) {
    x = SOURCE("fallback");
  }
  SINK(x); // $ flow=fallback SPURIOUS: flow=guarded
}

function returnOnFailure() {
  let x = SOURCE("return");
  if (!BARRIER(x)) {
    return;
  }
  SINK(x);
}

SINK(SOURCE("control")); // $ flow=control
