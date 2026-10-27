void rethrowOutsideCatch() {
  throw; // $ Alert
}

void helperRethrow() {
  throw; // $ Alert
}

void safeRethrowInCatch() {
  try {
  } catch (...) {
    throw;
  }
}

// The function name matches "%exception%", so a rethrow here is assumed to
// be intentional even though it is lexically and dynamically outside any
// catch block.
void rethrowException() {
  throw;
}

// Not lexically inside a catch block, but every call to this function is
// made from within a catch block, so the rethrow is assumed to be safe.
void calledFromCatch() {
  throw;
}

void triggersFromCatch() {
  try {
  } catch (...) {
    calledFromCatch();
  }
}
