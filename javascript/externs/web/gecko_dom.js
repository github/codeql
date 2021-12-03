/*
 * Copyright 2008 The Closure Compiler Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview Definitions for all the extensions over
 *  W3C's DOM specification by Gecko. This file depends on
 *  w3c_dom2.js.
 *
 * When a non-standard extension appears in both Gecko and IE, we put
 * it in gecko_dom.js
 *
 * @externs
 */

// TODO: Almost all of it has not been annotated with types.

// Gecko DOM;

/**
 * Mozilla only???
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLSpanElement() {}

/**
 * @see https://developer.mozilla.org/en/Components_object
 */
Window.prototype.Components;

/**
 * @type {Window}
 * @see https://developer.mozilla.org/en/DOM/window.content
 */
Window.prototype.content;

/**
 * @type {boolean}
 * @see https://developer.mozilla.org/en/DOM/window.closed
 */
Window.prototype.closed;

/** @see https://developer.mozilla.org/en/DOM/window.controllers */
Window.prototype.controllers;

/** @see https://developer.mozilla.org/en/DOM/window.crypto */
Window.prototype.crypto;

/**
 * Gets/sets the status bar text for the given window.
 * @type {string}
 * @see https://developer.mozilla.org/en/DOM/window.defaultStatus
 */
Window.prototype.defaultStatus;

/** @see https://developer.mozilla.org/en/DOM/window.dialogArguments */
Window.prototype.dialogArguments;

/** @see https://developer.mozilla.org/en/DOM/window.directories */
Window.prototype.directories;

/**
 * @type {HTMLObjectElement|HTMLIFrameElement|null}
 * @see https://developer.mozilla.org/en/DOM/window.frameElement
 */
Window.prototype.frameElement;

/**
 * Allows lookup of frames by index or by name.
 * @type {?Object}
 * @see https://developer.mozilla.org/en/DOM/window.frames
 */
Window.prototype.frames;

/**
 * @type {boolean}
 * @see https://developer.mozilla.org/en/DOM/window.fullScreen
 */
Window.prototype.fullScreen;

/**
 * @return {!Promise<!BatteryManager>}
 * @see http://www.w3.org/TR/battery-status/
 */
Navigator.prototype.getBattery = function() {};

/**
 * @see https://developer.mozilla.org/en/DOM/Storage#globalStorage
 */
Window.prototype.globalStorage;

/**
 * @type {!History}
 * @suppress {duplicate}
 * @see https://developer.mozilla.org/en/DOM/window.history
 */
var history;

/**
 * Returns the number of frames (either frame or iframe elements) in the
 * window.
 *
 * @type {number}
 * @see https://developer.mozilla.org/en/DOM/window.length
 */
Window.prototype.length;

/**
 * Location has an exception in the DeclaredGlobalExternsOnWindow pass
 * so we have to manually include it:
 * https://github.com/google/closure-compiler/blob/master/src/com/google/javascript/jscomp/DeclaredGlobalExternsOnWindow.java#L116
 *
 * @type {!Location}
 * @implicitCast
 * @see https://developer.mozilla.org/en/DOM/window.location
 */
Window.prototype.location;

/**
 * @see https://developer.mozilla.org/en/DOM/window.locationbar
 */
Window.prototype.locationbar;

/**
 * @see https://developer.mozilla.org/en/DOM/window.menubar
 */
Window.prototype.menubar;

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/DOM/window.name
 */
Window.prototype.name;

/**
 * @type {Navigator}
 * @see https://developer.mozilla.org/en/DOM/window.navigator
 */
Window.prototype.navigator;

/**
 * @type {?Window}
 * @see https://developer.mozilla.org/en/DOM/window.opener
 */
Window.prototype.opener;

/**
 * @type {!Window}
 * @see https://developer.mozilla.org/en/DOM/window.parent
 */
Window.prototype.parent;

/** @see https://developer.mozilla.org/en/DOM/window.personalbar */
Window.prototype.personalbar;

/** @see https://developer.mozilla.org/en/DOM/window.pkcs11 */
Window.prototype.pkcs11;

/** @see https://developer.mozilla.org/en/DOM/window */
Window.prototype.returnValue;

/** @see https://developer.mozilla.org/en/DOM/window.scrollbars */
Window.prototype.scrollbars;

/**
 * @type {number}
 * @see https://developer.mozilla.org/En/DOM/window.scrollMaxX
 */
Window.prototype.scrollMaxX;

/**
 * @type {number}
 * @see https://developer.mozilla.org/En/DOM/window.scrollMaxY
 */
