/**
 * For internal use only.
 *
 * Extracts data about the database for use in adaptive threat modeling (ATM).
 */

import javascript
private import FeaturizationConfig
private import FunctionBodyFeatures as FunctionBodyFeatures
private import EndpointTypes as EndpointTypes
private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations as NosqlInjectionCustomizations
private import semmle.javascript.security.dataflow.SqlInjectionCustomizations as SqlInjectionCustomizations
private import semmle.javascript.security.dataflow.TaintedPathCustomizations as TaintedPathCustomizations
private import semmle.javascript.security.dataflow.DomBasedXssCustomizations as DomBasedXssCustomizations
private import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.XssATM as XssAtm
private import experimental.adaptivethreatmodeling.EndpointCharacteristics as EndpointCharacteristics

/**
 * Gets the value of the token-based feature named `featureName` for the endpoint `endpoint`.
 *
 * This is a single string containing a space-separated list of tokens.
 */
private string getTokenFeature(DataFlow::Node endpoint, string featureName) {
  // Performance optimization: Restrict feature extraction to endpoints we've explicitly asked to featurize.
  endpoint = any(FeaturizationConfig cfg).getAnEndpointToFeaturize() and
  exists(EndpointFeature f | f.getName() = featureName and result = f.getValue(endpoint)) and
  featureName = getASupportedFeatureName()
}

private module FunctionNames {
  /**
   * Get the name of the function.
   *
   * We attempt to assign unnamed entities approximate names if they are passed to a likely
   * external library function. If we can't assign them an approximate name, we give them the name
   * `""`, so that these entities are included in `AdaptiveThreatModeling.qll`.
   *
   * For entities which have multiple names, we choose the lexically smallest name.
   */
  string getNameToFeaturize(Function function) {
    if exists(function.getName())
    then result = min(function.getName())
    else
      if exists(getApproximateNameForFunction(function))
      then result = getApproximateNameForFunction(function)
      else result = ""
  }

  /**
   * Holds if the call `call` has `function` is its `argumentIndex`th argument.
   */
  private predicate functionUsedAsArgumentToCall(
    Function function, DataFlow::CallNode call, int argumentIndex
  ) {
    DataFlow::localFlowStep*(call.getArgument(argumentIndex), function.flow())
  }

  /**
   * Returns a generated name for the function. This name is generated such that
   * entities with the same names have similar behavior.
   */
  private string getApproximateNameForFunction(Function function) {
    count(DataFlow::CallNode call, int index | functionUsedAsArgumentToCall(function, call, index)) =
      1 and
    exists(DataFlow::CallNode call, int index, string basePart |
      functionUsedAsArgumentToCall(function, call, index) and
      (
        if count(getReceiverName(call)) = 1
        then basePart = getReceiverName(call) + "."
        else basePart = ""
      ) and
      result = basePart + call.getCalleeName() + "#functionalargument"
    )
  }

  private string getReceiverName(DataFlow::CallNode call) {
    result = call.getReceiver().asExpr().(VarAccess).getName()
  }
}

/** Get a name of a supported generic token-based feature. */
string getASupportedFeatureName() { result = "codexPrompt" }

/**
 * Generic token-based features for ATM.
 *
 * This predicate holds if the generic token-based feature named `featureName` has the value
 * `featureValue` for the endpoint `endpoint`.
 */
predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  // Performance optimization: Restrict feature extraction to endpoints we've explicitly asked to featurize.
  endpoint = any(FeaturizationConfig cfg).getAnEndpointToFeaturize() and
  featureValue = getTokenFeature(endpoint, featureName)
}

/**
 * See EndpointFeature
 */
private newtype TEndpointFeature =
  TCodexPrompt() or
  TEnclosingFunctionName() or
  TReceiverName() or
  TEnclosingFunctionBody() or
  TFileImports() or
  TCalleeImports() or
  TCalleeFlexibleAccessPath() or
  TInputAccessPathFromCallee() or
  TInputArgumentIndex() or
  TContextFunctionInterfaces() or
  TContextSurroundingFunctionParameters() or
  TAssignedToPropName() or
  TStringConcatenatedWith()

/**
 * An implementation of an endpoint feature: defines feature-name/value tuples for use in ML.
 */
abstract class EndpointFeature extends TEndpointFeature {
  /**
   * Gets the name of the feature. Used by the ML model.
   * Names are coupled to models: changing the name of a feature requires retraining the model.
   */
  abstract string getName();

