package com.semmle.js.extractor;

import com.semmle.util.data.StringUtil;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.UserError;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import com.semmle.util.trap.TrapWriter.Table;
import org.yaml.snakeyaml.composer.Composer;
import org.yaml.snakeyaml.error.Mark;
import org.yaml.snakeyaml.error.MarkedYAMLException;
import org.yaml.snakeyaml.events.AliasEvent;
import org.yaml.snakeyaml.events.Event;
import org.yaml.snakeyaml.events.MappingStartEvent;
import org.yaml.snakeyaml.events.NodeEvent;
import org.yaml.snakeyaml.events.ScalarEvent;
import org.yaml.snakeyaml.events.SequenceStartEvent;
import org.yaml.snakeyaml.nodes.NodeId;
import org.yaml.snakeyaml.parser.Parser;
import org.yaml.snakeyaml.parser.ParserImpl;
import org.yaml.snakeyaml.reader.ReaderException;
import org.yaml.snakeyaml.reader.StreamReader;
import org.yaml.snakeyaml.resolver.Resolver;

/**
 * Extractor for populating YAML files.
 *
 * <p>The extractor uses <a href="http://www.snakeyaml.org/">SnakeYAML</a> to parse YAML.
 */
public class YAMLExtractor implements IExtractor {
  /** The tables constituting the YAML dbscheme. */
  private static enum YAMLTables implements Table {
    YAML(6), // yaml         (id: @yaml_node, kind: int ref, parent: @yaml_node_parent ref,
    //               idx: int ref, tag: string ref, tostring: string ref)
    YAML_ANCHORS(2), // yaml_anchors (node: @yaml_node ref, anchor: string ref)
    YAML_ALIASES(2), // yaml_aliases (alias: @yaml_alias_node ref, target: string ref)
    YAML_SCALARS(
        3), // yaml_scalars (scalar: @yaml_scalar_node ref, style: int ref, value: string ref)
    YAML_ERRORS(2); // yaml_errors  (id: @yaml_error, message: string ref)

    private final int arity;

    private YAMLTables(int arity) {
      this.arity = arity;
    }

    @Override
    public String getName() {
      return StringUtil.lc(name());
    }

    @Override
    public int getArity() {
      return arity;
    }

    @Override
    public boolean validate(Object... values) {
      return true;
    }
  }

  /*
   * case @yaml_node.kind of
   *   0 = @yaml_scalar_node
   * | 1 = @yaml_mapping_node
   * | 2 = @yaml_sequence_node
   * | 3 = @yaml_alias_node
   */
  private static enum NodeKind {
    SCALAR,
    MAPPING,
    SEQUENCE,
    ALIAS
  };

  private final boolean tolerateParseErrors;

  private LocationManager locationManager;
  private TrapWriter trapWriter;

  /**
   * The underlying SnakeYAML parser; we use the relatively low-level {@linkplain Parser} instead of
   * the more high-level {@linkplain Composer}, since our dbscheme represents YAML documents in AST
   * form, with aliases left unresolved.
   */
  private Parser parser;

  /** The resolver used for resolving type tags. */
  private Resolver resolver;

  public YAMLExtractor(ExtractorConfig config) {
    this.tolerateParseErrors = config.isTolerateParseErrors();
  }

  @Override
  public LoCInfo extract(TextualExtractor textualExtractor) {
    locationManager = textualExtractor.getLocationManager();
    trapWriter = textualExtractor.getTrapwriter();

    Label fileLabel = locationManager.getFileLabel();
    locationManager.setHasLocationTable("yaml_locations");
    try {
      parser = new ParserImpl(new StreamReader(textualExtractor.getSource()));
      resolver = new Resolver();
      int idx = 0;
      while (!atStreamEnd())
        extractDocument(fileLabel, idx++, textualExtractor.getSource().codePoints().toArray());
    } catch (MarkedYAMLException e) {
      int line = e.getProblemMark().getLine() + 1;
      int column = e.getProblemMark().getColumn() + 1;
      if (!this.tolerateParseErrors)
        throw new UserError(e.getProblem() + ": " + line + ":" + column);
      Label lbl = trapWriter.freshLabel();
      trapWriter.addTuple(YAMLTables.YAML_ERRORS, lbl, e.getProblem());
      locationManager.emitSnippetLocation(lbl, line, column, line, column);
    } catch (ReaderException e) {
      if (!this.tolerateParseErrors) throw new UserError(e.toString());
      int c = e.getCodePoint();
      String s = String.valueOf(Character.toChars(c));
      trapWriter.addTuple(
          YAMLTables.YAML_ERRORS,
          trapWriter.freshLabel(),
          "Unexpected character " + s + "(" + c + ")");
      // unfortunately, SnakeYAML does not provide structured location information for
      // ReaderExceptions
    }

    return new LoCInfo(0, 0);
  }

