package com.semmle.js.extractor;

import com.semmle.js.ast.json.JSONArray;
import com.semmle.js.ast.json.JSONLiteral;
import com.semmle.js.ast.json.JSONObject;
import com.semmle.js.ast.json.JSONValue;
import com.semmle.js.ast.json.Visitor;
import com.semmle.js.parser.JSONParser;
import com.semmle.js.parser.ParseError;
import com.semmle.util.data.Pair;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import com.semmle.js.extractor.ParseResultInfo;
import java.util.Collections;
import java.util.List;

/** Extractor for populating JSON files. */
public class JSONExtractor implements IExtractor {
  private static class Context {
    private final Label parent;
    private final int childIndex;

    public Context(Label parent, int childIndex) {
      this.parent = parent;
      this.childIndex = childIndex;
    }
  }

  private final boolean tolerateParseErrors;

  public JSONExtractor(ExtractorConfig config) {
    this.tolerateParseErrors = config.isTolerateParseErrors();
  }

  @Override
  public ParseResultInfo extract(final TextualExtractor textualExtractor) {
    final TrapWriter trapwriter = textualExtractor.getTrapwriter();
    final LocationManager locationManager = textualExtractor.getLocationManager();
    try {
      String source = textualExtractor.getSource();
      Pair<JSONValue, List<ParseError>> res = JSONParser.parseValue(source);
      JSONValue v = res.fst();
      List<ParseError> recoverableErrors = res.snd();
      if (!recoverableErrors.isEmpty() && !tolerateParseErrors)
        throw recoverableErrors.get(0).asUserError();

      Label fileLabel = locationManager.getFileLabel();
      locationManager.setHasLocationTable("json_locations");
      v.accept(
          new Visitor<Context, Label>() {
            private Label emit(JSONValue nd, int kind, Context c) {
              Label label = trapwriter.localID(nd);
              trapwriter.addTuple(
                  "json", label, kind, c.parent, c.childIndex, textualExtractor.mkToString(nd));
              locationManager.emitNodeLocation(nd, label);
              return label;
            }

            @Override
            public Label visit(JSONLiteral nd, Context c) {
              int kind = 0;
              if (nd.getValue() instanceof Boolean) kind = 1;
              else if (nd.getValue() instanceof Number) kind = 2;
              else if (nd.getValue() instanceof String) kind = 3;
              Label label = emit(nd, kind, c);
              trapwriter.addTuple("json_literals", nd.getStringValue(), nd.getRaw(), label);
              return label;
            }

            @Override
            public Label visit(JSONArray nd, Context c) {
              Label label = emit(nd, 4, c);
              int i = 0;
              for (JSONValue element : nd.getElements())
                element.accept(this, new Context(label, i++));
              return label;
            }

            @Override
            public Label visit(JSONObject nd, Context c) {
              Label label = emit(nd, 5, c);
              int i = 0;
              for (Pair<String, JSONValue> prop : nd.getProperties()) {
                String name = prop.fst();
                Label vallabel = prop.snd().accept(this, new Context(label, i++));
                trapwriter.addTuple("json_properties", label, name, vallabel);
              }
              return label;
            }
          },
          new Context(fileLabel, 0));

      for (ParseError e : recoverableErrors)
        populateError(textualExtractor, trapwriter, locationManager, e);

      return new ParseResultInfo(0, 0, recoverableErrors);
    } catch (ParseError e) {
      if (!this.tolerateParseErrors) throw e.asUserError();

      populateError(textualExtractor, trapwriter, locationManager, e);
      return new ParseResultInfo(0, 0, Collections.emptyList());
    }
  }

  private void populateError(
      final TextualExtractor textualExtractor,
      final TrapWriter trapwriter,
      final LocationManager locationManager,
      ParseError e) {
    Label label = trapwriter.freshLabel();
    trapwriter.addTuple("json_errors", label, "Error: " + e);
    locationManager.emitErrorLocation(label, e.getPosition(), textualExtractor.getNumLines());
  }
}
