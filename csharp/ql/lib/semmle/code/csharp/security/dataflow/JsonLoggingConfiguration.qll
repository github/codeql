/**
 * Provides a conservative, database-wide heuristic for deciding whether
 * standard logging calls are protected by a JSON-only logging configuration.
 *
 * Visible logging configuration is inventoried and any unsupported or
 * unresolved operation vetoes suppression. Ordinary external business-service
 * extensions are assumed not to mutate logging unless their signatures
 * identify them as logging configuration.
 */

import csharp
import semmle.code.csharp.dataflow.DataFlow

private predicate hasTypeName(Type t, string namespace, string name) {
  t.getUnboundDeclaration().hasFullyQualifiedName(namespace, name)
}

bindingset[name]
private predicate hasMethodIdentity(Method method, string namespace, string type, string name) {
  method.getUnboundDeclaration().getDeclaringType().hasFullyQualifiedName(namespace, type) and
  (
    method.getUnboundDeclaration().getName() = name or
    method.getUnboundDeclaration().getName().matches(name + "`%")
  )
}

private predicate isSerilogConfigurationType(Type t) {
  hasTypeName(t, "Serilog", "LoggerConfiguration") or
  hasTypeName(t, "Serilog.Configuration",
    [
      "LoggerSinkConfiguration", "LoggerAuditSinkConfiguration", "LoggerEnrichmentConfiguration",
      "LoggerFilterConfiguration", "LoggerMinimumLevelConfiguration", "LoggerSettingsConfiguration",
      "LoggerDestructuringConfiguration"
    ])
}

private predicate isLoggingBuilderType(Type t) {
  hasTypeName(t, "Microsoft.Extensions.Logging", "ILoggingBuilder")
}

private predicate isLoggerFactoryType(Type t) {
  hasTypeName(t, "Microsoft.Extensions.Logging", ["ILoggerFactory", "LoggerFactory"])
}

private predicate isLoggingSetupType(Type t) {
  isSerilogConfigurationType(t) or isLoggingBuilderType(t) or isLoggerFactoryType(t)
}

private predicate isLoggingServiceType(Type t) {
  hasTypeName(t, "Microsoft.Extensions.Logging",
    ["ILogger", "ILogger`1", "ILoggerFactory", "ILoggerProvider"]) or
  hasTypeName(t, "Microsoft.Extensions.Logging.Console", "ConsoleFormatter") or
  hasTypeName(t, "Serilog", "ILogger") or
  hasTypeName(t, "Serilog.Core", "ILogEventSink")
}

private predicate isOrImplementsLoggingService(Type t) {
  isLoggingServiceType(t)
  or
  isLoggingServiceType(t.(RefType).getABaseType+())
}

private predicate isLoggingOptionsType(Type t) {
  hasTypeName(t, "Microsoft.Extensions.Logging.Console",
    [
      "ConsoleLoggerOptions", "ConsoleFormatterOptions", "JsonConsoleFormatterOptions",
      "SimpleConsoleFormatterOptions"
    ])
}

private Expr getCallReceiver(MethodCall call) {
  call instanceof ExtensionMethodCall and result = call.getArgument(0)
  or
  not call instanceof ExtensionMethodCall and result = call.getQualifier()
}

/** Gets a type mentioned in a call's resolved signature or expressions. */
private Type getAMentionedType(MethodCall call) {
  result = call.getTarget().getDeclaringType() or
  result = call.getTarget().getReturnType() or
  result = getCallReceiver(call).getType() or
  result = call.getTarget().getAParameter().getType() or
  result = call.getAnArgument().getType()
}

private predicate callMentionsLoggingSetup(MethodCall call) {
  isLoggingSetupType(getAMentionedType(call))
}

private predicate callMentionsBuiltInLoggingSetup(MethodCall call) {
  isLoggingBuilderType(getAMentionedType(call)) or isLoggerFactoryType(getAMentionedType(call))
}

private predicate isFalseOrOmittedArgument(MethodCall call, string parameterName) {
  exists(Parameter p |
    p = call.getTarget().getAParameter() and
    p.hasName(parameterName) and
    not exists(call.getArgumentForParameter(p))
  )
  or
  call.getArgumentForName(parameterName).stripImplicit().(BoolLiteral).getBoolValue() = false
}

