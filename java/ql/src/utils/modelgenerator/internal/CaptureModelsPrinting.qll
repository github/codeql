private import java as J
private import codeql.mad.modelgenerator.internal.ModelPrinting
private import CaptureModels::ModelGeneratorInput as ModelGeneratorInput

private module ModelPrintingLang implements ModelPrintingLangSig {
  class Callable = J::Callable;

  predicate partialModel = ModelGeneratorInput::partialModel/6;
}

import ModelPrintingImpl<ModelPrintingLang>
