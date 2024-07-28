private import java as J
private import codeql.mad.modelgenerator.ModelPrinting
private import CaptureModelsSpecific as Specific

private module ModelPrintingLang implements ModelPrintingLangSig {
  class Callable = J::Callable;

  predicate partialModel = Specific::partialModel/6;
}

import ModelPrintingImpl<ModelPrintingLang>
