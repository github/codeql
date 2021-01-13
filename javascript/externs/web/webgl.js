/*
 * Copyright 2010 The Closure Compiler Authors
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
 * @fileoverview Definitions for WebGL functions as described at
 * http://www.khronos.org/registry/webgl/specs/latest/
 *
 * This file is current up to the WebGL 1.0.1 spec, including extensions.
 *
 * This relies on html5.js being included for Canvas and Typed Array support.
 *
 * This includes some extensions defined at
 * http://www.khronos.org/registry/webgl/extensions/
 *
 * @externs
 */


/**
 * @typedef {ImageBitmap|ImageData|HTMLImageElement|HTMLCanvasElement|
 *     HTMLVideoElement|OffscreenCanvas}
 */
var TexImageSource;

/**
 * @constructor
 */
function WebGLRenderingContext() {}


/** @const {number} */
WebGLRenderingContext.DEPTH_BUFFER_BIT;

/** @const {number} */
WebGLRenderingContext.STENCIL_BUFFER_BIT;

/** @const {number} */
WebGLRenderingContext.COLOR_BUFFER_BIT;

/** @const {number} */
WebGLRenderingContext.POINTS;

/** @const {number} */
WebGLRenderingContext.LINES;

/** @const {number} */
WebGLRenderingContext.LINE_LOOP;

/** @const {number} */
WebGLRenderingContext.LINE_STRIP;

/** @const {number} */
WebGLRenderingContext.TRIANGLES;

/** @const {number} */
WebGLRenderingContext.TRIANGLE_STRIP;

/** @const {number} */
WebGLRenderingContext.TRIANGLE_FAN;

/** @const {number} */
WebGLRenderingContext.ZERO;

/** @const {number} */
WebGLRenderingContext.ONE;

/** @const {number} */
WebGLRenderingContext.SRC_COLOR;

/** @const {number} */
WebGLRenderingContext.ONE_MINUS_SRC_COLOR;

/** @const {number} */
WebGLRenderingContext.SRC_ALPHA;

/** @const {number} */
WebGLRenderingContext.ONE_MINUS_SRC_ALPHA;

/** @const {number} */
WebGLRenderingContext.DST_ALPHA;

/** @const {number} */
WebGLRenderingContext.ONE_MINUS_DST_ALPHA;

/** @const {number} */
WebGLRenderingContext.DST_COLOR;

/** @const {number} */
WebGLRenderingContext.ONE_MINUS_DST_COLOR;

/** @const {number} */
WebGLRenderingContext.SRC_ALPHA_SATURATE;

/** @const {number} */
WebGLRenderingContext.FUNC_ADD;

/** @const {number} */
WebGLRenderingContext.BLEND_EQUATION;

/** @const {number} */
WebGLRenderingContext.BLEND_EQUATION_RGB;

/** @const {number} */
WebGLRenderingContext.BLEND_EQUATION_ALPHA;

/** @const {number} */
WebGLRenderingContext.FUNC_SUBTRACT;

/** @const {number} */
WebGLRenderingContext.FUNC_REVERSE_SUBTRACT;

/** @const {number} */
WebGLRenderingContext.BLEND_DST_RGB;

/** @const {number} */
WebGLRenderingContext.BLEND_SRC_RGB;

/** @const {number} */
WebGLRenderingContext.BLEND_DST_ALPHA;

/** @const {number} */
WebGLRenderingContext.BLEND_SRC_ALPHA;

/** @const {number} */
WebGLRenderingContext.CONSTANT_COLOR;

/** @const {number} */
WebGLRenderingContext.ONE_MINUS_CONSTANT_COLOR;

/** @const {number} */
WebGLRenderingContext.CONSTANT_ALPHA;

/** @const {number} */
WebGLRenderingContext.ONE_MINUS_CONSTANT_ALPHA;

/** @const {number} */
WebGLRenderingContext.BLEND_COLOR;

/** @const {number} */
WebGLRenderingContext.ARRAY_BUFFER;

/** @const {number} */
WebGLRenderingContext.ELEMENT_ARRAY_BUFFER;

/** @const {number} */
WebGLRenderingContext.ARRAY_BUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.ELEMENT_ARRAY_BUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.STREAM_DRAW;

/** @const {number} */
WebGLRenderingContext.STATIC_DRAW;

/** @const {number} */
WebGLRenderingContext.DYNAMIC_DRAW;

/** @const {number} */
WebGLRenderingContext.BUFFER_SIZE;

/** @const {number} */
WebGLRenderingContext.BUFFER_USAGE;

/** @const {number} */
WebGLRenderingContext.CURRENT_VERTEX_ATTRIB;

/** @const {number} */
WebGLRenderingContext.FRONT;

/** @const {number} */
WebGLRenderingContext.BACK;

/** @const {number} */
WebGLRenderingContext.FRONT_AND_BACK;

/** @const {number} */
WebGLRenderingContext.CULL_FACE;

/** @const {number} */
WebGLRenderingContext.BLEND;

/** @const {number} */
WebGLRenderingContext.DITHER;

/** @const {number} */
WebGLRenderingContext.STENCIL_TEST;

/** @const {number} */
WebGLRenderingContext.DEPTH_TEST;

/** @const {number} */
WebGLRenderingContext.SCISSOR_TEST;

/** @const {number} */
WebGLRenderingContext.POLYGON_OFFSET_FILL;

/** @const {number} */
WebGLRenderingContext.SAMPLE_ALPHA_TO_COVERAGE;

/** @const {number} */
WebGLRenderingContext.SAMPLE_COVERAGE;

/** @const {number} */
WebGLRenderingContext.NO_ERROR;

/** @const {number} */
WebGLRenderingContext.INVALID_ENUM;

/** @const {number} */
WebGLRenderingContext.INVALID_VALUE;

/** @const {number} */
WebGLRenderingContext.INVALID_OPERATION;

/** @const {number} */
WebGLRenderingContext.OUT_OF_MEMORY;

/** @const {number} */
WebGLRenderingContext.CW;

/** @const {number} */
WebGLRenderingContext.CCW;

/** @const {number} */
WebGLRenderingContext.LINE_WIDTH;

/** @const {number} */
WebGLRenderingContext.ALIASED_POINT_SIZE_RANGE;

/** @const {number} */
WebGLRenderingContext.ALIASED_LINE_WIDTH_RANGE;

/** @const {number} */
WebGLRenderingContext.CULL_FACE_MODE;

/** @const {number} */
WebGLRenderingContext.FRONT_FACE;

/** @const {number} */
WebGLRenderingContext.DEPTH_RANGE;

/** @const {number} */
WebGLRenderingContext.DEPTH_WRITEMASK;

/** @const {number} */
WebGLRenderingContext.DEPTH_CLEAR_VALUE;

/** @const {number} */
WebGLRenderingContext.DEPTH_FUNC;

/** @const {number} */
WebGLRenderingContext.STENCIL_CLEAR_VALUE;

/** @const {number} */
WebGLRenderingContext.STENCIL_FUNC;

/** @const {number} */
WebGLRenderingContext.STENCIL_FAIL;

/** @const {number} */
WebGLRenderingContext.STENCIL_PASS_DEPTH_FAIL;

/** @const {number} */
WebGLRenderingContext.STENCIL_PASS_DEPTH_PASS;

/** @const {number} */
WebGLRenderingContext.STENCIL_REF;

/** @const {number} */
WebGLRenderingContext.STENCIL_VALUE_MASK;

/** @const {number} */
WebGLRenderingContext.STENCIL_WRITEMASK;

/** @const {number} */
WebGLRenderingContext.STENCIL_BACK_FUNC;

/** @const {number} */
WebGLRenderingContext.STENCIL_BACK_FAIL;

/** @const {number} */
WebGLRenderingContext.STENCIL_BACK_PASS_DEPTH_FAIL;

/** @const {number} */
WebGLRenderingContext.STENCIL_BACK_PASS_DEPTH_PASS;

/** @const {number} */
WebGLRenderingContext.STENCIL_BACK_REF;

/** @const {number} */
WebGLRenderingContext.STENCIL_BACK_VALUE_MASK;

/** @const {number} */
WebGLRenderingContext.STENCIL_BACK_WRITEMASK;

/** @const {number} */
WebGLRenderingContext.VIEWPORT;

/** @const {number} */
WebGLRenderingContext.SCISSOR_BOX;

/** @const {number} */
WebGLRenderingContext.COLOR_CLEAR_VALUE;

/** @const {number} */
WebGLRenderingContext.COLOR_WRITEMASK;

/** @const {number} */
WebGLRenderingContext.UNPACK_ALIGNMENT;

/** @const {number} */
WebGLRenderingContext.PACK_ALIGNMENT;

/** @const {number} */
WebGLRenderingContext.MAX_TEXTURE_SIZE;

/** @const {number} */
WebGLRenderingContext.MAX_VIEWPORT_DIMS;

/** @const {number} */
WebGLRenderingContext.SUBPIXEL_BITS;

/** @const {number} */
WebGLRenderingContext.RED_BITS;

/** @const {number} */
WebGLRenderingContext.GREEN_BITS;

/** @const {number} */
WebGLRenderingContext.BLUE_BITS;

