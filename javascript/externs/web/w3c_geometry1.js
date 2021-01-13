/*
 * Copyright 2018 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's Geometry Interfaces Module Level 1 spec.
 *  The whole file has been fully type annotated. Created from
 *  https://www.w3.org/TR/geometry-1/
 *
 * @externs
 */

/**
 * @deprecated ClientRect has been replaced by DOMRect in the latest spec.
 * @constructor
 * @see https://www.w3.org/TR/cssom-view/#changes-from-2011-08-04
 */
function ClientRect() {}

/**
 * @type {number}
 * @see http://www.w3.org/TR/cssom-view/#dom-clientrect-top
 */
ClientRect.prototype.top;

/**
 * @type {number}
 * @see http://www.w3.org/TR/cssom-view/#dom-clientrect-right
 */
ClientRect.prototype.right;

/**
 * @type {number}
 * @see http://www.w3.org/TR/cssom-view/#dom-clientrect-bottom
 */
ClientRect.prototype.bottom;

/**
 * @type {number}
 * @see http://www.w3.org/TR/cssom-view/#dom-clientrect-left
 */
ClientRect.prototype.left;

/**
 * @type {number}
 * @see http://www.w3.org/TR/cssom-view/#dom-clientrect-width
 */
ClientRect.prototype.width;

/**
 * @type {number}
 * @see http://www.w3.org/TR/cssom-view/#dom-clientrect-height
 */
ClientRect.prototype.height;

/**
 * @constructor
 * @extends {ClientRect} for backwards compatibility
 * @param {number=} x
 * @param {number=} y
 * @param {number=} width
 * @param {number=} height
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-domrectreadonly
 */
function DOMRectReadOnly(x, y, width, height) {}

/**
 * @param {!DOMRectInit} other
 * @return {!DOMRectReadOnly}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-fromrect
 */
DOMRectReadOnly.prototype.fromRect = function(other) {};

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-x
 */
DOMRectReadOnly.prototype.x;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-y
 */
DOMRectReadOnly.prototype.y;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-width
 */
DOMRectReadOnly.prototype.width;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-height
 */
DOMRectReadOnly.prototype.height;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-top
 */
DOMRectReadOnly.prototype.top;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-right
 */
DOMRectReadOnly.prototype.right;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-bottom
 */
DOMRectReadOnly.prototype.bottom;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-left
 */
DOMRectReadOnly.prototype.left;

/**
 * @constructor
 * @extends {DOMRectReadOnly}
 * @param {number=} x
 * @param {number=} y
 * @param {number=} width
 * @param {number=} height
 * @see https://www.w3.org/TR/geometry-1/#dom-domrect-domrect
 */
function DOMRect(x, y, width, height) {}

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrect-x
 */
DOMRect.prototype.x;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrect-y
 */
DOMRect.prototype.y;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrect-width
 */
DOMRect.prototype.width;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrect-height
 */
DOMRect.prototype.height;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-top
 */
DOMRect.prototype.top;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-right
 */
DOMRect.prototype.right;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-bottom
 */
DOMRect.prototype.bottom;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectreadonly-left
 */
DOMRect.prototype.left;

/**
 * @constructor
 * @see https://www.w3.org/TR/geometry-1/#dictdef-domrectinit
 */
function DOMRectInit() {}

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectinit-x
 */
DOMRectInit.prototype.x;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectinit-y
 */
DOMRectInit.prototype.y;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectinit-width
 */
DOMRectInit.prototype.width;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-domrectinit-height
 */
DOMRectInit.prototype.height;

/**
 * @constructor
 * @param {number=} x
 * @param {number=} y
 * @param {number=} z
 * @param {number=} w
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointreadonly-dompointreadonly
 */
function DOMPointReadOnly(x, y, z, w) {}

/**
 * @param {!DOMPointInit} other
 * @return {!DOMPointReadOnly}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointreadonly-frompoint
 */
DOMPointReadOnly.prototype.fromPoint = function(other) {};

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointreadonly-x
 */
DOMPointReadOnly.prototype.x;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointreadonly-y
 */
DOMPointReadOnly.prototype.y;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointreadonly-z
 */
DOMPointReadOnly.prototype.z;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointreadonly-w
 */
DOMPointReadOnly.prototype.w;

/**
 * @constructor
 * @extends {DOMPointReadOnly}
 * @param {number=} x
 * @param {number=} y
 * @param {number=} z
 * @param {number=} w
 * @see https://www.w3.org/TR/geometry-1/#dom-dompoint-dompoint
 */
function DOMPoint(x, y, z, w) {}

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompoint-x
 */
DOMPoint.prototype.x;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompoint-y
 */
DOMPoint.prototype.y;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompoint-z
 */
DOMPoint.prototype.z;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompoint-w
 */
DOMPoint.prototype.w;

/**
 * @record
 * @see https://www.w3.org/TR/geometry-1/#dictdef-dompointinit
 */
function DOMPointInit() {}

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointinit-x
 */
DOMPointInit.prototype.x;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointinit-y
 */
DOMPointInit.prototype.y;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointinit-z
 */