private predicate isNullOrOmittedArgument(Call call, string parameterName) {
  exists(Parameter p |
    p = call.getTarget().getAParameter() and
    p.hasName(parameterName) and
    not exists(call.getArgumentForParameter(p))
  )
  or
  call.getArgumentForName(parameterName).stripImplicit() instanceof NullLiteral
}

private predicate isUnconditionalFluentSubexpression(Expr outer, Expr inner) {
  outer.stripImplicit() = inner
  or
  exists(PropertyRead read |
    outer.stripImplicit() = read and
    isUnconditionalFluentSubexpression(read.getQualifier(), inner)
  )
  or
  exists(MethodCall call |
    outer.stripImplicit() = call and
    isUnconditionalFluentSubexpression(getCallReceiver(call), inner)
  )
}

private predicate callDirectlyTargetsParameter(MethodCall call, Parameter p) {
  isUnconditionalFluentSubexpression(getCallReceiver(call), p.getAnAccess())
}

// Serilog discovery and local classification.
private predicate isSafeSerilogFormatter(Expr formatter) {
  exists(ObjectCreation creation |
    formatter.stripImplicit() = creation and
    not creation.getObjectType().getUnboundDeclaration().fromSource() and
    creation.getObjectType().hasFullyQualifiedName("Serilog.Formatting.Json", "JsonFormatter") and
    isNullOrOmittedArgument(creation, "closingDelimiter")
  )
  or
  exists(ObjectCreation creation |
    formatter.stripImplicit() = creation and
    not creation.getObjectType().getUnboundDeclaration().fromSource() and
    creation
        .getObjectType()
        .hasFullyQualifiedName("Serilog.Formatting.Compact",
          ["CompactJsonFormatter", "RenderedCompactJsonFormatter"]) and
    (
      isNullOrOmittedArgument(creation, "valueFormatter") or
      creation.getArgumentForName("valueFormatter") =
        any(ObjectCreation valueFormatter |
          not valueFormatter.getObjectType().getUnboundDeclaration().fromSource() and
          valueFormatter
              .getObjectType()
              .hasFullyQualifiedName("Serilog.Formatting.Json", "JsonValueFormatter")
        )
    )
  )
}

private predicate isSerilogOutputCall(MethodCall call) {
  (
    call.getTarget()
        .hasFullyQualifiedName("Serilog", "ConsoleLoggerConfigurationExtensions", "Console") or
    call.getTarget()
        .hasFullyQualifiedName("Serilog", "ConsoleAuditLoggerConfigurationExtensions", "Console") or
    call.getTarget().hasFullyQualifiedName("Serilog", "FileLoggerConfigurationExtensions", "File")
  ) and
  call.getTarget()
      .getParameter(0)
      .getType()
      .hasFullyQualifiedName("Serilog.Configuration",
        ["LoggerSinkConfiguration", "LoggerAuditSinkConfiguration"])
}

private predicate isRecognizedJsonOutput(MethodCall call) {
  isSerilogOutputCall(call) and isSafeSerilogFormatter(call.getArgumentForName("formatter"))
}

private predicate isSerilogWrapperCall(MethodCall call) {
  call.getTarget().hasFullyQualifiedName("Serilog", "LoggerConfigurationAsyncExtensions", "Async") and
  call.getTarget()
      .getParameter(0)
      .getType()
      .hasFullyQualifiedName("Serilog.Configuration",
        ["LoggerSinkConfiguration", "LoggerAuditSinkConfiguration"])
}

private predicate isRecognizedJsonWrapper(MethodCall call) {
  isSerilogWrapperCall(call) and
  exists(AnonymousFunctionExpr callback, Parameter sink, MethodCall output |
    call.getAnArgument() = callback and
    callback.hasExpressionBody() and
    sink = callback.getAParameter() and
    sink.getType().hasFullyQualifiedName("Serilog.Configuration", "LoggerSinkConfiguration") and
    output.getEnclosingCallable() = callback and
    isRecognizedJsonOutput(output) and
    callDirectlyTargetsParameter(output, sink) and
    isUnconditionalFluentSubexpression(callback.getExpressionBody(), output)
  )
}

private predicate isRecognizedJsonEmittingCall(MethodCall call) {
  isRecognizedJsonOutput(call) or isRecognizedJsonWrapper(call)
}