/** @const {number} */
WebGLRenderingContext.ALPHA_BITS;

/** @const {number} */
WebGLRenderingContext.DEPTH_BITS;

/** @const {number} */
WebGLRenderingContext.STENCIL_BITS;

/** @const {number} */
WebGLRenderingContext.POLYGON_OFFSET_UNITS;

/** @const {number} */
WebGLRenderingContext.POLYGON_OFFSET_FACTOR;

/** @const {number} */
WebGLRenderingContext.TEXTURE_BINDING_2D;

/** @const {number} */
WebGLRenderingContext.SAMPLE_BUFFERS;

/** @const {number} */
WebGLRenderingContext.SAMPLES;

/** @const {number} */
WebGLRenderingContext.SAMPLE_COVERAGE_VALUE;

/** @const {number} */
WebGLRenderingContext.SAMPLE_COVERAGE_INVERT;

/** @const {number} */
WebGLRenderingContext.COMPRESSED_TEXTURE_FORMATS;

/** @const {number} */
WebGLRenderingContext.DONT_CARE;

/** @const {number} */
WebGLRenderingContext.FASTEST;

/** @const {number} */
WebGLRenderingContext.NICEST;

/** @const {number} */
WebGLRenderingContext.GENERATE_MIPMAP_HINT;

/** @const {number} */
WebGLRenderingContext.BYTE;

/** @const {number} */
WebGLRenderingContext.UNSIGNED_BYTE;

/** @const {number} */
WebGLRenderingContext.SHORT;

/** @const {number} */
WebGLRenderingContext.UNSIGNED_SHORT;

/** @const {number} */
WebGLRenderingContext.INT;

/** @const {number} */
WebGLRenderingContext.UNSIGNED_INT;

/** @const {number} */
WebGLRenderingContext.FLOAT;

/** @const {number} */
WebGLRenderingContext.DEPTH_COMPONENT;

/** @const {number} */
WebGLRenderingContext.ALPHA;

/** @const {number} */
WebGLRenderingContext.RGB;

/** @const {number} */
WebGLRenderingContext.RGBA;

/** @const {number} */
WebGLRenderingContext.LUMINANCE;

/** @const {number} */
WebGLRenderingContext.LUMINANCE_ALPHA;

/** @const {number} */
WebGLRenderingContext.UNSIGNED_SHORT_4_4_4_4;

/** @const {number} */
WebGLRenderingContext.UNSIGNED_SHORT_5_5_5_1;

/** @const {number} */
WebGLRenderingContext.UNSIGNED_SHORT_5_6_5;

/** @const {number} */
WebGLRenderingContext.FRAGMENT_SHADER;

/** @const {number} */
WebGLRenderingContext.VERTEX_SHADER;

/** @const {number} */
WebGLRenderingContext.MAX_VERTEX_ATTRIBS;

/** @const {number} */
WebGLRenderingContext.MAX_VERTEX_UNIFORM_VECTORS;

/** @const {number} */
WebGLRenderingContext.MAX_VARYING_VECTORS;

/** @const {number} */
WebGLRenderingContext.MAX_COMBINED_TEXTURE_IMAGE_UNITS;

/** @const {number} */
WebGLRenderingContext.MAX_VERTEX_TEXTURE_IMAGE_UNITS;

/** @const {number} */
WebGLRenderingContext.MAX_TEXTURE_IMAGE_UNITS;

/** @const {number} */
WebGLRenderingContext.MAX_FRAGMENT_UNIFORM_VECTORS;

/** @const {number} */
WebGLRenderingContext.SHADER_TYPE;

/** @const {number} */
WebGLRenderingContext.DELETE_STATUS;

/** @const {number} */
WebGLRenderingContext.LINK_STATUS;

/** @const {number} */
WebGLRenderingContext.VALIDATE_STATUS;

/** @const {number} */
WebGLRenderingContext.ATTACHED_SHADERS;

/** @const {number} */
WebGLRenderingContext.ACTIVE_UNIFORMS;

/** @const {number} */
WebGLRenderingContext.ACTIVE_ATTRIBUTES;

/** @const {number} */
WebGLRenderingContext.SHADING_LANGUAGE_VERSION;

/** @const {number} */
WebGLRenderingContext.CURRENT_PROGRAM;

/** @const {number} */
WebGLRenderingContext.NEVER;

/** @const {number} */
WebGLRenderingContext.LESS;

/** @const {number} */
WebGLRenderingContext.EQUAL;

/** @const {number} */
WebGLRenderingContext.LEQUAL;

/** @const {number} */
WebGLRenderingContext.GREATER;

/** @const {number} */
WebGLRenderingContext.NOTEQUAL;

/** @const {number} */
WebGLRenderingContext.GEQUAL;

/** @const {number} */
WebGLRenderingContext.ALWAYS;

/** @const {number} */
WebGLRenderingContext.KEEP;

/** @const {number} */
WebGLRenderingContext.REPLACE;

/** @const {number} */
WebGLRenderingContext.INCR;

/** @const {number} */
WebGLRenderingContext.DECR;

/** @const {number} */
WebGLRenderingContext.INVERT;

/** @const {number} */
WebGLRenderingContext.INCR_WRAP;

/** @const {number} */
WebGLRenderingContext.DECR_WRAP;

/** @const {number} */
WebGLRenderingContext.VENDOR;

/** @const {number} */
WebGLRenderingContext.RENDERER;

/** @const {number} */
WebGLRenderingContext.VERSION;

/** @const {number} */
WebGLRenderingContext.NEAREST;

/** @const {number} */
WebGLRenderingContext.LINEAR;

/** @const {number} */
WebGLRenderingContext.NEAREST_MIPMAP_NEAREST;

/** @const {number} */
WebGLRenderingContext.LINEAR_MIPMAP_NEAREST;

/** @const {number} */
WebGLRenderingContext.NEAREST_MIPMAP_LINEAR;

/** @const {number} */
WebGLRenderingContext.LINEAR_MIPMAP_LINEAR;

/** @const {number} */
WebGLRenderingContext.TEXTURE_MAG_FILTER;

/** @const {number} */
WebGLRenderingContext.TEXTURE_MIN_FILTER;

/** @const {number} */
WebGLRenderingContext.TEXTURE_WRAP_S;

/** @const {number} */
WebGLRenderingContext.TEXTURE_WRAP_T;

/** @const {number} */
WebGLRenderingContext.TEXTURE_2D;

/** @const {number} */
WebGLRenderingContext.TEXTURE;

/** @const {number} */
WebGLRenderingContext.TEXTURE_CUBE_MAP;

/** @const {number} */
WebGLRenderingContext.TEXTURE_BINDING_CUBE_MAP;

/** @const {number} */
WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_X;

/** @const {number} */
WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_X;

/** @const {number} */
WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Y;

/** @const {number} */
WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Y;

/** @const {number} */
WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Z;

/** @const {number} */
WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Z;

/** @const {number} */
WebGLRenderingContext.MAX_CUBE_MAP_TEXTURE_SIZE;

/** @const {number} */
WebGLRenderingContext.TEXTURE0;

/** @const {number} */
WebGLRenderingContext.TEXTURE1;

/** @const {number} */
WebGLRenderingContext.TEXTURE2;

/** @const {number} */
WebGLRenderingContext.TEXTURE3;

/** @const {number} */
WebGLRenderingContext.TEXTURE4;

/** @const {number} */
WebGLRenderingContext.TEXTURE5;

/** @const {number} */
WebGLRenderingContext.TEXTURE6;

/** @const {number} */
WebGLRenderingContext.TEXTURE7;

/** @const {number} */
WebGLRenderingContext.TEXTURE8;

/** @const {number} */
WebGLRenderingContext.TEXTURE9;

/** @const {number} */
WebGLRenderingContext.TEXTURE10;

/** @const {number} */
WebGLRenderingContext.TEXTURE11;

/** @const {number} */
WebGLRenderingContext.TEXTURE12;

/** @const {number} */
WebGLRenderingContext.TEXTURE13;

/** @const {number} */
WebGLRenderingContext.TEXTURE14;

/** @const {number} */
WebGLRenderingContext.TEXTURE15;

/** @const {number} */
WebGLRenderingContext.TEXTURE16;

/** @const {number} */
WebGLRenderingContext.TEXTURE17;

/** @const {number} */
WebGLRenderingContext.TEXTURE18;

/** @const {number} */
WebGLRenderingContext.TEXTURE19;

/** @const {number} */
WebGLRenderingContext.TEXTURE20;

/** @const {number} */
WebGLRenderingContext.TEXTURE21;

/** @const {number} */
WebGLRenderingContext.TEXTURE22;

/** @const {number} */
WebGLRenderingContext.TEXTURE23;

/** @const {number} */
WebGLRenderingContext.TEXTURE24;

/** @const {number} */
WebGLRenderingContext.TEXTURE25;

/** @const {number} */
WebGLRenderingContext.TEXTURE26;

/** @const {number} */
WebGLRenderingContext.TEXTURE27;

/** @const {number} */
WebGLRenderingContext.TEXTURE28;

/** @const {number} */
WebGLRenderingContext.TEXTURE29;

/** @const {number} */
WebGLRenderingContext.TEXTURE30;

