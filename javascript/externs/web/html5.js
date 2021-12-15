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
 * @fileoverview Definitions for all the extensions over the
 *  W3C's DOM3 specification in HTML5. This file depends on
 *  w3c_dom3.js. The whole file has been fully type annotated.
 *
 *  @see http://www.whatwg.org/specs/web-apps/current-work/multipage/index.html
 *  @see http://dev.w3.org/html5/spec/Overview.html
 *
 *  This also includes Typed Array definitions from
 *  http://www.khronos.org/registry/typedarray/specs/latest/
 *
 *  This relies on w3c_event.js being included first.
 *
 * @externs
 */


/**
 * Note: In IE, the contains() method only exists on Elements, not Nodes.
 * Therefore, it is recommended that you use the Conformance framework to
 * prevent calling this on Nodes which are not Elements.
 * @see https://connect.microsoft.com/IE/feedback/details/780874/node-contains-is-incorrect
 *
 * @param {Node} n The node to check
 * @return {boolean} If 'n' is this Node, or is contained within this Node.
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Node.contains
 * @nosideeffects
 */
Node.prototype.contains = function(n) {};


/**
 * @constructor
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#the-canvas-element
 * @extends {HTMLElement}
 */
function HTMLCanvasElement() {}

/** @type {number} */
HTMLCanvasElement.prototype.width;

/** @type {number} */
HTMLCanvasElement.prototype.height;

/**
 * @see https://www.w3.org/TR/html5/scripting-1.html#dom-canvas-toblob
 * @param {function(!Blob)} callback
 * @param {string=} opt_type
 * @param {...*} var_args
 * @throws {Error}
 */
HTMLCanvasElement.prototype.toBlob = function(callback, opt_type, var_args) {};

/**
 * @param {string=} opt_type
 * @param {...*} var_args
 * @return {string}
 * @throws {Error}
 */
HTMLCanvasElement.prototype.toDataURL = function(opt_type, var_args) {};

/**
 * @param {string} contextId
 * @param {Object=} opt_args
 * @return {Object}
 */
HTMLCanvasElement.prototype.getContext = function(contextId, opt_args) {};

/**
 * @see https://www.w3.org/TR/mediacapture-fromelement/
 * @param {number=} opt_framerate
 * @return {!MediaStream}
 * @throws {Error}
 * */
HTMLCanvasElement.prototype.captureStream = function(opt_framerate) {};

/**
 * @interface
 * @see https://www.w3.org/TR/2dcontext/#canvaspathmethods
 */
function CanvasPathMethods() {};

/**
 * @return {undefined}
 */
CanvasPathMethods.prototype.closePath = function() {};

/**
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 */
CanvasPathMethods.prototype.moveTo = function(x, y) {};

/**
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 */
CanvasPathMethods.prototype.lineTo = function(x, y) {};

/**
 * @param {number} cpx
 * @param {number} cpy
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 */
CanvasPathMethods.prototype.quadraticCurveTo = function(cpx, cpy, x, y) {};

/**
 * @param {number} cp1x
 * @param {number} cp1y
 * @param {number} cp2x
 * @param {number} cp2y
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 */
CanvasPathMethods.prototype.bezierCurveTo = function(
    cp1x, cp1y, cp2x, cp2y, x, y) {};

/**
 * @param {number} x1
 * @param {number} y1
 * @param {number} x2
 * @param {number} y2
 * @param {number} radius
 * @return {undefined}
 */
CanvasPathMethods.prototype.arcTo = function(x1, y1, x2, y2, radius) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} w
 * @param {number} h
 * @return {undefined}
 */
CanvasPathMethods.prototype.rect = function(x, y, w, h) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} radius
 * @param {number} startAngle
 * @param {number} endAngle
 * @param {boolean=} opt_anticlockwise
 * @return {undefined}
 */
CanvasPathMethods.prototype.arc = function(
    x, y, radius, startAngle, endAngle, opt_anticlockwise) {};


/**
 * @constructor
 * @implements {CanvasPathMethods}
 * @see http://www.w3.org/TR/2dcontext/#canvasrenderingcontext2d
 */
function CanvasRenderingContext2D() {}

/** @type {!HTMLCanvasElement} */
CanvasRenderingContext2D.prototype.canvas;

/**
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.save = function() {};

/**
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.restore = function() {};

/**
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.scale = function(x, y) {};

/**
 * @param {number} angle
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.rotate = function(angle) {};

/**
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.translate = function(x, y) {};

/**
 * @param {number} m11
 * @param {number} m12
 * @param {number} m21
 * @param {number} m22
 * @param {number} dx
 * @param {number} dy
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.transform = function(
    m11, m12, m21, m22, dx, dy) {};

/**
 * @param {number} m11
 * @param {number} m12
 * @param {number} m21
 * @param {number} m22
 * @param {number} dx
 * @param {number} dy
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.setTransform = function(
    m11, m12, m21, m22, dx, dy) {};

/**
 * @param {number} x0
 * @param {number} y0
 * @param {number} x1
 * @param {number} y1
 * @return {CanvasGradient}
 * @throws {Error}
 */
CanvasRenderingContext2D.prototype.createLinearGradient = function(
    x0, y0, x1, y1) {};

/**
 * @param {number} x0
 * @param {number} y0
 * @param {number} r0
 * @param {number} x1
 * @param {number} y1
 * @param {number} r1
 * @return {CanvasGradient}
 * @throws {Error}
 */
CanvasRenderingContext2D.prototype.createRadialGradient = function(
    x0, y0, r0, x1, y1, r1) {};

/**
 * @param {HTMLImageElement|HTMLCanvasElement} image
 * @param {string} repetition
 * @return {CanvasPattern}
 * @throws {Error}
 */
CanvasRenderingContext2D.prototype.createPattern = function(
    image, repetition) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} w
 * @param {number} h
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.clearRect = function(x, y, w, h) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} w
 * @param {number} h
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.fillRect = function(x, y, w, h) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} w
 * @param {number} h
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.strokeRect = function(x, y, w, h) {};

/**
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.beginPath = function() {};

/**
 * @return {undefined}
 * @override
 */
CanvasRenderingContext2D.prototype.closePath = function() {};

/**
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 * @override
 */
CanvasRenderingContext2D.prototype.moveTo = function(x, y) {};

/**
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 * @override
 */
CanvasRenderingContext2D.prototype.lineTo = function(x, y) {};

/**
 * @param {number} cpx
 * @param {number} cpy
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 * @override
 */
CanvasRenderingContext2D.prototype.quadraticCurveTo = function(
    cpx, cpy, x, y) {};

/**
 * @param {number} cp1x
 * @param {number} cp1y
 * @param {number} cp2x
 * @param {number} cp2y
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 * @override
 */
CanvasRenderingContext2D.prototype.bezierCurveTo = function(
    cp1x, cp1y, cp2x, cp2y, x, y) {};

/**
 * @param {number} x1
 * @param {number} y1
 * @param {number} x2
 * @param {number} y2
 * @param {number} radius
 * @return {undefined}
 * @override
 */
CanvasRenderingContext2D.prototype.arcTo = function(x1, y1, x2, y2, radius) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} w
 * @param {number} h
 * @return {undefined}
 * @override
 */
CanvasRenderingContext2D.prototype.rect = function(x, y, w, h) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} radius
 * @param {number} startAngle
 * @param {number} endAngle
 * @param {boolean=} opt_anticlockwise
 * @return {undefined}
 * @override
 */
CanvasRenderingContext2D.prototype.arc = function(
    x, y, radius, startAngle, endAngle, opt_anticlockwise) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} radiusX
 * @param {number} radiusY
 * @param {number} rotation
 * @param {number} startAngle
 * @param {number} endAngle
 * @param {boolean=} opt_anticlockwise
 * @return {undefined}
 * @see http://developer.mozilla.org/en/docs/Web/API/CanvasRenderingContext2D/ellipse
 */
CanvasRenderingContext2D.prototype.ellipse = function(
    x, y, radiusX, radiusY, rotation, startAngle, endAngle, opt_anticlockwise) {
};

/**
 * @param {string=} opt_fillRule
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.fill = function(opt_fillRule) {};

/**
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.stroke = function() {};

/**
 * @param {string=} opt_fillRule
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.clip = function(opt_fillRule) {};

/**
 * @param {number} x
 * @param {number} y
 * @return {boolean}
 * @nosideeffects
 * @see http://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/isPointInStroke
 */
CanvasRenderingContext2D.prototype.isPointInStroke = function(x, y) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {string=} opt_fillRule
 * @return {boolean}
 * @nosideeffects
 */
CanvasRenderingContext2D.prototype.isPointInPath = function(
    x, y, opt_fillRule) {};

/**
 * @param {string} text
 * @param {number} x
 * @param {number} y
 * @param {number=} opt_maxWidth
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.fillText = function(
    text, x, y, opt_maxWidth) {};

/**
 * @param {string} text
 * @param {number} x
 * @param {number} y
 * @param {number=} opt_maxWidth
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.strokeText = function(
    text, x, y, opt_maxWidth) {};

/**
 * @param {string} text
 * @return {TextMetrics}
 * @nosideeffects
 */
CanvasRenderingContext2D.prototype.measureText = function(text) {};

/**
 * @param {HTMLImageElement|HTMLCanvasElement|Image|HTMLVideoElement} image
 * @param {number} dx Destination x coordinate.
 * @param {number} dy Destination y coordinate.
 * @param {number=} opt_dw Destination box width.  Defaults to the image width.
 * @param {number=} opt_dh Destination box height.
 *     Defaults to the image height.
 * @param {number=} opt_sx Source box x coordinate.  Used to select a portion of
 *     the source image to draw.  Defaults to 0.
 * @param {number=} opt_sy Source box y coordinate.  Used to select a portion of
 *     the source image to draw.  Defaults to 0.
 * @param {number=} opt_sw Source box width.  Used to select a portion of
 *     the source image to draw.  Defaults to the full image width.
 * @param {number=} opt_sh Source box height.  Used to select a portion of
 *     the source image to draw.  Defaults to the full image height.
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.drawImage = function(
    image, dx, dy, opt_dw, opt_dh, opt_sx, opt_sy, opt_sw, opt_sh) {};

/**
 * @param {number} sw
 * @param {number} sh
 * @return {ImageData}
 * @nosideeffects
 */
CanvasRenderingContext2D.prototype.createImageData = function(sw, sh) {};

/**
 * @param {number} sx
 * @param {number} sy
 * @param {number} sw
 * @param {number} sh
 * @return {ImageData}
 * @throws {Error}
 */
CanvasRenderingContext2D.prototype.getImageData = function(sx, sy, sw, sh) {};

/**
 * @param {ImageData} imagedata
 * @param {number} dx
 * @param {number} dy
 * @param {number=} opt_dirtyX
 * @param {number=} opt_dirtyY
 * @param {number=} opt_dirtyWidth
 * @param {number=} opt_dirtyHeight
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.putImageData = function(imagedata, dx, dy,
    opt_dirtyX, opt_dirtyY, opt_dirtyWidth, opt_dirtyHeight) {};

/**
 * Note: WebKit only
 * @param {number|string=} opt_a
 * @param {number=} opt_b
 * @param {number=} opt_c
 * @param {number=} opt_d
 * @param {number=} opt_e
 * @see http://developer.apple.com/library/safari/#documentation/appleapplications/reference/WebKitDOMRef/CanvasRenderingContext2D_idl/Classes/CanvasRenderingContext2D/index.html
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.setFillColor;

/**
 * Note: WebKit only
 * @param {number|string=} opt_a
 * @param {number=} opt_b
 * @param {number=} opt_c
 * @param {number=} opt_d
 * @param {number=} opt_e
 * @see http://developer.apple.com/library/safari/#documentation/appleapplications/reference/WebKitDOMRef/CanvasRenderingContext2D_idl/Classes/CanvasRenderingContext2D/index.html
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.setStrokeColor;

/**
 * @return {Array<number>}
 */
CanvasRenderingContext2D.prototype.getLineDash;

/**
 * @param {Array<number>} segments
 * @return {undefined}
 */
CanvasRenderingContext2D.prototype.setLineDash;

/** @type {string} */
CanvasRenderingContext2D.prototype.fillColor;

/**
 * @type {string|!CanvasGradient|!CanvasPattern}
 * @see https://html.spec.whatwg.org/multipage/scripting.html#fill-and-stroke-styles:dom-context-2d-fillstyle
 * @implicitCast
 */