private predicate isAllowedSerilogDecorationCall(MethodCall call) {
  callMentionsLoggingSetup(call) and
  (
    isSerilogConfigurationType(call.getTarget().getDeclaringType()) or
    call.getTarget()
        .getDeclaringType()
        .hasFullyQualifiedName("Serilog",
          [
            "LoggerEnrichmentConfigurationExtensions", "LoggerFilterConfigurationExtensions",
            "LoggerDestructuringConfigurationExtensions",
            "LoggerMinimumLevelConfigurationExtensions"
          ])
  ) and
  call.getTarget()
      .hasName([
          "MinimumLevel", "Verbose", "Debug", "Information", "Warning", "Error", "Fatal",
          "ControlledBy", "Override", "Enrich", "WithProperty", "With", "FromLogContext", "Filter",
          "ByIncludingOnly", "ByExcluding", "Destructure", "AsScalar", "ToMaximumDepth",
          "ToMaximumStringLength", "ToMaximumCollectionCount"
        ]) and
  not isSerilogOutputCall(call)
}

private predicate isSerilogTerminalCall(MethodCall call) {
  call.getTarget().hasFullyQualifiedName("Serilog", "LoggerConfiguration", "CreateLogger")
  or
  call.getTarget()
      .hasFullyQualifiedName("Serilog", "LoggerConfigurationExtensions", "CreateBootstrapLogger") and
  call.getTarget().getParameter(0).getType().hasFullyQualifiedName("Serilog", "LoggerConfiguration")
}

private predicate isRecognizedSerilogTerminalCall(MethodCall call) {
  isSerilogTerminalCall(call) and
  exists(MethodCall output |
    isRecognizedJsonEmittingCall(output) and
    DataFlow::localExprFlow(output, getCallReceiver(call))
  )
}

private predicate isSerilogServiceRegistration(MethodCall call) {
  call.fromSource() and
  call.getTarget()
      .hasFullyQualifiedName("Serilog", "SerilogServiceCollectionExtensions", "AddSerilog")
}

private predicate hasConfigurationCallback(
  MethodCall call, AnonymousFunctionExpr callback, Parameter configuration
) {
  call.getAnArgument() = callback and
  configuration = callback.getAParameter() and
  hasTypeName(configuration.getType(), "Serilog", "LoggerConfiguration")
}

private predicate isRecognizedSerilogServiceRegistration(MethodCall call) {
  isSerilogServiceRegistration(call) and
  exists(AnonymousFunctionExpr callback, Parameter configuration, MethodCall output |
    hasConfigurationCallback(call, callback, configuration) and
    callback.hasExpressionBody() and
    output.getEnclosingCallable() = callback and
    isRecognizedJsonEmittingCall(output) and
    callDirectlyTargetsParameter(output, configuration) and
    isUnconditionalFluentSubexpression(callback.getExpressionBody(), output)
  ) and
  (
    not exists(Parameter p | p = call.getTarget().getAParameter() and p.hasName("writeToProviders"))
    or
    isFalseOrOmittedArgument(call, "writeToProviders")
  ) and
  (
    not exists(Parameter p |
      p = call.getTarget().getAParameter() and p.hasName("preserveStaticLogger")
    )
    or
    isFalseOrOmittedArgument(call, "preserveStaticLogger")
  )
}

private predicate isStaticSerilogLoggerWrite(Assignment assignment) {
  assignment.fromSource() and
  assignment
      .getLeftOperand()
      .(PropertyWrite)
      .getProperty()
      .hasFullyQualifiedName("Serilog", "Log", "Logger")
}

private predicate isRecognizedStaticSerilogLoggerWrite(Assignment assignment) {
  isStaticSerilogLoggerWrite(assignment) and
  assignment.getRightOperand().stripImplicit() =
    any(MethodCall terminal | isRecognizedSerilogTerminalCall(terminal))
}

private predicate isSerilogSetupCandidate(MethodCall call) {
  call.fromSource() and
  (
    isSerilogConfigurationType(getAMentionedType(call)) or
    isSerilogServiceRegistration(call) or
    call.getTarget().hasFullyQualifiedName("Serilog", "SerilogHostBuilderExtensions", "UseSerilog") or
    call.getTarget()
        .hasFullyQualifiedName("Serilog", "SerilogLoggingBuilderExtensions", "AddSerilog")
  )
}

private predicate isRecognizedSerilogSetupCall(MethodCall call) {
  isRecognizedJsonOutput(call) or
  isRecognizedJsonWrapper(call) or
  isAllowedSerilogDecorationCall(call) or
  isRecognizedSerilogTerminalCall(call) or
  isRecognizedSerilogServiceRegistration(call)
}