/** @const {number} */
WebGLRenderingContext.TEXTURE31;

/** @const {number} */
WebGLRenderingContext.ACTIVE_TEXTURE;

/** @const {number} */
WebGLRenderingContext.REPEAT;

/** @const {number} */
WebGLRenderingContext.CLAMP_TO_EDGE;

/** @const {number} */
WebGLRenderingContext.MIRRORED_REPEAT;

/** @const {number} */
WebGLRenderingContext.FLOAT_VEC2;

/** @const {number} */
WebGLRenderingContext.FLOAT_VEC3;

/** @const {number} */
WebGLRenderingContext.FLOAT_VEC4;

/** @const {number} */
WebGLRenderingContext.INT_VEC2;

/** @const {number} */
WebGLRenderingContext.INT_VEC3;

/** @const {number} */
WebGLRenderingContext.INT_VEC4;

/** @const {number} */
WebGLRenderingContext.BOOL;

/** @const {number} */
WebGLRenderingContext.BOOL_VEC2;

/** @const {number} */
WebGLRenderingContext.BOOL_VEC3;

/** @const {number} */
WebGLRenderingContext.BOOL_VEC4;

/** @const {number} */
WebGLRenderingContext.FLOAT_MAT2;

/** @const {number} */
WebGLRenderingContext.FLOAT_MAT3;

/** @const {number} */
WebGLRenderingContext.FLOAT_MAT4;

/** @const {number} */
WebGLRenderingContext.SAMPLER_2D;

/** @const {number} */
WebGLRenderingContext.SAMPLER_CUBE;

/** @const {number} */
WebGLRenderingContext.VERTEX_ATTRIB_ARRAY_ENABLED;

/** @const {number} */
WebGLRenderingContext.VERTEX_ATTRIB_ARRAY_SIZE;

/** @const {number} */
WebGLRenderingContext.VERTEX_ATTRIB_ARRAY_STRIDE;

/** @const {number} */
WebGLRenderingContext.VERTEX_ATTRIB_ARRAY_TYPE;

/** @const {number} */
WebGLRenderingContext.VERTEX_ATTRIB_ARRAY_NORMALIZED;

/** @const {number} */
WebGLRenderingContext.VERTEX_ATTRIB_ARRAY_POINTER;

/** @const {number} */
WebGLRenderingContext.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.IMPLEMENTATION_COLOR_READ_FORMAT;

/** @const {number} */
WebGLRenderingContext.IMPLEMENTATION_COLOR_READ_TYPE;

/** @const {number} */
WebGLRenderingContext.COMPILE_STATUS;

/** @const {number} */
WebGLRenderingContext.LOW_FLOAT;

/** @const {number} */
WebGLRenderingContext.MEDIUM_FLOAT;

/** @const {number} */
WebGLRenderingContext.HIGH_FLOAT;

/** @const {number} */
WebGLRenderingContext.LOW_INT;

/** @const {number} */
WebGLRenderingContext.MEDIUM_INT;

/** @const {number} */
WebGLRenderingContext.HIGH_INT;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER;

/** @const {number} */
WebGLRenderingContext.RGBA4;

/** @const {number} */
WebGLRenderingContext.RGB5_A1;

/** @const {number} */
WebGLRenderingContext.RGB565;

/** @const {number} */
WebGLRenderingContext.DEPTH_COMPONENT16;

/** @const {number} */
WebGLRenderingContext.STENCIL_INDEX;

/** @const {number} */
WebGLRenderingContext.STENCIL_INDEX8;

/** @const {number} */
WebGLRenderingContext.DEPTH_STENCIL;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_WIDTH;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_HEIGHT;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_INTERNAL_FORMAT;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_RED_SIZE;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_GREEN_SIZE;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_BLUE_SIZE;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_ALPHA_SIZE;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_DEPTH_SIZE;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_STENCIL_SIZE;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE;

/** @const {number} */
WebGLRenderingContext.COLOR_ATTACHMENT0;

/** @const {number} */
WebGLRenderingContext.DEPTH_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.STENCIL_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.DEPTH_STENCIL_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.NONE;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_COMPLETE;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_INCOMPLETE_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_INCOMPLETE_DIMENSIONS;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_UNSUPPORTED;

/** @const {number} */
WebGLRenderingContext.FRAMEBUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.RENDERBUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.MAX_RENDERBUFFER_SIZE;

/** @const {number} */
WebGLRenderingContext.INVALID_FRAMEBUFFER_OPERATION;

/** @const {number} */
WebGLRenderingContext.UNPACK_FLIP_Y_WEBGL;

/** @const {number} */
WebGLRenderingContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL;

/** @const {number} */
WebGLRenderingContext.CONTEXT_LOST_WEBGL;

/** @const {number} */
WebGLRenderingContext.UNPACK_COLORSPACE_CONVERSION_WEBGL;

/** @const {number} */
WebGLRenderingContext.BROWSER_DEFAULT_WEBGL;


/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_BUFFER_BIT;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_BUFFER_BIT;

/** @const {number} */
WebGLRenderingContext.prototype.COLOR_BUFFER_BIT;

/** @const {number} */
WebGLRenderingContext.prototype.POINTS;

/** @const {number} */
WebGLRenderingContext.prototype.LINES;

/** @const {number} */
WebGLRenderingContext.prototype.LINE_LOOP;

/** @const {number} */
WebGLRenderingContext.prototype.LINE_STRIP;

/** @const {number} */
WebGLRenderingContext.prototype.TRIANGLES;

/** @const {number} */
WebGLRenderingContext.prototype.TRIANGLE_STRIP;

/** @const {number} */
WebGLRenderingContext.prototype.TRIANGLE_FAN;

/** @const {number} */
WebGLRenderingContext.prototype.ZERO;

/** @const {number} */
WebGLRenderingContext.prototype.ONE;

/** @const {number} */
WebGLRenderingContext.prototype.SRC_COLOR;

/** @const {number} */
WebGLRenderingContext.prototype.ONE_MINUS_SRC_COLOR;

/** @const {number} */
WebGLRenderingContext.prototype.SRC_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.ONE_MINUS_SRC_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.DST_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.ONE_MINUS_DST_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.DST_COLOR;

/** @const {number} */
WebGLRenderingContext.prototype.ONE_MINUS_DST_COLOR;

/** @const {number} */
WebGLRenderingContext.prototype.SRC_ALPHA_SATURATE;

/** @const {number} */
WebGLRenderingContext.prototype.FUNC_ADD;

/** @const {number} */
WebGLRenderingContext.prototype.BLEND_EQUATION;

/** @const {number} */
WebGLRenderingContext.prototype.BLEND_EQUATION_RGB;

/** @const {number} */
WebGLRenderingContext.prototype.BLEND_EQUATION_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.FUNC_SUBTRACT;

/** @const {number} */
WebGLRenderingContext.prototype.FUNC_REVERSE_SUBTRACT;

/** @const {number} */
WebGLRenderingContext.prototype.BLEND_DST_RGB;

/** @const {number} */
WebGLRenderingContext.prototype.BLEND_SRC_RGB;

/** @const {number} */
WebGLRenderingContext.prototype.BLEND_DST_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.BLEND_SRC_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.CONSTANT_COLOR;

/** @const {number} */
WebGLRenderingContext.prototype.ONE_MINUS_CONSTANT_COLOR;

/** @const {number} */
WebGLRenderingContext.prototype.CONSTANT_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.ONE_MINUS_CONSTANT_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.BLEND_COLOR;

/** @const {number} */
WebGLRenderingContext.prototype.ARRAY_BUFFER;

/** @const {number} */
WebGLRenderingContext.prototype.ELEMENT_ARRAY_BUFFER;

/** @const {number} */
WebGLRenderingContext.prototype.ARRAY_BUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.prototype.ELEMENT_ARRAY_BUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.prototype.STREAM_DRAW;

/** @const {number} */
WebGLRenderingContext.prototype.STATIC_DRAW;

/** @const {number} */
WebGLRenderingContext.prototype.DYNAMIC_DRAW;

/** @const {number} */
WebGLRenderingContext.prototype.BUFFER_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.BUFFER_USAGE;

/** @const {number} */
WebGLRenderingContext.prototype.CURRENT_VERTEX_ATTRIB;

/** @const {number} */
WebGLRenderingContext.prototype.FRONT;

/** @const {number} */
WebGLRenderingContext.prototype.BACK;

/** @const {number} */
WebGLRenderingContext.prototype.FRONT_AND_BACK;

/** @const {number} */
WebGLRenderingContext.prototype.CULL_FACE;

/** @const {number} */
WebGLRenderingContext.prototype.BLEND;

/** @const {number} */
WebGLRenderingContext.prototype.DITHER;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_TEST;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_TEST;

/** @const {number} */
WebGLRenderingContext.prototype.SCISSOR_TEST;

/** @const {number} */
WebGLRenderingContext.prototype.POLYGON_OFFSET_FILL;

/** @const {number} */
WebGLRenderingContext.prototype.SAMPLE_ALPHA_TO_COVERAGE;

/** @const {number} */
WebGLRenderingContext.prototype.SAMPLE_COVERAGE;