CanvasRenderingContext2D.prototype.fillStyle;

/** @type {string} */
CanvasRenderingContext2D.prototype.font;

/** @type {number} */
CanvasRenderingContext2D.prototype.globalAlpha;

/** @type {string} */
CanvasRenderingContext2D.prototype.globalCompositeOperation;

/** @type {number} */
CanvasRenderingContext2D.prototype.lineWidth;

/** @type {string} */
CanvasRenderingContext2D.prototype.lineCap;

/** @type {string} */
CanvasRenderingContext2D.prototype.lineJoin;

/** @type {number} */
CanvasRenderingContext2D.prototype.miterLimit;

/** @type {number} */
CanvasRenderingContext2D.prototype.shadowBlur;

/** @type {string} */
CanvasRenderingContext2D.prototype.shadowColor;

/** @type {number} */
CanvasRenderingContext2D.prototype.shadowOffsetX;

/** @type {number} */
CanvasRenderingContext2D.prototype.shadowOffsetY;

/**
 * @type {string|!CanvasGradient|!CanvasPattern}
 * @see https://html.spec.whatwg.org/multipage/scripting.html#fill-and-stroke-styles:dom-context-2d-strokestyle
 * @implicitCast
 */
CanvasRenderingContext2D.prototype.strokeStyle;

/** @type {string} */
CanvasRenderingContext2D.prototype.strokeColor;

/** @type {string} */
CanvasRenderingContext2D.prototype.textAlign;

/** @type {string} */
CanvasRenderingContext2D.prototype.textBaseline;

/** @type {number} */
CanvasRenderingContext2D.prototype.lineDashOffset;

/**
 * @constructor
 */
function CanvasGradient() {}

/**
 * @param {number} offset
 * @param {string} color
 * @return {undefined}
 */
CanvasGradient.prototype.addColorStop = function(offset, color) {};

/**
 * @constructor
 */
function CanvasPattern() {}

/**
 * @constructor
 */
function TextMetrics() {}

/** @type {number} */
TextMetrics.prototype.width;

/**
 * @param {Uint8ClampedArray|number} dataOrWidth In the first form, this is the
 *     array of pixel data.  In the second form, this is the image width.
 * @param {number} widthOrHeight In the first form, this is the image width.  In
 *     the second form, this is the image height.
 * @param {number=} opt_height In the first form, this is the optional image
 *     height.  The second form omits this argument.
 * @see https://html.spec.whatwg.org/multipage/scripting.html#imagedata
 * @constructor
 */
function ImageData(dataOrWidth, widthOrHeight, opt_height) {}

/** @type {Uint8ClampedArray} */
ImageData.prototype.data;

/** @type {number} */
ImageData.prototype.width;

/** @type {number} */
ImageData.prototype.height;

/**
 * @constructor
 */
function ClientInformation() {}

/** @type {boolean} */
ClientInformation.prototype.onLine;

/**
 * @param {string} protocol
 * @param {string} uri
 * @param {string} title
 * @return {undefined}
 */
ClientInformation.prototype.registerProtocolHandler = function(
    protocol, uri, title) {};

/**
 * @param {string} mimeType
 * @param {string} uri
 * @param {string} title
 * @return {undefined}
 */
ClientInformation.prototype.registerContentHandler = function(
    mimeType, uri, title) {};

// HTML5 Database objects
/**
 * @constructor
 */
function Database() {}

/**
 * @type {string}
 */
Database.prototype.version;

/**
 * @param {function(!SQLTransaction) : void} callback
 * @param {(function(!SQLError) : void)=} opt_errorCallback
 * @param {Function=} opt_Callback
 * @return {undefined}
 */
Database.prototype.transaction = function(
    callback, opt_errorCallback, opt_Callback) {};

/**
 * @param {function(!SQLTransaction) : void} callback
 * @param {(function(!SQLError) : void)=} opt_errorCallback
 * @param {Function=} opt_Callback
 * @return {undefined}
 */
Database.prototype.readTransaction = function(
    callback, opt_errorCallback, opt_Callback) {};

/**
 * @param {string} oldVersion
 * @param {string} newVersion
 * @param {function(!SQLTransaction) : void} callback
 * @param {function(!SQLError) : void} errorCallback
 * @param {Function} successCallback
 * @return {undefined}
 */
Database.prototype.changeVersion = function(
    oldVersion, newVersion, callback, errorCallback, successCallback) {};

/**
 * @interface
 */
function DatabaseCallback() {}

/**
 * @param {!Database} db
 * @return {undefined}
 */
DatabaseCallback.prototype.handleEvent = function(db) {};

/**
 * @constructor
 */
function SQLError() {}

/**
 * @type {number}
 */
SQLError.prototype.code;

/**
 * @type {string}
 */
SQLError.prototype.message;

/**
 * @constructor
 */
function SQLTransaction() {}

/**
 * @param {string} sqlStatement
 * @param {Array<*>=} opt_queryArgs
 * @param {SQLStatementCallback=} opt_callback
 * @param {(function(!SQLTransaction, !SQLError) : (boolean|void))=}
 *     opt_errorCallback
 * @return {undefined}
 */
SQLTransaction.prototype.executeSql = function(
    sqlStatement, opt_queryArgs, opt_callback, opt_errorCallback) {};

/**
 * @typedef {(function(!SQLTransaction, !SQLResultSet) : void)}
 */
var SQLStatementCallback;

/**
 * @constructor
 */
function SQLResultSet() {}

/**
 * @type {number}
 */
SQLResultSet.prototype.insertId;

/**
 * @type {number}
 */
SQLResultSet.prototype.rowsAffected;

/**
 * @type {SQLResultSetRowList}
 */
SQLResultSet.prototype.rows;

/**
 * @constructor
 * @implements {IArrayLike<!Object>}
 * @see http://www.w3.org/TR/webdatabase/#sqlresultsetrowlist
 */
function SQLResultSetRowList() {}

/**
 * @type {number}
 */
SQLResultSetRowList.prototype.length;

/**
 * @param {number} index
 * @return {Object}
 * @nosideeffects
 */
SQLResultSetRowList.prototype.item = function(index) {};

/**
 * @param {string} name
 * @param {string} version
 * @param {string} description
 * @param {number} size
 * @param {(DatabaseCallback|function(Database))=} opt_callback
 * @return {Database}
 */
function openDatabase(name, version, description, size, opt_callback) {}

/**
 * @param {string} name
 * @param {string} version
 * @param {string} description
 * @param {number} size
 * @param {(DatabaseCallback|function(Database))=} opt_callback
 * @return {Database}
 */
Window.prototype.openDatabase =
    function(name, version, description, size, opt_callback) {};

/**
 * @type {boolean}
 * @see https://www.w3.org/TR/html5/embedded-content-0.html#dom-img-complete
 */
HTMLImageElement.prototype.complete;

/**
 * @type {number}
 * @see https://www.w3.org/TR/html5/embedded-content-0.html#dom-img-naturalwidth
 */
HTMLImageElement.prototype.naturalWidth;

/**
 * @type {number}
 * @see https://www.w3.org/TR/html5/embedded-content-0.html#dom-img-naturalheight
 */
HTMLImageElement.prototype.naturalHeight;

/**
 * @type {string}
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/embedded-content-1.html#attr-img-crossorigin
 */
HTMLImageElement.prototype.crossOrigin;

/**
 * This is a superposition of the Window and Worker postMessage methods.
 * @param {*} message
 * @param {(string|!Array<!Transferable>)=} opt_targetOriginOrTransfer
 * @param {(string|!Array<!MessagePort>|!Array<!Transferable>)=}
 *     opt_targetOriginOrPortsOrTransfer
 * @return {void}
 */
function postMessage(message, opt_targetOriginOrTransfer,
    opt_targetOriginOrPortsOrTransfer) {}

/**
 * The postMessage method (as implemented in Opera).
 * @param {string} message
 */
Document.prototype.postMessage = function(message) {};

/**
 * Document head accessor.
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/dom.html#the-head-element-0
 * @type {HTMLHeadElement}
 */
Document.prototype.head;

/**
 * @see https://developer.apple.com/webapps/docs/documentation/AppleApplications/Reference/SafariJSRef/DOMApplicationCache/DOMApplicationCache.html
 * @constructor
 * @implements {EventTarget}
 */
function DOMApplicationCache() {}

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
DOMApplicationCache.prototype.addEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
DOMApplicationCache.prototype.removeEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
DOMApplicationCache.prototype.dispatchEvent = function(evt) {};

/**
 * The object isn't associated with an application cache. This can occur if the
 * update process fails and there is no previous cache to revert to, or if there
 * is no manifest file.
 * @type {number}
 */
DOMApplicationCache.prototype.UNCACHED = 0;

/**
 * The cache is idle.
 * @type {number}
 */
DOMApplicationCache.prototype.IDLE = 1;

/**
 * The update has started but the resources are not downloaded yet - for
 * example, this can happen when the manifest file is fetched.
 * @type {number}
 */
DOMApplicationCache.prototype.CHECKING = 2;

/**
 * The resources are being downloaded into the cache.
 * @type {number}
 */
DOMApplicationCache.prototype.DOWNLOADING = 3;

/**
 * Resources have finished downloading and the new cache is ready to be used.
 * @type {number}
 */
DOMApplicationCache.prototype.UPDATEREADY = 4;

/**
 * The cache is obsolete.
 * @type {number}
 */
DOMApplicationCache.prototype.OBSOLETE = 5;

/**
 * The current status of the application cache.
 * @type {number}
 */
DOMApplicationCache.prototype.status;

/**
 * Sent when the update process finishes for the first time; that is, the first
 * time an application cache is saved.
 * @type {?function(!Event)}
 */
DOMApplicationCache.prototype.oncached;

/**
 * Sent when the cache update process begins.
 * @type {?function(!Event)}
 */
DOMApplicationCache.prototype.onchecking;

/**
 * Sent when the update process begins downloading resources in the manifest
 * file.
 * @type {?function(!Event)}
 */
DOMApplicationCache.prototype.ondownloading;

/**
 * Sent when an error occurs.
 * @type {?function(!Event)}
 */
DOMApplicationCache.prototype.onerror;

/**
 * Sent when the update process finishes but the manifest file does not change.
 * @type {?function(!Event)}
 */
DOMApplicationCache.prototype.onnoupdate;

/**
 * Sent when each resource in the manifest file begins to download.
 * @type {?function(!Event)}
 */
DOMApplicationCache.prototype.onprogress;

/**
 * Sent when there is an existing application cache, the update process
 * finishes, and there is a new application cache ready for use.
 * @type {?function(!Event)}
 */
DOMApplicationCache.prototype.onupdateready;

/**
 * Replaces the active cache with the latest version.
 * @throws {DOMException}
 * @return {undefined}
 */
DOMApplicationCache.prototype.swapCache = function() {};

/**
 * Manually triggers the update process.
 * @throws {DOMException}
 * @return {undefined}
 */
DOMApplicationCache.prototype.update = function() {};

/** @type {DOMApplicationCache} */
var applicationCache;

/** @type {DOMApplicationCache} */
Window.prototype.applicationCache;

/**
 * @see https://developer.mozilla.org/En/DOM/Worker/Functions_available_to_workers
 * @param {...string} var_args
 * @return {undefined}
 */
Window.prototype.importScripts = function(var_args) {};

/**
 * @see https://developer.mozilla.org/En/DOM/Worker/Functions_available_to_workers
 * @param {...string} var_args
 * @return {undefined}
 */
function importScripts(var_args) {}

/**
 * @see http://dev.w3.org/html5/workers/
 * @constructor
 * @implements {EventTarget}
 */
function WebWorker() {}

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
WebWorker.prototype.addEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
WebWorker.prototype.removeEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
WebWorker.prototype.dispatchEvent = function(evt) {};

/**
 * Stops the worker process
 * @return {undefined}
 */
WebWorker.prototype.terminate = function() {};

/**
 * Posts a message to the worker thread.
 * @param {string} message
 * @return {undefined}
 */
WebWorker.prototype.postMessage = function(message) {};

/**
 * Sent when the worker thread posts a message to its creator.
 * @type {?function(!MessageEvent<*>)}
 */
WebWorker.prototype.onmessage;

/**
 * Sent when the worker thread encounters an error.
 * TODO(tbreisacher): Should this change to function(!ErrorEvent)?
 * @type {?function(!Event)}
 */