DOMPointInit.prototype.z;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dompointinit-w
 */
DOMPointInit.prototype.w;

/**
 * @constructor
 * @implements {DOMMatrixInit}
 * @param {string|Array<number>} init
 * @see https://www.w3.org/TR/geometry-1/#dommatrixreadonly
 */
function DOMMatrixReadOnly(init) {}

/**
 * @param {!DOMMatrixInit} other
 * @return {!DOMMatrixReadOnly}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-frommatrix
 */
DOMMatrixReadOnly.fromMatrix = function(other) {};

/**
 * @param {!Float32Array} array32
 * @return {!DOMMatrixReadOnly}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-fromfloat32array
 */
DOMMatrixReadOnly.fromFloat32Array = function(array32) {};

/**
 * @param {!Float64Array} array64
 * @return {!DOMMatrixReadOnly}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-fromfloat64array
 */
DOMMatrixReadOnly.fromFloat64Array = function(array64) {};

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-a
 */
DOMMatrixReadOnly.prototype.a;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-b
 */
DOMMatrixReadOnly.prototype.b;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-c
 */
DOMMatrixReadOnly.prototype.c;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-d
 */
DOMMatrixReadOnly.prototype.d;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-e
 */
DOMMatrixReadOnly.prototype.e;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-f
 */
DOMMatrixReadOnly.prototype.f;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m11
 */
DOMMatrixReadOnly.prototype.m11;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m12
 */
DOMMatrixReadOnly.prototype.m12;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m13
 */
DOMMatrixReadOnly.prototype.m13;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m14
 */
DOMMatrixReadOnly.prototype.m14;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m21
 */
DOMMatrixReadOnly.prototype.m21;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m22
 */
DOMMatrixReadOnly.prototype.m22;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m23
 */
DOMMatrixReadOnly.prototype.m23;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m24
 */
DOMMatrixReadOnly.prototype.m24;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m31
 */
DOMMatrixReadOnly.prototype.m31;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m32
 */
DOMMatrixReadOnly.prototype.m32;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m33
 */
DOMMatrixReadOnly.prototype.m33;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m34
 */
DOMMatrixReadOnly.prototype.m34;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m41
 */
DOMMatrixReadOnly.prototype.m41;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m42
 */
DOMMatrixReadOnly.prototype.m42;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m43
 */
DOMMatrixReadOnly.prototype.m43;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-m44
 */
DOMMatrixReadOnly.prototype.m44;

/**
 * @type {boolean}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-is2d
 */
DOMMatrixReadOnly.prototype.is2D;

/**
 * @type {boolean}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-isidentity
 */
DOMMatrixReadOnly.prototype.isIdentity;

/**
 * @param {number=} tx
 * @param {number=} ty
 * @param {number=} tz
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-translate
 */
DOMMatrixReadOnly.prototype.translate = function(tx, ty, tz) {};

/**
 * @param {number=} scaleX
 * @param {number=} scaleY
 * @param {number=} scaleZ
 * @param {number=} originX
 * @param {number=} originY
 * @param {number=} originZ
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-scale
 */
DOMMatrixReadOnly.prototype.scale = function(
    scaleX, scaleY, scaleZ, originX, originY, originZ) {};

/**
 * @param {number=} scaleX
 * @param {number=} scaleY
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-scalenonuniform
 */
DOMMatrixReadOnly.prototype.scaleNonUniform = function(scaleX, scaleY) {};

/**
 * @param {number=} scale
 * @param {number=} originX
 * @param {number=} originY
 * @param {number=} originZ
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-scale3d
 */
DOMMatrixReadOnly.prototype.scale3d = function(
    scale, originX, originY, originZ) {};

/**
 * @param {number=} rotX
 * @param {number=} rotY
 * @param {number=} rotZ
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-rotate
 */
DOMMatrixReadOnly.prototype.rotate = function(rotX, rotY, rotZ) {};

/**
 * @param {number=} x
 * @param {number=} y
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-rotatefromvector
 */
DOMMatrixReadOnly.prototype.rotateFromVector = function(x, y) {};

/**
 * @param {number=} x
 * @param {number=} y
 * @param {number=} z
 * @param {number=} angle
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-rotateaxisangle
 */
DOMMatrixReadOnly.prototype.rotateAxisAngle = function(x, y, z, angle) {};

/**
 * @param {number=} sx
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-skewx
 */
DOMMatrixReadOnly.prototype.skewX = function(sx) {};

/**
 * @param {number=} sy
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-skewy
 */
DOMMatrixReadOnly.prototype.skewY = function(sy) {};

/**
 * @param {!DOMMatrixInit} other
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-multiply
 */
DOMMatrixReadOnly.prototype.multiply = function(other) {};

/**
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-flipx
 */
DOMMatrixReadOnly.prototype.flipX = function() {};

/**
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-flipy
 */
DOMMatrixReadOnly.prototype.flipY = function() {};

/**
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-inverse
 */
DOMMatrixReadOnly.prototype.inverse = function() {};

/**
 * @param {!DOMPointInit} point
 * @return {!DOMPoint}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-transformpoint
 */
