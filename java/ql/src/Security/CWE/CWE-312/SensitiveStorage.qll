import java
import semmle.code.java.frameworks.Properties
import semmle.code.java.frameworks.JAXB
import semmle.code.java.frameworks.android.SharedPreferences
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.DataFlow3
import semmle.code.java.dataflow.DataFlow4
import semmle.code.java.dataflow.DataFlow5
import semmle.code.java.security.SensitiveActions

/** Test code filter. */
predicate testMethod(Method m) {
  (
    m instanceof TestMethod or
    m.getDeclaringType() instanceof TestClass
  ) and
  // Do report results in the Juliet tests.
  not m.getLocation().getFile().getAbsolutePath().matches("%CWE%")
}

private class SensitiveSourceFlowConfig extends TaintTracking::Configuration {
  SensitiveSourceFlowConfig() { this = "SensitiveStorage::SensitiveSourceFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof SensitiveExpr }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = cookieInput(_)
    or
    exists(MethodAccess m |
      m.getMethod() instanceof PropertiesSetPropertyMethod and sink.asExpr() = m.getArgument(1)
    )
    or
    exists(MethodAccess m |
      m.getMethod() instanceof SharedPreferences::SharedPreferencesSetMethod and
      sink.asExpr() = m.getArgument(1)
    )
    or
    sink.asExpr() = getInstanceInput(_, _)
  }

  override predicate isSanitizer(DataFlow::Node n) {
    n.getType() instanceof NumericType or n.getType() instanceof BooleanType
  }
}

/** Class for expressions that may represent 'sensitive' information */
class SensitiveSource extends Expr {
  SensitiveSource() {
    // SensitiveExpr is abstract, this lets us inherit from it without
    // being a technical subclass
    this instanceof SensitiveExpr
  }

  /** Holds if this source flows to the `sink`. */
  cached
  predicate flowsToCached(Expr sink) {
    exists(SensitiveSourceFlowConfig conf |
      conf.hasFlow(DataFlow::exprNode(this), DataFlow::exprNode(sink))
    )
  }
}

/**
 *  Class representing entities that may be stored/written, with methods
 *  for finding values that are stored within them, and cases
 *  of the entity being stored.
 */
abstract class Storable extends ClassInstanceExpr {
  /** Gets an "input" that is stored in an instance of this class. */
  abstract Expr getAnInput();

  /** Gets an expression where an instance of this class is stored (e.g. to disk). */
  abstract Expr getAStore();
}

private predicate cookieStore(DataFlow::Node cookie, Expr store) {
  exists(MethodAccess m, Method def |
    m.getMethod() = def and
    def.getName() = "addCookie" and
    def.getDeclaringType().getQualifiedName() = "javax.servlet.http.HttpServletResponse" and
    store = m and
    cookie.asExpr() = m.getAnArgument()
  )
}

private class CookieToStoreFlowConfig extends DataFlow2::Configuration {
  CookieToStoreFlowConfig() { this = "SensitiveStorage::CookieToStoreFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof Cookie }

  override predicate isSink(DataFlow::Node sink) { cookieStore(sink, _) }
}

private Expr cookieInput(Cookie c) { result = c.getArgument(1) }

/** The instantiation of a cookie, which can act as storage. */
class Cookie extends Storable {
  Cookie() {
    this.getConstructor().getDeclaringType().getQualifiedName() = "javax.servlet.http.Cookie"
  }

  /** Gets an input, for example `input` in `new Cookie("...", input);`. */
  override Expr getAnInput() { result = cookieInput(this) }