/** @const {number} */
WebGLRenderingContext.prototype.NO_ERROR;

/** @const {number} */
WebGLRenderingContext.prototype.INVALID_ENUM;

/** @const {number} */
WebGLRenderingContext.prototype.INVALID_VALUE;

/** @const {number} */
WebGLRenderingContext.prototype.INVALID_OPERATION;

/** @const {number} */
WebGLRenderingContext.prototype.OUT_OF_MEMORY;

/** @const {number} */
WebGLRenderingContext.prototype.CW;

/** @const {number} */
WebGLRenderingContext.prototype.CCW;

/** @const {number} */
WebGLRenderingContext.prototype.LINE_WIDTH;

/** @const {number} */
WebGLRenderingContext.prototype.ALIASED_POINT_SIZE_RANGE;

/** @const {number} */
WebGLRenderingContext.prototype.ALIASED_LINE_WIDTH_RANGE;

/** @const {number} */
WebGLRenderingContext.prototype.CULL_FACE_MODE;

/** @const {number} */
WebGLRenderingContext.prototype.FRONT_FACE;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_RANGE;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_WRITEMASK;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_CLEAR_VALUE;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_FUNC;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_CLEAR_VALUE;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_FUNC;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_FAIL;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_PASS_DEPTH_FAIL;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_PASS_DEPTH_PASS;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_REF;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_VALUE_MASK;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_WRITEMASK;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_BACK_FUNC;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_BACK_FAIL;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_BACK_PASS_DEPTH_FAIL;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_BACK_PASS_DEPTH_PASS;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_BACK_REF;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_BACK_VALUE_MASK;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_BACK_WRITEMASK;

/** @const {number} */
WebGLRenderingContext.prototype.VIEWPORT;

/** @const {number} */
WebGLRenderingContext.prototype.SCISSOR_BOX;

/** @const {number} */
WebGLRenderingContext.prototype.COLOR_CLEAR_VALUE;

/** @const {number} */
WebGLRenderingContext.prototype.COLOR_WRITEMASK;

/** @const {number} */
WebGLRenderingContext.prototype.UNPACK_ALIGNMENT;

/** @const {number} */
WebGLRenderingContext.prototype.PACK_ALIGNMENT;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_TEXTURE_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_VIEWPORT_DIMS;

/** @const {number} */
WebGLRenderingContext.prototype.SUBPIXEL_BITS;

/** @const {number} */
WebGLRenderingContext.prototype.RED_BITS;

/** @const {number} */
WebGLRenderingContext.prototype.GREEN_BITS;

/** @const {number} */
WebGLRenderingContext.prototype.BLUE_BITS;

/** @const {number} */
WebGLRenderingContext.prototype.ALPHA_BITS;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_BITS;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_BITS;

/** @const {number} */
WebGLRenderingContext.prototype.POLYGON_OFFSET_UNITS;

/** @const {number} */
WebGLRenderingContext.prototype.POLYGON_OFFSET_FACTOR;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_BINDING_2D;

/** @const {number} */
WebGLRenderingContext.prototype.SAMPLE_BUFFERS;

/** @const {number} */
WebGLRenderingContext.prototype.SAMPLES;

/** @const {number} */
WebGLRenderingContext.prototype.SAMPLE_COVERAGE_VALUE;

/** @const {number} */
WebGLRenderingContext.prototype.SAMPLE_COVERAGE_INVERT;

/** @const {number} */
WebGLRenderingContext.prototype.COMPRESSED_TEXTURE_FORMATS;

/** @const {number} */
WebGLRenderingContext.prototype.DONT_CARE;

/** @const {number} */
WebGLRenderingContext.prototype.FASTEST;

/** @const {number} */
WebGLRenderingContext.prototype.NICEST;

/** @const {number} */
WebGLRenderingContext.prototype.GENERATE_MIPMAP_HINT;

/** @const {number} */
WebGLRenderingContext.prototype.BYTE;

/** @const {number} */
WebGLRenderingContext.prototype.UNSIGNED_BYTE;

/** @const {number} */
WebGLRenderingContext.prototype.SHORT;

/** @const {number} */
WebGLRenderingContext.prototype.UNSIGNED_SHORT;

/** @const {number} */
WebGLRenderingContext.prototype.INT;

/** @const {number} */
WebGLRenderingContext.prototype.UNSIGNED_INT;

/** @const {number} */
WebGLRenderingContext.prototype.FLOAT;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_COMPONENT;

/** @const {number} */
WebGLRenderingContext.prototype.ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.RGB;

/** @const {number} */
WebGLRenderingContext.prototype.RGBA;

/** @const {number} */
WebGLRenderingContext.prototype.LUMINANCE;

/** @const {number} */
WebGLRenderingContext.prototype.LUMINANCE_ALPHA;

/** @const {number} */
WebGLRenderingContext.prototype.UNSIGNED_SHORT_4_4_4_4;

/** @const {number} */
WebGLRenderingContext.prototype.UNSIGNED_SHORT_5_5_5_1;

/** @const {number} */
WebGLRenderingContext.prototype.UNSIGNED_SHORT_5_6_5;

/** @const {number} */
WebGLRenderingContext.prototype.FRAGMENT_SHADER;

/** @const {number} */
WebGLRenderingContext.prototype.VERTEX_SHADER;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_VERTEX_ATTRIBS;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_VERTEX_UNIFORM_VECTORS;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_VARYING_VECTORS;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_COMBINED_TEXTURE_IMAGE_UNITS;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_VERTEX_TEXTURE_IMAGE_UNITS;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_TEXTURE_IMAGE_UNITS;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_FRAGMENT_UNIFORM_VECTORS;

/** @const {number} */
WebGLRenderingContext.prototype.SHADER_TYPE;

/** @const {number} */
WebGLRenderingContext.prototype.DELETE_STATUS;

/** @const {number} */
WebGLRenderingContext.prototype.LINK_STATUS;

/** @const {number} */
WebGLRenderingContext.prototype.VALIDATE_STATUS;

/** @const {number} */
WebGLRenderingContext.prototype.ATTACHED_SHADERS;

/** @const {number} */
WebGLRenderingContext.prototype.ACTIVE_UNIFORMS;

/** @const {number} */
WebGLRenderingContext.prototype.ACTIVE_ATTRIBUTES;

/** @const {number} */
WebGLRenderingContext.prototype.SHADING_LANGUAGE_VERSION;

/** @const {number} */
WebGLRenderingContext.prototype.CURRENT_PROGRAM;

/** @const {number} */
WebGLRenderingContext.prototype.NEVER;

/** @const {number} */
WebGLRenderingContext.prototype.LESS;

/** @const {number} */
WebGLRenderingContext.prototype.EQUAL;

/** @const {number} */
WebGLRenderingContext.prototype.LEQUAL;

/** @const {number} */
WebGLRenderingContext.prototype.GREATER;

/** @const {number} */
WebGLRenderingContext.prototype.NOTEQUAL;

/** @const {number} */
WebGLRenderingContext.prototype.GEQUAL;

/** @const {number} */
WebGLRenderingContext.prototype.ALWAYS;

/** @const {number} */
WebGLRenderingContext.prototype.KEEP;

/** @const {number} */
WebGLRenderingContext.prototype.REPLACE;

/** @const {number} */
WebGLRenderingContext.prototype.INCR;

/** @const {number} */
WebGLRenderingContext.prototype.DECR;

/** @const {number} */
WebGLRenderingContext.prototype.INVERT;

/** @const {number} */
WebGLRenderingContext.prototype.INCR_WRAP;

/** @const {number} */
WebGLRenderingContext.prototype.DECR_WRAP;

/** @const {number} */
WebGLRenderingContext.prototype.VENDOR;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERER;

/** @const {number} */
WebGLRenderingContext.prototype.VERSION;

/** @const {number} */
WebGLRenderingContext.prototype.NEAREST;

/** @const {number} */
WebGLRenderingContext.prototype.LINEAR;

/** @const {number} */
WebGLRenderingContext.prototype.NEAREST_MIPMAP_NEAREST;

/** @const {number} */
WebGLRenderingContext.prototype.LINEAR_MIPMAP_NEAREST;

/** @const {number} */
WebGLRenderingContext.prototype.NEAREST_MIPMAP_LINEAR;

/** @const {number} */
WebGLRenderingContext.prototype.LINEAR_MIPMAP_LINEAR;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_MAG_FILTER;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_MIN_FILTER;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_WRAP_S;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_WRAP_T;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_2D;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_CUBE_MAP;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_BINDING_CUBE_MAP;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_CUBE_MAP_POSITIVE_X;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_CUBE_MAP_NEGATIVE_X;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_CUBE_MAP_POSITIVE_Y;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_CUBE_MAP_NEGATIVE_Y;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_CUBE_MAP_POSITIVE_Z;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE_CUBE_MAP_NEGATIVE_Z;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_CUBE_MAP_TEXTURE_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE0;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE1;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE2;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE3;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE4;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE5;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE6;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE7;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE8;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE9;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE10;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE11;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE12;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE13;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE14;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE15;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE16;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE17;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE18;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE19;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE20;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE21;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE22;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE23;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE24;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE25;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE26;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE27;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE28;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE29;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE30;