  /**
   * Gets the value of the feature. Used by the ML model.
   * Models are trained based on feature values, so changing the value of a feature requires retraining the model.
   */
  abstract string getValue(DataFlow::Node endpoint);

  string toString() { result = this.getName() }
}

/**
 * The codex promt for this endpoint.
 */
class CodexPrompt extends EndpointFeature, TCodexPrompt {
  override string getName() { result = "codexPrompt" }

  override string getValue(DataFlow::Node endpoint) {
    result = this.getTrainingSetPrompt() + this.getCurrentEndpointPrompt(endpoint)
  }

  /**
   * Gets the beginning of the prompt, which contains the training examples, shuffled in random order.
   * TODO
   */
  private string getTrainingSetPrompt() {
    result =
      "# Examples of security vulnerability sinks and non-sinks\n|Dataflow node|Neighborhood|Classification|\n|---|---|---|\n|`refStr`|`    const refStr =      pageRef.gen === 0 ? ${pageRef.num}R : ${pageRef.num}R${pageRef.gen};    this.#pagesRefCache.set(refStr, pageNum);  }`|non-sink|\n|`name`|`      return res.redirect(back);    }    const ndb = req.mainClient.client.db(name);    ndb.createCollection(delete_me, function (err) {`|sql injection sink|\n|`It took  + (t1 - t0) +  msec to create  + count +  +className+ instances programmatically.`|`                         }                               var t1 = new Date().getTime();                          dojo.byId(results).innerHTML = It took  + (t1 - t0) +  msec to create  + count +  +className+ instances programmatically.;                   }                       dojo.ready(makeEm);`|non-sink|\n|`contents`|`  const contents = fileData.buffer.toString();  res.json({message: contents});});`|non-sink|\n|`{ _id }`|`    // If an ObjectID was correctly created from passed id param, try getting the ObjID first else falling back to try getting the string id    // If not valid ObjectID created, try getting string id    req.collection.findOne({ _id }, function (err, doc) {      if (err) {        req.session.error = Error:  + err;`|nosql injection sink|\n|`bid`|`  const body =   <a href=https://ampbyexample.com target=_blank>    <amp-img alt=AMP Ad height=250 src=//localhost:9876/amp4test/request-bank/${bid}/deposit/image width=300></amp-img>  </a>  <amp-pixel src=//localhost:9876/amp4test/request-bank/${bid}/deposit/pixel/foo?cid=CLIENT_ID(a)></amp-pixel>`|xss sink|\n|`nick`|`       irc.me = nick;  irc.nick(nick); irc.user(username, realname);`|non-sink|\n|`{where: {name: req.body.type}}`|`    if(req.is(json)) {        models.VisualizationType.find({            where: {                name: req.body.type            }        }).then(function(vizType) {            if(!vizType) {                throw new Error(Unknown Viztype);`|nosql injection sink|\n|`sql`|`        var callback = cb;        var dbService = this.getService(connectionName);        dbService.execute(sql, params, function(err, result) {            if (err) {                return callback(err);`|sql injection sink|\n|`filename`|`      const writeStream = gfs.createWriteStream({        _id: newFileID,        filename,        mode: w,        content_type: mimetype,`|path injection sink|\n|`req.url.substr(7)`|`          <html style=width:100%; height:100%;>            <body style=width:98%; height:98%;>              <iframe src=${req.url.substr(7)}                  style=width:100%; height:100%;>              </iframe>`|xss sink|\n|`assets/images/ + req.files.upload_file.name`|`            res.send({                success: true,                file_path: assets/images/ + req.files.upload_file.name            });        });`|path injection sink|\n|`path`|`async function handleListingRequest({query: {path, search}}, res) {  try {    assert(path);    const fileSet = await getListing(root, path);`|non-sink|\n|`{ lastLoginIp: lastLoginIp }`|`      }      models.User.findByPk(loggedInUser.data.id).then(user => {        user.update({ lastLoginIp: lastLoginIp }).then(user => {          res.json(user)        }).catch(error => {`|non-sink|\n|`uploadId`|`      Bucket: config.bucket,      Key: key,      UploadId: uploadId,      MultipartUpload: {        Parts: parts,`|non-sink|\n|`hash`|`  componentDidMount() {    const [, hash] = location.href.split(#)    this.setState({ hash })  }`|non-sink|\n"
    //hardNegativeExamplesForCodexPrompt() + hardPositiveExamplesForCodexPrompt(2, )
  }