Window.prototype.scrollMaxY;

/**
 * @type {!Window}
 * @see https://developer.mozilla.org/en/DOM/window.self
 */
Window.prototype.self;

/** @see https://developer.mozilla.org/en/DOM/Storage#sessionStorage */
Window.prototype.sessionStorage;

/** @see https://developer.mozilla.org/en/DOM/window.sidebar */
Window.prototype.sidebar;

/**
 * @type {?string}
 * @see https://developer.mozilla.org/en/DOM/window.status
 */
Window.prototype.status;

/** @see https://developer.mozilla.org/en/DOM/window.statusbar */
Window.prototype.statusbar;

/** @see https://developer.mozilla.org/en/DOM/window.toolbar */
Window.prototype.toolbar;

/**
 * @type {!Window}
 * @see https://developer.mozilla.org/en/DOM/window.self
 */
Window.prototype.top;

/**
 * @type {!Window}
 * @see https://developer.mozilla.org/en/DOM/window.self
 */
Window.prototype.window;

/**
 * @param {*} message
 * @see https://developer.mozilla.org/en/DOM/window.alert
 * @return {undefined}
 */
Window.prototype.alert = function(message) {};

/**
 * Decodes a string of data which has been encoded using base-64 encoding.
 *
 * @param {string} encodedData
 * @return {string}
 * @see https://developer.mozilla.org/en/DOM/window.atob
 * @nosideeffects
 */
function atob(encodedData) {}

/**
 * @see https://developer.mozilla.org/en/DOM/window.back
 * @return {undefined}
 */
Window.prototype.back = function() {};

/**
 * @see https://developer.mozilla.org/en/DOM/window.blur
 * @return {undefined}
 */
Window.prototype.blur = function() {};

/**
 * @param {string} stringToEncode
 * @return {string}
 * @see https://developer.mozilla.org/en/DOM/window.btoa
 * @nosideeffects
 */
function btoa(stringToEncode) {}

/** @deprecated */
Window.prototype.captureEvents;

/**
 * @see https://developer.mozilla.org/en/DOM/window.close
 * @return {undefined}
 */
Window.prototype.close = function() {};

/**@see https://developer.mozilla.org/en/DOM/window.find */
Window.prototype.find;

/**
 * @see https://developer.mozilla.org/en/DOM/window.focus
 * @return {undefined}
 */
Window.prototype.focus = function() {};

/**
 * @see https://developer.mozilla.org/en/DOM/window.forward
 * @return {undefined}
 */
Window.prototype.forward = function() {};

/**
 * @see https://developer.mozilla.org/en/DOM/window.getAttention
 * @return {undefined}
 */
Window.prototype.getAttention = function() {};

/**
 * @return {Selection}
 * @see https://developer.mozilla.org/en/DOM/window.getSelection
 * @nosideeffects
 */
Window.prototype.getSelection = function() {};

/**
 * @see https://developer.mozilla.org/en/DOM/window.home
 * @return {undefined}
 */
Window.prototype.home = function() {};

Window.prototype.openDialog;
Window.prototype.releaseEvents;
Window.prototype.scrollByLines;
Window.prototype.scrollByPages;

/**
 * @param {string} uri
 * @param {?=} opt_arguments
 * @param {string=} opt_options
 * @see https://developer.mozilla.org/en/DOM/window.showModalDialog
 */
Window.prototype.showModalDialog;

Window.prototype.sizeToContent;

/**
 * @see http://msdn.microsoft.com/en-us/library/ms536769(VS.85).aspx
 * @return {undefined}
 */
Window.prototype.stop = function() {};

Window.prototype.updateCommands;

// properties of Document

/**
 * @see https://developer.mozilla.org/en/DOM/document.alinkColor
 * @type {string}
 */
Document.prototype.alinkColor;

/**
 * @see https://developer.mozilla.org/en/DOM/document.anchors
 * @type {HTMLCollection<!HTMLAnchorElement>}
 */
Document.prototype.anchors;

/**
 * @see https://developer.mozilla.org/en/DOM/document.applets
 * @type {HTMLCollection<!HTMLAppletElement>}
 */
Document.prototype.applets;
/** @type {boolean} */ Document.prototype.async;
/** @type {string?} */ Document.prototype.baseURI;

/**
 * @see https://developer.mozilla.org/en/DOM/document.bgColor
 * @type {string}
 */
Document.prototype.bgColor;

/** @type {HTMLBodyElement} */ Document.prototype.body;
Document.prototype.characterSet;

