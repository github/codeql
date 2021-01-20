/*
 * Copyright 2019 The Closure Compiler Authors
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
 * @fileoverview Nonstandard definitions for components of the WebRTC browser
 * API.
 *
 * @externs
 */

/**
 * @type {function(new: MediaStream,
 *                 (!MediaStream|!Array<!MediaStreamTrack>)=)}
 */
var webkitMediaStream;

/**
 * @param {MediaStreamConstraints} constraints A MediaStreamConstraints object.
 * @param {function(!MediaStream)} successCallback
 *     A NavigatorUserMediaSuccessCallback function.
 * @param {function(!NavigatorUserMediaError)=} errorCallback A
 *     NavigatorUserMediaErrorCallback function.
 * @see http://dev.w3.org/2011/webrtc/editor/getusermedia.html
 * @see https://www.w3.org/TR/mediacapture-streams/
 * @return {undefined}
 */
Navigator.prototype.webkitGetUserMedia = function(
    constraints, successCallback, errorCallback) {};

/** @const */
var webkitRTCPeerConnection = RTCPeerConnection;
