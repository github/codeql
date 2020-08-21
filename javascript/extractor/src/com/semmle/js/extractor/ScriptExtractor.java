package com.semmle.js.extractor;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Map;
import java.util.HashMap;

import com.google.gson.Gson;

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

  /** True if files with the given extension and type (from package.json) should always be treated as ES2015 modules. */
  private boolean isAlwaysModule(String extension, String packageType) {
    if (extension.equals(".mjs") || extension.equals(".es6") || extension.equals(".es")) {
      return true;
    }
    return "module".equals(packageType) && extension.equals(".js");
  }

  /** True if files with the given extension and type (from package.json) should always be treated as CommonJS modules. */
  private boolean isAlwaysCommonJSModule(String extension, String packageType) {
    return extension.equals(".cjs") || (extension.equals(".js") && "commonjs".equals(packageType));
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

    String packageType = getPackageType(locationManager.getSourceFile().getParentFile());
    String extension = locationManager.getSourceFileExtension();

    // Some files are interpreted as modules by default.
    if (config.getSourceType() == SourceType.AUTO) {
      if (isAlwaysModule(extension, packageType)) {
        config = config.withSourceType(SourceType.MODULE);
      }
      if (isAlwaysCommonJSModule(extension, packageType)) {
        config = config.withSourceType(SourceType.COMMONJS_MODULE).withPlatform(Platform.NODE);
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

  /**
   * A minimal model of `package.json` files that can be used to read the "type" field.
   */
  private static class PackageJSON {
    String type;
  }

  // cache for `getPackageType`.
  private static final Map<File, String> cache = new HashMap<>();

  /**
   * Returns the "type" field from the nearest `package.json` file (searching up the file hierarchy).
   */
  private String getPackageType(File folder) {
    if (folder == null || !folder.isDirectory()) {
      return null;
    }
    if (cache.containsKey(folder)) {
      return cache.get(folder);
    }
    File file = new File(folder, "package.json");
    if (file.isDirectory()) {
      return null;
    }
    if (!file.exists()) {
      String result = getPackageType(folder.getParentFile());
      cache.put(folder, result);
      return result;
    }
    try {
      BufferedReader reader = new BufferedReader(new FileReader(file));
      String result = new Gson().fromJson(reader, PackageJSON.class).type;
      cache.put(folder, result);
      return result;
    } catch (IOException e) {
      return null;
    }
  }
}
