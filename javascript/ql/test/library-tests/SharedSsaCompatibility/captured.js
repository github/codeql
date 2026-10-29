import "dummy";

let capturedWrite = 0; // $ capturedWrite=capturedWrite ssaDefinition=capturedWrite noSsaAstNode=capturedWrite

function readCaptured() {
  return capturedWrite; // $ noCapturedWrite=capturedWrite
}

function unreachableCapturedWrites() {
  return;
  capturedWrite = 2; // $ noCapturedWrite=capturedWrite
}

function writeCaptured() {
  capturedWrite = 1; // $ capturedWrite=capturedWrite ssaDefinition=capturedWrite
  ++capturedWrite; // $ capturedWrite=capturedWrite ssaDefinition=capturedWrite
  capturedWrite += 1; // $ capturedWrite=capturedWrite ssaDefinition=capturedWrite
}

function uncapturedWrites() {
  let uncapturedWrite = 0; // $ noCapturedWrite=uncapturedWrite
  return uncapturedWrite++; // $ noCapturedWrite=uncapturedWrite
}

globalWrite = 1; // $ noCapturedWrite=globalWrite
use(globalWrite); // $ noCapturedWrite=globalWrite

const { capturedPattern } = input; // $ capturedWrite=capturedPattern ssaDefinition=capturedPattern
function readCapturedPattern() {
  return capturedPattern; // $ noCapturedWrite=capturedPattern
}

function destructuredDeclaration() {
  const { declaredObject, safeObject } = { // $ ssaDefinition=declaredObject ssaDefinition=safeObject
    declaredObject: SOURCE("object-declaration"),
    safeObject: "safe"
  };
  SINK(declaredObject); // $ localCapturedFlow=declaredObject capturedFlow=object-declaration legacyCapturedFlow=object-declaration
  SINK(safeObject); // $ localCapturedFlow=safeObject
  return () => {
    SINK(declaredObject); // $ capturedFlow=object-declaration legacyCapturedFlow=object-declaration
    SINK(safeObject);
  };
}
destructuredDeclaration()();

function destructuredAssignment() {
  let assignedObject;
  ({ assignedObject } = { assignedObject: SOURCE("object-assignment") }); // $ ssaDefinition=assignedObject
  SINK(assignedObject); // $ localCapturedFlow=assignedObject capturedFlow=object-assignment legacyCapturedFlow=object-assignment
  return () => SINK(assignedObject); // $ capturedFlow=object-assignment legacyCapturedFlow=object-assignment
}
destructuredAssignment()();

function destructuredParameter({ parameterObject }) { // $ ssaDefinition=parameterObject
  SINK(parameterObject); // $ localCapturedFlow=parameterObject capturedFlow=object-parameter legacyCapturedFlow=object-parameter
  return () => SINK(parameterObject); // $ capturedFlow=object-parameter legacyCapturedFlow=object-parameter
}
destructuredParameter({ parameterObject: SOURCE("object-parameter") })();

function destructuredLoop() {
  for (const { loopObject } of [{ loopObject: SOURCE("object-loop") }]) { // $ ssaDefinition=loopObject
    SINK(loopObject); // $ localCapturedFlow=loopObject capturedFlow=object-loop legacyCapturedFlow=object-loop
    (() => SINK(loopObject))(); // $ capturedFlow=object-loop legacyCapturedFlow=object-loop
  }
}
destructuredLoop();

function destructuredArray([arrayElement]) { // $ ssaDefinition=arrayElement
  SINK(arrayElement); // $ localCapturedFlow=arrayElement capturedFlow=array-element legacyCapturedFlow=array-element
  return () => SINK(arrayElement); // $ capturedFlow=array-element legacyCapturedFlow=array-element
}
destructuredArray([SOURCE("array-element")])();

const { topLevelObject } = { topLevelObject: SOURCE("top-level-object") }; // $ ssaDefinition=topLevelObject
function readTopLevelObject() {
  SINK(topLevelObject); // $ capturedFlow=top-level-object legacyCapturedFlow=top-level-object
}
readTopLevelObject();

let topLevelPhi;
if (unknownCondition()) {
  topLevelPhi = SOURCE("top-level-phi"); // $ ssaDefinition=topLevelPhi
} else {
  topLevelPhi = "safe"; // $ ssaDefinition=topLevelPhi
}
SINK(topLevelPhi); // $ capturedFlow=top-level-phi legacyCapturedFlow=top-level-phi
function readTopLevelPhi() {
  SINK(topLevelPhi); // $ capturedFlow=top-level-phi legacyCapturedFlow=top-level-phi
}
readTopLevelPhi();

function legacyGuardedPhi(condition) {
  let value = SOURCE("legacy-guarded-phi");
  if (condition && BARRIER(value)) {
  } else {
    value = "safe";
  }
  SINK(value); // $ SPURIOUS: capturedFlow=legacy-guarded-phi
}

function legacyGuardedWithReads(condition) {
  let value = SOURCE("legacy-with-guard");
  use(value);
  with ({}) {
    if (condition) {
      if (!BARRIER(value)) return;
      use(value);
    } else {
      value = "safe";
    }
  }
  SINK(value); // $ SPURIOUS: capturedFlow=legacy-with-guard
}