WebWorker.prototype.onerror;

/**
 * @see http://dev.w3.org/html5/workers/
 * @constructor
 * @implements {EventTarget}
 */
function Worker(opt_arg0) {}

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
Worker.prototype.addEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
Worker.prototype.removeEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
Worker.prototype.dispatchEvent = function(evt) {};

/**
 * Stops the worker process
 * @return {undefined}
 */
Worker.prototype.terminate = function() {};

/**
 * Posts a message to the worker thread.
 * @param {*} message
 * @param {Array<!Transferable>=} opt_transfer
 * @return {undefined}
 */
Worker.prototype.postMessage = function(message, opt_transfer) {};

/**
 * Posts a message to the worker thread.
 * @param {*} message
 * @param {Array<!Transferable>=} opt_transfer
 * @return {undefined}
 */
Worker.prototype.webkitPostMessage = function(message, opt_transfer) {};

/**
 * Sent when the worker thread posts a message to its creator.
 * @type {?function(!MessageEvent<*>)}
 */
Worker.prototype.onmessage;

/**
 * Sent when the worker thread encounters an error.
 * TODO(tbreisacher): Should this change to function(!ErrorEvent)?
 * @type {?function(!Event)}
 */
Worker.prototype.onerror;

/**
 * @see http://dev.w3.org/html5/workers/
 * @param {string} scriptURL The URL of the script to run in the SharedWorker.
 * @param {string=} opt_name A name that can later be used to obtain a
 *     reference to the same SharedWorker.
 * @constructor
 * @implements {EventTarget}
 */
function SharedWorker(scriptURL, opt_name) {}

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
SharedWorker.prototype.addEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
SharedWorker.prototype.removeEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
SharedWorker.prototype.dispatchEvent = function(evt) {};

/**
 * @type {!MessagePort}
 */
SharedWorker.prototype.port;

/**
 * Called on network errors for loading the initial script.
 * TODO(tbreisacher): Should this change to function(!ErrorEvent)?
 * @type {?function(!Event)}
 */
SharedWorker.prototype.onerror;

/**
 * @see http://dev.w3.org/html5/workers/
 * @see http://www.w3.org/TR/url-1/#dom-urlutilsreadonly
 * @interface
 */
function WorkerLocation() {}

/** @type {string} */
WorkerLocation.prototype.href;

/** @type {string} */
WorkerLocation.prototype.origin;

/** @type {string} */
WorkerLocation.prototype.protocol;

/** @type {string} */
WorkerLocation.prototype.host;

/** @type {string} */
WorkerLocation.prototype.hostname;

/** @type {string} */
WorkerLocation.prototype.port;

/** @type {string} */
WorkerLocation.prototype.pathname;

/** @type {string} */
WorkerLocation.prototype.search;

/** @type {string} */
WorkerLocation.prototype.hash;

/**
 * @see http://dev.w3.org/html5/workers/
 * @interface
 * @extends {EventTarget}
 */
function WorkerGlobalScope() {}

/** @type {WorkerGlobalScope} */
WorkerGlobalScope.prototype.self;

/** @type {WorkerLocation} */
WorkerGlobalScope.prototype.location;

/**
 * Closes the worker represented by this WorkerGlobalScope.
 * @return {undefined}
 */
WorkerGlobalScope.prototype.close = function() {};

/**
 * Sent when the worker encounters an error.
 * @type {?function(!Event)}
 */
WorkerGlobalScope.prototype.onerror;

/**
 * Sent when the worker goes offline.
 * @type {?function(!Event)}
 */
WorkerGlobalScope.prototype.onoffline;

/**
 * Sent when the worker goes online.
 * @type {?function(!Event)}
 */
WorkerGlobalScope.prototype.ononline;

/**
 * @see http://dev.w3.org/html5/workers/
 * @interface
 * @extends {WorkerGlobalScope}
 */
function DedicatedWorkerGlobalScope() {}

/**
 * Posts a message to creator of this worker.
 * @param {*} message
 * @param {Array<!Transferable>=} opt_transfer
 * @return {undefined}
 */
DedicatedWorkerGlobalScope.prototype.postMessage =
    function(message, opt_transfer) {};

/**
 * Posts a message to creator of this worker.
 * @param {*} message
 * @param {Array<!Transferable>=} opt_transfer
 * @return {undefined}
 */
DedicatedWorkerGlobalScope.prototype.webkitPostMessage =
    function(message, opt_transfer) {};

/**
 * Sent when the creator posts a message to this worker.
 * @type {?function(!MessageEvent<*>)}
 */
DedicatedWorkerGlobalScope.prototype.onmessage;

/**
 * @see http://dev.w3.org/html5/workers/
 * @interface
 * @extends {WorkerGlobalScope}
 */
function SharedWorkerGlobalScope() {}

/** @type {string} */
SharedWorkerGlobalScope.prototype.name;

/**
 * Sent when a connection to this worker is opened.
 * @type {?function(!Event)}
 */
SharedWorkerGlobalScope.prototype.onconnect;

/** @type {Element} */
HTMLElement.prototype.contextMenu;

/** @type {boolean} */
HTMLElement.prototype.draggable;

/**
 * This is actually a DOMSettableTokenList property. However since that
 * interface isn't currently defined and no known browsers implement this
 * feature, just define the property for now.
 *
 * @const
 * @type {Object}
 */
HTMLElement.prototype.dropzone;

/**
 * @see http://www.w3.org/TR/html5/dom.html#dom-getelementsbyclassname
 * @param {string} classNames
 * @return {!NodeList<!Element>}
 * @nosideeffects
 */
HTMLElement.prototype.getElementsByClassName = function(classNames) {};
// NOTE: Document.prototype.getElementsByClassName is in gecko_dom.js

/** @type {boolean} */
HTMLElement.prototype.hidden;

/** @type {boolean} */
HTMLElement.prototype.spellcheck;

/**
 * @see https://dom.spec.whatwg.org/#dictdef-getrootnodeoptions
 * @typedef {{
 *   composed: boolean
 * }}
 */
var GetRootNodeOptions;

/**
 * @see https://dom.spec.whatwg.org/#dom-node-getrootnode
 * @param {GetRootNodeOptions=} opt_options
 * @return {?Node}
 */
Node.prototype.getRootNode = function(opt_options) {};

/**
 * @see http://www.w3.org/TR/components-intro/
 * @return {!ShadowRoot}
 */
HTMLElement.prototype.createShadowRoot;

/**
 * @see http://www.w3.org/TR/components-intro/
 * @return {!ShadowRoot}
 */
HTMLElement.prototype.webkitCreateShadowRoot;

/**
 * @see http://www.w3.org/TR/shadow-dom/
 * @type {ShadowRoot}
 */
HTMLElement.prototype.shadowRoot;

/**
 * @see http://www.w3.org/TR/shadow-dom/
 * @return {!NodeList<!Node>}
 */
HTMLElement.prototype.getDestinationInsertionPoints = function() {};

/**
 * @see http://www.w3.org/TR/components-intro/
 * @type {function()}
 */
HTMLElement.prototype.createdCallback;

/**
 * @see http://w3c.github.io/webcomponents/explainer/#lifecycle-callbacks
 * @type {function()}
 */
HTMLElement.prototype.attachedCallback;

/**
 * @see http://w3c.github.io/webcomponents/explainer/#lifecycle-callbacks
 * @type {function()}
 */
HTMLElement.prototype.detachedCallback;

/** @type {string} */
HTMLAnchorElement.prototype.download;

/** @type {string} */
HTMLAnchorElement.prototype.hash;

/** @type {string} */
HTMLAnchorElement.prototype.host;

/** @type {string} */
HTMLAnchorElement.prototype.hostname;

/** @type {string} */
HTMLAnchorElement.prototype.pathname;

/**
 * The 'ping' attribute is known to be supported in recent versions (as of
 * mid-2014) of Chrome, Safari, and Firefox, and is not supported in any
 * current version of Internet Explorer.
 *
 * @type {string}
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/semantics.html#hyperlink-auditing
 */
HTMLAnchorElement.prototype.ping;

/** @type {string} */
HTMLAnchorElement.prototype.port;

/** @type {string} */
HTMLAnchorElement.prototype.protocol;

/** @type {string} */
HTMLAnchorElement.prototype.search;

/** @type {string} */
HTMLAreaElement.prototype.download;

/**
 * @type {string}
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/semantics.html#hyperlink-auditing
 */
HTMLAreaElement.prototype.ping;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html-markup/iframe.html#iframe.attrs.srcdoc
 */
HTMLIFrameElement.prototype.srcdoc;

/**
 * @type {?string}
 * @see http://www.w3.org/TR/2012/WD-html5-20121025/the-iframe-element.html#attr-iframe-sandbox
 */
HTMLIFrameElement.prototype.sandbox;

/** @type {string} */
HTMLInputElement.prototype.autocomplete;

/** @type {string} */
HTMLInputElement.prototype.dirname;

/** @type {FileList} */
HTMLInputElement.prototype.files;

/**
 * @type {boolean}
 * @see https://www.w3.org/TR/html5/forms.html#dom-input-indeterminate
 */
HTMLInputElement.prototype.indeterminate;

/** @type {string} */
HTMLInputElement.prototype.list;

/** @implicitCast @type {string} */
HTMLInputElement.prototype.max;

/** @implicitCast @type {string} */
HTMLInputElement.prototype.min;

/** @type {string} */
HTMLInputElement.prototype.pattern;

/** @type {boolean} */
HTMLInputElement.prototype.multiple;

/** @type {string} */
HTMLInputElement.prototype.placeholder;

/** @type {boolean} */
HTMLInputElement.prototype.required;

/** @implicitCast @type {string} */
HTMLInputElement.prototype.step;

/** @type {Date} */
HTMLInputElement.prototype.valueAsDate;

/** @type {number} */
HTMLInputElement.prototype.valueAsNumber;

/**
 * Changes the form control's value by the value given in the step attribute
 * multiplied by opt_n.
 * @param {number=} opt_n step multiplier.  Defaults to 1.
 * @return {undefined}
 */
HTMLInputElement.prototype.stepDown = function(opt_n) {};

/**
 * Changes the form control's value by the value given in the step attribute
 * multiplied by opt_n.
 * @param {number=} opt_n step multiplier.  Defaults to 1.
 * @return {undefined}
 */
HTMLInputElement.prototype.stepUp = function(opt_n) {};



/**
 * @constructor
 * @extends {HTMLElement}
 * @see https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement
 */
function HTMLMediaElement() {}

/**
 * @type {number}
 * @const
 */
HTMLMediaElement.HAVE_NOTHING;  // = 0

/**
 * @type {number}
 * @const
 */
HTMLMediaElement.HAVE_METADATA;  // = 1

/**
 * @type {number}
 * @const
 */
HTMLMediaElement.HAVE_CURRENT_DATA;  // = 2

/**
 * @type {number}
 * @const
 */
HTMLMediaElement.HAVE_FUTURE_DATA;  // = 3

/**
 * @type {number}
 * @const
 */
HTMLMediaElement.HAVE_ENOUGH_DATA;  // = 4

/** @type {MediaError} */
HTMLMediaElement.prototype.error;

/** @type {string} */
HTMLMediaElement.prototype.src;

/** @type {string} */
HTMLMediaElement.prototype.currentSrc;

/** @type {number} */
HTMLMediaElement.prototype.networkState;

/** @type {boolean} */
HTMLMediaElement.prototype.autobuffer;

/** @type {TimeRanges} */
HTMLMediaElement.prototype.buffered;

/**
 * Loads the media element.
 * @return {undefined}
 */
HTMLMediaElement.prototype.load = function() {};

/**
 * @param {string} type Type of the element in question in question.
 * @return {string} Whether it can play the type.
 * @nosideeffects
 */
HTMLMediaElement.prototype.canPlayType = function(type) {};

/** Event handlers */

/** @type {?function(Event)} */
HTMLMediaElement.prototype.onabort;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.oncanplay;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.oncanplaythrough;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.ondurationchange;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onemptied;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onended;

/** @type {?function(Event)} */
HTMLMediaElement.prototype.onerror;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onloadeddata;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onloadedmetadata;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onloadstart;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onpause;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onplay;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onplaying;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onprogress;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onratechange;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onseeked;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onseeking;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onstalled;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onsuspend;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.ontimeupdate;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onvolumechange;

