/**
 * @name Fetch suggestions for access paths of input and output parameters of a method (framework mode)
 * @description A list of access paths for input and output parameters of a method. Excludes test and generated code.
 * @kind table
 * @id java/utils/modeleditor/framework-mode-access-path-suggestions
 * @tags modeleditor access-path-suggestions framework-mode
 */

private import java
private import semmle.code.java.Collections
private import semmle.code.java.Maps
private import FrameworkModeEndpointsQuery
private import ModelEditor

predicate nestedPathBase(
  Endpoint endpoint, Element element, string value, string details, string defType,
  boolean isInputOnly, boolean isOutputOnly
) {
  endpoint.getReturnType() = element and
  isInputOnly = false and
  isOutputOnly = true and
  value = "ReturnValue" and
  details = element.toString() and
  defType = "return"
  or
  exists(Parameter parameter |
    endpoint.getAParameter() = parameter and parameter.getType() = element
  |
    value = "Argument[" + parameter.getPosition() + "]" and
    details = parameter.getType().toString() + " " + parameter.getName() and
    isInputOnly = false and
    isOutputOnly = false and
    defType = "parameter"
  )
  or
  endpoint.getDeclaringType() = element and
  isInputOnly = false and
  isOutputOnly = false and
  value = "Argument[this]" and
  details = element.toString() and
  defType = "class"
}

predicate nestedPathRec(
  Endpoint endpoint, Element element, string value, string details, string defType,
  boolean isInputOnly, boolean isOutputOnly, int pathLength
) {
  pathLength < 8 and
  (
    nestedPathBase(endpoint, element, value, details, defType, isInputOnly, isOutputOnly) and
    pathLength = 1
    or
    exists(
      Type prevType, string prevValue, string prevDetails, string prevDefType,
      boolean prevIsInputOnly, boolean prevIsOutputOnly, int prevPathLength
    |
      nestedPathRec(endpoint, prevType, prevValue, prevDetails, prevDefType, prevIsInputOnly,
        prevIsOutputOnly, prevPathLength) and
      pathLength = prevPathLength + 1
    |
      element = prevType.(CollectionType).getElementType() and
      value = prevValue + ".Element" and
      details = element.toString() and
      isInputOnly = prevIsInputOnly and
      isOutputOnly = prevIsOutputOnly and
      defType = "array"
      or
      element = prevType.(MapType).getKeyType() and
      value = prevValue + ".MapKey" and
      details = element.toString() and
      isInputOnly = prevIsInputOnly and
      isOutputOnly = prevIsOutputOnly and
      defType = "key"
      or
      element = prevType.(MapType).getValueType() and
      value = prevValue + ".MapValue" and
      details = element.toString() and
      isInputOnly = prevIsInputOnly and
      isOutputOnly = prevIsOutputOnly and
      defType = "misc"
      or
      element = prevType.(CollectionType).getElementType() and
      (value = prevValue + ".WithoutElement" or value = prevValue + ".WithElement") and
      details = element.toString() and
      isInputOnly = true and
      isOutputOnly = prevIsOutputOnly and
      defType = "array"
      or
      element = prevType.(RefType).getAField() and
      not element.(Field).isStatic() and
      value =
        prevValue + ".Field[" + element.(Field).getDeclaringType().getPackage() + "." +
          element.(Field).getDeclaringType().getName() + "." + element.(Field).getName() + "]" and
      details = element.(Field).getType().toString() + " " + element.(Field).getName() and
      isInputOnly = false and
      isOutputOnly = false and
      defType = "field"
    )
  )
}

predicate nestedPath(
  Endpoint endpoint, Element element, string value, string details, string defType,
  boolean isInputOnly, boolean isOutputOnly
) {
  nestedPathRec(endpoint, element, value, details, defType, isInputOnly, isOutputOnly, _)
}

predicate suggestions(
  string packageName, string typeName, string methodName, string methodParameters, string value,
  string details, string defType, boolean isInputOnly, boolean isOutputOnly
) {
  exists(PublicEndpointFromSource endpoint, Element element |
    nestedPath(endpoint, element, value, details, defType, isInputOnly, isOutputOnly)
  |
    packageName = endpoint.getPackageName() and
    typeName = endpoint.getTypeName() and
    methodName = endpoint.getName() and
    methodParameters = endpoint.getParameterTypes()
  )
}

predicate inputSuggestions(
  string packageName, string typeName, string methodName, string methodParameters, string value,
  string details, string defType
) {
  suggestions(packageName, typeName, methodName, methodParameters, value, details, defType, _, false)
}

predicate outputSuggestions(
  string packageName, string typeName, string methodName, string methodParameters, string value,
  string details, string defType
) {
  suggestions(packageName, typeName, methodName, methodParameters, value, details, defType, false, _)
}

query predicate input = inputSuggestions/7;

query predicate output = outputSuggestions/7;
