'''
Support for multi-process safe logging with colorized output.
'''

import os
import sys
import traceback
import multiprocessing
import enum
import datetime


#Use standard Semmle logging levels

OFF = 0
ERROR = 1
WARN = 2
INFO = 3
DEBUG = 4
TRACE = 5
TRACEBACK = 6

COLOR = 8

if os.name == "nt":
    MAGENTA = ""
    GREY = ""
    BLUE = ""
    YELLOW = ""
    RED = ""
    RESET = ""
else:
    MAGENTA = "\x1b[35m"
    GREY = "\x1b[2m\x1b[37m"
    BLUE = "\x1b[34m"
    YELLOW = "\x1b[33m"
    RED = "\x1b[31m"
    RESET = '\x1b[0m'

LOG_PREFIX = {
    TRACE: "[TRACE] ",
    DEBUG: "[DEBUG] ",
    INFO: "[INFO] ",
    WARN: "[WARN] ",
    ERROR: "[ERROR] ",
    TRACEBACK: "[TRACEBACK] ",
    COLOR | TRACE: GREY + "[TRACE] ",
    COLOR | DEBUG: "[DEBUG] ",
    COLOR | INFO: BLUE + "[INFO] ",
    COLOR | WARN: YELLOW + "[WARN] ",
    COLOR | ERROR: RED + "[ERROR] ",
    COLOR | TRACEBACK: MAGENTA + "[TRACEBACK] ",
}

def write_message(level, text):
    '''Write a message direct to stdout without queueing.'''
    reset = RESET if level & COLOR == COLOR else ''
    print(LOG_PREFIX[level] + text + reset)
    sys.stdout.flush()

def write_message_with_proc(level, proc_id, text):
    reset = RESET if level & COLOR == COLOR else ''
    print(LOG_PREFIX[level] + proc_id + text + reset)
    sys.stdout.flush()

_logging_process = None

def stop():
    _logging_process.join()

class Logger(object):
    '''Multi-process safe logger'''

    def __init__(self, level=WARN, color=False):
        global _logging_process
        self.proc_id = ""
        self.level = level
        # macOS does not support `fork` properly, so we must use `spawn` instead.
        method = 'spawn' if sys.platform == "darwin" else None
        try:
            ctx = multiprocessing.get_context(method)
        except AttributeError:
            # `get_context` doesn't exist -- we must be running an old version of Python.
            ctx = multiprocessing
        self.queue = ctx.Queue()
        _logging_process = ctx.Process(target=_message_loop, args=(self.queue,))
        _logging_process.start()
        self.color = COLOR if color else 0

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()
        return False

    def set_process_id(self, proc_id):
        '''Set the process id to be included in log messages.'''
        self.proc_id = "[%d] " % proc_id

    def setLevel(self, level):
        self.level = level

    def log(self, level, fmt, *args):
        '''Log a message in a process safe fashion.
        Message will be of the form [level] fmt%args.'''
        if level <= self.level:
            txt = fmt % args
            try:
                self.queue.put((self.color | level, self.proc_id, txt), False)
            except Exception:
                self.write_message(self.color | level, txt)

    def debug(self, fmt, *args):
        self.log(DEBUG, fmt, *args)

    def info(self, fmt, *args):
        self.log(INFO, fmt, *args)

    def warning(self, fmt, *args):
        self.log(WARN, fmt, *args)

    def error(self, fmt, *args):
        self.log(ERROR, fmt, *args)

    def trace(self, fmt, *args):
        self.log(TRACE, fmt, *args)

    def traceback(self, level=INFO):
        if level > self.level:
            return
        lines = trim_traceback(traceback.format_exc())
        for line in lines:
            try:
                self.queue.put((self.color | TRACEBACK, self.proc_id, line), False)
            except Exception:
                self.write_message(TRACEBACK, line)

    def close(self):
        self.queue.put(None)

    def write_message(self, level, text):
        '''Write a message direct to stdout without queueing.
        Safe to use even after logger is closed.
        Calling this concurrently from different processes or before calling logger.close()
        may cause messages to become interleaved.'''
        if level <= self.level:
            write_message_with_proc(self.color | level, self.proc_id, text)

#Function run by logger output process
def _message_loop(log_queue):
    # use utf-8 as the character encoding for stdout/stderr to be able to properly
    # log/print things on systems that use bad default encodings (windows).
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')

    common = set()
    while True:
        try:
            msg = log_queue.get()
            if msg is None:
                return
            level, proc_id, text = msg
            if proc_id:
                write_message_with_proc(level, proc_id, text)
            elif (level, text) not in common:
                write_message(level, text)
                common.add((level, text))
        except KeyboardInterrupt:
            #Will be handled in other processes.
            pass

def select_traceback_lines(lines, limit_start=30, limit_end=12):
    '''Select a subset of traceback lines to be displayed, cutting out the middle part of the
    traceback if the length exceeds `limit_start + limit_end`.
    This is intended to avoid displaying too many lines of tracebacks
    that are not relevant to the user.'''
    lines = lines.splitlines()
    num_lines = len(lines)
    limit = limit_start + limit_end
    if num_lines <= limit:
        yield from lines
    else:
        yield from lines[:limit_start]
        yield "... {} lines skipped".format(num_lines - limit)
        yield from lines[-limit_end:]


def trim_traceback(lines):
    trimmed = []
    for line in select_traceback_lines(lines):
        shortline = line.strip()
        try:
            if shortline.startswith("File"):
                shortline = '"semmle' + shortline.split("semmle")[-1]
            elif shortline.startswith("..."):
                pass
            else:
                continue
        except Exception:
            #Formatting error, just emit line as-is.
            pass
        trimmed.append(shortline)
    return trimmed