  /**
   * Gets the last line of the prompt, containing the current endpoint.
   * TODO
   */
  private string getCurrentEndpointPrompt(DataFlow::Node endpoint) {
    result =
      "|`" + this.tokenizeEndpoint(endpoint) + "`|`" + this.tokenizeNeighborhood(endpoint, 2) + "`|"
  }

  /**
   * Holds if `endpoint` is a sink for a security vulnerability of type `sinkType`, where the string used to label this
   * sink type is `sinkName`.
   */
  private predicate isPositiveExampleFromCurrentRepo(
    DataFlow::Node endpoint, EndpointTypes::EndpointType sinkType, string sinkName
  ) {
    sinkType instanceof EndpointTypes::NosqlInjectionSinkType and
    endpoint instanceof NosqlInjectionCustomizations::NosqlInjection::Sink and
    sinkName = "nosql injection sink"
    or
    sinkType instanceof EndpointTypes::SqlInjectionSinkType and
    endpoint instanceof SqlInjectionCustomizations::SqlInjection::Sink and
    sinkName = "sql injection sink"
    or
    sinkType instanceof EndpointTypes::TaintedPathSinkType and
    endpoint instanceof TaintedPathCustomizations::TaintedPath::Sink and
    sinkName = "path injection sink"
    or
    sinkType instanceof EndpointTypes::XssSinkType and
    endpoint instanceof DomBasedXssCustomizations::DomBasedXss::Sink and
    sinkName = "xss sink"
  }

  /**
   * Holds if `endpoint` is a not a sink for any type of security vulnerability for the reason specified by
   * `characteristic`.
   */
  private predicate isNegativeExampleFromCurrentRepo(
    DataFlow::Node endpoint, EndpointCharacteristics::EndpointCharacteristic characteristic
  ) {
    characteristic.appliesToEndpoint(endpoint) and
    exists(float confidence |
      characteristic
          .hasImplications(any(EndpointTypes::NegativeType negativeClass), true, confidence) and
      confidence >= characteristic.highConfidence()
    )
  }

  private predicate selectTwoPositiveExamples(
    DataFlow::Node endpoint, EndpointTypes::EndpointType sinkType, string sinkName, File file
  ) {
    this.positiveExamplesForCodexPrompt(2, endpoint, sinkType, sinkName) and
    file = endpoint.getFile()
  }

  /**
   * Select `numExamples` positive examples for the codex prompt for each query, selecting from a diverse set
   * of files.
   */
  bindingset[numExamples]
  private predicate positiveExamplesForCodexPrompt(
    int numExamples, DataFlow::Node endpoint, EndpointTypes::EndpointType sinkType, string sinkName
  ) {
    this.isPositiveExampleFromCurrentRepo(endpoint, sinkType, sinkName) and
    // There is no previous positive example of the same type in the same file.
    not exists(DataFlow::Node endpoint2 |
      this.isPositiveExampleFromCurrentRepo(endpoint2, sinkType, sinkName) and
      endpoint.getFile() = endpoint2.getFile() and
      (
        endpoint.getStartLine() > endpoint2.getStartLine()
        or
        endpoint.getStartLine() = endpoint2.getStartLine() and
        endpoint.getStartColumn() > endpoint2.getStartColumn()
      )
    )
    // and
    //   exists(int rankIndex, File file |
    //     rankIndex <= numExamples and rankIndex > 0 and
    //     file = endpoint.asExpr().getLocation().getFile() and not exists(int lowerRankIndex |  | )
    //     endpoint = rank[rankIndex](string file, int a, int b, int c, int d |
    //   |
    //     endpoint order by sinkName, file
    //   )
    // //    and
    // // r % (1 / rate).ceil() = 0
    // )
    //   exists(int r | r <= numExamples and endpoint = rank[r](string file, int a, int b, int c, int d |
    //         endpoint.asExpr().getLocation().hasLocationInfo(file, a, b, c, d)
    //       |
    //         endpoint order by sinkName, file, a, b, c, d
    //       )
    //     //    and
    //     // r % (1 / rate).ceil() = 0
    //     )
    // // select `numExamples` examples for each query
    // count( | | 1) <= numExamples and
    // // select examples from a diverse set of files
    // not exists(string file |
    //   file = endpoint.getLocation().getFile().getRelativePath() and
    //   file = any(EndpointTypes::EndpointType t).getAFileWithPositiveExample(t)
    // )
    // // and
    // // TODO
  }