/** @type {?function(!Event)} */
HTMLMediaElement.prototype.onwaiting;

/** @type {?function(Event)} */
HTMLImageElement.prototype.onload;

/** @type {?function(Event)} */
HTMLImageElement.prototype.onerror;

/** @type {number} */
HTMLMediaElement.prototype.readyState;

/** @type {boolean} */
HTMLMediaElement.prototype.seeking;

/**
 * The current time, in seconds.
 * @type {number}
 */
HTMLMediaElement.prototype.currentTime;

/**
 * The absolute timeline offset.
 * @return {!Date}
 */
HTMLMediaElement.prototype.getStartDate = function() {};

/**
 * The length of the media in seconds.
 * @type {number}
 */
HTMLMediaElement.prototype.duration;

/** @type {boolean} */
HTMLMediaElement.prototype.paused;

/** @type {number} */
HTMLMediaElement.prototype.defaultPlaybackRate;

/** @type {number} */
HTMLMediaElement.prototype.playbackRate;

/** @type {TimeRanges} */
HTMLMediaElement.prototype.played;

/** @type {TimeRanges} */
HTMLMediaElement.prototype.seekable;

/** @type {boolean} */
HTMLMediaElement.prototype.ended;

/** @type {boolean} */
HTMLMediaElement.prototype.autoplay;

/** @type {boolean} */
HTMLMediaElement.prototype.loop;

/**
 * Starts playing the media.
 * @return {undefined}
 */
HTMLMediaElement.prototype.play = function() {};

/**
 * Pauses the media.
 * @return {undefined}
 */
HTMLMediaElement.prototype.pause = function() {};

/** @type {boolean} */
HTMLMediaElement.prototype.controls;

/**
 * The audio volume, from 0.0 (silent) to 1.0 (loudest).
 * @type {number}
 */
HTMLMediaElement.prototype.volume;

/** @type {boolean} */
HTMLMediaElement.prototype.muted;

/**
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/the-video-element.html#dom-media-addtexttrack
 * @param {string} kind Kind of the text track.
 * @param {string=} opt_label Label of the text track.
 * @param {string=} opt_language Language of the text track.
 * @return {TextTrack} TextTrack object added to the media element.
 */
HTMLMediaElement.prototype.addTextTrack =
    function(kind, opt_label, opt_language) {};

/** @type {TextTrackList} */
HTMLMediaElement.prototype.textTracks;


/**
 * @see http://www.w3.org/TR/shadow-dom/
 * @return {!NodeList<!Node>}
 */
Text.prototype.getDestinationInsertionPoints = function() {};


/**
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/the-video-element.html#texttracklist
 * @constructor
 * @implements {IArrayLike<!TextTrack>}
 */
function TextTrackList() {}

/** @type {number} */
TextTrackList.prototype.length;

/**
 * @param {string} id
 * @return {TextTrack}
 */
TextTrackList.prototype.getTrackById = function(id) {};


/**
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/the-video-element.html#texttrack
 * @constructor
 * @implements {EventTarget}
 */
function TextTrack() {}

/**
 * @param {TextTrackCue} cue
 * @return {undefined}
 */
TextTrack.prototype.addCue = function(cue) {};

/**
 * @param {TextTrackCue} cue
 * @return {undefined}
 */
TextTrack.prototype.removeCue = function(cue) {};

/**
 * @const {TextTrackCueList}
 */
TextTrack.prototype.activeCues;

/**
 * @const {TextTrackCueList}
 */
TextTrack.prototype.cues;

/**
 * @type {string}
 */
TextTrack.prototype.mode;

/**
 * @override
 * @return {undefined}
 */
TextTrack.prototype.addEventListener = function(type, listener, useCapture) {};

/**
 * @override
 * @return {boolean}
 */
TextTrack.prototype.dispatchEvent = function(evt) {};

/**
 * @override
 * @return {undefined}
 */
TextTrack.prototype.removeEventListener = function(type, listener, useCapture)
    {};



/**
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/the-video-element.html#texttrackcuelist
 * @constructor
 * @implements {IArrayLike<!TextTrackCue>}
 */
function TextTrackCueList() {}

/** @const {number} */
TextTrackCueList.prototype.length;

/**
 * @param {string} id
 * @return {TextTrackCue}
 */
TextTrackCueList.prototype.getCueById = function(id) {};



/**
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/the-video-element.html#texttrackcue
 * @constructor
 * @param {number} startTime
 * @param {number} endTime
 * @param {string} text
 */
function TextTrackCue(startTime, endTime, text) {}

/** @type {string} */
TextTrackCue.prototype.id;

/** @type {number} */
TextTrackCue.prototype.startTime;

/** @type {number} */
TextTrackCue.prototype.endTime;

/** @type {string} */
TextTrackCue.prototype.text;


/**
 * @see http://dev.w3.org/html5/webvtt/#the-vttcue-interface
 * @constructor
 * @extends {TextTrackCue}
 */
function VTTCue(startTime, endTime, text) {}


/**
 * @constructor
 * @extends {HTMLMediaElement}
 */
function HTMLAudioElement() {}

/**
 * @constructor
 * @extends {HTMLMediaElement}
 * The webkit-prefixed attributes are defined in
 * https://code.google.com/p/chromium/codesearch#chromium/src/third_party/WebKit/Source/core/html/HTMLVideoElement.idl
 */
function HTMLVideoElement() {}

/**
 * Starts displaying the video in full screen mode.
 * @return {undefined}
 */
HTMLVideoElement.prototype.webkitEnterFullscreen = function() {};

/**
 * Starts displaying the video in full screen mode.
 * @return {undefined}
 */
HTMLVideoElement.prototype.webkitEnterFullScreen = function() {};

/**
 * Stops displaying the video in full screen mode.
 * @return {undefined}
 */
HTMLVideoElement.prototype.webkitExitFullscreen = function() {};

/**
 * Stops displaying the video in full screen mode.
 * @return {undefined}
 */
HTMLVideoElement.prototype.webkitExitFullScreen = function() {};

/** @type {number} */
HTMLVideoElement.prototype.width;

/** @type {number} */
HTMLVideoElement.prototype.height;

/** @type {number} */
HTMLVideoElement.prototype.videoWidth;

/** @type {number} */
HTMLVideoElement.prototype.videoHeight;

/** @type {string} */
HTMLVideoElement.prototype.poster;

/** @type {boolean} */
HTMLVideoElement.prototype.webkitSupportsFullscreen;

/** @type {boolean} */
HTMLVideoElement.prototype.webkitDisplayingFullscreen;

/** @type {number} */
HTMLVideoElement.prototype.webkitDecodedFrameCount;

/** @type {number} */
HTMLVideoElement.prototype.webkitDroppedFrameCount;

/**
 * @typedef {{
 *    creationTime: number,
 *    totalVideoFrames: number,
 *    droppedVideoFrames: number,
 *    corruptedVideoFrames: number,
 *    totalFrameDelay: number
 * }}
 */
var VideoPlaybackQuality;

/**
 * @see https://w3c.github.io/media-source/#htmlvideoelement-extensions
 * @return {!VideoPlaybackQuality} Stats about the current playback.
 */
HTMLVideoElement.prototype.getVideoPlaybackQuality = function() {};


/**
 * @constructor
 */
function MediaError() {}

/** @type {number} */
MediaError.prototype.code;

/**
 * The fetching process for the media resource was aborted by the user agent at
 * the user's request.
 * @type {number}
 */
MediaError.MEDIA_ERR_ABORTED;

/**
 * A network error of some description caused the user agent to stop fetching
 * the media resource, after the resource was established to be usable.
 * @type {number}
 */
MediaError.MEDIA_ERR_NETWORK;

/**
 * An error of some description occurred while decoding the media resource,
 * after the resource was established to be usable.
 * @type {number}
 */
MediaError.MEDIA_ERR_DECODE;

/**
 * The media resource indicated by the src attribute was not suitable.
 * @type {number}
 */
MediaError.MEDIA_ERR_SRC_NOT_SUPPORTED;

// HTML5 MessageChannel
/**
 * @see http://dev.w3.org/html5/spec/comms.html#messagechannel
 * @constructor
 */
function MessageChannel() {}

/**
 * Returns the first port.
 * @type {!MessagePort}
 */
MessageChannel.prototype.port1;

/**
 * Returns the second port.
 * @type {!MessagePort}
 */
MessageChannel.prototype.port2;

// HTML5 MessagePort
/**
 * @see http://dev.w3.org/html5/spec/comms.html#messageport
 * @constructor
 * @implements {EventTarget}
 * @implements {Transferable}
 */
function MessagePort() {}

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
MessagePort.prototype.addEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
MessagePort.prototype.removeEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
MessagePort.prototype.dispatchEvent = function(evt) {};


/**
 * Posts a message through the channel, optionally with the given
 * Array of Transferables.
 * @param {*} message
 * @param {Array<!Transferable>=} opt_transfer
 * @return {undefined}
 */
MessagePort.prototype.postMessage = function(message, opt_transfer) {
};

/**
 * Begins dispatching messages received on the port.
 * @return {undefined}
 */
MessagePort.prototype.start = function() {};

/**
 * Disconnects the port, so that it is no longer active.
 * @return {undefined}
 */
MessagePort.prototype.close = function() {};

/**
 * TODO(blickly): Change this to MessageEvent<*> and add casts as needed
 * @type {?function(!MessageEvent<?>)}
 */
MessagePort.prototype.onmessage;

// HTML5 MessageEvent class
/**
 * @see http://dev.w3.org/html5/spec/comms.html#messageevent
 * @constructor
 * @extends {Event}
 * @template T
 * @param {string} type
 * @param {Object=} init
 */
function MessageEvent(type, init) {}

/**
 * The data payload of the message.
 * @type {T}
 */
MessageEvent.prototype.data;

/**
 * The origin of the message, for server-sent events and cross-document
 * messaging.
 * @type {string}
 */
MessageEvent.prototype.origin;

/**
 * The last event ID, for server-sent events.
 * @type {string}
 */
MessageEvent.prototype.lastEventId;

/**
 * The window that dispatched the event.
 * @type {Window}
 */
MessageEvent.prototype.source;

/**
 * The Array of MessagePorts sent with the message, for cross-document
 * messaging and channel messaging.
 * @type {Array<MessagePort>}
 */
MessageEvent.prototype.ports;

/**
 * Initializes the event in a manner analogous to the similarly-named methods in
 * the DOM Events interfaces.
 * @param {string} typeArg
 * @param {boolean} canBubbleArg
 * @param {boolean} cancelableArg
 * @param {T} dataArg
 * @param {string} originArg
 * @param {string} lastEventIdArg
 * @param {Window} sourceArg
 * @param {Array<MessagePort>} portsArg
 * @return {undefined}
 */
MessageEvent.prototype.initMessageEvent = function(typeArg, canBubbleArg,
    cancelableArg, dataArg, originArg, lastEventIdArg, sourceArg, portsArg) {};

/**
 * Initializes the event in a manner analogous to the similarly-named methods in
 * the DOM Events interfaces.
 * @param {string} namespaceURI
 * @param {string} typeArg
 * @param {boolean} canBubbleArg
 * @param {boolean} cancelableArg
 * @param {T} dataArg
 * @param {string} originArg
 * @param {string} lastEventIdArg
 * @param {Window} sourceArg
 * @param {Array<MessagePort>} portsArg
 * @return {undefined}
 */
MessageEvent.prototype.initMessageEventNS = function(namespaceURI, typeArg,
    canBubbleArg, cancelableArg, dataArg, originArg, lastEventIdArg, sourceArg,
    portsArg) {};

/**
 * HTML5 BroadcastChannel class.
 * @param {string} channelName
 * @see https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel
 * @see https://html.spec.whatwg.org/multipage/comms.html#dom-broadcastchannel
 * @implements {EventTarget}
 * @constructor
 */
function BroadcastChannel(channelName) {}

/**
 * Sends the message, of any type of object, to each BroadcastChannel object
 * listening to the same channel.
 * @param {*} message
 */
BroadcastChannel.prototype.postMessage;

/**
 * Closes the channel object, indicating it won't get any new messages, and
 * allowing it to be, eventually, garbage collected.
 * @return {void}
 */
BroadcastChannel.prototype.close;

/** @override */
BroadcastChannel.prototype.addEventListener = function(
    type, listener, useCapture) {};