class StructuredLogObject(object):
    """
    Base class for CodeQL diagnostic message format

    see https://github.com/github/code-scanning/blob/main/docs/adrs/0035-diagnostics.md#codeql-diagnostic-message-format
    """
    def to_dict(self):
        # Discard any entries with a value of `None`
        def f(v):
            if isinstance(v, StructuredLogObject):
                return v.to_dict()
            return v
        return {k: f(v) for k, v in self.__dict__.items() if v is not None}

class Severity(StructuredLogObject, enum.Enum):
    ERROR = "error"
    WARNING = "warning"
    NOTE = "note"

    def to_dict(self):
        return self.value

class Source(StructuredLogObject):
    def __init__(self, id, name, extractorName="python"):
        self.id = id
        self.name = name
        self.extractorName = extractorName

    def extractorName(self, extractorName):
        self.extractorName = extractorName
        return self

class Visibility(StructuredLogObject):
    def __init__(self, statusPage=False, cliSummaryTable=False, telemetry=False):
        self.statusPage = statusPage
        self.cliSummaryTable = cliSummaryTable
        self.telemetry = telemetry

    def statusPage(self, statusPage):
        self.statusPage = statusPage
        return self

    def cliSummaryTable(self, cliSummaryTable):
        self.cliSummaryTable = cliSummaryTable
        return self

    def telemetry(self, telemetry):
        self.telemetry = telemetry
        return self

class Location(StructuredLogObject):
    def __init__(self, file=None, startLine=None, startColumn=None, endLine=None, endColumn=None):
        self.file = file
        self.startLine = startLine
        self.startColumn = startColumn

        # If you set startline/startColumn you MUST also set endLine/endColumn, so we
        # ensure they are also set.
        self.endLine = endLine
        if endLine is None and startLine is not None:
            self.endLine = startLine

        self.endColumn = endColumn
        if endColumn is None and startColumn is not None:
            self.endColumn = startColumn

    def file(self, file):
        self.file = file
        return self

    def startLine(self, startLine):
        self.startLine = startLine
        return self

    def startColumn(self, startColumn):
        self.startColumn = startColumn
        return self

    def endLine(self, endLine):
        self.endLine = endLine
        return self

    def endColumn(self, endColumn):
        self.endColumn = endColumn
        return self

class DiagnosticMessage(StructuredLogObject):
    def __init__(self, source, severity=Severity.WARNING, location=None, markdownMessage=None, plaintextMessage=None, helpLinks=None, visibility=None, attributes=None, timestamp=None):
        self.timestamp = timestamp or datetime.datetime.now().isoformat()
        self.source = source
        self.severity = severity
        self.location = location
        self.markdownMessage = markdownMessage
        self.plaintextMessage = plaintextMessage
        self.helpLinks = helpLinks
        if visibility is None:
            visibility = Visibility()
        self.visibility = visibility
        self.attributes = attributes

    def with_severity(self, severity):
        self.severity = severity
        return self

    def with_location(self, location):
        self.location = location
        return self

    def markdown(self, message):
        self.markdownMessage = message
        return self

    def text(self, message):
        self.plaintextMessage = message
        return self

    def help_link(self, link):
        if self.helpLinks is None:
            self.helpLinks = []
        self.helpLinks.append(link)
        return self

    def cli_summary_table(self):
        self.visibility.cliSummaryTable = True
        return self

    def status_page(self):
        self.visibility.statusPage = True
        return self

    def telemetry(self):
        self.visibility.telemetry = True
        return self

    def attribute(self, key, value):
        if self.attributes is None:
            self.attributes = {}
        self.attributes[key] = value
        return self

    def with_timestamp(self, timestamp):
        self.timestamp = timestamp
        return self

def get_stack_trace_lines():
    """Creates a stack trace for inclusion into the `attributes` part of a diagnostic message.
    Limits the size of the stack trace to 5000 characters, so as to not make the SARIF file overly big.
    """
    lines = trim_traceback(traceback.format_exc())
    trace_length = 0
    for i, line in enumerate(lines):
        trace_length += len(line)
        if trace_length > 5000:
            return lines[:i]
    return lines

def syntax_error_message(exception, unit):
    l = Location(file=unit.path, startLine=exception.lineno, startColumn=exception.offset)
    error = (DiagnosticMessage(Source("py/diagnostics/syntax-error", "Could not process some files due to syntax errors"), Severity.WARNING)
             .with_location(l)
             .markdown("A parse error occurred while processing `{}`, and as a result this file could not be analyzed. Check the syntax of the file using the `python -m py_compile` command and correct any invalid syntax.".format(unit.path))
             .attribute("traceback", get_stack_trace_lines())
             .attribute("args", exception.args)
             .status_page()
             .cli_summary_table()
             .telemetry()
    )
    return error

def recursion_error_message(exception, unit):
    # if unit is a BuiltinModuleExtractable, there will be no path attribute
    l = Location(file=unit.path) if hasattr(unit, "path") else None
    return (DiagnosticMessage(Source("py/diagnostics/recursion-error", "Recursion error in Python extractor"), Severity.ERROR)
            .with_location(l)
            .text(exception.args[0])
            .attribute("traceback", get_stack_trace_lines())
            .attribute("args", exception.args)
            .telemetry()
    )

def internal_error_message(exception, unit):
    # if unit is a BuiltinModuleExtractable, there will be no path attribute
    l = Location(file=unit.path) if hasattr(unit, "path") else None
    return (DiagnosticMessage(Source("py/diagnostics/internal-error", "Internal error in Python extractor"), Severity.ERROR)
            .with_location(l)
            .text("Internal error")
            .attribute("traceback", get_stack_trace_lines())
            .attribute("args", exception.args)
            .telemetry()
    )