DOMMatrixReadOnly.prototype.transformPoint = function(point) {};

/**
 * @return {!Float32Array}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-tofloat32array
 */
DOMMatrixReadOnly.prototype.toFloat32Array = function() {};

/**
 * @return {!Float64Array}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixreadonly-tofloat64array
 */
DOMMatrixReadOnly.prototype.toFloat64Array = function() {};

/**
 * @constructor
 * @extends {DOMMatrixReadOnly}
 * @param {string|Array<number>} init
 * @see https://www.w3.org/TR/geometry-1/#dommatrix
 */
function DOMMatrix(init) {}

/**
 * @param {!DOMMatrixInit} other
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-frommatrix
 */
DOMMatrix.fromMatrix = function(other) {};

/**
 * @param {!Float32Array} array32
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-fromfloat32array
 */
DOMMatrix.fromFloat32Array = function(array32) {};

/**
 * @param {!Float64Array} array64
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-fromfloat64array
 */
DOMMatrix.fromFloat64Array = function(array64) {};

/**
 * @param {!DOMMatrixInit} other
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-multiply
 */
DOMMatrix.prototype.multiplySelf = function(other) {};

/**
 * @param {!DOMMatrixInit} other
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-premultiply
 */
DOMMatrix.prototype.preMultiplySelf = function(other) {};

/**
 * @param {number=} tx
 * @param {number=} ty
 * @param {number=} tz
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-translate
 */
DOMMatrix.prototype.translateSelf = function(tx, ty, tz) {};

/**
 * @param {number=} scaleX
 * @param {number=} scaleY
 * @param {number=} scaleZ
 * @param {number=} originX
 * @param {number=} originY
 * @param {number=} originZ
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-scale
 */
DOMMatrix.prototype.scaleSelf = function(
    scaleX, scaleY, scaleZ, originX, originY, originZ) {};

/**
 * @param {number=} scale
 * @param {number=} originX
 * @param {number=} originY
 * @param {number=} originZ
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-scale3d
 */
DOMMatrix.prototype.scale3dSelf = function(scale, originX, originY, originZ) {};

/**
 * @param {number=} rotX
 * @param {number=} rotY
 * @param {number=} rotZ
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-rotate
 */
DOMMatrix.prototype.rotateSelf = function(rotX, rotY, rotZ) {};

/**
 * @param {number=} x
 * @param {number=} y
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-rotatefromvector
 */
DOMMatrix.prototype.rotateFromVectorSelf = function(x, y) {};

/**
 * @param {number=} x
 * @param {number=} y
 * @param {number=} z
 * @param {number=} angle
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-rotateaxisangle
 */
DOMMatrix.prototype.rotateAxisAngleSelf = function(x, y, z, angle) {};

/**
 * @param {number=} sx
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-skewx
 */
DOMMatrix.prototype.skewXSelf = function(sx) {};

/**
 * @param {number=} sy
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-skewy
 */
DOMMatrix.prototype.skewYSelf = function(sy) {};

/**
 * @return {!DOMMatrix}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix-inverse
 */
DOMMatrix.prototype.inverseSelf = function() {};

/**
 * @record
 * @see https://www.w3.org/TR/geometry-1/#dictdef-dommatrix2dinit
 */
function DOMMatrix2DInit() {}

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-a
 */
DOMMatrix2DInit.prototype.a;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-b
 */
DOMMatrix2DInit.prototype.b;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-c
 */
DOMMatrix2DInit.prototype.c;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-d
 */
DOMMatrix2DInit.prototype.d;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-e
 */
DOMMatrix2DInit.prototype.e;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-f
 */
DOMMatrix2DInit.prototype.f;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-m11
 */
DOMMatrix2DInit.prototype.m11;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-m12
 */
DOMMatrix2DInit.prototype.m12;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-m21
 */
DOMMatrix2DInit.prototype.m21;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-m22
 */
DOMMatrix2DInit.prototype.m22;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-m41
 */
DOMMatrix2DInit.prototype.m41;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrix2dinit-m42
 */
DOMMatrix2DInit.prototype.m42;

/**
 * @record
 * @extends {DOMMatrix2DInit}
 * @see https://www.w3.org/TR/geometry-1/#dictdef-dommatrix
 */
function DOMMatrixInit() {}

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m13
 */
DOMMatrixInit.prototype.m13;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m14
 */
DOMMatrixInit.prototype.m14;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m23
 */
DOMMatrixInit.prototype.m23;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m24
 */
DOMMatrixInit.prototype.m24;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m31
 */
DOMMatrixInit.prototype.m31;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m32
 */
DOMMatrixInit.prototype.m32;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m33
 */
DOMMatrixInit.prototype.m33;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m34
 */
DOMMatrixInit.prototype.m34;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m43
 */
DOMMatrixInit.prototype.m43;

/**
 * @type {number}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-m44
 */
DOMMatrixInit.prototype.m44;

/**
 * @type {boolean}
 * @see https://www.w3.org/TR/geometry-1/#dom-dommatrixinit-is2d
 */
DOMMatrixInit.prototype.is2D;
