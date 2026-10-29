function ordinaryPhiNodes(condition, otherCondition) {
  let value;
  if (condition) {
    value = "first";
  } else {
    value = "second";
  }
  if (otherCondition) {
    CHECK(value); // $ uniquePhiDefinition phiNodeMetadata phiReachesCheck globalPhiReachesCheck
  } else {
    use(value);
  }
}

function refinedPhiNodes(value, condition) {
  if (value) {
    value = "safe";
  }
  if (condition) {
    CHECK(value); // $ uniquePhiDefinition phiNodeMetadata phiReachesCheck globalPhiReachesCheck
  } else {
    use(value);
  }
}

function nestedPhiNodes(firstCondition, secondCondition, thirdCondition) {
  let value;
  if (firstCondition) {
    if (secondCondition) {
      value = "first";
    } else {
      value = "second";
    }
    otherOperation();
  } else {
    value = "third";
  }
  if (thirdCondition) {
    CHECK(value); // $ uniquePhiDefinition phiNodeMetadata phiReachesCheck globalPhiReachesCheck
  } else {
    use(value);
  }
}

function capturedPhiNodes(condition, otherCondition) {
  let value;
  if (condition) {
    value = "first";
  } else {
    value = "second";
  }
  function capture() {
    return value;
  }
  capture();
  if (otherCondition) {
    CHECK(value); // $ uniquePhiDefinition phiNodeMetadata phiReachesCheck globalPhiReachesCheck
  } else {
    use(value);
  }
}

function sharedDefinitionApi(parameter) {
  CHECK_NATIVE(parameter); // $ sharedDefinition
  let uninitialized;
  CHECK_NATIVE(uninitialized); // $ sharedDefinition
  const { value } = { value: parameter };
  CHECK_NATIVE(value); // $ sharedDefinition
  if (typeof value === "object") {
    CHECK_NATIVE(value); // $ sharedDefinition
  }
}

function capturedDefinitionApi() {
  let value = 0;
  function write() {
    value = 1;
    value = 2;
  }
  function* read() {
    CHECK_NATIVE(value); // $ sharedDefinition
    yield;
    CHECK_NATIVE(value); // $ sharedDefinition
  }
  write();
  CHECK_NATIVE(value); // $ sharedDefinition
  return read;
}