/** @const {number} */
WebGLRenderingContext.prototype.TEXTURE31;

/** @const {number} */
WebGLRenderingContext.prototype.ACTIVE_TEXTURE;

/** @const {number} */
WebGLRenderingContext.prototype.REPEAT;

/** @const {number} */
WebGLRenderingContext.prototype.CLAMP_TO_EDGE;

/** @const {number} */
WebGLRenderingContext.prototype.MIRRORED_REPEAT;

/** @const {number} */
WebGLRenderingContext.prototype.FLOAT_VEC2;

/** @const {number} */
WebGLRenderingContext.prototype.FLOAT_VEC3;

/** @const {number} */
WebGLRenderingContext.prototype.FLOAT_VEC4;

/** @const {number} */
WebGLRenderingContext.prototype.INT_VEC2;

/** @const {number} */
WebGLRenderingContext.prototype.INT_VEC3;

/** @const {number} */
WebGLRenderingContext.prototype.INT_VEC4;

/** @const {number} */
WebGLRenderingContext.prototype.BOOL;

/** @const {number} */
WebGLRenderingContext.prototype.BOOL_VEC2;

/** @const {number} */
WebGLRenderingContext.prototype.BOOL_VEC3;

/** @const {number} */
WebGLRenderingContext.prototype.BOOL_VEC4;

/** @const {number} */
WebGLRenderingContext.prototype.FLOAT_MAT2;

/** @const {number} */
WebGLRenderingContext.prototype.FLOAT_MAT3;

/** @const {number} */
WebGLRenderingContext.prototype.FLOAT_MAT4;

/** @const {number} */
WebGLRenderingContext.prototype.SAMPLER_2D;

/** @const {number} */
WebGLRenderingContext.prototype.SAMPLER_CUBE;

/** @const {number} */
WebGLRenderingContext.prototype.VERTEX_ATTRIB_ARRAY_ENABLED;

/** @const {number} */
WebGLRenderingContext.prototype.VERTEX_ATTRIB_ARRAY_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.VERTEX_ATTRIB_ARRAY_STRIDE;

/** @const {number} */
WebGLRenderingContext.prototype.VERTEX_ATTRIB_ARRAY_TYPE;

/** @const {number} */
WebGLRenderingContext.prototype.VERTEX_ATTRIB_ARRAY_NORMALIZED;

/** @const {number} */
WebGLRenderingContext.prototype.VERTEX_ATTRIB_ARRAY_POINTER;

/** @const {number} */
WebGLRenderingContext.prototype.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.prototype.COMPILE_STATUS;

/** @const {number} */
WebGLRenderingContext.prototype.LOW_FLOAT;

/** @const {number} */
WebGLRenderingContext.prototype.MEDIUM_FLOAT;

/** @const {number} */
WebGLRenderingContext.prototype.HIGH_FLOAT;

/** @const {number} */
WebGLRenderingContext.prototype.LOW_INT;

/** @const {number} */
WebGLRenderingContext.prototype.MEDIUM_INT;

/** @const {number} */
WebGLRenderingContext.prototype.HIGH_INT;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER;

/** @const {number} */
WebGLRenderingContext.prototype.RGBA4;

/** @const {number} */
WebGLRenderingContext.prototype.RGB5_A1;

/** @const {number} */
WebGLRenderingContext.prototype.RGB565;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_COMPONENT16;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_INDEX;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_INDEX8;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_STENCIL;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_WIDTH;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_HEIGHT;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_INTERNAL_FORMAT;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_RED_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_GREEN_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_BLUE_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_ALPHA_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_DEPTH_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_STENCIL_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE;

/** @const {number} */
WebGLRenderingContext.prototype.COLOR_ATTACHMENT0;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.prototype.STENCIL_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.prototype.DEPTH_STENCIL_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.prototype.NONE;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_COMPLETE;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_INCOMPLETE_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_INCOMPLETE_DIMENSIONS;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_UNSUPPORTED;

/** @const {number} */
WebGLRenderingContext.prototype.FRAMEBUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.prototype.RENDERBUFFER_BINDING;

/** @const {number} */
WebGLRenderingContext.prototype.MAX_RENDERBUFFER_SIZE;

/** @const {number} */
WebGLRenderingContext.prototype.INVALID_FRAMEBUFFER_OPERATION;

/** @const {number} */
WebGLRenderingContext.prototype.UNPACK_FLIP_Y_WEBGL;

/** @const {number} */
WebGLRenderingContext.prototype.UNPACK_PREMULTIPLY_ALPHA_WEBGL;

/** @const {number} */
WebGLRenderingContext.prototype.CONTEXT_LOST_WEBGL;

/** @const {number} */
WebGLRenderingContext.prototype.UNPACK_COLORSPACE_CONVERSION_WEBGL;

/** @const {number} */
WebGLRenderingContext.prototype.BROWSER_DEFAULT_WEBGL;


/**
 * @type {!HTMLCanvasElement}
 */
WebGLRenderingContext.prototype.canvas;

/**
 * @type {number}
 */
WebGLRenderingContext.prototype.drawingBufferWidth;

/**
 * @type {number}
 */
WebGLRenderingContext.prototype.drawingBufferHeight;

/**
 * @return {!WebGLContextAttributes}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getContextAttributes = function() {};

/**
 * @return {boolean}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.isContextLost = function() {};

/**
 * @return {!Array<string>}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getSupportedExtensions = function() {};

/**
 * Note that this has side effects by enabling the extension even if the
 * result is not used.
 * @param {string} name
 * @return {Object}
 */
WebGLRenderingContext.prototype.getExtension = function(name) {};

/**
 * @param {number} texture
 * @return {undefined}
 */
WebGLRenderingContext.prototype.activeTexture = function(texture) {};

/**
 * @param {WebGLProgram} program
 * @param {WebGLShader} shader
 * @return {undefined}
 */
WebGLRenderingContext.prototype.attachShader = function(program, shader) {};

/**
 * @param {WebGLProgram} program
 * @param {number} index
 * @param {string} name
 * @return {undefined}
 */
WebGLRenderingContext.prototype.bindAttribLocation = function(
    program, index, name) {};

/**
 * @param {number} target
 * @param {WebGLBuffer} buffer
 * @return {undefined}
 */
WebGLRenderingContext.prototype.bindBuffer = function(target, buffer) {};

/**
 * @param {number} target
 * @param {WebGLFramebuffer} buffer
 * @return {undefined}
 */
WebGLRenderingContext.prototype.bindFramebuffer = function(target, buffer) {};

/**
 * @param {number} target
 * @param {WebGLRenderbuffer} buffer
 * @return {undefined}
 */
WebGLRenderingContext.prototype.bindRenderbuffer = function(target, buffer) {};

/**
 * @param {number} target
 * @param {WebGLTexture} texture
 * @return {undefined}
 */
WebGLRenderingContext.prototype.bindTexture = function(target, texture) {};

/**
 * @param {number} red
 * @param {number} green
 * @param {number} blue
 * @param {number} alpha
 * @return {undefined}
 */
WebGLRenderingContext.prototype.blendColor = function(
    red, green, blue, alpha) {};

/**
 * @param {number} mode
 * @return {undefined}
 */
WebGLRenderingContext.prototype.blendEquation = function(mode) {};

/**
 * @param {number} modeRGB
 * @param {number} modeAlpha
 * @return {undefined}
 */
WebGLRenderingContext.prototype.blendEquationSeparate = function(
    modeRGB, modeAlpha) {};

/**
 * @param {number} sfactor
 * @param {number} dfactor
 * @return {undefined}
 */
WebGLRenderingContext.prototype.blendFunc = function(sfactor, dfactor) {};

/**
 * @param {number} srcRGB
 * @param {number} dstRGB
 * @param {number} srcAlpha
 * @param {number} dstAlpha
 * @return {undefined}
 */
WebGLRenderingContext.prototype.blendFuncSeparate = function(
    srcRGB, dstRGB, srcAlpha, dstAlpha) {};

/**
 * @param {number} target
 * @param {ArrayBufferView|ArrayBuffer|number} data
 * @param {number} usage
 * @return {undefined}
 */
WebGLRenderingContext.prototype.bufferData = function(target, data, usage) {};

/**
 * @param {number} target
 * @param {number} offset
 * @param {ArrayBufferView|ArrayBuffer} data
 * @return {undefined}
 */
WebGLRenderingContext.prototype.bufferSubData = function(
    target, offset, data) {};

/**
 * @param {number} target
 * @return {number}
 */
WebGLRenderingContext.prototype.checkFramebufferStatus = function(target) {};

/**
 * @param {number} mask
 * @return {undefined}
 */
WebGLRenderingContext.prototype.clear = function(mask) {};

/**
 * @param {number} red
 * @param {number} green
 * @param {number} blue
 * @param {number} alpha
 * @return {undefined}
 */
WebGLRenderingContext.prototype.clearColor = function(
    red, green, blue, alpha) {};

/**
 * @param {number} depth
 * @return {undefined}
 */
WebGLRenderingContext.prototype.clearDepth = function(depth) {};

/**
 * @param {number} s
 * @return {undefined}
 */
WebGLRenderingContext.prototype.clearStencil = function(s) {};