/**
 * @see https://developer.mozilla.org/en/DOM/document.compatMode
 * @type {string}
 */
Document.prototype.compatMode;

Document.prototype.contentType;
/** @type {string} */ Document.prototype.cookie;
Document.prototype.defaultView;

/**
 * @see https://developer.mozilla.org/en/DOM/document.designMode
 * @type {string}
 */
Document.prototype.designMode;

Document.prototype.documentURIObject;

/**
 * @see https://developer.mozilla.org/en/DOM/document.domain
 * @type {string}
 */
Document.prototype.domain;

/**
 * @see https://developer.mozilla.org/en/DOM/document.embeds
 * @type {HTMLCollection<!HTMLEmbedElement>}
 */
Document.prototype.embeds;

/**
 * @see https://developer.mozilla.org/en/DOM/document.fgColor
 * @type {string}
 */
Document.prototype.fgColor;

/** @type {Element} */ Document.prototype.firstChild;

/**
 * @see https://developer.mozilla.org/en/DOM/document.forms
 * @type {HTMLCollection<!HTMLFormElement>}
 */
Document.prototype.forms;

/** @type {number} */
Document.prototype.height;

/** @type {HTMLCollection<!HTMLImageElement>} */
Document.prototype.images;

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/DOM/document.lastModified
 */
Document.prototype.lastModified;

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/DOM/document.linkColor
 */
Document.prototype.linkColor;

/**
 * @see https://developer.mozilla.org/en/DOM/document.links
 * @type {HTMLCollection<(!HTMLAreaElement|!HTMLAnchorElement)>}
 */
Document.prototype.links;

/**
 * @type {!Location}
 * @implicitCast
 */
Document.prototype.location;

Document.prototype.namespaceURI;
Document.prototype.nodePrincipal;
Document.prototype.plugins;
Document.prototype.popupNode;

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/DOM/document.referrer
 */
Document.prototype.referrer;

/**
 * @type {StyleSheetList}
 * @see https://developer.mozilla.org/en/DOM/document.styleSheets
 */
Document.prototype.styleSheets;

/** @type {?string} */ Document.prototype.title;
Document.prototype.tooltipNode;
/** @type {string} */ Document.prototype.URL;

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/DOM/document.vlinkColor
 */
Document.prototype.vlinkColor;

/** @type {number} */ Document.prototype.width;

// Methods of Document
/**
 * @see https://developer.mozilla.org/en/DOM/document.clear
 * @return {undefined}
 */
Document.prototype.clear = function() {};

/**
 * @see https://developer.mozilla.org/en/DOM/document.close
 */
Document.prototype.close;

/**
 * @param {string} type
 * @return {Event}
 */
Document.prototype.createEvent = function(type) {};
Document.prototype.createNSResolver;
/** @return {Range} */ Document.prototype.createRange = function() {};
Document.prototype.createTreeWalker;

Document.prototype.evaluate;

/**
 * @param {string} commandName
 * @param {?boolean=} opt_showUi
 * @param {*=} opt_value
 * @see https://developer.mozilla.org/en/Rich-Text_Editing_in_Mozilla#Executing_Commands
 */
Document.prototype.execCommand;

/**
 * @param {string} name
 * @return {!NodeList<!Element>}
 * @nosideeffects
 * @see https://developer.mozilla.org/en/DOM/document.getElementsByClassName
 */
Document.prototype.getElementsByClassName = function(name) {};

/**
 * @param {string} uri
 * @return {undefined}
 */
Document.prototype.load = function(uri) {};
Document.prototype.loadOverlay;

/**
 * @see https://developer.mozilla.org/en/DOM/document.open
 */
Document.prototype.open;

/**
 * @see https://developer.mozilla.org/en/Midas
 * @see http://msdn.microsoft.com/en-us/library/ms536676(VS.85).aspx
 */
Document.prototype.queryCommandEnabled;

/**
 * @see https://developer.mozilla.org/en/Midas
 * @see http://msdn.microsoft.com/en-us/library/ms536678(VS.85).aspx
 */
Document.prototype.queryCommandIndeterm;

/**
 * @see https://developer.mozilla.org/en/Midas
 * @see http://msdn.microsoft.com/en-us/library/ms536679(VS.85).aspx
 */
Document.prototype.queryCommandState;

/**
 * @see https://developer.mozilla.org/en/DOM/document.queryCommandSupported
 * @see http://msdn.microsoft.com/en-us/library/ms536681(VS.85).aspx
 * @param {string} command
 * @return {?} Implementation-specific.
 */
