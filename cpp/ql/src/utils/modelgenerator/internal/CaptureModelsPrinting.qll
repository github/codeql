private import cpp as Cpp
private import codeql.mad.modelgenerator.internal.ModelPrinting
private import CaptureModels::ModelGeneratorCommonInput as ModelGeneratorInput

private module ModelPrintingLang implements ModelPrintingLangSig {
  class Callable = Cpp::Declaration;

  predicate partialModelRow = ModelGeneratorInput::partialModelRow/2;

  predicate partialNeutralModelRow = ModelGeneratorInput::partialNeutralModelRow/2;
}

import ModelPrintingImpl<ModelPrintingLang>