/** @override */
BroadcastChannel.prototype.dispatchEvent = function(evt) {};

/** @override */
BroadcastChannel.prototype.removeEventListener = function(
    type, listener, useCapture) {};

/**
 * An EventHandler property that specifies the function to execute when a
 * message event is fired on this object.
 * @type {?function(!MessageEvent<*>)}
 */
BroadcastChannel.prototype.onmessage;

/**
 * The name of the channel.
 * @type {string}
 */
BroadcastChannel.prototype.name;

/**
 * HTML5 DataTransfer class.
 *
 * We say that this extends ClipboardData, because Event.prototype.clipboardData
 * is a DataTransfer on WebKit but a ClipboardData on IE. The interfaces are so
 * similar that it's easier to merge them.
 *
 * @see http://www.w3.org/TR/2011/WD-html5-20110113/dnd.html
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/dnd.html
 * @see http://developers.whatwg.org/dnd.html#datatransferitem
 * @constructor
 * @extends {ClipboardData}
 */
function DataTransfer() {}

/** @type {string} */
DataTransfer.prototype.dropEffect;

/** @type {string} */
DataTransfer.prototype.effectAllowed;

/** @type {Array<string>} */
DataTransfer.prototype.types;

/** @type {FileList} */
DataTransfer.prototype.files;

/**
 * @param {string=} opt_format Format for which to remove data.
 * @override
 * @return {undefined}
 */
DataTransfer.prototype.clearData = function(opt_format) {};

/**
 * @param {string} format Format for which to set data.
 * @param {string} data Data to add.
 * @override
 * @return {boolean}
 */
DataTransfer.prototype.setData = function(format, data) {};

/**
 * @param {string} format Format for which to set data.
 * @return {string} Data for the given format.
 * @override
 */
DataTransfer.prototype.getData = function(format) { return ''; };

/**
 * @param {HTMLElement} img The image to use when dragging.
 * @param {number} x Horizontal position of the cursor.
 * @param {number} y Vertical position of the cursor.
 * @return {undefined}
 */
DataTransfer.prototype.setDragImage = function(img, x, y) {};

/**
 * @param {HTMLElement} elem Element to receive drag result events.
 * @return {undefined}
 */
DataTransfer.prototype.addElement = function(elem) {};

/**
 * Addition for accessing clipboard file data that are part of the proposed
 * HTML5 spec.
 * @type {DataTransfer}
 */
MouseEvent.prototype.dataTransfer;

/**
 * @record
 * @extends {MouseEventInit}
 * @see https://w3c.github.io/uievents/#idl-wheeleventinit
 */
function WheelEventInit() {}

/** @type {undefined|number} */
WheelEventInit.prototype.deltaX;

/** @type {undefined|number} */
WheelEventInit.prototype.deltaY;

/** @type {undefined|number} */
WheelEventInit.prototype.deltaZ;

/** @type {undefined|number} */
WheelEventInit.prototype.deltaMode;

/**
 * @param {string} type
 * @param {WheelEventInit=} opt_eventInitDict
 * @see http://www.w3.org/TR/DOM-Level-3-Events/#interface-WheelEvent
 * @constructor
 * @extends {MouseEvent}
 */
function WheelEvent(type, opt_eventInitDict) {}

/** @type {number} */
WheelEvent.DOM_DELTA_PIXEL;

/** @type {number} */
WheelEvent.DOM_DELTA_LINE;

/** @type {number} */
WheelEvent.DOM_DELTA_PAGE;

/** @const {number} */
WheelEvent.prototype.deltaX;

/** @const {number} */
WheelEvent.prototype.deltaY;

/** @const {number} */
WheelEvent.prototype.deltaZ;

/** @const {number} */
WheelEvent.prototype.deltaMode;

/**
 * HTML5 DataTransferItem class.
 *
 * @see http://www.w3.org/TR/2011/WD-html5-20110113/dnd.html
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/dnd.html
 * @see http://developers.whatwg.org/dnd.html#datatransferitem
 * @constructor
 */
function DataTransferItem() {}

/** @type {string} */
DataTransferItem.prototype.kind;

/** @type {string} */
DataTransferItem.prototype.type;

/**
 * @param {function(string)} callback
 * @return {undefined}
 */
DataTransferItem.prototype.getAsString = function(callback) {};

/**
 * @return {?File} The file corresponding to this item, or null.
 * @nosideeffects
 */
DataTransferItem.prototype.getAsFile = function() { return null; };

/**
 * @return {?Entry} The Entry corresponding to this item, or null. Note that
 * despite its name,this method only works in Chrome, and will eventually
 * be renamed to {@code getAsEntry}.
 * @nosideeffects
 */
DataTransferItem.prototype.webkitGetAsEntry = function() { return null; };

/**
 * HTML5 DataTransferItemList class. There are some discrepancies in the docs
 * on the whatwg.org site. When in doubt, these prototypes match what is
 * implemented as of Chrome 30.
 *
 * @see http://www.w3.org/TR/2011/WD-html5-20110113/dnd.html
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/dnd.html
 * @see http://developers.whatwg.org/dnd.html#datatransferitem
 * @constructor
 * @implements {IArrayLike<!DataTransferItem>}
 */
function DataTransferItemList() {}

/** @type {number} */
DataTransferItemList.prototype.length;

/**
 * @param {number} i File to return from the list.
 * @return {DataTransferItem} The ith DataTransferItem in the list, or null.
 * @nosideeffects
 */
DataTransferItemList.prototype.item = function(i) { return null; };

/**
 * Adds an item to the list.
 * @param {string|!File} data Data for the item being added.
 * @param {string=} opt_type Mime type of the item being added. MUST be present
 *     if the {@code data} parameter is a string.
 * @return {DataTransferItem}
 */
DataTransferItemList.prototype.add = function(data, opt_type) {};

/**
 * Removes an item from the list.
 * @param {number} i File to remove from the list.
 * @return {undefined}
 */
DataTransferItemList.prototype.remove = function(i) {};

/**
 * Removes all items from the list.
 * @return {undefined}
 */
DataTransferItemList.prototype.clear = function() {};

/** @type {!DataTransferItemList} */
DataTransfer.prototype.items;

/**
 * @record
 * @extends {MouseEventInit}
 * @see http://w3c.github.io/html/editing.html#dictdef-drageventinit
 */
function DragEventInit() {}

/** @type {undefined|?DataTransfer} */
DragEventInit.prototype.dataTransfer;


/**
 * @see http://www.whatwg.org/specs/web-apps/current-work/multipage/dnd.html#the-dragevent-interface
 * @constructor
 * @extends {MouseEvent}
 * @param {string} type
 * @param {DragEventInit=} opt_eventInitDict
 */
function DragEvent(type, opt_eventInitDict) {}

/** @type {DataTransfer} */
DragEvent.prototype.dataTransfer;


/**
 * @record
 * @extends {EventInit}
 * @see https://www.w3.org/TR/progress-events/#progresseventinit
 */
function ProgressEventInit() {}

/** @type {undefined|boolean} */
ProgressEventInit.prototype.lengthComputable;

/** @type {undefined|number} */
ProgressEventInit.prototype.loaded;

/** @type {undefined|number} */
ProgressEventInit.prototype.total;

/**
 * @constructor
 * @param {string} type
 * @param {ProgressEventInit=} opt_progressEventInitDict
 * @extends {Event}
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ProgressEvent
 */
function ProgressEvent(type, opt_progressEventInitDict) {}

/** @type {number} */
ProgressEvent.prototype.total;

/** @type {number} */
ProgressEvent.prototype.loaded;

/** @type {boolean} */
ProgressEvent.prototype.lengthComputable;


/**
 * @constructor
 */
function TimeRanges() {}

/** @type {number} */
TimeRanges.prototype.length;

/**
 * @param {number} index The index.
 * @return {number} The start time of the range at index.
 * @throws {DOMException}
 */
TimeRanges.prototype.start = function(index) { return 0; };

/**
 * @param {number} index The index.
 * @return {number} The end time of the range at index.
 * @throws {DOMException}
 */
TimeRanges.prototype.end = function(index) { return 0; };


// HTML5 Web Socket class
/**
 * @see http://dev.w3.org/html5/websockets/
 * @constructor
 * @param {string} url
 * @param {string=} opt_protocol
 * @implements {EventTarget}
 */
function WebSocket(url, opt_protocol) {}

/**
 * The connection has not yet been established.
 * @type {number}
 */
WebSocket.CONNECTING = 0;

/**
 * The WebSocket connection is established and communication is possible.
 * @type {number}
 */
WebSocket.OPEN = 1;

/**
 * The connection is going through the closing handshake, or the close() method has been invoked.
 * @type {number}
 */
WebSocket.CLOSING = 2;

/**
 * The connection has been closed or could not be opened.
 * @type {number}
 */
WebSocket.CLOSED = 3;

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
WebSocket.prototype.addEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
WebSocket.prototype.removeEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
WebSocket.prototype.dispatchEvent = function(evt) {};

/**
 * Returns the URL value that was passed to the constructor.
 * @type {string}
 */
WebSocket.prototype.url;

/**
 * Represents the state of the connection.
 * @type {number}
 */
WebSocket.prototype.readyState;

/**
 * Returns the number of bytes that have been queued but not yet sent.
 * @type {number}
 */
WebSocket.prototype.bufferedAmount;

/**
 * An event handler called on open event.
 * @type {?function(!Event)}
 */
WebSocket.prototype.onopen;

/**
 * An event handler called on message event.
 * TODO(blickly): Change this to MessageEvent<*> and add casts as needed
 * @type {?function(!MessageEvent<?>)}
 */
WebSocket.prototype.onmessage;

/**
 * An event handler called on close event.
 * @type {?function(!Event)}
 */
WebSocket.prototype.onclose;

/**
 * Transmits data using the connection.
 * @param {string|ArrayBuffer|ArrayBufferView} data
 * @return {boolean}
 */
WebSocket.prototype.send = function(data) {};

/**
 * Closes the Web Socket connection or connection attempt, if any.
 * @param {number=} opt_code
 * @param {string=} opt_reason
 * @return {undefined}
 */
WebSocket.prototype.close = function(opt_code, opt_reason) {};

/**
 * @type {string} Sets the type of data (blob or arraybuffer) for binary data.
 */
WebSocket.prototype.binaryType;

// HTML5 History
/**
 * @constructor
 */
function History() {}

/**
 * Pushes a new state into the session history.
 * @see http://www.w3.org/TR/html5/history.html#the-history-interface
 * @param {*} data New state.
 * @param {string} title The title for a new session history entry.
 * @param {string=} opt_url The URL for a new session history entry.
 * @return {undefined}
 */
History.prototype.pushState = function(data, title, opt_url) {};

/**
 * Replaces the current state in the session history.
 * @see http://www.w3.org/TR/html5/history.html#the-history-interface
 * @param {*} data New state.
 * @param {string} title The title for a session history entry.
 * @param {string=} opt_url The URL for a new session history entry.
 * @return {undefined}
 */
History.prototype.replaceState = function(data, title, opt_url) {};

/**
 * Pending state object.
 * @see https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Manipulating_the_browser_history#Reading_the_current_state
 * @type {*}
 */
History.prototype.state;

/**
 * Allows web applications to explicitly set default scroll restoration behavior
 * on history navigation. This property can be either auto or manual.
 *
 * Non-standard. Only supported in Chrome 46+.
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/API/History
 * @see https://majido.github.io/scroll-restoration-proposal/history-based-api.html
 * @type {string}
 */
History.prototype.scrollRestoration;

/**
 * @see http://www.whatwg.org/specs/web-apps/current-work/#popstateevent
 * @constructor
 * @extends {Event}
 *
 * @param {string} type
 * @param {{state: *}=} opt_eventInitDict
 */
function PopStateEvent(type, opt_eventInitDict) {}

/**
 * @type {*}
 */
PopStateEvent.prototype.state;

/**
 * Initializes the event after it has been created with document.createEvent
 * @param {string} typeArg
 * @param {boolean} canBubbleArg
 * @param {boolean} cancelableArg
 * @param {*} stateArg
 * @return {undefined}
 */
PopStateEvent.prototype.initPopStateEvent = function(typeArg, canBubbleArg,
    cancelableArg, stateArg) {};

