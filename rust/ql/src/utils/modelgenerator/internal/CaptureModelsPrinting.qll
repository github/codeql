private import codeql.mad.modelgenerator.internal.ModelPrinting
private import CaptureModels::ModelGeneratorCommonInput as ModelGeneratorInput
private import CaptureModels

private module ModelPrintingLang implements ModelPrintingLangSig {
  class Callable = QualifiedCallable;

  predicate partialModelRow = ModelGeneratorInput::partialModelRow/2;

  predicate partialNeutralModelRow = ModelGeneratorInput::partialNeutralModelRow/2;
}

import ModelPrintingImpl<ModelPrintingLang>