  /**
   * Select `numExamples` negative examples for the codex prompt, selecting from a diverse set of characteristics.
   * TODO
   */
  private string hardNegativeExamplesForCodexPrompt() {
    result =
      "# Examples of security vulnerability sinks and non-sinks\n|Dataflow node|Neighborhood|Classification|\n|---|---|---|\n|`m[9] ? m[10] : null`|`                        this.authority = m[5] ? m[6] : null;                    this.path = m[7];                       this.query = m[9] ? m[10] : null;                       this.fragment = m[12] ? m[13] : null;  return this;`|non-sink|\n|`this.flowRunId`|`          variables: {            input: {              flow_run_id: this.flowRunId,              name: e            }`|non-sink|\n|`req.body.firstName`|`    res.json({      firstName: req.body.firstName,      lastName: req.body.lastName,      email: req.body.email`|non-sink|\n|`lang[1]`|`            if (lang) {                document.getElementsByTagName('html')[0].setAttribute('lang', lang[1]);            }`|non-sink|\n|`token`|`    },  });  tokenProvider.saveNewToken(token).then(ok => {    insights.trackEvent({      name: 'ReposCreateTokenFinish',`|non-sink|\n|`filename`|`function sendFile(filename, response) {  response.setHeader('Content-Type', mime.lookup(filename));  response.writeHead(200);  const fileStream = createReadStream(filename);`|non-sink|\n|`year`|`      postsData = await getPostsDateArchive(        postType,        !isNaN(parseInt(year, 10)) ? parseInt(year, 10) : null,        !isNaN(parseInt(month, 10)) ? parseInt(month, 10) : null,        !isNaN(parseInt(day, 10)) ? parseInt(day, 10) : null,`|non-sink|\n|`redirectTo === 'login' ? {redirectTo: to.path,} : to.query`|`    return next({      name: redirectTo,      query: redirectTo === 'login' ? {        redirectTo: to.path,      } : to.query,    });  }`|non-sink|\n"
  }

  /**
   * Gets the reconstructed source code text for a range of locations.
   */
  string tokenize(Location location) {
    result =
      strictconcat(Token token |
        location.containsLoosely(token.getLocation())
      |
        token.getValue(),
          // Use space as the separator, since that is most likely.
          // May not be an exact reconstruction, e.g. if the code
          // had newlines between successive tokens.
          // TODO: Don't add a space if the current or previous token is a period.
          " "
        order by
          token.getLocation().getStartLine(), token.getLocation().getStartColumn()
      )
  }

  /**
   * Gets the reconstructed source code text for `node`.
   */
  string tokenizeEndpoint(DataFlow::Node node) {
    result = this.tokenize(node.getAstNode().getLocation())
  }

  /**
   * Gets the reconstructed source code text for the neighborhood around `node`, including `neighborhoodSize` lines
   * before and `neighborhoodSize` lines after `node`.
   */
  bindingset[neighborhoodSize]
  string tokenizeNeighborhood(DataFlow::Node node, int neighborhoodSize) {
    result =
      this.tokenize(any(Location location |
          location.getFile() = node.getAstNode().getLocation().getFile() and
          location.getStartLine() =
            max(int line |
              line = node.getAstNode().getLocation().getStartLine() - neighborhoodSize or line = 1
            |
              line
            ) and
          location.getEndLine() =
            min(int line |
              line = node.getAstNode().getLocation().getEndLine() + neighborhoodSize + 1 or // Add 1 because the end column is 1
              line = location.getFile().getNumberOfLines()
            |
              line
            ) and
          location.getStartColumn() = 1 and
          location.getEndColumn() = 1
        ))
  }
}

/**
 * The feature for the name of the function that encloses the endpoint.
 */
class EnclosingFunctionName extends EndpointFeature, TEnclosingFunctionName {
  override string getName() { result = "enclosingFunctionName" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      FunctionNames::getNameToFeaturize(FunctionBodyFeatures::getRepresentativeFunctionForEndpoint(endpoint))
  }
}

/**
 * The feature for the name of the receiver of the call, e.g. in a call `Artist.findOne(...)`, this is `Artist`.
 */
