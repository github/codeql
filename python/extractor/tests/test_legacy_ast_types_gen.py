import yaml

from semmle.python import legacy_ast_types_gen


def test_generated_legacy_ast_schema_is_up_to_date():
    generated = legacy_ast_types_gen.render_schema()
    assert legacy_ast_types_gen.OUTPUT_PATH.read_text(encoding="utf-8") == generated
    assert ": null" not in generated


def test_generated_legacy_ast_schema_structure():
    schema = yaml.safe_load(legacy_ast_types_gen.render_schema())

    assert "BinOp" in schema["supertypes"]["expr"]["subtypes"]
    assert schema["supertypes"]["expr"]["fields"] == {
        "parenthesised?": "boolean_literal"
    }
    assert schema["supertypes"]["parameter"] == ["Name", "Tuple"]
    assert "MatchClassPattern" in schema["supertypes"]["pattern"]["subtypes"]
    assert schema["supertypes"]["pattern"]["fields"] == {
        "parenthesised?": "boolean_literal"
    }
    assert "string_literal" in schema["supertypes"]["literal"]

    assert schema["named"]["BinOp"] == {
        "left?": "expr",
        "op?": "operator",
        "right?": "expr",
        "parenthesised?": "boolean_literal",
    }
    assert list(schema["named"]["Assign"]) == ["targets*", "value?"]
    assert list(schema["named"]["DictComp"]) == [
        "key?",
        "value?",
        "generators*",
        "function?",
        "iterable?",
        "parenthesised?",
    ]
    assert schema["named"]["Global"]["names*"] == "string_literal"
    assert schema["named"]["arguments"]["annotations*"] == [
        "expr",
        "none_literal",
    ]
    assert schema["named"]["StringPart"] == {
        "text?": "string_literal",
        "prefix?": "string_literal",
        "s?": "python_string_literal",
    }
    assert schema["named"]["Module"] == {"body*": "stmt"}
    assert schema["named"]["Add"] == {}
    assert schema["named"]["Load"] == {}
    assert schema["named"]["Pass"] == {}
    assert "class?" not in schema["named"]["MatchClassPattern"]
    assert schema["named"]["MatchClassPattern"]["class_name?"] == "expr"
    assert "location" not in schema["named"]["Name"]
    assert schema["named"]["none_literal"] is None
