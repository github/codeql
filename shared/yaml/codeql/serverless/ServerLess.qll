/**
 * Provides classes and predicates for working with serverless handlers.
 * E.g. [AWS](https://docs.aws.amazon.com/lambda/latest/dg/nodejs-handler.html) or [serverless](https://npmjs.com/package/serverless)
 */

/**
 * Provides the input for the `ServerLess` module.
 * Most of these should be provided by the `yaml` library.
 */
signature module Input {
  // --------------------------------------------------
  // The below should be provided by the `yaml` library.
  // --------------------------------------------------
  class Container {
    string getAbsolutePath();

    Container getParentContainer();
  }

  class File extends Container;

  class YamlNode {
    File getFile();

    YamlCollection getParentNode();
  }

  class YamlValue extends YamlNode;

  class YamlCollection extends YamlValue;

  class YamlScalar extends YamlValue {
    string getValue();
  }

  class YamlMapping extends YamlCollection {
    YamlValue lookup(string key);

    YamlValue getValue(int i);
  }
}

/**
 * Provides classes and predicates for working with serverless handlers.
 * Supports AWS, Alibaba, and serverless.
 *
 * Common usage is to interpret the handlers as functions and add the
 * first argument of these as remote flow sources.
 */
module ServerLess<Input I> {
  import I

  /**
   * Gets the looked up value as a convenience.
   */
  pragma[inline]
  private string lookupValue(YamlMapping mapping, string property) {
    result = mapping.lookup(property).(YamlScalar).getValue()
  }

  /**
   * Gets the looked up value if it exists or
   * the empty string if it does not.
   */
  bindingset[property]
  pragma[inline]
  private string lookupValueOrEmpty(YamlMapping mapping, string property) {
    if exists(mapping.lookup(property))
    then result = mapping.lookup(property).(YamlScalar).getValue()
    else result = ""
  }

  /**
   * Gets a string where an ending "/." is simplified to "/" (if it exists).
   */
  bindingset[base]
  private string removeTrailingDot(string base) {
    if base.regexpMatch(".*/\\.")
    then result = base.substring(0, base.length() - 1)
    else result = base
  }

  /**
   * Gets a string where a leading "./" is simplified to "" (if it exists).
   */
  bindingset[base]
  private string removeLeadingDotSlash(string base) {
    if base.regexpMatch("\\./.*") then result = base.substring(2, base.length()) else result = base
  }

  /**
   * Gets a string suitable as part of a file path.
   *
   * Maps the empty string to the empty string.
   */
  bindingset[base]
  private string normalizePath(string base) {
    result = removeLeadingDotSlash(removeTrailingDot(base))
  }

  /**
   * Holds if the `.yml` file `ymlFile` contains a serverless configuration from `framework` with
   * `handler`, `codeURI`, and `runtime` properties.
   * `codeURI` and `runtime` default to the empty string if no explicit value is set in the configuration.
   *
   * `handler` should be interpreted in a language specific way, see `mapping.md`.
   */
  predicate hasServerlessHandler(
    File ymlFile, string framework, string handler, string codeUri, string runtime
  ) {
    exists(YamlMapping resource | ymlFile = resource.getFile() |
      // Official AWS API uses "AWS::Serverless::Function" but we've seen that Aliyun uses the same schema ("Aliyun::Serverless::Function"), so we allow any prefix to be used.
      // Note that "AWS::Serverless::Function" expands to a "AWS::Lambda::Function" when deployed (described here: https://github.com/aws/serverless-application-model#getting-started). Also note that a "AWS::Lambda::Function" requires code in its definition, so needs different handling (see https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-function.html)
      resource.lookup("Type").(YamlScalar).getValue().regexpMatch(".*::Serverless::Function") and
      framework = lookupValue(resource, "Type") and
      exists(YamlMapping properties | properties = resource.lookup("Properties") |
        (
          handler = lookupValue(properties, "Handler") and
          codeUri = normalizePath(lookupValueOrEmpty(properties, "CodeUri")) and
          runtime = lookupValueOrEmpty(properties, "Runtime")
        )
      )
      or
      // The `serverless` library, which specifies a top-level `functions` property
      framework = "Serverless" and
      exists(YamlMapping functions |
        functions = resource.lookup("functions") and
        not exists(resource.getParentNode()) and
        handler = lookupValue(functions.getValue(_), "handler") and
        codeUri = "" and
        runtime = lookupValueOrEmpty(functions, "Runtime")
      )
    )
  }

  /**
   * Holds if `handler` = `filePart . astPart` and `filePart` does not contain a `.`.
   * This is a convenience predicate, as in many cases the first part of the handler property
   * should be interpreted as (the stem of) a file name.
   */
  bindingset[handler]
  predicate splitHandler(string handler, string filePart, string astPart) {
    exists(string pattern | pattern = "(.*?)\\.(.*)" |
      filePart = handler.regexpCapture(pattern, 1) and
      astPart = handler.regexpCapture(pattern, 2)
    )
  }

  /**
   * Holds if a file with path `pathNoExt` (+ some extension) has a serverless handler denoted by `func`.
   *
   * This is a convenience predicate for the common case where the first part of the
   * handler property is the file name.
   *
   * `func` should be interpreted in a language specific way, see `mapping.md`.
   */
  predicate hasServerlessHandler(string pathNoExt, string func, string framework, string runtime) {
    exists(File ymlFile, string handler, string codeUri, string filePart |
      hasServerlessHandler(ymlFile, framework, handler, codeUri, runtime)
    |
      splitHandler(handler, filePart, func) and
      pathNoExt = ymlFile.getParentContainer().getAbsolutePath() + "/" + codeUri + filePart
    )
  }
}