class ReceiverName extends EndpointFeature, TReceiverName {
  override string getName() { result = "receiverName" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      strictconcat(DataFlow::CallNode call, string component |
        endpoint = call.getAnArgument() and
        component = call.getReceiver().asExpr().(VarRef).getName()
      |
        component, " "
      )
  }
}

/**
 * The feature for the natural language tokens from the function that encloses the endpoint in
 * the order that they appear in the source code.
 */
class EnclosingFunctionBody extends EndpointFeature, TEnclosingFunctionBody {
  override string getName() { result = "enclosingFunctionBody" }

  override string getValue(DataFlow::Node endpoint) {
    endpoint = any(FeaturizationConfig cfg).getAnEndpointToFeaturize() and
    result =
      FunctionBodyFeatures::getBodyTokensFeature(FunctionBodyFeatures::getRepresentativeFunctionForEndpoint(endpoint))
  }
}

/**
 * The feature for the imports defined in the file containing an endpoint.
 *
 * ### Example
 *
 * ```javascript
 * import { findOne } from 'mongoose';
 * import * as _ from 'lodash';
 * const pg = require('pg');
 *
 * // ...
 * ```
 *
 * In this file, all endpoints will have the value `lodash mongoose pg` for the feature `fileImports`.
 */
class FileImports extends EndpointFeature, TFileImports {
  override string getName() { result = "fileImports" }

  override string getValue(DataFlow::Node endpoint) {
    result = SyntacticUtilities::getImportPathsForFile(endpoint.getFile())
  }
}

/**
 * The feature for the function parameters of the functions that enclose an endpoint.
 *
 * ### Example
 * ```javascript
 * function f(a, b) {
 *   // ...
 *   const g = (c, d) => x.foo(endpoint);
 * //                          ^^^^^^^^
 * }
 * ```
 * In the above example, the feature for the marked endpoint has value '(a, b)\n(c, d)'.
 * The line breaks act as a separator between the parameters of different functions but
 * will be treated by tokenization as if they were spaces.
 */
class ContextSurroundingFunctionParameters extends EndpointFeature,
  TContextSurroundingFunctionParameters {
  override string getName() { result = "contextSurroundingFunctionParameters" }

  Function getRelevantFunction(DataFlow::Node endpoint) {
    result = endpoint.asExpr().getEnclosingFunction*()
  }

  override string getValue(DataFlow::Node endpoint) {
    result =
      concat(string functionParameterLine, Function f |
        f = this.getRelevantFunction(endpoint) and
        functionParameterLine = SyntacticUtilities::getFunctionParametersFeatureComponent(f)
      |
        functionParameterLine, "\n"
        order by
          f.getLocation().getStartLine(), f.getLocation().getStartColumn()
      )
  }
}

/**
 * The feature that gives the name of any properties an endpoint is assigned to (if any).
 *
 * ### Example
 * ```javascript
 * const div = document.createElement('div');
 * div.innerHTML = endpoint; // feature value is 'innerHTML'
 *
 * foo({x: endpoint}); // feature value is 'x'
 * ```
 */
class AssignedToPropName extends EndpointFeature, TAssignedToPropName {
  override string getName() { result = "assignedToPropName" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::PropWrite w | w.getRhs().asExpr().getUnderlyingValue().flow() = endpoint |
      result = w.getPropertyName()
    )
  }
}

/**
 * The feature that shows the text an endpoint is being concatenated with.
 *
 * ### Example
 *
 * ```javascript
 * const x = 'foo' + endpoint + 'bar'; // feature value is `'foo' -endpoint- 'bar'
 * ```
 */
class StringConcatenatedWith extends EndpointFeature, TStringConcatenatedWith {
  override string getName() { result = "stringConcatenatedWith" }

  override string getValue(DataFlow::Node endpoint) {
    exists(StringOps::ConcatenationRoot root |
      root.getALeaf() = endpoint and
      result =
        concat(StringOps::ConcatenationLeaf p |
            p.getRoot() = root and
            (
              p.getStartLine() < endpoint.getStartLine()
              or
              p.getStartLine() = endpoint.getStartLine() and
              p.getStartColumn() < endpoint.getStartColumn()
            )
          |
            SyntacticUtilities::renderStringConcatOperand(p), " + "
            order by
              p.getStartLine(), p.getStartColumn()
          ) + " -endpoint- " +
          concat(StringOps::ConcatenationLeaf p |
            p.getRoot() = root and
            (
              p.getStartLine() > endpoint.getStartLine()
              or
              p.getStartLine() = endpoint.getStartLine() and
              p.getStartColumn() > endpoint.getStartColumn()
            )
          |
            SyntacticUtilities::renderStringConcatOperand(p), " + "
            order by
              p.getStartLine(), p.getStartColumn()
          )
    )
  }
}