// Microsoft.Extensions.Logging discovery and local classification.
private predicate isBuiltInJsonCall(MethodCall call) {
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.Extensions.Logging", "ConsoleLoggerExtensions",
        "AddJsonConsole") and
  call.getTarget().getNumberOfParameters() = 1
}

private predicate isClearProvidersCall(MethodCall call) {
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.Extensions.Logging", "LoggingBuilderExtensions",
        "ClearProviders")
}

private predicate isAddLoggingCall(MethodCall call) {
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.Extensions.DependencyInjection",
        "LoggingServiceCollectionExtensions", "AddLogging")
}

private predicate isConfigureLoggingCall(MethodCall call) {
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.Extensions.Hosting",
        ["HostingHostBuilderExtensions", "HostBuilderExtensions"], "ConfigureLogging")
}

private predicate callbackHasJsonOnlySetup(AnonymousFunctionExpr callback, boolean requireClear) {
  callback.hasExpressionBody() and
  exists(Parameter logging, MethodCall json |
    logging = callback.getAParameter() and
    isLoggingBuilderType(logging.getType()) and
    json.getEnclosingCallable() = callback and
    isBuiltInJsonCall(json) and
    isUnconditionalFluentSubexpression(callback.getExpressionBody(), json) and
    (
      requireClear = false and callDirectlyTargetsParameter(json, logging)
      or
      requireClear = true and
      exists(MethodCall clear |
        clear.getEnclosingCallable() = callback and
        isClearProvidersCall(clear) and
        callDirectlyTargetsParameter(clear, logging) and
        getCallReceiver(json).stripImplicit() = clear
      )
    )
  ) and
  not exists(MethodCall other |
    other.getEnclosingCallable() = callback and
    callMentionsBuiltInLoggingSetup(other) and
    not isClearProvidersCall(other) and
    not isBuiltInJsonCall(other)
  )
}

private predicate isLoggerFactoryCreateCall(MethodCall call) {
  call.getTarget().hasFullyQualifiedName("Microsoft.Extensions.Logging", "LoggerFactory", "Create")
}

private predicate isRecognizedLoggerFactoryCreate(MethodCall call) {
  isLoggerFactoryCreateCall(call) and
  exists(AnonymousFunctionExpr callback |
    call.getAnArgument() = callback and callbackHasJsonOnlySetup(callback, false)
  )
}

private predicate isRecognizedAddLogging(MethodCall call) {
  isAddLoggingCall(call) and
  exists(AnonymousFunctionExpr callback |
    call.getAnArgument() = callback and callbackHasJsonOnlySetup(callback, true)
  )
}

private predicate isRecognizedConfigureLogging(MethodCall call) {
  isConfigureLoggingCall(call) and
  exists(AnonymousFunctionExpr callback |
    call.getAnArgument() = callback and callbackHasJsonOnlySetup(callback, true)
  )
}

private predicate isLoggerFactoryConsumptionCall(MethodCall call) {
  call.getTarget()
      .hasFullyQualifiedName("Microsoft.Extensions.Logging", "ILoggerFactory", "CreateLogger")
  or
  hasMethodIdentity(call.getTarget(), "Microsoft.Extensions.Logging", "LoggerFactoryExtensions",
    "CreateLogger")
  or
  call.getTarget().hasFullyQualifiedName("Microsoft.Extensions.Logging", "LoggerFactory", "Dispose")
  or
  call.getTarget().hasFullyQualifiedName("System", "IDisposable", "Dispose") and
  isLoggerFactoryType(getCallReceiver(call).getType())
}

private predicate isBuiltInSetupCandidate(MethodCall call) {
  call.fromSource() and
  (
    callMentionsBuiltInLoggingSetup(call) or
    isAddLoggingCall(call) or
    isConfigureLoggingCall(call) or
    isLoggerFactoryCreateCall(call)
  )
}

private predicate isRecognizedBuiltInSetupCall(MethodCall call) {
  isClearProvidersCall(call) or
  isBuiltInJsonCall(call) or
  isRecognizedAddLogging(call) or
  isRecognizedConfigureLogging(call) or
  isRecognizedLoggerFactoryCreate(call) or
  isLoggerFactoryConsumptionCall(call)
}