/**
 * @see http://www.whatwg.org/specs/web-apps/current-work/#hashchangeevent
 * @constructor
 * @extends {Event}
 *
 * @param {string} type
 * @param {{oldURL: string, newURL: string}=} opt_eventInitDict
 */
function HashChangeEvent(type, opt_eventInitDict) {}

/** @type {string} */
HashChangeEvent.prototype.oldURL;

/** @type {string} */
HashChangeEvent.prototype.newURL;

/**
 * Initializes the event after it has been created with document.createEvent
 * @param {string} typeArg
 * @param {boolean} canBubbleArg
 * @param {boolean} cancelableArg
 * @param {string} oldURLArg
 * @param {string} newURLArg
 * @return {undefined}
 */
HashChangeEvent.prototype.initHashChangeEvent = function(typeArg, canBubbleArg,
    cancelableArg, oldURLArg, newURLArg) {};

/**
 * @see http://www.whatwg.org/specs/web-apps/current-work/#pagetransitionevent
 * @constructor
 * @extends {Event}
 *
 * @param {string} type
 * @param {{persisted: boolean}=} opt_eventInitDict
 */
function PageTransitionEvent(type, opt_eventInitDict) {}

/** @type {boolean} */
PageTransitionEvent.prototype.persisted;

/**
 * Initializes the event after it has been created with document.createEvent
 * @param {string} typeArg
 * @param {boolean} canBubbleArg
 * @param {boolean} cancelableArg
 * @param {*} persistedArg
 * @return {undefined}
 */
PageTransitionEvent.prototype.initPageTransitionEvent = function(typeArg,
    canBubbleArg, cancelableArg, persistedArg) {};

/**
 * @constructor
 * @implements {IArrayLike<!File>}
 */
function FileList() {}

/** @type {number} */
FileList.prototype.length;

/**
 * @param {number} i File to return from the list.
 * @return {File} The ith file in the list.
 * @nosideeffects
 */
FileList.prototype.item = function(i) { return null; };

/**
 * @type {boolean}
 * @see http://dev.w3.org/2006/webapi/XMLHttpRequest-2/#withcredentials
 */
XMLHttpRequest.prototype.withCredentials;

/**
 * @type {?function(!ProgressEvent): void}
 * @see https://xhr.spec.whatwg.org/#handler-xhr-onloadstart
 */
XMLHttpRequest.prototype.onloadstart;

/**
 * @type {?function(!ProgressEvent): void}
 * @see https://dvcs.w3.org/hg/xhr/raw-file/tip/Overview.html#handler-xhr-onprogress
 */
XMLHttpRequest.prototype.onprogress;

/**
 * @type {?function(!ProgressEvent): void}
 * @see https://xhr.spec.whatwg.org/#handler-xhr-onabort
 */
XMLHttpRequest.prototype.onabort;

/**
 * @type {?function(!ProgressEvent): void}
 * @see https://xhr.spec.whatwg.org/#handler-xhr-onload
 */
XMLHttpRequest.prototype.onload;

/**
 * @type {?function(!ProgressEvent): void}
 * @see https://xhr.spec.whatwg.org/#handler-xhr-ontimeout
 */
XMLHttpRequest.prototype.ontimeout;

/**
 * @type {?function(!ProgressEvent): void}
 * @see https://xhr.spec.whatwg.org/#handler-xhr-onloadend
 */
XMLHttpRequest.prototype.onloadend;

/**
 * @type {XMLHttpRequestUpload}
 * @see http://dev.w3.org/2006/webapi/XMLHttpRequest-2/#the-upload-attribute
 */
XMLHttpRequest.prototype.upload;

/**
 * @param {string} mimeType The mime type to override with.
 * @return {undefined}
 */
XMLHttpRequest.prototype.overrideMimeType = function(mimeType) {};

/**
 * @type {string}
 * @see http://dev.w3.org/2006/webapi/XMLHttpRequest-2/#the-responsetype-attribute
 */
XMLHttpRequest.prototype.responseType;

/**
 * @type {?(ArrayBuffer|Blob|Document|Object|string)}
 * @see http://dev.w3.org/2006/webapi/XMLHttpRequest-2/#the-response-attribute
 */
XMLHttpRequest.prototype.response;


/**
 * @type {ArrayBuffer}
 * Implemented as a draft spec in Firefox 4 as the way to get a requested array
 * buffer from an XMLHttpRequest.
 * @see https://developer.mozilla.org/En/Using_XMLHttpRequest#Receiving_binary_data_using_JavaScript_typed_arrays
 *
 * This property is not used anymore and should be removed.
 * @see https://github.com/google/closure-compiler/pull/1389
 */
XMLHttpRequest.prototype.mozResponseArrayBuffer;

/**
 * XMLHttpRequestEventTarget defines events for checking the status of a data
 * transfer between a client and a server. This should be a common base class
 * for XMLHttpRequest and XMLHttpRequestUpload.
 *
 * @constructor
 * @implements {EventTarget}
 */
function XMLHttpRequestEventTarget() {}

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
XMLHttpRequestEventTarget.prototype.addEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
XMLHttpRequestEventTarget.prototype.removeEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
XMLHttpRequestEventTarget.prototype.dispatchEvent = function(evt) {};

/**
 * An event target to track the status of an upload.
 *
 * @constructor
 * @extends {XMLHttpRequestEventTarget}
 */
function XMLHttpRequestUpload() {}

/**
 * @type {?function(!ProgressEvent): void}
 * @see https://dvcs.w3.org/hg/xhr/raw-file/tip/Overview.html#handler-xhr-onprogress
 */
XMLHttpRequestUpload.prototype.onprogress;

/**
 * @param {number=} opt_width
 * @param {number=} opt_height
 * @constructor
 * @extends {HTMLImageElement}
 */
function Image(opt_width, opt_height) {}


/**
 * Dataset collection.
 * This is really a DOMStringMap but it behaves close enough to an object to
 * pass as an object.
 * @type {Object}
 * @const
 */
HTMLElement.prototype.dataset;


/**
 * @constructor
 * @implements {IArrayLike<string>}
 * @see https://dom.spec.whatwg.org/#interface-domtokenlist
 */
function DOMTokenList() {}

/**
 * Returns the number of CSS classes applied to this Element.
 * @type {number}
 */
DOMTokenList.prototype.length;

/**
 * @param {number} index The index of the item to return.
 * @return {string} The CSS class at the specified index.
 * @nosideeffects
 */
DOMTokenList.prototype.item = function(index) {};

/**
 * @param {string} token The CSS class to check for.
 * @return {boolean} Whether the CSS class has been applied to the Element.
 * @nosideeffects
 */
DOMTokenList.prototype.contains = function(token) {};

/**
 * @param {...string} var_args The CSS class(es) to add to this element.
 * @return {undefined}
 */
DOMTokenList.prototype.add = function(var_args) {};

/**
 * @param {...string} var_args The CSS class(es) to remove from this element.
 * @return {undefined}
 */
DOMTokenList.prototype.remove = function(var_args) {};

/**
 * @param {string} token The CSS class to toggle from this element.
 * @param {boolean=} opt_force True to add the class whether it exists
 *     or not. False to remove the class whether it exists or not.
 *     This argument is not supported on IE 10 and below, according to
 *     the MDN page linked below.
 * @return {boolean} False if the token was removed; True otherwise.
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Element.classList
 */
DOMTokenList.prototype.toggle = function(token, opt_force) {};

/**
 * @return {string} A stringified representation of CSS classes.
 * @nosideeffects
 * @override
 */
DOMTokenList.prototype.toString = function() {};

/**
 * A better interface to CSS classes than className.
 * @type {!DOMTokenList}
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Element/classList
 * @const
 */
Element.prototype.classList;

/**
 * Constraint Validation API properties and methods
 * @see http://www.w3.org/TR/2009/WD-html5-20090423/forms.html#the-constraint-validation-api
 */

/** @return {boolean} */
HTMLFormElement.prototype.checkValidity = function() {};

/** @return {boolean} */
HTMLFormElement.prototype.reportValidity = function() {};

/** @type {boolean} */
HTMLFormElement.prototype.noValidate;

/** @constructor */
function ValidityState() {}

/** @type {boolean} */
ValidityState.prototype.badInput;

/** @type {boolean} */
ValidityState.prototype.customError;

/** @type {boolean} */
ValidityState.prototype.patternMismatch;

/** @type {boolean} */
ValidityState.prototype.rangeOverflow;

/** @type {boolean} */
ValidityState.prototype.rangeUnderflow;

/** @type {boolean} */
ValidityState.prototype.stepMismatch;

/** @type {boolean} */
ValidityState.prototype.typeMismatch;

/** @type {boolean} */
ValidityState.prototype.tooLong;

/** @type {boolean} */
ValidityState.prototype.tooShort;

/** @type {boolean} */
ValidityState.prototype.valid;

/** @type {boolean} */
ValidityState.prototype.valueMissing;


/** @type {boolean} */
HTMLButtonElement.prototype.autofocus;

/**
 * @const
 * @type {NodeList<!HTMLLabelElement>}
 */
HTMLButtonElement.prototype.labels;

/** @type {string} */
HTMLButtonElement.prototype.validationMessage;

/**
 * @const
 * @type {ValidityState}
 */
HTMLButtonElement.prototype.validity;

/** @type {boolean} */
HTMLButtonElement.prototype.willValidate;

/** @return {boolean} */
HTMLButtonElement.prototype.checkValidity = function() {};

/** @return {boolean} */
HTMLButtonElement.prototype.reportValidity = function() {};

/**
 * @param {string} message
 * @return {undefined}
 */
HTMLButtonElement.prototype.setCustomValidity = function(message) {};

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/forms.html#attr-fs-formaction
 */
HTMLButtonElement.prototype.formAction;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/forms.html#attr-fs-formenctype
 */
HTMLButtonElement.prototype.formEnctype;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/forms.html#attr-fs-formmethod
 */
HTMLButtonElement.prototype.formMethod;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/forms.html#attr-fs-formtarget
 */
HTMLButtonElement.prototype.formTarget;

/** @type {boolean} */
HTMLInputElement.prototype.autofocus;

/** @type {boolean} */
HTMLInputElement.prototype.formNoValidate;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/forms.html#attr-fs-formaction
 */
HTMLInputElement.prototype.formAction;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/forms.html#attr-fs-formenctype
 */
HTMLInputElement.prototype.formEnctype;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/forms.html#attr-fs-formmethod
 */
HTMLInputElement.prototype.formMethod;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/forms.html#attr-fs-formtarget
 */
HTMLInputElement.prototype.formTarget;

/**
 * @const
 * @type {NodeList<!HTMLLabelElement>}
 */
HTMLInputElement.prototype.labels;

/** @type {string} */
HTMLInputElement.prototype.validationMessage;

/**
 * @const
 * @type {ValidityState}
 */
HTMLInputElement.prototype.validity;

/** @type {boolean} */
HTMLInputElement.prototype.willValidate;

/** @return {boolean} */
HTMLInputElement.prototype.checkValidity = function() {};

/** @return {boolean} */
HTMLInputElement.prototype.reportValidity = function() {};

/**
 * @param {string} message
 * @return {undefined}
 */
HTMLInputElement.prototype.setCustomValidity = function(message) {};

/** @type {Element} */
HTMLLabelElement.prototype.control;

/** @type {boolean} */
HTMLSelectElement.prototype.autofocus;

/**
 * @const
 * @type {NodeList<!HTMLLabelElement>}
 */
HTMLSelectElement.prototype.labels;

/** @type {HTMLCollection<!HTMLOptionElement>} */
HTMLSelectElement.prototype.selectedOptions;

/** @type {string} */
HTMLSelectElement.prototype.validationMessage;

/**
 * @const
 * @type {ValidityState}
 */
HTMLSelectElement.prototype.validity;

/** @type {boolean} */
HTMLSelectElement.prototype.willValidate;

/** @return {boolean} */
HTMLSelectElement.prototype.checkValidity = function() {};

/** @return {boolean} */
HTMLSelectElement.prototype.reportValidity = function() {};

/**
 * @param {string} message
 * @return {undefined}
 */
HTMLSelectElement.prototype.setCustomValidity = function(message) {};

/** @type {boolean} */
HTMLTextAreaElement.prototype.autofocus;

/**
 * @const
 * @type {NodeList<!HTMLLabelElement>}
 */
HTMLTextAreaElement.prototype.labels;

/** @type {string} */
HTMLTextAreaElement.prototype.validationMessage;