/**
 * The feature for the imports used in the callee of an invocation.
 *
 * ### Example
 *
 * ```javascript
 * import * as _ from 'lodash';
 *
 * // ...
 * _.deepClone(someObject);
 * //          ^^^^^^^^^^ will have the value `lodash` for the feature `calleeImports`.
 * ```
 */
class CalleeImports extends EndpointFeature, TCalleeImports {
  override string getName() { result = "calleeImports" }

  override string getValue(DataFlow::Node endpoint) {
    not result = SyntacticUtilities::getUnknownSymbol() and
    exists(DataFlow::InvokeNode invk |
      (
        invk.getAnArgument() = endpoint or
        SyntacticUtilities::getANestedInitializerValue(invk.getAnArgument()
              .asExpr()
              .getUnderlyingValue()).flow() = endpoint
      ) and
      result =
        concat(string importPath |
          importPath = SyntacticUtilities::getCalleeImportPath(invk.getCalleeNode())
        |
          importPath, " " order by importPath
        )
    )
  }
}

/**
 * The feature for the interfaces of all named functions in the same file as the endpoint.
 *
 * ### Example
 * ```javascript
 * // Will return: "f(a, b, c)\ng(x, y, z)\nh(u, v)" for this file.
 * function f(a, b, c) { ... }
 *
 * function g(x, y, z) {
 *   function h(u, v) { ... }
 *   ...
 * }
 * ```
 */
class ContextFunctionInterfaces extends EndpointFeature, TContextFunctionInterfaces {
  override string getName() { result = "contextFunctionInterfaces" }

  override string getValue(DataFlow::Node endpoint) {
    result = SyntacticUtilities::getFunctionInterfacesForFile(endpoint.getFile())
  }
}

/**
 * Syntactic utilities for feature value computation.
 */
private module SyntacticUtilities {
  /**
   * Renders an operand in a string concatenation by surrounding a constant in quotes, and
   * by using `getSimpleAccessPath` for everything else.
   */
  string renderStringConcatOperand(DataFlow::Node operand) {
    if exists(unique(string v | operand.mayHaveStringValue(v)))
    then result = "'" + any(string v | operand.mayHaveStringValue(v)) + "'"
    else result = getSimpleAccessPath(operand)
  }

  /** Gets all the imports defined in the file containing the endpoint. */
  string getImportPathsForFile(File file) {
    result =
      concat(string importPath |
        importPath = SyntacticUtilities::getImportPathForFile(file)
      |
        importPath, " " order by importPath
      )
  }

  /** Gets an import located in `file`. */
  string getImportPathForFile(File file) {
    result = any(Import imp | imp.getFile() = file).getImportedPath().getValue()
  }

  /**
   * Gets the feature component for the parameters of a function.
   *
   * ```javascript
   * function f(a, b, c) { // will return "(a, b, c)" for this function
   *  return a + b + c;
   * }
   *
   * async function g(a) { // will return "(a)" for this function
   *   return 2*a
   * };
   *
   * const h = (b) => 3*b; // will return "(b)" for this function
   * ```
   */
  string getFunctionParametersFeatureComponent(Function f) {
    result =
      "(" +
        concat(string parameter, int i |
          parameter = getParameterNameOrUnknown(f.getParameter(i))
        |
          parameter, ", " order by i
        ) + ")"
  }

  /**
   * Gets the function interfaces of all named functions in a file, concatenated together.
   *
   * ```javascript
   * // Will return: "f(a, b, c)\ng(x, y, z)\nh(u, v)" for this file.
   * function f(a, b, c) { ... }
   *
   * function g(x, y, z) {
   *   function h(u, v) { ... }
   *   ...
   * }
   */
  string getFunctionInterfacesForFile(File file) {
    result =
      concat(Function func, string line |
        func.getFile() = file and
        line = func.getName() + getFunctionParametersFeatureComponent(func)
      |
        line, "\n" order by line
      )
  }