// Host/setup association.
private predicate isHostCreation(Expr creation) {
  exists(MethodCall call |
    creation = call and
    call.fromSource() and
    (
      call.getTarget()
          .hasFullyQualifiedName("Microsoft.AspNetCore.Builder", "WebApplication",
            ["CreateBuilder", "CreateSlimBuilder", "CreateEmptyBuilder"]) or
      call.getTarget()
          .hasFullyQualifiedName("Microsoft.AspNetCore", "WebHost", "CreateDefaultBuilder") or
      call.getTarget()
          .hasFullyQualifiedName("Microsoft.Extensions.Hosting", "Host",
            ["CreateDefaultBuilder", "CreateApplicationBuilder", "CreateEmptyApplicationBuilder"])
    )
  )
  or
  exists(ObjectCreation constructorCall |
    creation = constructorCall and
    constructorCall.fromSource() and
    constructorCall
        .getObjectType()
        .hasFullyQualifiedName("Microsoft.Extensions.Hosting", "HostApplicationBuilder")
  )
}

private predicate hasUnambiguousLocalOrigin(Expr expression, Expr origin) {
  expression.stripImplicit() = origin
  or
  exists(LocalVariableAccess access, LocalVariable variable |
    expression.stripImplicit() = access and
    access.getTarget() = variable and
    not exists(LocalVariableWrite write |
      write.getTarget() = variable and
      not exists(LocalVariableDeclAndInitExpr initialization |
        initialization.getLeftOperand() = write
      )
    ) and
    hasUnambiguousLocalOrigin(variable.getInitializer(), origin)
  )
}

private predicate propertyIsReadFromHost(Expr hostCreation, PropertyRead read, string name) {
  read.getProperty().hasName(name) and
  hasUnambiguousLocalOrigin(read.getQualifier(), hostCreation)
}

private predicate callTargetsHostProperty(Expr hostCreation, MethodCall call, string name) {
  exists(PropertyRead read |
    propertyIsReadFromHost(hostCreation, read, name) and
    hasUnambiguousLocalOrigin(getCallReceiver(call), read)
  )
}

private predicate setupUnconditionallyFollowsHost(Expr hostCreation, MethodCall setup) {
  setup.getControlFlowNode().postDominates(hostCreation.getControlFlowNode()) and
  setup.reachableFrom(hostCreation) and
  not exists(MethodCall build |
    build.getTarget().getName() = "Build" and
    // Safe setup needs an unambiguous receiver, but a possibly invalidating build must use
    // may-flow so that builds through merged aliases cannot be overlooked.
    DataFlow::localExprFlow(hostCreation, getCallReceiver(build)) and
    not (
      build.reachableFrom(setup) and
      build.getControlFlowNode().postDominates(setup.getControlFlowNode())
    )
  )
}

private predicate hostHasDirectJsonSetup(Expr hostCreation) {
  exists(MethodCall clear, MethodCall json |
    isClearProvidersCall(clear) and
    isBuiltInJsonCall(json) and
    callTargetsHostProperty(hostCreation, clear, "Logging") and
    (
      callTargetsHostProperty(hostCreation, json, "Logging") or
      DataFlow::localExprFlow(clear, getCallReceiver(json))
    ) and
    setupUnconditionallyFollowsHost(hostCreation, clear) and
    setupUnconditionallyFollowsHost(hostCreation, json) and
    json.reachableFrom(clear)
  )
}

private predicate hostHasRegistrationJsonSetup(Expr hostCreation) {
  exists(MethodCall setup |
    (isRecognizedAddLogging(setup) or isRecognizedSerilogServiceRegistration(setup)) and
    callTargetsHostProperty(hostCreation, setup, "Services") and
    setupUnconditionallyFollowsHost(hostCreation, setup)
  )
  or
  exists(MethodCall setup |
    isRecognizedConfigureLogging(setup) and
    hasUnambiguousLocalOrigin(getCallReceiver(setup), hostCreation) and
    setupUnconditionallyFollowsHost(hostCreation, setup)
  )
}

private predicate hostHasRecognizedJsonSetup(Expr hostCreation) {
  hostHasDirectJsonSetup(hostCreation) or hostHasRegistrationJsonSetup(hostCreation)
}

/*
 * Host creation and setup are deliberately modeled together above. Both
 * factory calls and HostApplicationBuilder constructors flow into the same
 * bounded local association checks.
 */

// Global veto inventory.
private predicate isUnresolvedLoggerFactoryConstruction(ObjectCreation creation) {
  creation.fromSource() and
  creation.getObjectType().hasFullyQualifiedName("Microsoft.Extensions.Logging", "LoggerFactory")
}