/**
 * @param {boolean} red
 * @param {boolean} green
 * @param {boolean} blue
 * @param {boolean} alpha
 * @return {undefined}
 */
WebGLRenderingContext.prototype.colorMask = function(
    red, green, blue, alpha) {};

/**
 * @param {WebGLShader} shader
 * @return {undefined}
 */
WebGLRenderingContext.prototype.compileShader = function(shader) {};

/**
 * @param {number} target
 * @param {number} level
 * @param {number} internalformat
 * @param {number} width
 * @param {number} height
 * @param {number} border
 * @param {ArrayBufferView} data
 * @return {undefined}
 */
WebGLRenderingContext.prototype.compressedTexImage2D = function(
    target, level, internalformat, width, height, border, data) {};

/**
 * @param {number} target
 * @param {number} level
 * @param {number} xoffset
 * @param {number} yoffset
 * @param {number} width
 * @param {number} height
 * @param {number} format
 * @param {ArrayBufferView} data
 * @return {undefined}
 */
WebGLRenderingContext.prototype.compressedTexSubImage2D = function(
    target, level, xoffset, yoffset, width, height, format, data) {};

/**
 * @param {number} target
 * @param {number} level
 * @param {number} format
 * @param {number} x
 * @param {number} y
 * @param {number} width
 * @param {number} height
 * @param {number} border
 * @return {undefined}
 */
WebGLRenderingContext.prototype.copyTexImage2D = function(
    target, level, format, x, y, width, height, border) {};

/**
 * @param {number} target
 * @param {number} level
 * @param {number} xoffset
 * @param {number} yoffset
 * @param {number} x
 * @param {number} y
 * @param {number} width
 * @param {number} height
 * @return {undefined}
 */
WebGLRenderingContext.prototype.copyTexSubImage2D = function(
    target, level, xoffset, yoffset, x, y, width, height) {};

/**
 * @return {!WebGLBuffer}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.createBuffer = function() {};

/**
 * @return {!WebGLFramebuffer}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.createFramebuffer = function() {};

/**
 * @return {!WebGLProgram}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.createProgram = function() {};

/**
 * @return {!WebGLRenderbuffer}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.createRenderbuffer = function() {};

/**
 * @param {number} type
 * @return {!WebGLShader}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.createShader = function(type) {};

/**
 * @return {!WebGLTexture}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.createTexture = function() {};

/**
 * @param {number} mode
 * @return {undefined}
 */
WebGLRenderingContext.prototype.cullFace = function(mode) {};

/**
 * @param {WebGLBuffer} buffer
 * @return {undefined}
 */
WebGLRenderingContext.prototype.deleteBuffer = function(buffer) {};

/**
 * @param {WebGLFramebuffer} buffer
 * @return {undefined}
 */
WebGLRenderingContext.prototype.deleteFramebuffer = function(buffer) {};

/**
 * @param {WebGLProgram} program
 * @return {undefined}
 */
WebGLRenderingContext.prototype.deleteProgram = function(program) {};

/**
 * @param {WebGLRenderbuffer} buffer
 * @return {undefined}
 */
WebGLRenderingContext.prototype.deleteRenderbuffer = function(buffer) {};

/**
 * @param {WebGLShader} shader
 * @return {undefined}
 */
WebGLRenderingContext.prototype.deleteShader = function(shader) {};

/**
 * @param {WebGLTexture} texture
 * @return {undefined}
 */
WebGLRenderingContext.prototype.deleteTexture = function(texture) {};

/**
 * @param {number} func
 * @return {undefined}
 */
WebGLRenderingContext.prototype.depthFunc = function(func) {};

/**
 * @param {boolean} flag
 * @return {undefined}
 */
WebGLRenderingContext.prototype.depthMask = function(flag) {};

/**
 * @param {number} nearVal
 * @param {number} farVal
 * @return {undefined}
 */
WebGLRenderingContext.prototype.depthRange = function(nearVal, farVal) {};

/**
 * @param {WebGLProgram} program
 * @param {WebGLShader} shader
 * @return {undefined}
 */
WebGLRenderingContext.prototype.detachShader = function(program, shader) {};

/**
 * @param {number} flags
 * @return {undefined}
 */
WebGLRenderingContext.prototype.disable = function(flags) {};

/**
 * @param {number} index
 * @return {undefined}
 */
WebGLRenderingContext.prototype.disableVertexAttribArray = function(
    index) {};

/**
 * @param {number} mode
 * @param {number} first
 * @param {number} count
 * @return {undefined}
 */
WebGLRenderingContext.prototype.drawArrays = function(mode, first, count) {};

/**
 * @param {number} mode
 * @param {number} count
 * @param {number} type
 * @param {number} offset
 * @return {undefined}
 */
WebGLRenderingContext.prototype.drawElements = function(
    mode, count, type, offset) {};

/**
 * @param {number} cap
 * @return {undefined}
 */
WebGLRenderingContext.prototype.enable = function(cap) {};

/**
 * @param {number} index
 * @return {undefined}
 */
WebGLRenderingContext.prototype.enableVertexAttribArray = function(
    index) {};

WebGLRenderingContext.prototype.finish = function() {};

WebGLRenderingContext.prototype.flush = function() {};

/**
 * @param {number} target
 * @param {number} attachment
 * @param {number} renderbuffertarget
 * @param {WebGLRenderbuffer} renderbuffer
 * @return {undefined}
 */
WebGLRenderingContext.prototype.framebufferRenderbuffer = function(
    target, attachment, renderbuffertarget, renderbuffer) {};

/**
 * @param {number} target
 * @param {number} attachment
 * @param {number} textarget
 * @param {WebGLTexture} texture
 * @param {number} level
 * @return {undefined}
 */
WebGLRenderingContext.prototype.framebufferTexture2D = function(
    target, attachment, textarget, texture, level) {};

/**
 * @param {number} mode
 * @return {undefined}
 */
WebGLRenderingContext.prototype.frontFace = function(mode) {};

/**
 * @param {number} target
 * @return {undefined}
 */
WebGLRenderingContext.prototype.generateMipmap = function(target) {};

/**
 * @param {WebGLProgram} program
 * @param {number} index
 * @return {WebGLActiveInfo}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getActiveAttrib = function(program, index) {};

/**
 * @param {WebGLProgram} program
 * @param {number} index
 * @return {WebGLActiveInfo}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getActiveUniform = function(program, index) {};

/**
 * @param {WebGLProgram} program
 * @return {!Array<WebGLShader>}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getAttachedShaders = function(program) {};

/**
 * @param {WebGLProgram} program
 * @param {string} name
 * @return {number}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getAttribLocation = function(program, name) {};

/**
 * @param {number} target
 * @param {number} pname
 * @return {*}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getBufferParameter = function(target, pname) {};

/**
 * @param {number} pname
 * @return {*}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getParameter = function(pname) {};

/**
 * @return {number}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getError = function() {};

/**
 * @param {number} target
 * @param {number} attachment
 * @param {number} pname
 * @return {*}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getFramebufferAttachmentParameter = function(
    target, attachment, pname) {};

/**
 * @param {WebGLProgram} program
 * @param {number} pname
 * @return {*}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getProgramParameter = function(
    program, pname) {};

/**
 * @param {WebGLProgram} program
 * @return {string}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getProgramInfoLog = function(program) {};

/**
 * @param {number} target
 * @param {number} pname
 * @return {*}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getRenderbufferParameter = function(
    target, pname) {};

/**
 * @param {WebGLShader} shader
 * @param {number} pname
 * @return {*}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getShaderParameter = function(shader, pname) {};

/**
 * @param {number} shadertype
 * @param {number} precisiontype
 * @return {WebGLShaderPrecisionFormat}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getShaderPrecisionFormat = function(shadertype,
    precisiontype) {};

/**
 * @param {WebGLShader} shader
 * @return {string}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getShaderInfoLog = function(shader) {};

/**
 * @param {WebGLShader} shader
 * @return {string}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getShaderSource = function(shader) {};

/**
 * @param {number} target
 * @param {number} pname
 * @return {*}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getTexParameter = function(target, pname) {};

/**
 * @param {WebGLProgram} program
 * @param {WebGLUniformLocation} location
 * @return {*}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getUniform = function(program, location) {};

/**
 * @param {WebGLProgram} program
 * @param {string} name
 * @return {WebGLUniformLocation}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getUniformLocation = function(program, name) {};

/**
 * @param {number} index
 * @param {number} pname
 * @return {*}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getVertexAttrib = function(index, pname) {};

/**
 * @param {number} index
 * @param {number} pname
 * @return {number}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.getVertexAttribOffset = function(
    index, pname) {};

/**
 * @param {number} target
 * @param {number} mode
 * @return {undefined}
 */
WebGLRenderingContext.prototype.hint = function(target, mode) {};

/**
 * @param {WebGLObject} buffer
 * @return {boolean}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.isBuffer = function(buffer) {};

/**
 * @param {number} cap
 * @return {boolean}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.isEnabled = function(cap) {};

/**
 * @param {WebGLObject} framebuffer
 * @return {boolean}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.isFramebuffer = function(framebuffer) {};

/**
 * @param {WebGLObject} program
 * @return {boolean}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.isProgram = function(program) {};

/**
 * @param {WebGLObject} renderbuffer
 * @return {boolean}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.isRenderbuffer = function(renderbuffer) {};

/**
 * @param {WebGLObject} shader
 * @return {boolean}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.isShader = function(shader) {};

/**
 * @param {WebGLObject} texture
 * @return {boolean}
 * @nosideeffects
 */
