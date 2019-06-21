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
    try {
      parser = new ParserImpl(new StreamReader(textualExtractor.getSource()));
      resolver = new Resolver();

      int idx = 0;
      while (!atStreamEnd()) extractDocument(fileLabel, idx++);
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

  /** Extract a complete YAML document; cf. {@link Composer#composeDocument}. */
  private void extractDocument(Label parent, int idx) {
    // Drop the DOCUMENT-START event
    parser.getEvent();
    extractNode(parent, idx);
    // Drop the DOCUMENT-END event
    parser.getEvent();
  }

  /** Extract a single YAML node; cf. {@link Composer#composeNode}. */
  private void extractNode(Label parent, int idx) {
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
        trapWriter.addTuple(
            YAMLTables.YAML_SCALARS, label, (int) scalar.getStyle(), scalar.getValue());
      } else if (start.is(Event.ID.SequenceStart)) {
        kind = NodeKind.SEQUENCE;
        SequenceStartEvent sequenceStart = (SequenceStartEvent) start;
        tag = getTag(sequenceStart.getTag(), NodeId.sequence, null, sequenceStart.getImplicit());

        int childIdx = 0;
        while (!parser.checkEvent(Event.ID.SequenceEnd)) extractNode(label, childIdx++);

        end = parser.getEvent();
      } else if (start.is(Event.ID.MappingStart)) {
        kind = NodeKind.MAPPING;
        MappingStartEvent mappingStart = (MappingStartEvent) start;
        tag = getTag(mappingStart.getTag(), NodeId.mapping, null, mappingStart.getImplicit());

        int childIdx = 1;
        while (!parser.checkEvent(Event.ID.MappingEnd)) {
          extractNode(label, childIdx);
          extractNode(label, -childIdx);
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
        mkToString(start.getStartMark(), end.getEndMark()));
    extractLocation(label, start.getStartMark(), end.getEndMark());
  }

  /** Determine the type tag of a node. */
  private String getTag(String explicitTag, NodeId kind, String value, boolean implicit) {
    if (explicitTag == null || "!".equals(explicitTag))
      return resolver.resolve(kind, value, implicit).getValue();
    return explicitTag;
  }

  /**
   * SnakeYAML doesn't directly expose the source text of nodes, but we can get a decent
   * approximation from the snippet associated with the node's start {@linkplain Mark}.
   *
   * <p>The snippet of a {@linkplain Mark} is meant to be used for diagnostic messages and consists
   * of two lines: the first line contains some context around the source position represented by
   * the mark, the second line contains a caret character positioned underneath the source position
   * itself.
   *
   * <p>To approximate the source text, we take the text on the first line and strip off the first
   * <i>n</i> characters, where <i>n</i> is the number of spaces preceding the caret character on
   * the second line.
   *
   * <p>This is only an approximation, since the context is limited to relatively short strings that
   * never extend across newlines, but it suffices for the purposes of <code>toString</code>.
   */
  private String mkToString(Mark startMark, Mark endMark) {
    String snippet = startMark.get_snippet(0, Integer.MAX_VALUE);
    int nl = snippet.indexOf('\n');
    String context = snippet.substring(0, nl);
    String src = context.substring(snippet.substring(nl + 1).indexOf('^'));
    int desiredStringLength = endMark.getColumn() - startMark.getColumn();
    boolean hasAccessToDesiredString = src.length() >= desiredStringLength;
    boolean isSingleLine = endMark.getLine() == startMark.getLine();
    if (isSingleLine && hasAccessToDesiredString)
    	src = src.substring(0, desiredStringLength);
    return TextualExtractor.sanitiseToString(src);
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
