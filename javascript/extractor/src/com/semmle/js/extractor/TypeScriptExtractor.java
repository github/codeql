package com.semmle.js.extractor;

import com.semmle.js.extractor.ExtractorConfig.ECMAVersion;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.parser.JSParser.Result;
import com.semmle.js.parser.ParseError;
import com.semmle.js.parser.TypeScriptParser;
import java.io.File;

public class TypeScriptExtractor implements IExtractor {
  private final JSExtractor jsExtractor;
  private final TypeScriptParser parser;

  public TypeScriptExtractor(ExtractorConfig config, TypeScriptParser parser) {
    this.jsExtractor = new JSExtractor(config);
    this.parser = parser;
  }

  @Override
  public LoCInfo extract(TextualExtractor textualExtractor) {
    LocationManager locationManager = textualExtractor.getLocationManager();
    String source = textualExtractor.getSource();
    File sourceFile = locationManager.getSourceFile();
    Result res = parser.parse(sourceFile, source, textualExtractor.getMetrics());
    ScopeManager scopeManager =
        new ScopeManager(textualExtractor.getTrapwriter(), ECMAVersion.ECMA2017);
    try {
      SourceType sourceType = jsExtractor.establishSourceType(source, false);
      return jsExtractor.extract(textualExtractor, source, 0, scopeManager, sourceType, res).snd();
    } catch (ParseError e) {
      e.setPosition(locationManager.translatePosition(e.getPosition()));
      throw e.asUserError();
    }
  }
}