private predicate isAlternativeLoggingRegistration(MethodCall call) {
  call.fromSource() and
  (
    call.getTarget()
        .hasFullyQualifiedName("NLog.Extensions.Logging",
          ["ConfigureExtensions", "LoggingBuilderExtensions"], ["AddNLog", "UseNLog"]) or
    call.getTarget().hasFullyQualifiedName("NLog.Web", "AspNetExtensions", "UseNLog") or
    call.getTarget()
        .hasFullyQualifiedName("Microsoft.Extensions.Logging",
          ["Log4NetProviderExtensions", "Log4NetExtensions"], "AddLog4Net")
  )
}

private predicate callHasLoggingServiceTypeArgument(MethodCall call) {
  isOrImplementsLoggingService(call.getTarget().(ConstructedGeneric).getATypeArgument())
  or
  isOrImplementsLoggingService(call.getAnArgument()
        .stripImplicit()
        .(TypeofExpr)
        .getTypeAccess()
        .getTarget())
}

private predicate isCustomLoggingServiceRegistration(MethodCall call) {
  call.fromSource() and
  (
    hasMethodIdentity(call.getTarget(), "Microsoft.Extensions.DependencyInjection",
      "ServiceCollectionServiceExtensions",
      [
        "AddSingleton", "AddScoped", "AddTransient", "AddKeyedSingleton", "AddKeyedScoped",
        "AddKeyedTransient"
      ]) or
    hasMethodIdentity(call.getTarget(), "Microsoft.Extensions.DependencyInjection.Extensions",
      "ServiceCollectionDescriptorExtensions",
      [
        "TryAddSingleton", "TryAddScoped", "TryAddTransient", "TryAddKeyedSingleton",
        "TryAddKeyedScoped", "TryAddKeyedTransient", "RemoveAll", "RemoveAllKeyed"
      ])
  ) and
  callHasLoggingServiceTypeArgument(call)
}

private predicate isLoggingServiceDescriptorCreation(Expr descriptor) {
  exists(MethodCall call |
    descriptor = call and
    call.fromSource() and
    call.getTarget()
        .getDeclaringType()
        .hasFullyQualifiedName("Microsoft.Extensions.DependencyInjection", "ServiceDescriptor") and
    callHasLoggingServiceTypeArgument(call)
  )
  or
  exists(ObjectCreation creation |
    descriptor = creation and
    creation.fromSource() and
    creation
        .getObjectType()
        .hasFullyQualifiedName("Microsoft.Extensions.DependencyInjection", "ServiceDescriptor") and
    isOrImplementsLoggingService(creation
          .getAnArgument()
          .stripImplicit()
          .(TypeofExpr)
          .getTypeAccess()
          .getTarget())
  )
}

private predicate isLoggingOptionsConfiguration(MethodCall call) {
  call.fromSource() and
  call.getTarget().getUnboundDeclaration().getName().matches(["Configure%", "PostConfigure%"]) and
  (
    isLoggingOptionsType(call.getTarget().(ConstructedGeneric).getATypeArgument()) or
    isLoggingOptionsType(call.getTarget().getDeclaringType().(ConstructedType).getATypeArgument())
  )
}

private predicate isConsoleFormatterSelectionWrite(Assignment assignment) {
  assignment.fromSource() and
  assignment
      .getLeftOperand()
      .(PropertyWrite)
      .getProperty()
      .hasFullyQualifiedName("Microsoft.Extensions.Logging.Console", "ConsoleLoggerOptions",
        "FormatterName")
}

private predicate hasLoggingConfigurationEscape(Assignment assignment) {
  assignment.fromSource() and
  isLoggingSetupType(assignment.getRightOperand().getType()) and
  (
    assignment.getLeftOperand() instanceof FieldWrite or
    assignment.getLeftOperand() instanceof PropertyWrite
  )
}

private predicate isSourceDefinedLoggerImplementation(RefType t) {
  t.fromSource() and
  (
    t.getABaseType+()
        .hasFullyQualifiedName("Microsoft.Extensions.Logging", ["ILogger", "ILogger`1"]) or
    t.getABaseType+().hasFullyQualifiedName("Serilog", "ILogger")
  )
}