  /** Gets a store, for example `response.addCookie(cookie);`. */
  override Expr getAStore() {
    exists(CookieToStoreFlowConfig conf, DataFlow::Node n |
      cookieStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

private predicate propertiesInput(DataFlow::Node prop, Expr input) {
  exists(MethodAccess m |
    m.getMethod() instanceof PropertiesSetPropertyMethod and
    input = m.getArgument(1) and
    prop.asExpr() = m.getQualifier()
  )
}

private predicate propertiesStore(DataFlow::Node prop, Expr store) {
  exists(MethodAccess m |
    m.getMethod() instanceof PropertiesStoreMethod and
    store = m and
    prop.asExpr() = m.getQualifier()
  )
}

private class PropertiesFlowConfig extends DataFlow3::Configuration {
  PropertiesFlowConfig() { this = "SensitiveStorage::PropertiesFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof Properties }

  override predicate isSink(DataFlow::Node sink) {
    propertiesInput(sink, _) or
    propertiesStore(sink, _)
  }
}

/** The instantiation of a `Properties` object, which can be stored to disk. */
class Properties extends Storable {
  Properties() { this.getConstructor().getDeclaringType() instanceof TypeProperty }

  /** Gets an input, for example `input` in `props.setProperty("password", input);`. */
  override Expr getAnInput() {
    exists(PropertiesFlowConfig conf, DataFlow::Node n |
      propertiesInput(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }

  /** Gets a store, for example `props.store(outputStream, "...")`. */
  override Expr getAStore() {
    exists(PropertiesFlowConfig conf, DataFlow::Node n |
      propertiesStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

abstract class ClassStore extends Storable {
  /** Gets an input, for example `input` in `instance.password = input`. */
  override Expr getAnInput() {
    exists(ClassStoreFlowConfig conf, DataFlow::Node instance |
      conf.hasFlow(DataFlow::exprNode(this), instance) and
      result = getInstanceInput(instance, this.getConstructor().getDeclaringType())
    )
  }
}

/** Gets an input, for example `input` in `instance.password = input`. */
private Expr getInstanceInput(DataFlow::Node instance, RefType t) {
  exists(AssignExpr a, FieldAccess fa |
    instance = DataFlow::getFieldQualifier(fa) and
    a.getDest() = fa and
    a.getSource() = result and
    fa.getField().getDeclaringType() = t
  |
    t.getASourceSupertype*() instanceof TypeSerializable or
    t instanceof JAXBElement
  )
}

private class ClassStoreFlowConfig extends DataFlow4::Configuration {
  ClassStoreFlowConfig() { this = "SensitiveStorage::ClassStoreFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ClassStore }

  override predicate isSink(DataFlow::Node sink) {
    exists(getInstanceInput(sink, _)) or
    serializableStore(sink, _) or
    marshallableStore(sink, _)
  }

  override int fieldFlowBranchLimit() { result = 1 }
}

private predicate serializableStore(DataFlow::Node instance, Expr store) {
  exists(MethodAccess m |
    store = m and
    m.getMethod() instanceof WriteObjectMethod and
    instance.asExpr() = m.getArgument(0)
  )
}

private predicate marshallableStore(DataFlow::Node instance, Expr store) {
  exists(MethodAccess m |
    store = m and
    m.getMethod() instanceof JAXBMarshalMethod and
    instance.asExpr() = m.getArgument(0)
  )
}

/**
 * The instantiation of a serializable class, which can be stored to disk.
 *
 * Only includes tainted instances where data from a `SensitiveSource` may flow
 * to an input of the `Serializable`.
 */
class Serializable extends ClassStore {
  Serializable() {
    this.getConstructor().getDeclaringType().getASupertype*() instanceof TypeSerializable and
    // `Properties` are `Serializable`, but handled elsewhere.
    not this instanceof Properties and
    // restrict attention to tainted instances
    exists(SensitiveSource data |
      data.flowsToCached(getInstanceInput(_, this.getConstructor().getDeclaringType()))
    )
  }

  /** Gets a store, for example `outputStream.writeObject(instance)`. */
  override Expr getAStore() {
    exists(ClassStoreFlowConfig conf, DataFlow::Node n |
      serializableStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

/** The instantiation of a marshallable class, which can be stored to disk as XML. */
class Marshallable extends ClassStore {
  Marshallable() { this.getConstructor().getDeclaringType() instanceof JAXBElement }

  /** Gets a store, for example `marshaller.marshal(instance)`. */
  override Expr getAStore() {
    exists(ClassStoreFlowConfig conf, DataFlow::Node n |
      marshallableStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}

/* Holds if the method call is a setter method of `SharedPreferences`. */
private predicate sharedPreferencesInput(DataFlow::Node sharedPrefs, Expr input) {
  exists(MethodAccess m |
    m.getMethod() instanceof SharedPreferences::SharedPreferencesSetMethod and
    input = m.getArgument(1) and
    not exists(EncryptedValueFlowConfig conf | conf.hasFlow(_, DataFlow::exprNode(input))) and
    sharedPrefs.asExpr() = m.getQualifier()
  )
}

/* Holds if the method call is the store method of `SharedPreferences`. */
private predicate sharedPreferencesStore(DataFlow::Node sharedPrefs, Expr store) {
  exists(MethodAccess m |
    m.getMethod() instanceof SharedPreferences::SharedPreferencesStoreMethod and
    store = m and
    sharedPrefs.asExpr() = m.getQualifier()
  )
}

/* Flow from `SharedPreferences` to either a setter or a store method. */
class SharedPreferencesFlowConfig extends TaintTracking::Configuration {
  SharedPreferencesFlowConfig() { this = "SensitiveStorage::SharedPreferencesFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof SharedPreferencesEditor
  }

  override predicate isSink(DataFlow::Node sink) {
    sharedPreferencesInput(sink, _) or
    sharedPreferencesStore(sink, _)
  }
}

/**
 * Method call of encrypting sensitive information.
 * As there are various implementations of encryption (reversible and non-reversible) from both JDK and third parties, this class simply checks method name to take a best guess to reduce false positives.
 */
class EncryptedSensitiveMethodAccess extends MethodAccess {
  EncryptedSensitiveMethodAccess() {
    getMethod().getName().toLowerCase().matches(["%encrypt%", "%hash%"])
  }
}

/* Flow configuration of encrypting sensitive information. */
class EncryptedValueFlowConfig extends DataFlow5::Configuration {
  EncryptedValueFlowConfig() { this = "SensitiveStorage::EncryptedValueFlowConfig" }

  override predicate isSource(DataFlow5::Node src) {
    exists(EncryptedSensitiveMethodAccess ema | src.asExpr() = ema.getAnArgument())
  }

  override predicate isSink(DataFlow5::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof SharedPreferences::SharedPreferencesSetMethod and
      sink.asExpr() = ma.getArgument(1)
    )
  }

  override predicate isAdditionalFlowStep(DataFlow5::Node n1, DataFlow5::Node n2) {
    exists(EncryptedSensitiveMethodAccess ema |
      n1.asExpr() = ema.getAnArgument() and
      n2.asExpr() = ema
    )
  }
}

/* Flow from the create method of `androidx.security.crypto.EncryptedSharedPreferences` to its instance. */
private class EncryptedSharedPrefFlowConfig extends DataFlow3::Configuration {
  EncryptedSharedPrefFlowConfig() { this = "SensitiveStorage::EncryptedSharedPrefFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().(MethodAccess).getMethod() instanceof
      SharedPreferences::EncryptedSharedPrefsCreateMethod
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr().getType() instanceof SharedPreferences::TypeSharedPreferences
  }
}

/** The call to get a `SharedPreferences.Editor` object, which can set shared preferences or be stored to device. */
class SharedPreferencesEditor extends MethodAccess {
  SharedPreferencesEditor() {
    this.getMethod() instanceof SharedPreferences::SharedPreferencesGetEditorMethod and
    not exists(
      EncryptedSharedPrefFlowConfig config // not exists `SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(...)`
    |
      config.hasFlow(_, DataFlow::exprNode(this.getQualifier()))
    )
  }

  /** Gets an input, for example `input` in `editor.putString("password", password);`. */
  Expr getAnInput() {
    exists(SharedPreferencesFlowConfig conf, DataFlow::Node n |
      sharedPreferencesInput(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }

  /** Gets a store, for example `editor.commit();`. */
  Expr getAStore() {
    exists(SharedPreferencesFlowConfig conf, DataFlow::Node n |
      sharedPreferencesStore(n, result) and
      conf.hasFlow(DataFlow::exprNode(this), n)
    )
  }
}
