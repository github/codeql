package com.semmle.js.extractor;

import java.io.File;
import java.nio.file.Path;
import java.util.regex.Pattern;

import com.semmle.extractor.html.HtmlPopulator;
import com.semmle.js.extractor.ExtractorConfig.Platform;
import com.semmle.js.extractor.ExtractorConfig.SourceType;
import com.semmle.js.parser.ParseError;
import com.semmle.util.data.Option;
import com.semmle.util.data.StringUtil;
import com.semmle.util.io.WholeIO;
import com.semmle.util.trap.TrapWriter;

import net.htmlparser.jericho.Attribute;
import net.htmlparser.jericho.Attributes;
import net.htmlparser.jericho.Element;
import net.htmlparser.jericho.HTMLElementName;
import net.htmlparser.jericho.RowColumnVector;
import net.htmlparser.jericho.Segment;

/** Extractor for handling HTML and XHTML files. */
public class HTMLExtractor implements IExtractor {
	private class JavaScriptHTMLElementHandler implements HtmlPopulator.ElementHandler {
		private final ScopeManager scopeManager;
		private final TextualExtractor textualExtractor;
		private LoCInfo locInfo;

		public JavaScriptHTMLElementHandler(TextualExtractor textualExtractor) {
			this.textualExtractor = textualExtractor;

			this.locInfo = new LoCInfo(0, 0);

			this.scopeManager = new ScopeManager(textualExtractor.getTrapwriter(), config.getEcmaVersion());
		}

		/*
		 * Extract all JavaScript snippets appearing in (in-line) script elements and as
		 * attribute values.
		 */
		@Override
		public void handleElement(Element elt) {
			LoCInfo snippetLoC = null;
			if (elt.getName().equals(HTMLElementName.SCRIPT)) {
				SourceType sourceType = getScriptSourceType(elt, textualExtractor.getExtractedFile());
				if (sourceType != null) {
					// Jericho sometimes misparses empty elements, which will show up as start tags
					// ending in "/"; we manually exclude these cases to avoid spurious syntax
					// errors
					if (elt.getStartTag().getTagContent().toString().trim().endsWith("/"))
						return;

					Segment content = elt.getContent();
					String source = content.toString();
					boolean isTypeScript = isTypeScriptTag(elt);

					/*
					 * Script blocks in XHTML files may wrap (parts of) their code inside CDATA
					 * sections. We need to unwrap them in order not to confuse the JavaScript
					 * parser.
					 *
					 * Note that CDATA sections do not nest, so they can be detected by a regular
					 * expression.
					 *
					 * In order to preserve position information, we replace the CDATA section
					 * markers with an equivalent number of whitespace characters. This will yield
					 * surprising results for CDATA sections inside string literals, but those are
					 * likely to be rare.
					 */
					source = source.replace("<![CDATA[", "         ").replace("]]>", "   ");
					if (!source.trim().isEmpty()) {
						RowColumnVector contentStart = content.getRowColumnVector();
						snippetLoC = extractSnippet(1, config.withSourceType(sourceType), scopeManager,
								textualExtractor, source, contentStart.getRow(), contentStart.getColumn(),
								isTypeScript);
					}
				}
			} else {
				Attributes attributes = elt.getAttributes();
				// attributes can be null for directives
				if (attributes != null)
					for (Attribute attr : attributes) {
						// ignore empty attributes
						if (attr.getValue() == null || attr.getValue().isEmpty())
							continue;

						String source = attr.getValue();
						RowColumnVector valueStart = attr.getValueSegment().getRowColumnVector();
						if (JS_ATTRIBUTE.matcher(attr.getName()).matches()) {
							snippetLoC = extractSnippet(2, config, scopeManager, textualExtractor, source,
									valueStart.getRow(), valueStart.getColumn(), false /* isTypeScript */);
						} else if (source.startsWith("javascript:")) {
							source = source.substring(11);
							snippetLoC = extractSnippet(3, config, scopeManager, textualExtractor, source,
									valueStart.getRow(), valueStart.getColumn() + 11, false /* isTypeScript */);
						}
					}
			}

			if (snippetLoC != null)
				locInfo.add(snippetLoC);
		}

		public LoCInfo getLoCInfo() {
			return this.locInfo;
		}
	}

