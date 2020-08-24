package com.semmle.js.extractor;

import com.semmle.js.extractor.ExtractorConfig.Platform;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.parser.ParseError;
import com.semmle.util.data.Pair;
import com.semmle.util.trap.TrapWriter.Label;

/** Extract a stand-alone JavaScript script. */
public class ScriptExtractor implements IExtractor {
  private ExtractorConfig config;

  public ScriptExtractor(ExtractorConfig config) {
    this.config = config;
  }

  /** True if files with the given extension should always be treated as modules. */
  private boolean isAlwaysModule(String extension) {
    return extension.equals(".mjs") || extension.equals(".es6") || extension.equals(".es");
  }

  /** True if files with the given extension should always be treated as CommonJS modules. */
  private boolean isAlwaysCommonJSModule(String extension) {
    return extension.equals(".cjs");
  }

  @Override
  public LoCInfo extract(TextualExtractor textualExtractor) {
    LocationManager locationManager = textualExtractor.getLocationManager();
    String source = textualExtractor.getSource();
    String shebangLine = null, shebangLineTerm = null;

    if (source.startsWith("#!")) {
      // at this point, it's safe to assume we're extracting Node.js code
      // (unless we were specifically told otherwise)
      if (config.getPlatform() != Platform.WEB) config = config.withPlatform(Platform.NODE);

      // skip shebang (but populate it as part of the lines relation below)
      int eolPos = source.indexOf('\n');
      if (eolPos > 0) {
        shebangLine = source.substring(0, eolPos);
        shebangLineTerm = "\n";
        source = source.substring(eolPos + 1);
      } else {
        shebangLine = source;
        shebangLineTerm = "";
        source = "";
      }
      locationManager.setStart(2, 1);
    }

    // Some file extensions are interpreted as modules by default.
    if (config.getSourceType() == SourceType.AUTO) {
      if (isAlwaysModule(locationManager.getSourceFileExtension())) {
        config = config.withSourceType(SourceType.MODULE);
      }
      if (isAlwaysCommonJSModule(locationManager.getSourceFileExtension())) {
        config = config.withSourceType(SourceType.COMMONJS_MODULE);
      }
    }

    ScopeManager scopeManager =
        new ScopeManager(textualExtractor.getTrapwriter(), config.getEcmaVersion());
    Label toplevelLabel = null;
    LoCInfo loc;
    try {
      Pair<Label, LoCInfo> res =
          new JSExtractor(config).extract(textualExtractor, source, 0, scopeManager);
      toplevelLabel = res.fst();
      loc = res.snd();
    } catch (ParseError e) {
      e.setPosition(locationManager.translatePosition(e.getPosition()));
      throw e.asUserError();
    }

    if (shebangLine != null)
      textualExtractor.extractLine(shebangLine, shebangLineTerm, 0, toplevelLabel);

    return loc;
  }
}
