/*
 * Copyright 2017 The Closure Compiler Authors.
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
 * @fileoverview Definitions for Vibration API based on "W3C Recommendation 18 October 2016"
 * @see https://www.w3.org/TR/2016/REC-vibration-20161018/
 *
 * @externs
 * @author vobruba.martin@gmail.com (Martin Vobruba)
 */


/**
 * @typedef {number|!Array<number>}
 * @see https://www.w3.org/TR/2016/REC-vibration-20161018/#idl-def-vibratepattern
 */
var VibratePattern;


/**
 * @param {!VibratePattern} pattern
 * @return {boolean}
 * @see https://www.w3.org/TR/2016/REC-vibration-20161018/#idl-def-navigator-vibrate(vibratepattern)
 */
Navigator.prototype.vibrate = function(pattern) {};
