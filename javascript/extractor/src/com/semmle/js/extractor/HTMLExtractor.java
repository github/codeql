package com.semmle.js.extractor;

import java.io.File;
import java.nio.file.Path;
import java.util.regex.Pattern;

import com.semmle.js.extractor.ExtractorConfig.Platform;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.parser.ParseError;
import com.semmle.util.data.StringUtil;
import com.semmle.util.io.WholeIO;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;

import net.htmlparser.jericho.Attribute;
import net.htmlparser.jericho.Attributes;
import net.htmlparser.jericho.CharacterReference;
import net.htmlparser.jericho.Element;
import net.htmlparser.jericho.HTMLElementName;
import net.htmlparser.jericho.RowColumnVector;
import net.htmlparser.jericho.Segment;
import net.htmlparser.jericho.Source;
import net.htmlparser.jericho.StartTagType;

/** Extractor for handling HTML and XHTML files. */
public class HTMLExtractor implements IExtractor {
  /** List of HTML attributes whose value is interpreted as JavaScript. */
  private static final Pattern JS_ATTRIBUTE =
      Pattern.compile(
          "^on(abort|blur|change|(dbl)?click|error|focus|key(down|press|up)|load|mouse(down|move|out|over|up)|re(set|size)|select|submit|unload)$",
          Pattern.CASE_INSENSITIVE);

  private final ExtractorConfig config;
  private final ExtractorState state;

  public HTMLExtractor(ExtractorConfig config, ExtractorState state) {
    this.config = config.withPlatform(Platform.WEB);
    this.state = state;
  }

  @Override
  public LoCInfo extract(TextualExtractor textualExtractor) {
    LoCInfo result = new LoCInfo(0, 0);

    Source src = new Source(textualExtractor.getSource());
    src.setLogger(null);
    ScopeManager scopeManager =
        new ScopeManager(textualExtractor.getTrapwriter(), config.getEcmaVersion());

    LocationManager locationManager = textualExtractor.getLocationManager();

    /*
     * Extract all JavaScript snippets appearing in (in-line) script elements and
     * as attribute values.
     */
    for (Element elt : src.getAllElements()) {
      LoCInfo snippetLoC = null;
      if (elt.getName().equals(HTMLElementName.SCRIPT)) {
        SourceType sourceType = getScriptSourceType(elt, textualExtractor.getExtractedFile());
        if (sourceType != null) {
          // Jericho sometimes misparses empty elements, which will show up as start tags
          // ending in "/"; we manually exclude these cases to avoid spurious syntax errors
          if (elt.getStartTag().getTagContent().toString().trim().endsWith("/")) continue;

          Segment content = elt.getContent();
          String source = content.toString();
          boolean isTypeScript = isTypeScriptTag(elt);

          /*
           * Script blocks in XHTML files may wrap (parts of) their code inside CDATA sections.
           * We need to unwrap them in order not to confuse the JavaScript parser.
           *
           * Note that CDATA sections do not nest, so they can be detected by a regular expression.
           *
           * In order to preserve position information, we replace the CDATA section markers with
           * an equivalent number of whitespace characters. This will yield surprising results
           * for CDATA sections inside string literals, but those are likely to be rare.
           */
          source = source.replace("<![CDATA[", "         ").replace("]]>", "   ");
          if (!source.trim().isEmpty()) {
            RowColumnVector contentStart = content.getRowColumnVector();
            snippetLoC =
                extractSnippet(
                    1,
                    config.withSourceType(sourceType),
                    scopeManager,
                    textualExtractor,
                    source,
                    contentStart.getRow(),
                    contentStart.getColumn(),
                    isTypeScript);
          }
        }
      } else {
        Attributes attributes = elt.getAttributes();
        // attributes can be null for directives
        if (attributes != null)
          for (Attribute attr : attributes) {
            // ignore empty attributes
            if (attr.getValue() == null || attr.getValue().isEmpty()) continue;

            String source = attr.getValue();
            RowColumnVector valueStart = attr.getValueSegment().getRowColumnVector();
            if (JS_ATTRIBUTE.matcher(attr.getName()).matches()) {
              snippetLoC =
                  extractSnippet(
                      2,
                      config,
                      scopeManager,
                      textualExtractor,
                      source,
                      valueStart.getRow(),
                      valueStart.getColumn(),
                      false /* isTypeScript */);
            } else if (source.startsWith("javascript:")) {
              source = source.substring(11);
              snippetLoC =
                  extractSnippet(
                      3,
                      config,
                      scopeManager,
                      textualExtractor,
                      source,
                      valueStart.getRow(),
                      valueStart.getColumn() + 11,
                      false /* isTypeScript */);
            }
          }
      }

      if (snippetLoC != null) result.add(snippetLoC);
    }

    // extract HTML elements if necessary.
    if (config.getHtmlHandling().extractElements()) {
      extractChildElements(src, locationManager);

      for (Element elt : src.getAllElements()) {
        if (isPlainElement(elt)) {
          extractChildElements(elt, locationManager);
          extractAttributes(elt, locationManager);
        }
      }
    }

    return result;
  }