  /**
   * Gets a property initializer value in an object literal or one of its nested object literals.
   */
  Expr getANestedInitializerValue(ObjectExpr o) {
    exists(Expr init | init = o.getAProperty().getInit().getUnderlyingValue() |
      result = [init, getANestedInitializerValue(init)]
    )
  }

  /**
   * Computes a simple access path for how a callee can refer to a value that appears in an argument to a call.
   *
   * Supports:
   * - direct arguments
   * - properties of (nested) objects that are arguments
   *
   * Unknown cases and property names result in `?`.
   */
  string getSimpleParameterAccessPath(DataFlow::Node node) {
    if exists(DataFlow::CallNode call | node = call.getArgument(_))
    then exists(DataFlow::CallNode call, int i | node = call.getArgument(i) | result = i + "")
    else result = getSimplePropertyAccessPath(node)
  }

  /**
   * Computes a simple access path for how a user can refer to a value that appears in an (nested) object.
   *
   * Supports:
   * - properties of (nested) objects
   *
   * Unknown cases and property names result in `?`.
   */
  string getSimplePropertyAccessPath(DataFlow::Node node) {
    if exists(ObjectExpr o | o.getAProperty().getInit().getUnderlyingValue() = node.asExpr())
    then
      exists(DataFlow::PropWrite w |
        w.getRhs() = node and
        result = getSimpleParameterAccessPath(w.getBase()) + "." + getPropertyNameOrUnknown(w)
      )
    else result = getUnknownSymbol()
  }

  /**
   * Gets the imported package path that this node depends on, if any.
   *
   * Otherwise, returns '?'.
   *
   * XXX Be careful with using this in your features, as it might teach the model
   * a fixed list of "dangerous" libraries that could lead to bad generalization.
   */
  string getCalleeImportPath(DataFlow::Node node) {
    exists(DataFlow::Node src | src = node.getALocalSource() |
      if src instanceof DataFlow::ModuleImportNode
      then result = src.(DataFlow::ModuleImportNode).getPath()
      else
        if src instanceof DataFlow::PropRead
        then result = getCalleeImportPath(src.(DataFlow::PropRead).getBase())
        else
          if src instanceof DataFlow::InvokeNode
          then result = getCalleeImportPath(src.(DataFlow::InvokeNode).getCalleeNode())
          else
            if src.asExpr() instanceof AwaitExpr
            then result = getCalleeImportPath(src.asExpr().(AwaitExpr).getOperand().flow())
            else result = getUnknownSymbol()
    )
  }

  /**
   * Computes a simple access path for a node.
   *
   * Supports:
   * - variable reads (including `this` and `super`)
   * - imports
   * - await
   * - property reads
   * - invocations
   *
   * Unknown cases and property names results in `?`.
   *
   * # Examples
   *
   *  - The node `x.foo` will have the simple access path `x.foo`.
   *  - In the following file, the simple access path will be `import("./foo").bar.baz`:
   *
   * ```javascript
   * import * as lib from "./foo"
   * console.log(lib.bar.baz());
   * //          ^^^^^^^^^^^ node
   */
  string getSimpleAccessPath(DataFlow::Node node) {
    exists(Expr e | e = node.asExpr().getUnderlyingValue() |
      if
        e instanceof SuperAccess or
        e instanceof ThisAccess or
        e instanceof VarAccess or
        e instanceof Import or
        e instanceof AwaitExpr or
        node instanceof DataFlow::PropRead or
        node instanceof DataFlow::InvokeNode
      then
        e instanceof SuperAccess and result = "super"
        or
        e instanceof ThisAccess and result = "this"
        or
        e instanceof VarAccess and result = e.(VarAccess).getName()
        or
        e instanceof Import and result = "import(" + getSimpleImportPath(e) + ")"
        or
        e instanceof AwaitExpr and
        result = "(await " + getSimpleAccessPath(e.(AwaitExpr).getOperand().flow()) + ")"
        or
        node instanceof DataFlow::PropRead and
        result =
          getSimpleAccessPath(node.(DataFlow::PropRead).getBase()) + "." +
            getPropertyNameOrUnknown(node)
        or
        (node instanceof DataFlow::InvokeNode and not e instanceof Import) and
        result = getSimpleAccessPath(node.(DataFlow::InvokeNode).getCalleeNode()) + "()"
      else result = getUnknownSymbol()
    )
  }

  string getUnknownSymbol() { result = "?" }

