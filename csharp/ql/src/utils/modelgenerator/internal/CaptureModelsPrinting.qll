private import csharp as CS
private import codeql.mad.modelgenerator.ModelPrinting
private import semmle.code.csharp.dataflow.internal.ExternalFlow as ExternalFlow

private module ModelPrintingLang implements ModelPrintingLangSig {
  class Callable = CS::Callable;

  predicate partialModel = ExternalFlow::partialModel/6;
}

import ModelPrintingImpl<ModelPrintingLang>
