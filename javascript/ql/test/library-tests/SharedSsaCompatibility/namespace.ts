namespace SharedSsaNamespace {
  let value: unknown;
  if (check()) {
    value = SOURCE("ts-namespace");
  }
  if (value) {
    SINK(value); // $ localRefinementFlow=ts-namespace noRefinementBypass=ts-namespace refinementFlow=ts-namespace refinementTaint=ts-namespace
  }
}
