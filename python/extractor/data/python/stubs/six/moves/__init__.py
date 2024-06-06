# six.moves

import sys
PY2 = sys.version_info < (3,)
PY3 = sys.version_info >= (3,)

# Generated (six_gen.py) from six version 1.14.0 with Python 2.7.17 (default, Nov 18 2019, 13:12:39)
if PY2:
    import cStringIO as _1
    cStringIO = _1.StringIO
    import itertools as _2
    filter = _2.filter
    filterfalse = _2.filterfalse
    import __builtin__ as _3
    input = _3.raw_input
    intern = _3.intern
    map = _2.map
    import os as _4
    getcwd = _4.getcwdu
    getcwdb = _4.getcwd
    import commands as _5
    getoutput = _5.getoutput
    range = _3.xrange
    reload_module = _3.reload
    reduce = _3.reduce
    import pipes as _6
    shlex_quote = _6.quote
    import StringIO as _7
    StringIO = _7.StringIO
    import UserDict as _8
    UserDict = _8.UserDict
    import UserList as _9
    UserList = _9.UserList
    import UserString as _10
    UserString = _10.UserString
    xrange = _3.xrange
    zip = zip
    zip_longest = _2.zip_longest
    import __builtin__ as builtins
    import ConfigParser as configparser
    import collections as collections_abc
    import copy_reg as copyreg
    import gdbm as dbm_gnu
    import dbm as dbm_ndbm
    import dummy_thread as _dummy_thread
    import cookielib as http_cookiejar
    import Cookie as http_cookies
    import htmlentitydefs as html_entities
    import HTMLParser as html_parser
    import httplib as http_client
    import email.MIMEBase as email_mime_base
    import email.MIMEImage as email_mime_image
    import email.MIMEMultipart as email_mime_multipart
    import email.MIMENonMultipart as email_mime_nonmultipart
    import email.MIMEText as email_mime_text
    import BaseHTTPServer as BaseHTTPServer
    import CGIHTTPServer as CGIHTTPServer
    import SimpleHTTPServer as SimpleHTTPServer
    import cPickle as cPickle
    import Queue as queue
    import repr as reprlib
    import SocketServer as socketserver
    import thread as _thread
    import Tkinter as tkinter
    import Dialog as tkinter_dialog
    import FileDialog as tkinter_filedialog
    import ScrolledText as tkinter_scrolledtext
    import SimpleDialog as tkinter_simpledialog
    import Tix as tkinter_tix
    import ttk as tkinter_ttk
    import Tkconstants as tkinter_constants
    import Tkdnd as tkinter_dnd
    import tkColorChooser as tkinter_colorchooser
    import tkCommonDialog as tkinter_commondialog
    import tkFileDialog as tkinter_tkfiledialog
    import tkFont as tkinter_font
    import tkMessageBox as tkinter_messagebox
    import tkSimpleDialog as tkinter_tksimpledialog
    import xmlrpclib as xmlrpc_client
    import SimpleXMLRPCServer as xmlrpc_server
    del _1
    del _5
    del _7
    del _8
    del _6
    del _3
    del _9
    del _2
    del _10
    del _4

# Generated (six_gen.py) from six version 1.14.0 with Python 3.8.0 (default, Nov 18 2019, 13:17:17)
if PY3:
    import io as _1
    cStringIO = _1.StringIO
    import builtins as _2
    filter = _2.filter
    import itertools as _3
    filterfalse = _3.filterfalse
    input = _2.input
    import sys as _4
    intern = _4.intern
    map = _2.map
    import os as _5
    getcwd = _5.getcwd
    getcwdb = _5.getcwdb
    import subprocess as _6
    getoutput = _6.getoutput
    range = _2.range
    import importlib as _7
    reload_module = _7.reload
    import functools as _8
    reduce = _8.reduce
    import shlex as _9
    shlex_quote = _9.quote
    StringIO = _1.StringIO
    import collections as _10
    UserDict = _10.UserDict
    UserList = _10.UserList
    UserString = _10.UserString
    xrange = _2.range
    zip = _2.zip
    zip_longest = _3.zip_longest
    import builtins as builtins
    import configparser as configparser
    import collections.abc as collections_abc
    import copyreg as copyreg
    import dbm.gnu as dbm_gnu
    import dbm.ndbm as dbm_ndbm
    import _dummy_thread as _dummy_thread
    import http.cookiejar as http_cookiejar
    import http.cookies as http_cookies
    import html.entities as html_entities
    import html.parser as html_parser
    import http.client as http_client
    import email.mime.base as email_mime_base
    import email.mime.image as email_mime_image
    import email.mime.multipart as email_mime_multipart
    import email.mime.nonmultipart as email_mime_nonmultipart
    import email.mime.text as email_mime_text
    import http.server as BaseHTTPServer
    import http.server as CGIHTTPServer
    import http.server as SimpleHTTPServer
    import pickle as cPickle
    import queue as queue
    import reprlib as reprlib
    import socketserver as socketserver
    import _thread as _thread
    import tkinter as tkinter
    import tkinter.dialog as tkinter_dialog
    import tkinter.filedialog as tkinter_filedialog
    import tkinter.scrolledtext as tkinter_scrolledtext
    import tkinter.simpledialog as tkinter_simpledialog
    import tkinter.tix as tkinter_tix
    import tkinter.ttk as tkinter_ttk
    import tkinter.constants as tkinter_constants
    import tkinter.dnd as tkinter_dnd
    import tkinter.colorchooser as tkinter_colorchooser
    import tkinter.commondialog as tkinter_commondialog
    import tkinter.filedialog as tkinter_tkfiledialog
    import tkinter.font as tkinter_font
    import tkinter.messagebox as tkinter_messagebox
    import tkinter.simpledialog as tkinter_tksimpledialog
    import xmlrpc.client as xmlrpc_client
    import xmlrpc.server as xmlrpc_server
    del _1
    del _2
    del _3
    del _4
    del _5
    del _6
    del _7
    del _8
    del _9
    del _10