/**
 * @const
 * @type {ValidityState}
 */
HTMLTextAreaElement.prototype.validity;

/** @type {boolean} */
HTMLTextAreaElement.prototype.willValidate;

/** @return {boolean} */
HTMLTextAreaElement.prototype.checkValidity = function() {};

/** @return {boolean} */
HTMLTextAreaElement.prototype.reportValidity = function() {};

/**
 * @param {string} message
 * @return {undefined}
 */
HTMLTextAreaElement.prototype.setCustomValidity = function(message) {};

/**
 * @constructor
 * @extends {HTMLElement}
 * @see http://www.w3.org/TR/html5/the-embed-element.html#htmlembedelement
 */
function HTMLEmbedElement() {}

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/dimension-attributes.html#dom-dim-width
 */
HTMLEmbedElement.prototype.width;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/dimension-attributes.html#dom-dim-height
 */
HTMLEmbedElement.prototype.height;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/the-embed-element.html#dom-embed-src
 */
HTMLEmbedElement.prototype.src;

/**
 * @type {string}
 * @see http://www.w3.org/TR/html5/the-embed-element.html#dom-embed-type
 */
HTMLEmbedElement.prototype.type;

// Fullscreen APIs.

/**
 * @see http://www.w3.org/TR/2012/WD-fullscreen-20120703/#dom-element-requestfullscreen
 * @return {undefined}
 */
Element.prototype.requestFullscreen = function() {};

/**
 * @type {boolean}
 * @see http://www.w3.org/TR/2012/WD-fullscreen-20120703/#dom-document-fullscreenenabled
 */
Document.prototype.fullscreenEnabled;

/**
 * @type {Element}
 * @see http://www.w3.org/TR/2012/WD-fullscreen-20120703/#dom-document-fullscreenelement
 */
Document.prototype.fullscreenElement;

/**
 * @see http://www.w3.org/TR/2012/WD-fullscreen-20120703/#dom-document-exitfullscreen
 * @return {undefined}
 */
Document.prototype.exitFullscreen = function() {};

// Externs definitions of browser current implementations.
// Firefox 10 implementation.
Element.prototype.mozRequestFullScreen = function() {};

Element.prototype.mozRequestFullScreenWithKeys = function() {};

/** @type {boolean} */
Document.prototype.mozFullScreen;

Document.prototype.mozCancelFullScreen = function() {};

/** @type {Element} */
Document.prototype.mozFullScreenElement;

/** @type {boolean} */
Document.prototype.mozFullScreenEnabled;

// Chrome 21 implementation.
/**
 * The current fullscreen element for the document is set to this element.
 * Valid only for Webkit browsers.
 * @param {number=} opt_allowKeyboardInput Whether keyboard input is desired.
 *     Should use ALLOW_KEYBOARD_INPUT constant.
 * @return {undefined}
 */
Element.prototype.webkitRequestFullScreen = function(opt_allowKeyboardInput) {};

/**
 * The current fullscreen element for the document is set to this element.
 * Valid only for Webkit browsers.
 * @param {number=} opt_allowKeyboardInput Whether keyboard input is desired.
 *     Should use ALLOW_KEYBOARD_INPUT constant.
 * @return {undefined}
 */
Element.prototype.webkitRequestFullscreen = function(opt_allowKeyboardInput) {};

/** @type {boolean} */
Document.prototype.webkitIsFullScreen;

Document.prototype.webkitCancelFullScreen = function() {};

/** @type {boolean} */
Document.prototype.webkitFullscreenEnabled;

/** @type {Element} */
Document.prototype.webkitCurrentFullScreenElement;

/** @type {Element} */
Document.prototype.webkitFullscreenElement;

/** @type {boolean} */
Document.prototype.webkitFullScreenKeyboardInputAllowed;

// IE 11 implementation.
// http://msdn.microsoft.com/en-us/library/ie/dn265028(v=vs.85).aspx
/** @return {void} */
Element.prototype.msRequestFullscreen = function() {};

/** @return {void} */
Element.prototype.msExitFullscreen = function() {};

/** @type {boolean} */
Document.prototype.msFullscreenEnabled;

/** @type {Element} */
Document.prototype.msFullscreenElement;

/** @type {number} */
Element.ALLOW_KEYBOARD_INPUT = 1;

/** @type {number} */
Element.prototype.ALLOW_KEYBOARD_INPUT = 1;


/**
 * @typedef {{
 *   childList: (boolean|undefined),
 *   attributes: (boolean|undefined),
 *   characterData: (boolean|undefined),
 *   subtree: (boolean|undefined),
 *   attributeOldValue: (boolean|undefined),
 *   characterDataOldValue: (boolean|undefined),
 *   attributeFilter: (!Array<string>|undefined)
 * }}
 */
var MutationObserverInit;


/** @constructor */
function MutationRecord() {}

/** @type {string} */
MutationRecord.prototype.type;

/** @type {Node} */
MutationRecord.prototype.target;

/** @type {NodeList<!Node>} */
MutationRecord.prototype.addedNodes;

/** @type {NodeList<!Node>} */
MutationRecord.prototype.removedNodes;

/** @type {Node} */
MutationRecord.prototype.previousSibling;

/** @type {Node} */
MutationRecord.prototype.nextSibling;

/** @type {?string} */
MutationRecord.prototype.attributeName;

/** @type {?string} */
MutationRecord.prototype.attributeNamespace;

/** @type {?string} */
MutationRecord.prototype.oldValue;


/**
 * @see http://www.w3.org/TR/domcore/#mutation-observers
 * @param {function(Array<MutationRecord>, MutationObserver)} callback
 * @constructor
 */
function MutationObserver(callback) {}

/**
 * @param {Node} target
 * @param {MutationObserverInit=} options
 * @return {undefined}
 */
MutationObserver.prototype.observe = function(target, options) {};

MutationObserver.prototype.disconnect = function() {};

/**
 * @return {!Array<!MutationRecord>}
 */
MutationObserver.prototype.takeRecords = function() {};

/**
 * @type {function(new:MutationObserver, function(Array<MutationRecord>))}
 */
Window.prototype.WebKitMutationObserver;

/**
 * @type {function(new:MutationObserver, function(Array<MutationRecord>))}
 */
Window.prototype.MozMutationObserver;


/**
 * @see http://www.w3.org/TR/page-visibility/
 * @type {VisibilityState}
 */
Document.prototype.visibilityState;

/**
 * @type {string}
 */
Document.prototype.mozVisibilityState;

/**
 * @type {string}
 */
Document.prototype.webkitVisibilityState;

/**
 * @type {string}
 */
Document.prototype.msVisibilityState;

/**
 * @see http://www.w3.org/TR/page-visibility/
 * @type {boolean}
 */
Document.prototype.hidden;

/**
 * @type {boolean}
 */
Document.prototype.mozHidden;

/**
 * @type {boolean}
 */
Document.prototype.webkitHidden;

/**
 * @type {boolean}
 */
Document.prototype.msHidden;

/**
 * @see http://www.w3.org/TR/components-intro/
 * @see http://w3c.github.io/webcomponents/spec/custom/#extensions-to-document-interface-to-register
 * @param {string} type
 * @param {{extends: (string|undefined), prototype: (Object|undefined)}=} options
 * @return {!Function} a constructor for the new tag. A generic function is the best we
 *     can do here as it allows the return value to be annotated properly
 *     at the call site.
 */
Document.prototype.registerElement = function(type, options) {};

/**
 * This method is deprecated and should be removed by the end of 2014.
 * @see http://www.w3.org/TR/components-intro/
 * @see http://w3c.github.io/webcomponents/spec/custom/#extensions-to-document-interface-to-register
 * @param {string} type
 * @param {{extends: (string|undefined), prototype: (Object|undefined)}} options
 */
Document.prototype.register = function(type, options) {};

/**
 * @type {!FontFaceSet}
 * @see http://dev.w3.org/csswg/css-font-loading/#dom-fontfacesource-fonts
 */
Document.prototype.fonts;


/**
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Document/currentScript
 */
Document.prototype.currentScript;

/**
 * Definition of ShadowRoot interface,
 * @see http://www.w3.org/TR/shadow-dom/#api-shadow-root
 * @constructor
 * @extends {DocumentFragment}
 */
function ShadowRoot() {}

/**
 * The host element that a ShadowRoot is attached to.
 * Note: this is not yet W3C standard but is undergoing development.
 * W3C feature tracking bug:
 * https://www.w3.org/Bugs/Public/show_bug.cgi?id=22399
 * Draft specification:
 * https://dvcs.w3.org/hg/webcomponents/raw-file/6743f1ace623/spec/shadow/index.html#shadow-root-object
 * @type {!Element}
 */
ShadowRoot.prototype.host;

/**
 * @param {string} id id.
 * @return {HTMLElement}
 * @nosideeffects
 */
ShadowRoot.prototype.getElementById = function(id) {};


/**
 * @param {string} className
 * @return {!NodeList<!Element>}
 * @nosideeffects
 */
ShadowRoot.prototype.getElementsByClassName = function(className) {};


/**
 * @param {string} tagName
 * @return {!NodeList<!Element>}
 * @nosideeffects
 */
ShadowRoot.prototype.getElementsByTagName = function(tagName) {};


/**
 * @param {string} namespace
 * @param {string} localName
 * @return {!NodeList<!Element>}
 * @nosideeffects
 */
ShadowRoot.prototype.getElementsByTagNameNS = function(namespace, localName) {};


/**
 * @return {Selection}
 * @nosideeffects
 */
ShadowRoot.prototype.getSelection = function() {};


/**
 * @param {number} x
 * @param {number} y
 * @return {Element}
 * @nosideeffects
 */
ShadowRoot.prototype.elementFromPoint = function(x, y) {};


/**
 * @type {boolean}
 */
ShadowRoot.prototype.applyAuthorStyles;


/**
 * @type {boolean}
 */
ShadowRoot.prototype.resetStyleInheritance;


/**
 * @type {Element}
 */
ShadowRoot.prototype.activeElement;


/**
 * @type {?ShadowRoot}
 */
ShadowRoot.prototype.olderShadowRoot;


/**
 * @type {string}
 */
ShadowRoot.prototype.innerHTML;


/**
 * @type {!StyleSheetList}
 */
ShadowRoot.prototype.styleSheets;



/**
 * @see http://www.w3.org/TR/shadow-dom/#the-content-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLContentElement() {}

/**
 * @type {!string}
 */
HTMLContentElement.prototype.select;

/**
 * @return {!NodeList<!Node>}
 */
HTMLContentElement.prototype.getDistributedNodes = function() {};


/**
 * @see http://www.w3.org/TR/shadow-dom/#the-shadow-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLShadowElement() {}

/**
 * @return {!NodeList<!Node>}
 */
HTMLShadowElement.prototype.getDistributedNodes = function() {};


/**
 * @see http://www.w3.org/TR/html5/webappapis.html#the-errorevent-interface
 *
 * @constructor
 * @extends {Event}
 *
 * @param {string} type
 * @param {ErrorEventInit=} opt_eventInitDict
 */
function ErrorEvent(type, opt_eventInitDict) {}

/** @const {string} */
ErrorEvent.prototype.message;

/** @const {string} */
ErrorEvent.prototype.filename;

/** @const {number} */
ErrorEvent.prototype.lineno;

/** @const {number} */
ErrorEvent.prototype.colno;

/** @const {*} */
ErrorEvent.prototype.error;


/**
 * @record
 * @extends {EventInit}
 * @see https://www.w3.org/TR/html5/webappapis.html#erroreventinit
 */
function ErrorEventInit() {}

/** @type {undefined|string} */
ErrorEventInit.prototype.message;

/** @type {undefined|string} */
ErrorEventInit.prototype.filename;

/** @type {undefined|number} */
ErrorEventInit.prototype.lineno;

/** @type {undefined|number} */
ErrorEventInit.prototype.colno;

/** @type {*} */
ErrorEventInit.prototype.error;


/**
 * @see http://dom.spec.whatwg.org/#dom-domimplementation-createhtmldocument
 * @param {string=} opt_title A title to give the new HTML document
 * @return {!HTMLDocument}
 */
DOMImplementation.prototype.createHTMLDocument = function(opt_title) {};



/**
 * @constructor
 * @see https://html.spec.whatwg.org/multipage/embedded-content.html#the-picture-element
 * @extends {HTMLElement}
 */
function HTMLPictureElement() {}