  /**
   * Deduce the {@link SourceType} with which the given <code>script</code> element should be
   * extracted, returning <code>null</code> if it cannot be determined.
   */
  private SourceType getScriptSourceType(Element script, File file) {
    String scriptType = getAttributeValueLC(script, "type");
    String scriptLanguage = getScriptLanguage(script);
    
    SourceType fallbackSourceType = config.getSourceType();
    if (file.getName().endsWith(".vue")) {
      fallbackSourceType = SourceType.MODULE;
    }

    if (isTypeScriptTag(script)) return fallbackSourceType;

    // if `type` and `language` are both either missing, contain the
    // string "javascript", or if `type` is the string "text/jsx", this is a plain script
    if ((scriptType == null || scriptType.contains("javascript") || "text/jsx".equals(scriptType))
        && (scriptLanguage == null || scriptLanguage.contains("javascript")))
      // use default source type
      return fallbackSourceType;

    // if `type` is "text/babel", the source type depends on the `data-plugins` attribute
    if ("text/babel".equals(scriptType)) {
      String plugins = getAttributeValueLC(script, "data-plugins");
      if (plugins != null && plugins.contains("transform-es2015-modules-umd")) {
        return SourceType.MODULE;
      }
      return fallbackSourceType;
    }

    // if `type` is "module", extract as module
    if ("module".equals(scriptType)) return SourceType.MODULE;

    return null;
  }

  private String getScriptLanguage(Element script) {
    String scriptLanguage = getAttributeValueLC(script, "language");

    if (scriptLanguage == null) { // Vue templates use 'lang' instead of 'language'.
      scriptLanguage = getAttributeValueLC(script, "lang");
    }
    return scriptLanguage;
  }

  private boolean isTypeScriptTag(Element script) {
    String language = getScriptLanguage(script);
    if ("ts".equals(language) || "typescript".equals(language)) return true;
    String type = getAttributeValueLC(script, "type");
    if (type != null && type.contains("typescript")) return true;
    return false;
  }

  /**
   * Get the value of attribute <code>attr</code> of element <code>elt</code> in lower case; if the
   * attribute has no value, <code>null</code> is returned.
   */
  private String getAttributeValueLC(Element elt, String attr) {
    String val = elt.getAttributeValue(attr);
    return val == null ? val : StringUtil.lc(val);
  }

