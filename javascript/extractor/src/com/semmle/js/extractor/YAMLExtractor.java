package com.semmle.js.extractor;

import java.util.Collections;

import com.semmle.extractor.yaml.YamlPopulator;

/**
 * Extractor for populating YAML files.
 *
 * <p>
 * The extractor uses <a href="http://www.snakeyaml.org/">SnakeYAML</a> to parse
 * YAML.
 */
public class YAMLExtractor implements IExtractor {
  private final boolean tolerateParseErrors;

  public YAMLExtractor(ExtractorConfig config) {
    this.tolerateParseErrors = config.isTolerateParseErrors();
  }

  @Override
  public ParseResultInfo extract(TextualExtractor textualExtractor) {
    new YamlPopulator(textualExtractor.getExtractedFile(), textualExtractor.getSource(),
        textualExtractor.getTrapwriter(),
        this.tolerateParseErrors).extract();
    return new ParseResultInfo(0, 0, Collections.emptyList());
  }
}