WebGLRenderingContext.prototype.isTexture = function(texture) {};

/**
 * @param {number} width
 * @return {undefined}
 */
WebGLRenderingContext.prototype.lineWidth = function(width) {};

/**
 * @param {WebGLProgram} program
 * @return {undefined}
 */
WebGLRenderingContext.prototype.linkProgram = function(program) {};

/**
 * @param {number} pname
 * @param {number|boolean} param
 * @return {undefined}
 */
WebGLRenderingContext.prototype.pixelStorei = function(pname, param) {};

/**
 * @param {number} factor
 * @param {number} units
 * @return {undefined}
 */
WebGLRenderingContext.prototype.polygonOffset = function(factor, units) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} width
 * @param {number} height
 * @param {number} format
 * @param {number} type
 * @param {ArrayBufferView} pixels
 * @return {undefined}
 */
WebGLRenderingContext.prototype.readPixels = function(
    x, y, width, height, format, type, pixels) {};

/**
 * @param {number} target
 * @param {number} internalformat
 * @param {number} width
 * @param {number} height
 * @return {undefined}
 */
WebGLRenderingContext.prototype.renderbufferStorage = function(
    target, internalformat, width, height) {};

/**
 * @param {number} coverage
 * @param {boolean} invert
 * @return {undefined}
 */
WebGLRenderingContext.prototype.sampleCoverage = function(coverage, invert) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} width
 * @param {number} height
 * @return {undefined}
 */
WebGLRenderingContext.prototype.scissor = function(x, y, width, height) {};

/**
 * @param {WebGLShader} shader
 * @param {string} source
 * @return {undefined}
 */
WebGLRenderingContext.prototype.shaderSource = function(shader, source) {};

/**
 * @param {number} func
 * @param {number} ref
 * @param {number} mask
 * @return {undefined}
 */
WebGLRenderingContext.prototype.stencilFunc = function(func, ref, mask) {};

/**
 * @param {number} face
 * @param {number} func
 * @param {number} ref
 * @param {number} mask
 * @return {undefined}
 */
WebGLRenderingContext.prototype.stencilFuncSeparate = function(
    face, func, ref, mask) {};

/**
 * @param {number} mask
 * @return {undefined}
 */
WebGLRenderingContext.prototype.stencilMask = function(mask) {};

/**
 * @param {number} face
 * @param {number} mask
 * @return {undefined}
 */
WebGLRenderingContext.prototype.stencilMaskSeparate = function(face, mask) {};

/**
 * @param {number} fail
 * @param {number} zfail
 * @param {number} zpass
 * @return {undefined}
 */
WebGLRenderingContext.prototype.stencilOp = function(fail, zfail, zpass) {};

/**
 * @param {number} face
 * @param {number} fail
 * @param {number} zfail
 * @param {number} zpass
 * @return {undefined}
 */
WebGLRenderingContext.prototype.stencilOpSeparate = function(
    face, fail, zfail, zpass) {};

/**
 * @param {number} target
 * @param {number} level
 * @param {number} internalformat
 * @param {number} format or width
 * @param {number} type or height
 * @param {?TexImageSource|number} img or border
 * @param {number=} opt_format
 * @param {number=} opt_type
 * @param {ArrayBufferView=} opt_pixels
 * @return {undefined}
 */
WebGLRenderingContext.prototype.texImage2D = function(
    target, level, internalformat, format, type, img, opt_format, opt_type,
    opt_pixels) {};

/**
 * @param {number} target
 * @param {number} pname
 * @param {number} param
 * @return {undefined}
 */
WebGLRenderingContext.prototype.texParameterf = function(
    target, pname, param) {};

/**
 * @param {number} target
 * @param {number} pname
 * @param {number} param
 * @return {undefined}
 */
WebGLRenderingContext.prototype.texParameteri = function(
    target, pname, param) {};

/**
 * @param {number} target
 * @param {number} level
 * @param {number} xoffset
 * @param {number} yoffset
 * @param {number} format or width
 * @param {number} type or height
 * @param {?TexImageSource|number} data or format
 * @param {number=} opt_type
 * @param {ArrayBufferView=} opt_pixels
 * @return {undefined}
 */
WebGLRenderingContext.prototype.texSubImage2D = function(
    target, level, xoffset, yoffset, format, type, data, opt_type,
    opt_pixels) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {number} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform1f = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {Float32Array|Array<number>} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform1fv = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {number|boolean} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform1i = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {Int32Array|Array<number>|Array<boolean>} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform1iv = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {number} value1
 * @param {number} value2
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform2f = function(
    location, value1, value2) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {Float32Array|Array<number>} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform2fv = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {number|boolean} value1
 * @param {number|boolean} value2
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform2i = function(
    location, value1, value2) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {Int32Array|Array<number>|Array<boolean>} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform2iv = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {number} value1
 * @param {number} value2
 * @param {number} value3
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform3f = function(
    location, value1, value2, value3) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {Float32Array|Array<number>} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform3fv = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {number|boolean} value1
 * @param {number|boolean} value2
 * @param {number|boolean} value3
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform3i = function(
    location, value1, value2, value3) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {Int32Array|Array<number>|Array<boolean>} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform3iv = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {number} value1
 * @param {number} value2
 * @param {number} value3
 * @param {number} value4
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform4f = function(
    location, value1, value2, value3, value4) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {Float32Array|Array<number>} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform4fv = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {number|boolean} value1
 * @param {number|boolean} value2
 * @param {number|boolean} value3
 * @param {number|boolean} value4
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform4i = function(
    location, value1, value2, value3, value4) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {Int32Array|Array<number>|Array<boolean>} value
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniform4iv = function(location, value) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {boolean} transpose
 * @param {Float32Array|Array<number>} data
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniformMatrix2fv = function(
    location, transpose, data) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {boolean} transpose
 * @param {Float32Array|Array<number>} data
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniformMatrix3fv = function(
    location, transpose, data) {};

/**
 * @param {WebGLUniformLocation} location
 * @param {boolean} transpose
 * @param {Float32Array|Array<number>} data
 * @return {undefined}
 */
WebGLRenderingContext.prototype.uniformMatrix4fv = function(
    location, transpose, data) {};

/**
 * @param {WebGLProgram} program
 * @return {undefined}
 */
WebGLRenderingContext.prototype.useProgram = function(program) {};

/**
 * @param {WebGLProgram} program
 * @return {undefined}
 */
WebGLRenderingContext.prototype.validateProgram = function(program) {};

/**
 * @param {number} indx
 * @param {number} x
 * @return {undefined}
 */
WebGLRenderingContext.prototype.vertexAttrib1f = function(indx, x) {};

/**
 * @param {number} indx
 * @param {Float32Array|Array<number>} values
 * @return {undefined}
 */
WebGLRenderingContext.prototype.vertexAttrib1fv = function(indx, values) {};

/**
 * @param {number} indx
 * @param {number} x
 * @param {number} y
 * @return {undefined}
 */
WebGLRenderingContext.prototype.vertexAttrib2f = function(
    indx, x, y) {};

/**
 * @param {number} indx
 * @param {Float32Array|Array<number>} values
 * @return {undefined}
 */
WebGLRenderingContext.prototype.vertexAttrib2fv = function(
    indx, values) {};

/**
 * @param {number} indx
 * @param {number} x
 * @param {number} y
 * @param {number} z
 * @return {undefined}
 */
WebGLRenderingContext.prototype.vertexAttrib3f = function(
    indx, x, y, z) {};

/**
 * @param {number} indx
 * @param {Float32Array|Array<number>} values
 * @return {undefined}
 */
WebGLRenderingContext.prototype.vertexAttrib3fv = function(indx, values) {};

/**
 * @param {number} indx
 * @param {number} x
 * @param {number} y
 * @param {number} z
 * @param {number} w
 * @return {undefined}
 */
WebGLRenderingContext.prototype.vertexAttrib4f = function(
    indx, x, y, z, w) {};

/**
 * @param {number} indx
 * @param {Float32Array|Array<number>} values
 * @return {undefined}
 */
WebGLRenderingContext.prototype.vertexAttrib4fv = function(indx, values) {};

/**
 * @param {number} indx
 * @param {number} size
 * @param {number} type
 * @param {boolean} normalized
 * @param {number} stride
 * @param {number} offset
 * @return {undefined}
 */
WebGLRenderingContext.prototype.vertexAttribPointer = function(
    indx, size, type, normalized, stride, offset) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} width
 * @param {number} height
 * @return {undefined}
 */
WebGLRenderingContext.prototype.viewport = function(x, y, width, height) {};


/**
 * @constructor
 */
function WebGLContextAttributes() {}

/**
 * @type {boolean}
 */
WebGLContextAttributes.prototype.alpha;

/**
 * @type {boolean}
 */
WebGLContextAttributes.prototype.depth;