  private LoCInfo extractSnippet(
      int toplevelKind,
      ExtractorConfig config,
      ScopeManager scopeManager,
      TextualExtractor textualExtractor,
      String source,
      int line,
      int column,
      boolean isTypeScript) {
    if (isTypeScript) {
      Path file = textualExtractor.getExtractedFile().toPath();
      FileSnippet snippet = new FileSnippet(file, line, column, toplevelKind, config.getSourceType());
      VirtualSourceRoot vroot = config.getVirtualSourceRoot();
      // Vue files are special in that they can be imported as modules, and may only contain one <script> tag.
      // For .vue files we omit the usual snippet decoration to ensure the TypeScript compiler can find it.
      Path virtualFile =
          file.getFileName().toString().endsWith(".vue")
          ? vroot.toVirtualFile(file.resolveSibling(file.getFileName() + ".ts"))
          : vroot.getVirtualFileForSnippet(snippet, ".ts");
      if (virtualFile != null) {
        virtualFile = virtualFile.toAbsolutePath().normalize();
        synchronized(vroot.getLock()) {
          new WholeIO().strictwrite(virtualFile, source);
        }
        state.getSnippets().put(virtualFile, snippet);
      }
      return null; // LoC info is accounted for later
    }
    TrapWriter trapwriter = textualExtractor.getTrapwriter();
    LocationManager locationManager = textualExtractor.getLocationManager();
    LocationManager scriptLocationManager =
        new LocationManager(
            locationManager.getSourceFile(), trapwriter, locationManager.getFileLabel());
    scriptLocationManager.setStart(line, column);
    JSExtractor extractor = new JSExtractor(config);
    try {
      TextualExtractor tx =
          new TextualExtractor(
              trapwriter,
              scriptLocationManager,
              source,
              config.getExtractLines(),
              textualExtractor.getMetrics(),
              textualExtractor.getExtractedFile());
      return extractor.extract(tx, source, toplevelKind, scopeManager).snd();
    } catch (ParseError e) {
      e.setPosition(scriptLocationManager.translatePosition(e.getPosition()));
      throw e.asUserError();
    }
  }

  /**
   * Is {@code elt} a plain HTML element (as opposed to a doctype declaration, comment, processing
   * instruction, etc.)?
   */
  private boolean isPlainElement(Element elt) {
    return elt.getStartTag().getTagType() == StartTagType.NORMAL;
  }

  /** Is {@code elt} a CDATA element ? */
  private boolean isCDataElement(Element elt) {
    return elt.getStartTag().getTagType() == StartTagType.CDATA_SECTION;
  }

  /** Is {@code elt} an HTML comment? */
  private boolean isComment(Element elt) {
    return elt.getStartTag().getTagType() == StartTagType.COMMENT;
  }

  /**
   * Populate the {@code xmlElements} relation recording information about all child elements of
   * {@code parent}, which is either an {@link Element} or a {@link Source} (representing the HTML
   * file itself).
   */
  private void extractChildElements(Segment parent, LocationManager locationManager) {
    TrapWriter trapWriter = locationManager.getTrapWriter();
    Label fileLabel = locationManager.getFileLabel();
    Label parentLabel = parent instanceof Source ? fileLabel : trapWriter.localID(parent);
    int childIndex = 0;
    Source source = parent.getSource();
    int contentStart =
        parent instanceof Element ? ((Element) parent).getStartTag().getEnd() : parent.getBegin();
    int contentEnd;
    if (parent instanceof Element && ((Element) parent).getEndTag() != null)
      contentEnd = ((Element) parent).getEndTag().getBegin();
    else contentEnd = parent.getEnd();
    int prevChildEnd = contentStart;
    for (Element child : parent.getChildElements()) {
      childIndex +=
          emitXmlChars(
              source,
              prevChildEnd,
              child.getBegin(),
              parentLabel,
              childIndex,
              false,
              fileLabel,
              locationManager);

      if (isCDataElement(child)) {
        // treat CDATA sections as text
        childIndex +=
            emitXmlChars(
                source,
                child.getBegin() + "<![CDATA[".length(),
                child.getEnd() - "]]>".length(),
                parentLabel,
                childIndex,
                true,
                fileLabel,
                locationManager);
      }

      if (isPlainElement(child)) {
        String childName = child.getName();
        Label childLabel = trapWriter.localID(child);
        trapWriter.addTuple(
            "xmlElements", childLabel, childName, parentLabel, childIndex++, fileLabel);
        emitLocation(child, childLabel, locationManager);
      }

      if (config.getHtmlHandling().extractComments() && isComment(child)) {
        Label childLabel = trapWriter.localID(child);
        trapWriter.addTuple("xmlComments", childLabel, child.toString(), parentLabel, fileLabel);
        emitLocation(child, childLabel, locationManager);
      }

      prevChildEnd = child.getEnd();
    }
    emitXmlChars(
        source,
        prevChildEnd,
        contentEnd,
        parentLabel,
        childIndex,
        false,
        fileLabel,
        locationManager);
  }