/**
 * @constructor
 * @see https://html.spec.whatwg.org/multipage/embedded-content.html#the-picture-element
 * @extends {HTMLElement}
 */
function HTMLSourceElement() {}

/** @type {string} */
HTMLSourceElement.prototype.media;

/** @type {string} */
HTMLSourceElement.prototype.sizes;

/** @type {string} */
HTMLSourceElement.prototype.src;

/** @type {string} */
HTMLSourceElement.prototype.srcset;

/** @type {string} */
HTMLSourceElement.prototype.type;

/** @type {string} */
HTMLImageElement.prototype.sizes;

/** @type {string} */
HTMLImageElement.prototype.srcset;


/**
 * 4.11 Interactive elements
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html
 */

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#the-details-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLDetailsElement() {}

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-details-open
 * @type {boolean}
 */
HTMLDetailsElement.prototype.open;


// As of 2/20/2015, <summary> has no special web IDL interface nor global
// constructor (i.e. HTMLSummaryElement).


/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-menu-type
 * @type {string}
 */
HTMLMenuElement.prototype.type;

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-menu-label
 * @type {string}
 */
HTMLMenuElement.prototype.label;


/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#the-menuitem-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLMenuItemElement() {}

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-menuitem-type
 * @type {string}
 */
HTMLMenuItemElement.prototype.type;

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-menuitem-label
 * @type {string}
 */
HTMLMenuItemElement.prototype.label;

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-menuitem-icon
 * @type {string}
 */
HTMLMenuItemElement.prototype.icon;

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-menuitem-disabled
 * @type {boolean}
 */
HTMLMenuItemElement.prototype.disabled;

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-menuitem-checked
 * @type {boolean}
 */
HTMLMenuItemElement.prototype.checked;

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-menuitem-radiogroup
 * @type {string}
 */
HTMLMenuItemElement.prototype.radiogroup;

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-menuitem-default
 * @type {boolean}
 */
HTMLMenuItemElement.prototype.default;

// TODO(dbeam): add HTMLMenuItemElement.prototype.command if it's implemented.


/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#relatedevent
 * @param {string} type
 * @param {{relatedTarget: (EventTarget|undefined)}=} opt_eventInitDict
 * @constructor
 * @extends {Event}
 */
function RelatedEvent(type, opt_eventInitDict) {}

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-relatedevent-relatedtarget
 * @type {EventTarget|undefined}
 */
RelatedEvent.prototype.relatedTarget;


/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#the-dialog-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLDialogElement() {}

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-dialog-open
 * @type {boolean}
 */
HTMLDialogElement.prototype.open;

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-dialog-returnvalue
 * @type {string}
 */
HTMLDialogElement.prototype.returnValue;

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-dialog-show
 * @param {(MouseEvent|Element)=} opt_anchor
 * @return {undefined}
 */
HTMLDialogElement.prototype.show = function(opt_anchor) {};

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-dialog-showmodal
 * @param {(MouseEvent|Element)=} opt_anchor
 * @return {undefined}
 */
HTMLDialogElement.prototype.showModal = function(opt_anchor) {};

/**
 * @see http://www.w3.org/html/wg/drafts/html/master/interactive-elements.html#dom-dialog-close
 * @param {string=} opt_returnValue
 * @return {undefined}
 */
HTMLDialogElement.prototype.close = function(opt_returnValue) {};


/**
 * @see https://html.spec.whatwg.org/multipage/scripting.html#the-template-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLTemplateElement() {}

/**
 * @see https://html.spec.whatwg.org/multipage/scripting.html#the-template-element
 * @type {!DocumentFragment}
 */
HTMLTemplateElement.prototype.content;


/**
 * @type {?Document}
 * @see w3c_dom2.js
 * @see http://www.w3.org/TR/html-imports/#interface-import
 */
HTMLLinkElement.prototype.import;


/**
 * @return {boolean}
 * @see https://www.w3.org/TR/html5/forms.html#dom-fieldset-elements
 */
HTMLFieldSetElement.prototype.checkValidity = function() {};

/**
 * @type {HTMLCollection}
 * @see https://www.w3.org/TR/html5/forms.html#dom-fieldset-elements
 */
HTMLFieldSetElement.prototype.elements;

/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/forms.html#the-fieldset-element
 */
HTMLFieldSetElement.prototype.name;

/**
 * @param {string} message
 * @see https://www.w3.org/TR/html5/forms.html#dom-fieldset-elements
 * @return {undefined}
 */
HTMLFieldSetElement.prototype.setCustomValidity = function(message) {};

/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/forms.html#dom-fieldset-type
 */
HTMLFieldSetElement.prototype.type;

/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/forms.html#the-fieldset-element
 */
HTMLFieldSetElement.prototype.validationMessage;

/**
 * @type {ValidityState}
 * @see https://www.w3.org/TR/html5/forms.html#the-fieldset-element
 */
HTMLFieldSetElement.prototype.validity;

/**
 * @type {boolean}
 * @see https://www.w3.org/TR/html5/forms.html#the-fieldset-element
 */
HTMLFieldSetElement.prototype.willValidate;

/**
 * @constructor
 * @extends {NodeList<T>}
 * @template T
 * @see https://html.spec.whatwg.org/multipage/infrastructure.html#radionodelist
 */
function RadioNodeList() {}



/**
 * @see https://html.spec.whatwg.org/multipage/forms.html#the-datalist-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLDataListElement() {}


/** @type {HTMLCollection<!HTMLOptionElement>} */
HTMLDataListElement.prototype.options;



/**
 * @see https://html.spec.whatwg.org/multipage/forms.html#the-output-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLOutputElement() {}

/**
 * @const {!DOMTokenList}
 */
HTMLOutputElement.prototype.htmlFor;

/**
 * @type {HTMLFormElement}
 */
HTMLOutputElement.prototype.form;

/**
 * @type {string}
 */
HTMLOutputElement.prototype.name;

/**
 * @const {string}
 */
HTMLOutputElement.prototype.type;

/**
 * @type {string}
 */
HTMLOutputElement.prototype.defaultValue;

/**
 * @type {string}
 */
HTMLOutputElement.prototype.value;

/**
 * @const {NodeList<!HTMLLabelElement>}
 */
HTMLOutputElement.prototype.labels;

/** @type {string} */
HTMLOutputElement.prototype.validationMessage;

/**
 * @const {ValidityState}
 */
HTMLOutputElement.prototype.validity;

/** @type {boolean} */
HTMLOutputElement.prototype.willValidate;

/** @return {boolean} */
HTMLOutputElement.prototype.checkValidity = function() {};

/** @return {boolean} */
HTMLOutputElement.prototype.reportValidity = function() {};

/** @param {string} message */
HTMLOutputElement.prototype.setCustomValidity = function(message) {};



/**
 * @see https://html.spec.whatwg.org/multipage/forms.html#the-progress-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLProgressElement() {}


/** @type {number} */
HTMLProgressElement.prototype.value;


/** @type {number} */
HTMLProgressElement.prototype.max;


/** @type {number} */
HTMLProgressElement.prototype.position;


/** @type {NodeList<!Node>} */
HTMLProgressElement.prototype.labels;



/**
 * @see https://html.spec.whatwg.org/multipage/embedded-content.html#the-track-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLTrackElement() {}


/** @type {string} */
HTMLTrackElement.prototype.kind;


/** @type {string} */
HTMLTrackElement.prototype.src;


/** @type {string} */
HTMLTrackElement.prototype.srclang;


/** @type {string} */
HTMLTrackElement.prototype.label;


/** @type {boolean} */
HTMLTrackElement.prototype.default;


/** @const {number} */
HTMLTrackElement.prototype.readyState;


/** @const {TextTrack} */
HTMLTrackElement.prototype.track;



/**
 * @see https://html.spec.whatwg.org/multipage/forms.html#the-meter-element
 * @constructor
 * @extends {HTMLElement}
 */
function HTMLMeterElement() {}


/** @type {number} */
HTMLMeterElement.prototype.value;


/** @type {number} */
HTMLMeterElement.prototype.min;


/** @type {number} */
HTMLMeterElement.prototype.max;


/** @type {number} */
HTMLMeterElement.prototype.low;


/** @type {number} */
HTMLMeterElement.prototype.high;


/** @type {number} */
HTMLMeterElement.prototype.optimum;


/** @type {NodeList<!Node>} */
HTMLMeterElement.prototype.labels;


/**
 * @constructor
 * @see https://www.w3.org/TR/html5/webappapis.html#navigator
 */
function Navigator() {}
/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-appcodename
 */
Navigator.prototype.appCodeName;

/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-appname
 */
Navigator.prototype.appName;

/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-appversion
 */
Navigator.prototype.appVersion;

/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-platform
 */
Navigator.prototype.platform;

/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-product
 */
Navigator.prototype.product;

/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-useragent
 */
Navigator.prototype.userAgent;

/**
 * @return {boolean}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-taintenabled
 */
Navigator.prototype.taintEnabled = function() {};

/**
 * @type {string}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-language
 */
Navigator.prototype.language;

/**
 * @type {boolean}
 * @see https://www.w3.org/TR/html5/browsers.html#navigatoronline
 */
Navigator.prototype.onLine;

/**
 * @type {boolean}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-cookieenabled
 */
Navigator.prototype.cookieEnabled;

/**
 * @param {string} scheme
 * @param {string} url
 * @param {string} title
 * @return {undefined}
 */
Navigator.prototype.registerProtocolHandler = function(scheme, url, title) {}

/**
 * @param {string} mimeType
 * @param {string} url
 * @param {string} title
 * @return {undefined}
 */
Navigator.prototype.registerContentHandler = function(mimeType, url, title) {}

/**
 * @param {string} scheme
 * @param {string} url
 * @return {undefined}
 */
Navigator.prototype.unregisterProtocolHandler = function(scheme, url) {}

/**
 * @param {string} mimeType
 * @param {string} url
 * @return {undefined}
 */
Navigator.prototype.unregisterContentHandler = function(mimeType, url) {}

/**
 * @type {MimeTypeArray}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-mimetypes
 */
Navigator.prototype.mimeTypes;

/**
 * @type {PluginArray}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-plugins
 */
Navigator.prototype.plugins;

/**
 * @return {boolean}
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-navigator-javaenabled
 * @nosideeffects
 */
Navigator.prototype.javaEnabled = function() {};


/**
 * @constructor
 * @implements {IObject<(string|number),!Plugin>}
 * @implements {IArrayLike<!Plugin>}
 * @see https://www.w3.org/TR/html5/webappapis.html#pluginarray
 */
function PluginArray() {}

/** @type {number} */
PluginArray.prototype.length;

/**
 * @param {number} index
 * @return {Plugin}
 */
PluginArray.prototype.item = function(index) {};

/**
 * @param {string} name
 * @return {Plugin}
 */
PluginArray.prototype.namedItem = function(name) {};

/**
 * @param {boolean=} reloadDocuments
 * @return {undefined}
 */
PluginArray.prototype.refresh = function(reloadDocuments) {};

/**
 * @constructor
 * @implements {IObject<(string|number),!MimeType>}
 * @implements {IArrayLike<!MimeType>}
 * @see https://www.w3.org/TR/html5/webappapis.html#mimetypearray
 */
function MimeTypeArray() {}

/**
 * @param {number} index
 * @return {MimeType}
 */
MimeTypeArray.prototype.item = function(index) {};

/**
 * @type {number}
 * @see https://developer.mozilla.org/en/DOM/window.navigator.mimeTypes
 */
MimeTypeArray.prototype.length;

/**
 * @param {string} name
 * @return {MimeType}
 */
MimeTypeArray.prototype.namedItem = function(name) {};

/**
 * @constructor
 * @see https://www.w3.org/TR/html5/webappapis.html#mimetype
 */
function MimeType() {}

/** @type {string} */
MimeType.prototype.description;

/** @type {Plugin} */
MimeType.prototype.enabledPlugin;

/** @type {string} */
MimeType.prototype.suffixes;

/** @type {string} */
MimeType.prototype.type;

/**
 * @constructor
 * @see https://www.w3.org/TR/html5/webappapis.html#dom-plugin
 */
function Plugin() {}

/** @type {string} */
Plugin.prototype.description;

/** @type {string} */
Plugin.prototype.filename;

/** @type {number} */
Plugin.prototype.length;

/** @type {string} */
Plugin.prototype.name;