	/** List of HTML attributes whose value is interpreted as JavaScript. */
	private static final Pattern JS_ATTRIBUTE = Pattern.compile(
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
		JavaScriptHTMLElementHandler eltHandler = new JavaScriptHTMLElementHandler(textualExtractor);

		HtmlPopulator extractor = new HtmlPopulator(this.config.getHtmlHandling(), textualExtractor.getSource(),
				textualExtractor.getTrapwriter(), textualExtractor.getLocationManager().getFileLabel());

		extractor.doit(Option.some(eltHandler));

		return eltHandler.getLoCInfo();
	}

	/**
	 * Deduce the {@link SourceType} with which the given <code>script</code>
	 * element should be extracted, returning <code>null</code> if it cannot be
	 * determined.
	 */
	private SourceType getScriptSourceType(Element script, File file) {
		String scriptType = getAttributeValueLC(script, "type");
		String scriptLanguage = getScriptLanguage(script);

		SourceType fallbackSourceType = config.getSourceType();
		if (file.getName().endsWith(".vue")) {
			fallbackSourceType = SourceType.MODULE;
		}

		if (isTypeScriptTag(script))
			return fallbackSourceType;

		// if `type` and `language` are both either missing, contain the
		// string "javascript", or if `type` is the string "text/jsx", this is a plain
		// script
		if ((scriptType == null || scriptType.contains("javascript") || "text/jsx".equals(scriptType))
				&& (scriptLanguage == null || scriptLanguage.contains("javascript")))
			// use default source type
			return fallbackSourceType;

		// if `type` is "text/babel", the source type depends on the `data-plugins`
		// attribute
		if ("text/babel".equals(scriptType)) {
			String plugins = getAttributeValueLC(script, "data-plugins");
			if (plugins != null && plugins.contains("transform-es2015-modules-umd")) {
				return SourceType.MODULE;
			}
			return fallbackSourceType;
		}

		// if `type` is "module", extract as module
		if ("module".equals(scriptType))
			return SourceType.MODULE;

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
		if ("ts".equals(language) || "typescript".equals(language))
			return true;
		String type = getAttributeValueLC(script, "type");
		if (type != null && type.contains("typescript"))
			return true;
		return false;
	}

	/**
	 * Get the value of attribute <code>attr</code> of element <code>elt</code> in
	 * lower case; if the attribute has no value, <code>null</code> is returned.
	 */
	private String getAttributeValueLC(Element elt, String attr) {
		String val = elt.getAttributeValue(attr);
		return val == null ? val : StringUtil.lc(val);
	}

	private LoCInfo extractSnippet(int toplevelKind, ExtractorConfig config, ScopeManager scopeManager,
			TextualExtractor textualExtractor, String source, int line, int column, boolean isTypeScript) {
		if (isTypeScript) {
			Path file = textualExtractor.getExtractedFile().toPath();
			FileSnippet snippet = new FileSnippet(file, line, column, toplevelKind, config.getSourceType());
			VirtualSourceRoot vroot = config.getVirtualSourceRoot();
			// Vue files are special in that they can be imported as modules, and may only
			// contain one <script> tag.
			// For .vue files we omit the usual snippet decoration to ensure the TypeScript
			// compiler can find it.
			Path virtualFile = file.getFileName().toString().endsWith(".vue")
					? vroot.toVirtualFile(file.resolveSibling(file.getFileName() + ".ts"))
					: vroot.getVirtualFileForSnippet(snippet, ".ts");
			if (virtualFile != null) {
				virtualFile = virtualFile.toAbsolutePath().normalize();
				synchronized (vroot.getLock()) {
					new WholeIO().strictwrite(virtualFile, source);
				}
				state.getSnippets().put(virtualFile, snippet);
			}
			return null; // LoC info is accounted for later
		}
		TrapWriter trapwriter = textualExtractor.getTrapwriter();
		LocationManager locationManager = textualExtractor.getLocationManager();
		LocationManager scriptLocationManager = new LocationManager(locationManager.getSourceFile(), trapwriter,
				locationManager.getFileLabel());
		scriptLocationManager.setStart(line, column);
		JSExtractor extractor = new JSExtractor(config);
		try {
			TextualExtractor tx = new TextualExtractor(trapwriter, scriptLocationManager, source,
					config.getExtractLines(), textualExtractor.getMetrics(), textualExtractor.getExtractedFile());
			return extractor.extract(tx, source, toplevelKind, scopeManager).snd();
		} catch (ParseError e) {
			e.setPosition(scriptLocationManager.translatePosition(e.getPosition()));
			throw e.asUserError();
		}
	}
}