Document.prototype.queryCommandSupported;

/**
 * @see https://developer.mozilla.org/en/Midas
 * @see http://msdn.microsoft.com/en-us/library/ms536683(VS.85).aspx
 */
Document.prototype.queryCommandValue;

/**
 * @see https://developer.mozilla.org/en/DOM/document.write
 * @param {string} text
 * @return {undefined}
 */
Document.prototype.write = function(text) {};

/**
 * @see https://developer.mozilla.org/en/DOM/document.writeln
 * @param {string} text
 * @return {undefined}
 */
Document.prototype.writeln = function(text) {};

Document.prototype.ononline;
Document.prototype.onoffline;

// XUL
/**
 * @see http://developer.mozilla.org/en/DOM/document.getBoxObjectFor
 * @return {BoxObject}
 * @nosideeffects
 */
Document.prototype.getBoxObjectFor = function(element) {};

// From:
// http://lxr.mozilla.org/mozilla1.8/source/dom/public/idl/range/nsIDOMNSRange.idl

/**
 * @param {string} tag
 * @return {DocumentFragment}
 */
Range.prototype.createContextualFragment;

/**
 * @param {Node} parent
 * @param {number} offset
 * @return {boolean}
 * @nosideeffects
 */
Range.prototype.isPointInRange;

/**
 * @param {Node} parent
 * @param {number} offset
 * @return {number}
 * @nosideeffects
 */
Range.prototype.comparePoint;

/**
 * @param {Node} n
 * @return {boolean}
 * @nosideeffects
 */
Range.prototype.intersectsNode;

/**
 * @param {Node} n
 * @return {number}
 * @nosideeffects
 */
Range.prototype.compareNode;


/** @constructor */
function Selection() {}

/**
 * @type {Node}
 * @see https://developer.mozilla.org/en/DOM/Selection/anchorNode
 */
Selection.prototype.anchorNode;

/**
 * @type {number}
 * @see https://developer.mozilla.org/en/DOM/Selection/anchorOffset
 */
Selection.prototype.anchorOffset;

/**
 * @type {Node}
 * @see https://developer.mozilla.org/en/DOM/Selection/focusNode
 */
Selection.prototype.focusNode;

/**
 * @type {number}
 * @see https://developer.mozilla.org/en/DOM/Selection/focusOffset
 */
Selection.prototype.focusOffset;

/**
 * @type {boolean}
 * @see https://developer.mozilla.org/en/DOM/Selection/isCollapsed
 */
Selection.prototype.isCollapsed;

/**
 * @type {number}
 * @see https://developer.mozilla.org/en/DOM/Selection/rangeCount
 */
Selection.prototype.rangeCount;

/**
 * @param {Range} range
 * @return {undefined}
 * @see https://developer.mozilla.org/en/DOM/Selection/addRange
 */
Selection.prototype.addRange = function(range) {};

/**
 * @param {number} index
 * @return {Range}
 * @see https://developer.mozilla.org/en/DOM/Selection/getRangeAt
 * @nosideeffects
 */
Selection.prototype.getRangeAt = function(index) {};

/**
 * @param {Node} node
 * @param {number} index
 * @return {undefined}
 * @see https://developer.mozilla.org/en/DOM/Selection/collapse
 */
Selection.prototype.collapse = function(node, index) {};

/**
 * @return {undefined}
 * @see https://developer.mozilla.org/en/DOM/Selection/collapseToEnd
 */
Selection.prototype.collapseToEnd = function() {};

/**
 * @return {undefined}
 * @see https://developer.mozilla.org/en/DOM/Selection/collapseToStart
 */
Selection.prototype.collapseToStart = function() {};

/**
 * @param {Node} node
 * @param {boolean} partlyContained
 * @return {boolean}
 * @see https://developer.mozilla.org/en/DOM/Selection/containsNode
 * @nosideeffects
 */
Selection.prototype.containsNode = function(node, partlyContained) {};

/**
 * @see https://developer.mozilla.org/en/DOM/Selection/deleteFromDocument
 * @return {undefined}
 */
Selection.prototype.deleteFromDocument = function() {};

/**
 * @param {Node} parentNode
 * @param {number} offset
 * @see https://developer.mozilla.org/en/DOM/Selection/extend
 * @return {undefined}
 */
Selection.prototype.extend = function(parentNode, offset) {};

/**
 * @see https://developer.mozilla.org/en/DOM/Selection/removeAllRanges
 * @return {undefined}
 */