# Not generated:

import six.moves.urllib as urllib
import six.moves.urllib_parse as urllib_parse
import six.moves.urllib_response as urllib_response
import six.moves.urllib_request as urllib_request
import six.moves.urllib_error as urllib_error
import six.moves.urllib_robotparser as urllib_robotparser


sys.modules['six.moves.builtins'] = builtins
sys.modules['six.moves.configparser'] = configparser
sys.modules['six.moves.collections_abc'] = collections_abc
sys.modules['six.moves.copyreg'] = copyreg
sys.modules['six.moves.dbm_gnu'] = dbm_gnu
sys.modules['six.moves.dbm_ndbm'] = dbm_ndbm
sys.modules['six.moves._dummy_thread'] = _dummy_thread
sys.modules['six.moves.http_cookiejar'] = http_cookiejar
sys.modules['six.moves.http_cookies'] = http_cookies
sys.modules['six.moves.html_entities'] = html_entities
sys.modules['six.moves.html_parser'] = html_parser
sys.modules['six.moves.http_client'] = http_client
sys.modules['six.moves.email_mime_base'] = email_mime_base
sys.modules['six.moves.email_mime_image'] = email_mime_image
sys.modules['six.moves.email_mime_multipart'] = email_mime_multipart
sys.modules['six.moves.email_mime_nonmultipart'] = email_mime_nonmultipart
sys.modules['six.moves.email_mime_text'] = email_mime_text
sys.modules['six.moves.BaseHTTPServer'] = BaseHTTPServer
sys.modules['six.moves.CGIHTTPServer'] = CGIHTTPServer
sys.modules['six.moves.SimpleHTTPServer'] = SimpleHTTPServer
sys.modules['six.moves.cPickle'] = cPickle
sys.modules['six.moves.queue'] = queue
sys.modules['six.moves.reprlib'] = reprlib
sys.modules['six.moves.socketserver'] = socketserver
sys.modules['six.moves._thread'] = _thread
sys.modules['six.moves.tkinter'] = tkinter
sys.modules['six.moves.tkinter_dialog'] = tkinter_dialog
sys.modules['six.moves.tkinter_filedialog'] = tkinter_filedialog
sys.modules['six.moves.tkinter_scrolledtext'] = tkinter_scrolledtext
sys.modules['six.moves.tkinter_simpledialog'] = tkinter_simpledialog
sys.modules['six.moves.tkinter_tix'] = tkinter_tix
sys.modules['six.moves.tkinter_ttk'] = tkinter_ttk
sys.modules['six.moves.tkinter_constants'] = tkinter_constants
sys.modules['six.moves.tkinter_dnd'] = tkinter_dnd
sys.modules['six.moves.tkinter_colorchooser'] = tkinter_colorchooser
sys.modules['six.moves.tkinter_commondialog'] = tkinter_commondialog
sys.modules['six.moves.tkinter_tkfiledialog'] = tkinter_tkfiledialog
sys.modules['six.moves.tkinter_font'] = tkinter_font
sys.modules['six.moves.tkinter_messagebox'] = tkinter_messagebox
sys.modules['six.moves.tkinter_tksimpledialog'] = tkinter_tksimpledialog
sys.modules['six.moves.xmlrpc_client'] = xmlrpc_client
sys.modules['six.moves.xmlrpc_server'] = xmlrpc_server

# Windows special

if PY2:
    import _winreg as winreg
if PY3:
    import winreg as winreg

sys.modules['six.moves.winreg'] = winreg

del sys