/** Reports visible evidence that prevents database-wide JSON logging suppression. */
predicate jsonLoggingConfigurationVeto(Element element, string reason) {
  exists(MethodCall call |
    element = call and
    isSerilogSetupCandidate(call) and
    not isRecognizedSerilogSetupCall(call) and
    reason = "unsupported Serilog configuration"
  )
  or
  exists(MethodCall call |
    element = call and
    isBuiltInSetupCandidate(call) and
    not isRecognizedBuiltInSetupCall(call) and
    reason = "unsupported Microsoft logging configuration"
  )
  or
  exists(MethodCall call |
    element = call and
    isAlternativeLoggingRegistration(call) and
    reason = "alternative logging registration"
  )
  or
  exists(MethodCall call |
    element = call and
    isCustomLoggingServiceRegistration(call) and
    reason = "logging service registration"
  )
  or
  exists(Expr descriptor |
    element = descriptor and
    isLoggingServiceDescriptorCreation(descriptor) and
    reason = "logging service descriptor"
  )
  or
  exists(MethodCall call |
    element = call and
    isLoggingOptionsConfiguration(call) and
    reason = "logging options configuration"
  )
  or
  exists(Assignment assignment |
    element = assignment and
    isConsoleFormatterSelectionWrite(assignment) and
    reason = "console formatter selection"
  )
  or
  exists(Expr hostCreation |
    element = hostCreation and
    isHostCreation(hostCreation) and
    not hostHasRecognizedJsonSetup(hostCreation) and
    reason = "host without associated JSON setup"
  )
  or
  exists(ObjectCreation creation |
    element = creation and
    isUnresolvedLoggerFactoryConstruction(creation) and
    reason = "unresolved logger factory construction"
  )
  or
  exists(Assignment assignment |
    element = assignment and
    hasLoggingConfigurationEscape(assignment) and
    reason = "logging configuration escape"
  )
  or
  exists(Assignment assignment |
    element = assignment and
    isStaticSerilogLoggerWrite(assignment) and
    not isRecognizedStaticSerilogLoggerWrite(assignment) and
    reason = "unsupported static Serilog logger assignment"
  )
  or
  exists(RefType t |
    element = t and
    isSourceDefinedLoggerImplementation(t) and
    reason = "source-defined logger implementation"
  )
}

private predicate hasRecognizedJsonLoggingEvidence() {
  exists(Expr hostCreation |
    isHostCreation(hostCreation) and hostHasRecognizedJsonSetup(hostCreation)
  )
  or
  exists(MethodCall call |
    isRecognizedLoggerFactoryCreate(call) or isRecognizedConfigureLogging(call)
  )
  or
  exists(MethodCall call |
    isRecognizedSerilogServiceRegistration(call) and
    not exists(Expr hostCreation | isHostCreation(hostCreation))
  )
}

/** Holds if the database is eligible for JSON logging suppression under this model. */
predicate isJsonLoggingSuppressionEligible() {
  hasRecognizedJsonLoggingEvidence() and
  not exists(Element element, string reason | jsonLoggingConfigurationVeto(element, reason))
}

private predicate isLibraryFrameworkLoggerType(Type t) {
  not t.getUnboundDeclaration().fromSource() and
  (
    t.(RefType)
        .getABaseType*()
        .hasFullyQualifiedName("Microsoft.Extensions.Logging", ["ILogger", "ILogger`1"]) or
    t.(RefType).getABaseType*().hasFullyQualifiedName("Serilog", "ILogger") or
    hasTypeName(t, "Serilog.Core", "Logger")
  )
}

private predicate isSupportedFrameworkLoggingCall(MethodCall call) {
  call.getTarget().fromLibrary() and
  (
    call.getTarget()
        .getDeclaringType()
        .hasFullyQualifiedName("Microsoft.Extensions.Logging",
          ["ILogger", "ILogger`1", "LoggerExtensions"]) or
    call.getTarget()
        .getDeclaringType()
        .hasFullyQualifiedName("Serilog", ["ILogger", "LoggerExtensions"]) or
    call.getTarget().getDeclaringType().hasFullyQualifiedName("Serilog.Core", "Logger")
  ) and
  (
    not exists(getCallReceiver(call)) or
    isLibraryFrameworkLoggerType(getCallReceiver(call).getType())
  )
}

/** Holds if `argument` is part of an eligible standard-framework logging call. */
predicate isJsonProtectedLogArgument(Expr argument) {
  isJsonLoggingSuppressionEligible() and
  exists(MethodCall call |
    argument = call.getAnArgument() and isSupportedFrameworkLoggingCall(call)
  )
}