  /** Check whether the parser has encountered the end of the YAML input stream. */
  private boolean atStreamEnd() {
    if (parser.checkEvent(Event.ID.StreamStart)) parser.getEvent();
    return parser.checkEvent(Event.ID.StreamEnd);
  }

  /** Extract a complete YAML document; cf. {@link Composer#getNode}. */
  private void extractDocument(Label parent, int idx, int[] codepoints) {
    // Drop the DOCUMENT-START event
    parser.getEvent();
    extractNode(parent, idx, codepoints);
    // Drop the DOCUMENT-END event
    parser.getEvent();
  }

  /** Extract a single YAML node; cf. {@link Composer#composeNode}. */
  private void extractNode(Label parent, int idx, int[] codepoints) {
    Label label = trapWriter.freshLabel();
    NodeKind kind;
    String tag = "";
    Event start = parser.getEvent(), end = start;

    if (start.is(Event.ID.Alias)) {
      kind = NodeKind.ALIAS;
      trapWriter.addTuple(YAMLTables.YAML_ALIASES, label, ((AliasEvent) start).getAnchor());
    } else {
      String anchor = start instanceof NodeEvent ? ((NodeEvent) start).getAnchor() : null;
      if (anchor != null) trapWriter.addTuple(YAMLTables.YAML_ANCHORS, label, anchor);

      if (start.is(Event.ID.Scalar)) {
        kind = NodeKind.SCALAR;
        ScalarEvent scalar = (ScalarEvent) start;
        tag =
            getTag(
                scalar.getTag(),
                NodeId.scalar,
                scalar.getValue(),
                scalar.getImplicit().canOmitTagInPlainScalar());
        Character style = scalar.getStyle();
        int styleCode = style == null ? 0 : (int) style;
        trapWriter.addTuple(YAMLTables.YAML_SCALARS, label, styleCode, scalar.getValue());
      } else if (start.is(Event.ID.SequenceStart)) {
        kind = NodeKind.SEQUENCE;
        SequenceStartEvent sequenceStart = (SequenceStartEvent) start;
        tag = getTag(sequenceStart.getTag(), NodeId.sequence, null, sequenceStart.getImplicit());

        int childIdx = 0;
        while (!parser.checkEvent(Event.ID.SequenceEnd)) extractNode(label, childIdx++, codepoints);

        end = parser.getEvent();
      } else if (start.is(Event.ID.MappingStart)) {
        kind = NodeKind.MAPPING;
        MappingStartEvent mappingStart = (MappingStartEvent) start;
        tag = getTag(mappingStart.getTag(), NodeId.mapping, null, mappingStart.getImplicit());

        int childIdx = 1;
        while (!parser.checkEvent(Event.ID.MappingEnd)) {
          extractNode(label, childIdx, codepoints);
          extractNode(label, -childIdx, codepoints);
          ++childIdx;
        }

        end = parser.getEvent();
      } else {
        throw new CatastrophicError("Unexpected YAML parser event: " + start);
      }
    }

    trapWriter.addTuple(
        YAMLTables.YAML,
        label,
        kind.ordinal(),
        parent,
        idx,
        tag,
        mkToString(start.getStartMark(), end.getEndMark(), codepoints));
    extractLocation(label, start.getStartMark(), end.getEndMark());
  }

  /** Determine the type tag of a node. */
  private String getTag(String explicitTag, NodeId kind, String value, boolean implicit) {
    if (explicitTag == null || "!".equals(explicitTag))
      return resolver.resolve(kind, value, implicit).getValue();
    return explicitTag;
  }

  private static boolean isNewLine(int codePoint) {
    switch (codePoint) {
      case '\n':
      case '\r':
      case '\u0085':
      case '\u2028':
      case '\u2029':
        return true;
      default:
        return false;
    }
  }

  /**
   * SnakeYAML doesn't directly expose the source text of nodes, but we also take the file contents
   * as an array of Unicode code points. The start and end marks each contain an index into the code
   * point stream (the end is exclusive), so we can reconstruct the snippet. For readability, we
   * stop at the first encountered newline.
   */
  private static String mkToString(Mark startMark, Mark endMark, int[] codepoints) {
    StringBuilder b = new StringBuilder();
    for (int i = startMark.getIndex(); i < endMark.getIndex() && !isNewLine(codepoints[i]); i++)
      b.appendCodePoint(codepoints[i]);
    return TextualExtractor.sanitiseToString(b.toString());
  }

  /** Emit a source location for a YAML node. */
  private void extractLocation(Label label, Mark startMark, Mark endMark) {
    int startLine, startColumn, endLine, endColumn;

    // SnakeYAML uses 0-based indexing for both lines and columns, so need to +1
    startLine = startMark.getLine() + 1;
    startColumn = startMark.getColumn() + 1;

    // SnakeYAML's end positions are exclusive, so only need to +1 for the line
    endLine = endMark.getLine() + 1;
    endColumn = endMark.getColumn();

    locationManager.emitSnippetLocation(label, startLine, startColumn, endLine, endColumn);
  }
}
