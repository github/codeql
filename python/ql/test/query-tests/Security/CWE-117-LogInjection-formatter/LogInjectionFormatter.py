#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：Log Injection prevented by a sanitizing `logging.Formatter`

A formatter that strips control characters sanitizes when the record is written,
so the individual logging calls are not vulnerable.
"""
import logging

from flask import Flask
from flask import request

app = Flask(__name__)

ESCAPE_TABLE = {ord("\n"): "\\n", ord("\r"): "\\r", ord("\t"): "\\t"}


def escape_controls(text):
    """Escape the control characters in a log message."""
    return text.translate(ESCAPE_TABLE)


class EscapingFormatter(logging.Formatter):
    """A formatter that escapes control characters in the rendered message."""

    def format(self, record):
        record.msg = escape_controls(record.getMessage())
        record.args = None
        return super().format(record)


logging.basicConfig(level=logging.INFO, handlers=[logging.StreamHandler()])

for handler in logging.getLogger().handlers:
    handler.setFormatter(EscapingFormatter())

logger = logging.getLogger("test")


@app.route("/f-string")
def f_string():
    name = request.args.get("name")
    logger.warning(f"User name: {name}")  # Good
    return "ok"


@app.route("/percent-args")
def percent_args():
    name = request.args.get("name")
    logger.info("User name: %s", name)  # Good
    return "ok"


@app.route("/escaped-at-call-site")
def escaped_at_call_site():
    name = request.args.get("name")
    logger.warning("User name: " + escape_controls(name))  # Good
    return "ok"