  /**
   * Populate the {@code xmlAttrs} relation recording information about all attributes of {@code
   * elt}.
   */
  private void extractAttributes(Element elt, LocationManager locationManager) {
    TrapWriter trapWriter = locationManager.getTrapWriter();
    Label fileLabel = locationManager.getFileLabel();
    Label eltLabel = trapWriter.localID(elt);
    Attributes attributes = elt.getAttributes();
    // attributes can be null for directives
    if (attributes == null) return;
    int i = 0;
    for (Attribute attr : attributes) {
      String attrName = attr.getName();
      String attrValue = attr.getValue() == null ? "" : attr.getValue();
      Label attrLabel = trapWriter.localID(attr);
      trapWriter.addTuple("xmlAttrs", attrLabel, eltLabel, attrName, attrValue, i++, fileLabel);
      emitLocation(attr, attrLabel, locationManager);
    }
  }

  /**
   * Record the location of {@code s}, which is either an {@link Element} or an {@code Attribute}.
   */
  private void emitLocation(Segment s, Label label, LocationManager locationManager) {
    TrapWriter trapWriter = locationManager.getTrapWriter();
    Source src = s.getSource();
    int so = s.getBegin(), eo = s.getEnd() - 1;
    int sl = src.getRow(so), sc = src.getColumn(so);
    int el = src.getRow(eo), ec = src.getColumn(eo);
    Label loc = locationManager.emitLocationsDefault(sl, sc, el, ec);
    trapWriter.addTuple("xmllocations", label, loc);
  }

  /**
   * If {@code textEnd} is greater than {@code textBegin}, extract all characters in that range as
   * HTML text, populating {@code xmlChars} and make it the {@code i}th child of {@code
   * parentLabel}.
   *
   * @return 1 if text was extractod, 0 otherwise
   */
  private int emitXmlChars(
      Source src,
      int textBegin,
      int textEnd,
      Label parentLabel,
      int id,
      boolean isCData,
      Label fileLabel,
      LocationManager locationManager) {
    if (!config.getHtmlHandling().extractText()) {
      return 0;
    }
    if (textBegin >= textEnd) {
      return 0;
    }
    TrapWriter trapWriter = locationManager.getTrapWriter();
    Segment s = new Segment(src, textBegin, textEnd);

    int so = s.getBegin(), eo = s.getEnd() - 1;
    String rawText = s.toString();
    if (!isCData) {
      // expand entities. Note that `rawText` no longer spans the start/end region.
      rawText = CharacterReference.decode(rawText, false);
    }
    Label label = trapWriter.freshLabel();
    trapWriter.addTuple("xmlChars", label, rawText, parentLabel, id, isCData ? 1 : 0, fileLabel);
    int sl = src.getRow(so), sc = src.getColumn(so);
    int el = src.getRow(eo), ec = src.getColumn(eo);
    Label loc = locationManager.emitLocationsDefault(sl, sc, el, ec);
    trapWriter.addTuple("xmllocations", label, loc);

    return 1;
  }
}