Selection.prototype.removeAllRanges = function() {};

/**
 * @param {Range} range
 * @see https://developer.mozilla.org/en/DOM/Selection/removeRange
 * @return {undefined}
 */
Selection.prototype.removeRange = function(range) {};

/**
 * @param {Node} parentNode
 * @see https://developer.mozilla.org/en/DOM/Selection/selectAllChildren
 */
Selection.prototype.selectAllChildren;

/**
 * @see https://developer.mozilla.org/en/DOM/Selection/selectionLanguageChange
 */
Selection.prototype.selectionLanguageChange;

/**
 * @type {!NodeList<!Element>}
 * @see https://developer.mozilla.org/en/DOM/element.children
 */
Element.prototype.children;

/**
 * Firebug sets this property on elements it is inserting into the DOM.
 * @type {boolean}
 */
Element.prototype.firebugIgnore;

/**
 * Note: According to the spec, id is actually defined on HTMLElement and
 * SVGElement, rather than Element. Deliberately ignore this so that saying
 * Element.id is allowed.
 * @type {string}
 * @implicitCast
 */
Element.prototype.id;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Parsing/#widl-Element-innerHTML
 * @implicitCast
 */
Element.prototype.innerHTML;

/**
 * Note: According to the spec, name is defined on specific types of
 * HTMLElements, rather than on Node, Element, or HTMLElement directly.
 * Ignore this.
 * @type {string}
 */
Element.prototype.name;

Element.prototype.nodePrincipal;

/**
 * @type {!CSSStyleDeclaration}
 * This belongs on HTMLElement rather than Element, but that
 * breaks a lot.
 * TODO(rdcronin): Remove this declaration once the breakage is fixed.
 */
Element.prototype.style;

/**
 * @override
 * @return {!Element}
 */
Element.prototype.cloneNode = function(deep) {};

/** @return {undefined} */
Element.prototype.blur = function() {};

/** @return {undefined} */
Element.prototype.click = function() {};

/** @return {undefined} */
Element.prototype.focus = function() {};

/** @type {number} */
HTMLInputElement.prototype.selectionStart;

/** @type {number} */
HTMLInputElement.prototype.selectionEnd;

/**
 * @param {number} selectionStart
 * @param {number} selectionEnd
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/editing.html#dom-textarea/input-setselectionrange
 * @return {undefined}
 */
HTMLInputElement.prototype.setSelectionRange =
    function(selectionStart, selectionEnd) {};

/** @type {number} */
HTMLTextAreaElement.prototype.selectionStart;

/** @type {number} */
HTMLTextAreaElement.prototype.selectionEnd;

/**
 * @param {number} selectionStart
 * @param {number} selectionEnd
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/editing.html#dom-textarea/input-setselectionrange
 * @return {undefined}
 */
HTMLTextAreaElement.prototype.setSelectionRange =
    function(selectionStart, selectionEnd) {};

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/Navigator.buildID
 */
Navigator.prototype.buildID;

/**
 * @type {!Array<string>|undefined}
 * @see https://developer.mozilla.org/en/Navigator.languages
 */
Navigator.prototype.languages;

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/Navigator.oscpu
 */
Navigator.prototype.oscpu;

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/Navigator.productSub
 */
Navigator.prototype.productSub;

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/Navigator.securityPolicy
 */
Navigator.prototype.securityPolicy;

/**
 * @param {string} url
 * @param {ArrayBufferView|Blob|string|FormData=} opt_data
 * @return {boolean}
 * @see https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
 */
Navigator.prototype.sendBeacon = function(url, opt_data) {};

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/Navigator.vendor
 */
Navigator.prototype.vendor;

/**
 * @type {string}
 * @see https://developer.mozilla.org/en/Navigator.vendorSub
 */
Navigator.prototype.vendorSub;


/** @constructor */
function BoxObject() {}

/** @type {Element} */
BoxObject.prototype.element;

/** @type {number} */
BoxObject.prototype.screenX;

/** @type {number} */
BoxObject.prototype.screenY;

/** @type {number} */
BoxObject.prototype.x;

/** @type {number} */
BoxObject.prototype.y;

/** @type {number} */
BoxObject.prototype.width;


/**
 * @param {Element} element
 * @param {?string=} pseudoElt
 * @return {?CSSStyleDeclaration}
 * @nosideeffects
 * @see https://bugzilla.mozilla.org/show_bug.cgi?id=548397
 */
function getComputedStyle(element, pseudoElt) {}