/**
 * @type {boolean}
 */
WebGLContextAttributes.prototype.stencil;

/**
 * @type {boolean}
 */
WebGLContextAttributes.prototype.antialias;

/**
 * @type {boolean}
 */
WebGLContextAttributes.prototype.premultipliedAlpha;

/**
 * @type {boolean}
 */
WebGLContextAttributes.prototype.preserveDrawingBuffer;

/**
 * @type {boolean}
 */
WebGLContextAttributes.prototype.desynchronized;

/**
 * @type {boolean}
 */
WebGLContextAttributes.prototype.failIfMajorPerformanceCaveat;

/**
 * Possible values: 'default', 'low-power', 'high-performance'
 * @type {string}
 */
WebGLContextAttributes.prototype.powerPreference;

/**
 * @param {string} eventType
 * @constructor
 * @extends {Event}
 */
function WebGLContextEvent(eventType) {}

/**
 * @type {string}
 */
WebGLContextEvent.prototype.statusMessage;


/**
 * @constructor
 */
function WebGLShaderPrecisionFormat() {}

/**
 * @type {number}
 */
WebGLShaderPrecisionFormat.prototype.rangeMin;

/**
 * @type {number}
 */
WebGLShaderPrecisionFormat.prototype.rangeMax;

/**
 * @type {number}
 */
WebGLShaderPrecisionFormat.prototype.precision;


/**
 * @constructor
 */
function WebGLObject() {}


/**
 * @constructor
 * @extends {WebGLObject}
 */
function WebGLBuffer() {}


/**
 * @constructor
 * @extends {WebGLObject}
 */
function WebGLFramebuffer() {}


/**
 * @constructor
 * @extends {WebGLObject}
 */
function WebGLProgram() {}


/**
 * @constructor
 * @extends {WebGLObject}
 */
function WebGLRenderbuffer() {}


/**
 * @constructor
 * @extends {WebGLObject}
 */
function WebGLShader() {}


/**
 * @constructor
 * @extends {WebGLObject}
 */
function WebGLTexture() {}


/**
 * @constructor
 */
function WebGLActiveInfo() {}

/** @type {number} */
WebGLActiveInfo.prototype.size;

/** @type {number} */
WebGLActiveInfo.prototype.type;

/** @type {string} */
WebGLActiveInfo.prototype.name;


/**
 * @constructor
 */
function WebGLUniformLocation() {}


/**
 * @see http://www.khronos.org/registry/webgl/extensions/OES_texture_float/
 * @constructor
 */
function OES_texture_float() {}


/**
 * @see http://www.khronos.org/registry/webgl/extensions/OES_texture_half_float/
 * @constructor
 */
function OES_texture_half_float() {}

/** @type {number} */
OES_texture_half_float.prototype.HALF_FLOAT_OES;


/**
 * @see http://www.khronos.org/registry/webgl/extensions/WEBGL_lose_context/
 * @constructor
 */
function WEBGL_lose_context() {}

WEBGL_lose_context.prototype.loseContext = function() {};

WEBGL_lose_context.prototype.restoreContext = function() {};


/**
 * @see http://www.khronos.org/registry/webgl/extensions/OES_standard_derivatives/
 * @constructor
 */
function OES_standard_derivatives() {}

/** @type {number} */
OES_standard_derivatives.prototype.FRAGMENT_SHADER_DERIVATIVE_HINT_OES;


/**
 * @see http://www.khronos.org/registry/webgl/extensions/OES_vertex_array_object/
 * @constructor
 * @extends {WebGLObject}
 */
function WebGLVertexArrayObjectOES() {}


/**
 * @see http://www.khronos.org/registry/webgl/extensions/OES_vertex_array_object/
 * @constructor
 */
function OES_vertex_array_object() {}

/** @type {number} */
OES_vertex_array_object.prototype.VERTEX_ARRAY_BINDING_OES;

/**
 * @return {WebGLVertexArrayObjectOES}
 * @nosideeffects
 */
OES_vertex_array_object.prototype.createVertexArrayOES = function() {};

/**
 * @param {WebGLVertexArrayObjectOES} arrayObject
 * @return {undefined}
 */
OES_vertex_array_object.prototype.deleteVertexArrayOES =
    function(arrayObject) {};

/**
 * @param {WebGLVertexArrayObjectOES} arrayObject
 * @return {boolean}
 * @nosideeffects
 */
OES_vertex_array_object.prototype.isVertexArrayOES = function(arrayObject) {};

/**
 * @param {WebGLVertexArrayObjectOES} arrayObject
 * @return {undefined}
 */
OES_vertex_array_object.prototype.bindVertexArrayOES = function(arrayObject) {};


/**
 * @see http://www.khronos.org/registry/webgl/extensions/WEBGL_debug_renderer_info/
 * @constructor
 */
function WEBGL_debug_renderer_info() {}

/** @const {number} */
WEBGL_debug_renderer_info.prototype.UNMASKED_VENDOR_WEBGL;

/** @const {number} */
WEBGL_debug_renderer_info.prototype.UNMASKED_RENDERER_WEBGL;


/**
 * @see http://www.khronos.org/registry/webgl/extensions/WEBGL_debug_shaders/
 * @constructor
 */
function WEBGL_debug_shaders() {}

/**
 * @param {WebGLShader} shader
 * @return {string}
 * @nosideeffects
 */
WEBGL_debug_shaders.prototype.getTranslatedShaderSource = function(shader) {};


/**
 * @see http://www.khronos.org/registry/webgl/extensions/WEBGL_compressed_texture_s3tc/
 * @constructor
 */
function WEBGL_compressed_texture_s3tc() {}

/** @const {number} */
WEBGL_compressed_texture_s3tc.prototype.COMPRESSED_RGB_S3TC_DXT1_EXT;

/** @const {number} */
WEBGL_compressed_texture_s3tc.prototype.COMPRESSED_RGBA_S3TC_DXT1_EXT;

/** @const {number} */
WEBGL_compressed_texture_s3tc.prototype.COMPRESSED_RGBA_S3TC_DXT3_EXT;

/** @const {number} */
WEBGL_compressed_texture_s3tc.prototype.COMPRESSED_RGBA_S3TC_DXT5_EXT;


/**
 * @see http://www.khronos.org/registry/webgl/extensions/OES_depth_texture/
 * @constructor
 */
function OES_depth_texture() {}


/**
 * @see http://www.khronos.org/registry/webgl/extensions/OES_element_index_uint/
 * @constructor
 */
function OES_element_index_uint() {}


/**
 * @see http://www.khronos.org/registry/webgl/extensions/EXT_texture_filter_anisotropic/
 * @constructor
 */
function EXT_texture_filter_anisotropic() {}

/** @const {number} */
EXT_texture_filter_anisotropic.prototype.TEXTURE_MAX_ANISOTROPY_EXT;

/** @const {number} */
EXT_texture_filter_anisotropic.prototype.MAX_TEXTURE_MAX_ANISOTROPY_EXT;


/**
 * @see https://www.khronos.org/registry/webgl/extensions/WEBGL_draw_buffers/
 * @constructor
 */
function WEBGL_draw_buffers() {}

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT0_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT1_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT2_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT3_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT4_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT5_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT6_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT7_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT8_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT9_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT10_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT11_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT12_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT13_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT14_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.COLOR_ATTACHMENT15_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER0_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER1_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER2_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER3_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER4_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER5_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER6_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER7_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER8_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER9_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER10_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER11_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER12_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER13_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER14_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.DRAW_BUFFER15_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.MAX_COLOR_ATTACHMENTS_WEBGL;

/** @const {number} */
WEBGL_draw_buffers.prototype.MAX_DRAW_BUFFERS_WEBGL;

/**
 * @param {Array<number>} buffers Draw buffers.
 * @return {undefined}
 */
WEBGL_draw_buffers.prototype.drawBuffersWEBGL = function(buffers) {};


/**
 * @see http://www.khronos.org/registry/webgl/extensions/ANGLE_instanced_arrays/
 * @constructor
 */
function ANGLE_instanced_arrays() {}


/** @const {number} */
ANGLE_instanced_arrays.prototype.VERTEX_ATTRIB_ARRAY_DIVISOR_ANGLE;


/**
 * @param {number} mode Primitive type.
 * @param {number} first First vertex.
 * @param {number} count Number of vertices per instance.
 * @param {number} primcount Number of instances.
 * @return {undefined}
 */
ANGLE_instanced_arrays.prototype.drawArraysInstancedANGLE = function(
    mode, first, count, primcount) {};


/**
 * @param {number} mode Primitive type.
 * @param {number} count Number of vertex indices per instance.
 * @param {number} type Type of a vertex index.
 * @param {number} offset Offset to the first vertex index.
 * @param {number} primcount Number of instances.
 * @return {undefined}
 */
ANGLE_instanced_arrays.prototype.drawElementsInstancedANGLE = function(
    mode, count, type, offset, primcount) {};


/**
 * @param {number} index Attribute index.
 * @param {number} divisor Instance divisor.
 * @return {undefined}
 */
ANGLE_instanced_arrays.prototype.vertexAttribDivisorANGLE = function(
    index, divisor) {};

