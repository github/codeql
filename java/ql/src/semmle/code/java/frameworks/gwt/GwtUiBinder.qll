/**
 * Provides classes and predicates for identifying uses of the GWT UiBinder framework.
 *
 * The UiBinder framework allows the specification of user interfaces in XML template files. These
 * can then be interacted with programmatically by writing an associated owner class.
 */

import java
import GwtUiBinderXml

/**
 * An annotation in the package `com.google.gwt.uibinder.client`.
 */
class GwtUiBinderClientAnnotation extends Annotation {
  GwtUiBinderClientAnnotation() { getType().getPackage().hasName("com.google.gwt.uibinder.client") }
}

/**
 * A `@com.google.gwt.uibinder.client.UiHandler` annotation.
 */
class GwtUiHandlerAnnotation extends GwtUiBinderClientAnnotation {
  GwtUiHandlerAnnotation() { getType().hasName("UiHandler") }
}

/**
 * A `@com.google.gwt.uibinder.client.UiField` annotation.
 */
class GwtUiFieldAnnotation extends GwtUiBinderClientAnnotation {
  GwtUiFieldAnnotation() { getType().hasName("UiField") }
}

/**
 * A `@com.google.gwt.uibinder.client.UiTemplate` annotation.
 */
class GwtUiTemplateAnnotation extends GwtUiBinderClientAnnotation {
  GwtUiTemplateAnnotation() { getType().hasName("UiTemplate") }
}

/**
 * A `@com.google.gwt.uibinder.client.UiFactory` annotation.
 */
class GwtUiFactoryAnnotation extends GwtUiBinderClientAnnotation {
  GwtUiFactoryAnnotation() { getType().hasName("UiFactory") }
}

/**
 * A `@com.google.gwt.uibinder.client.UiConstructor` annotation.
 */
class GwtUiConstructorAnnotation extends GwtUiBinderClientAnnotation {
  GwtUiConstructorAnnotation() { getType().hasName("UiConstructor") }
}

/**
 * A field that is reflectively written to, and read from, by the GWT UiBinder framework.
 */
class GwtUiField extends Field {
  GwtUiField() { getAnAnnotation() instanceof GwtUiFieldAnnotation }

  /**
   * If true, the field must be filled before `UiBinder.createAndBindUi` is called.
   * If false, `UiBinder.createAndBindUi` will fill the field.
   */
  predicate isProvided() {
    getAnAnnotation().(GwtUiFieldAnnotation).getValue("provided").(BooleanLiteral).getBooleanValue() =
      true
  }
}

/**
 * A method called as a handler for events thrown by GWT widgets.
 */
class GwtUiHandler extends Method {
  GwtUiHandler() { getAnAnnotation() instanceof GwtUiHandlerAnnotation }

  /**
   * Gets the name of the field for which this handler is registered.
   */
  string getFieldName() {
    result =
      getAnAnnotation()
          .(GwtUiHandlerAnnotation)
          .getValue("value")
          .(CompileTimeConstantExpr)
          .getStringValue()
  }

  /**
   * Gets the field for which this handler is registered, if the UiField is represented in this class.
   */
  GwtUiField getField() {
    result = this.getDeclaringType().getAField() and
    result.getName() = getFieldName()
  }
}

/**
 * A method that may be called by the UiBinder framework as a result of a `GWT.create()` call, to
 * construct an instance of a class specified in a UiBinder XML file.
 */
class GwtUiFactory extends Method {
  GwtUiFactory() { getAnAnnotation() instanceof GwtUiFactoryAnnotation }
}

/**
 * A constructor that may be called by the UiBinder framework as a result of a `GWT.create()` call.
 */
class GwtUiConstructor extends Constructor {
  GwtUiConstructor() { getAnAnnotation() instanceof GwtUiConstructorAnnotation }
}