  /**
   * Gets the imported path.
   *
   * XXX To avoid teaching the ML model about npm packages, only relative paths are supported
   *
   * Unknown paths result in `?`.
   */
  string getSimpleImportPath(Import i) {
    if exists(i.getImportedPath().getValue())
    then
      exists(string p | p = i.getImportedPath().getValue() |
        // Hide absolute imports from ML training data.
        // ============================================
        // There is the hypothesis that exposing absolute imports to the model
        // might lead to bad generalization. For example, the model might learn
        // to strongly associate a specific database client with sinks and no
        // longer be able to flag sinks when data flow is broken.
        // Placing this logic so deeply within the feature extraction code is
        // perhaps a bit of a hack and it is a use case to consider when refactoring
        // endpoint filters/data extraction.
        if p.matches(".%") then result = "\"p\"" else result = "!"
      )
    else result = getUnknownSymbol()
  }

  /**
   * Gets the property name of a property reference or `?` if it is unknown.
   */
  string getPropertyNameOrUnknown(DataFlow::PropRef ref) {
    if exists(ref.getPropertyName())
    then result = ref.getPropertyName()
    else result = getUnknownSymbol()
  }

  /**
   * Gets the parameter name if it exists, or `?` if it is unknown.
   */
  string getParameterNameOrUnknown(Parameter p) {
    if exists(p.getName()) then result = p.getName() else result = getUnknownSymbol()
  }
}

/**
 * The feature for the access path of the callee node of a call that has an argument that "contains" the endpoint.
 *
 * "Containment" is syntactic, and currently means that the endpoint is an argument to the call, or that the endpoint is a (nested) property value of an argument.
 *
 * Examples:
 * ```
 * foo(endpoint); // -> foo
 * foo.bar(endpoint); // -> foo.bar
 * foo.bar({ baz: endpoint }); // -> foo.bar
 * this.foo.bar(endpoint); // -> this.foo.bar
 * foo[complex()].bar(endpoint); // -> foo.?.bar
 * ```
 */
class CalleeFlexibleAccessPath extends EndpointFeature, TCalleeFlexibleAccessPath {
  override string getName() { result = "CalleeFlexibleAccessPath" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::InvokeNode invk |
      result = SyntacticUtilities::getSimpleAccessPath(invk.getCalleeNode()) and
      // ignore the unknown path
      not result = SyntacticUtilities::getUnknownSymbol() and
      (
        invk.getAnArgument() = endpoint or
        SyntacticUtilities::getANestedInitializerValue(invk.getAnArgument()
              .asExpr()
              .getUnderlyingValue()).flow() = endpoint
      )
    )
  }
}

/**
 * The feature for how a callee can refer to a the endpoint that is "contained" in some argument to a call
 *
 * "Containment" is syntactic, and currently means that the endpoint is an argument to the call, or that the endpoint is a (nested) property value of an argument.
 *
 * Examples:
 * ```
 * foo({ bar: endpoint }); // -> bar
 * foo(x, { bar: { baz: endpoint } }); // -> bar.baz
 * ```
 */
class InputAccessPathFromCallee extends EndpointFeature, TInputAccessPathFromCallee {
  override string getName() { result = "InputAccessPathFromCallee" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::InvokeNode invk |
      result = SyntacticUtilities::getSimpleParameterAccessPath(endpoint) and
      SyntacticUtilities::getANestedInitializerValue(invk.getAnArgument()
            .asExpr()
            .getUnderlyingValue()).flow() = endpoint
    )
  }
}

/**
 * The feature for how the index of an argument that "contains" and endpoint.
 *
 * "Containment" is syntactic, and currently means that the endpoint is an argument to the call, or that the endpoint is a (nested) property value of an argument.
 *
 * Examples:
 * ```
 * foo(endpoint); // -> 0
 * foo({ bar: endpoint }); // -> 0
 * foo(x, { bar: { baz: endpoint } }); // -> 1
 * ```
 */
class InputArgumentIndex extends EndpointFeature, TInputArgumentIndex {
  override string getName() { result = "InputArgumentIndex" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::InvokeNode invk, DataFlow::Node arg, int i | arg = invk.getArgument(i) |
      result = i + "" and
      (
        invk.getArgument(i) = endpoint
        or
        SyntacticUtilities::getANestedInitializerValue(arg.asExpr().getUnderlyingValue()).flow() =
          endpoint
      )
    )
  }
}
