private import java as J
private import codeql.mad.modelgenerator.internal.ModelPrinting
private import CaptureModels::ModelGeneratorInput as ModelGeneratorInput

private module ModelPrintingLang implements ModelPrintingLangSig {
  class Callable = J::Callable;

  predicate partialModelRow = ModelGeneratorInput::partialModelRow/2;

  predicate partialNeutralModelRow = ModelGeneratorInput::partialNeutralModelRow/2;
}

import ModelPrintingImpl<ModelPrintingLang>
