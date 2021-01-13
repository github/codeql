/*
 * Copyright 2011 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's Speech Input 2010 draft API and the
 * 2012 Web Speech draft API (in progress).
 * 2010 Speech Input API:
 * http://www.w3.org/2005/Incubator/htmlspeech/2010/10/google-api-draft.html
 * 2012 Web Speech API:
 * http://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html
 * This file contains only those functions/properties that are actively
 * used in the Voice Search experiment. Because the draft is under discussion
 * and constantly evolving, this file does not attempt to stay in sync with it.
 *
 * @externs
 */

// W3C Speech Input API implemented in Chrome M12
/**
 * @constructor
 * @extends {UIEvent}
 */
function SpeechInputEvent() {}

/** @type {SpeechInputResultList} */
SpeechInputEvent.prototype.results;


/**
 * @constructor
 */
function SpeechInputResultList() {}

/** @type {number} */
SpeechInputResultList.prototype.length;


/**
 * @constructor
 */
function SpeechInputResult() {}

/** @type {string} */
SpeechInputResult.prototype.utterance;

/** @type {number} */
SpeechInputResult.prototype.confidence;


// HTMLInputElement
/** @type {boolean} */
HTMLInputElement.prototype.webkitspeech;

/** @type {?function (Event)} */
HTMLInputElement.prototype.onwebkitspeechchange;



// W3C Web Speech API implemented in Chrome M23
/**
 * @constructor
 * @implements {EventTarget}
 */
function SpeechRecognition() {}

/** @override */
SpeechRecognition.prototype.addEventListener = function(
    type, listener, opt_options) {};

/** @override */
SpeechRecognition.prototype.removeEventListener = function(
    type, listener, opt_options) {};

/** @override */
SpeechRecognition.prototype.dispatchEvent = function(evt) {};

/** @type {SpeechGrammarList} */
SpeechRecognition.prototype.grammars;

/** @type {string} */
SpeechRecognition.prototype.lang;

/** @type {boolean} */
SpeechRecognition.prototype.continuous;

/** @type {boolean} */
SpeechRecognition.prototype.interimResults;

/** @type {number} */
SpeechRecognition.prototype.maxAlternatives;

/** @type {string} */
SpeechRecognition.prototype.serviceURI;

/** @type {function()} */
SpeechRecognition.prototype.start;

/** @type {function()} */
SpeechRecognition.prototype.stop;

/** @type {function()} */
SpeechRecognition.prototype.abort;

/** @type {?function(!Event)} */
SpeechRecognition.prototype.onaudiostart;

/** @type {?function(!Event)} */
SpeechRecognition.prototype.onsoundstart;

/** @type {?function(!Event)} */
SpeechRecognition.prototype.onspeechstart;

/** @type {?function(!Event)} */
SpeechRecognition.prototype.onspeechend;

/** @type {?function(!Event)} */
SpeechRecognition.prototype.onsoundend;

/** @type {?function(!Event)} */
SpeechRecognition.prototype.onaudioend;

/** @type {?function(!SpeechRecognitionEvent)} */
SpeechRecognition.prototype.onresult;

/** @type {?function(!SpeechRecognitionEvent)} */
SpeechRecognition.prototype.onnomatch;

/** @type {?function(!SpeechRecognitionError)} */
SpeechRecognition.prototype.onerror;

/** @type {?function(!Event)} */
SpeechRecognition.prototype.onstart;

/** @type {?function(!Event)} */
SpeechRecognition.prototype.onend;


/**
 * @constructor
 * @extends {Event}
 */
function SpeechRecognitionError() {}

/** @type {string} */
SpeechRecognitionError.prototype.error;

/** @type {string} */
SpeechRecognitionError.prototype.message;


/**
 * @constructor
 */
function SpeechRecognitionAlternative() {}

/** @type {string} */
SpeechRecognitionAlternative.prototype.transcript;

/** @type {number} */
SpeechRecognitionAlternative.prototype.confidence;


/**
 * @constructor
 */
function SpeechRecognitionResult() {}

/**
 * @type {number}
 */
SpeechRecognitionResult.prototype.length;

/**
 * @type {function(number): SpeechRecognitionAlternative}
 */
SpeechRecognitionResult.prototype.item = function(index) {};

/**
 * @type {boolean}
 */
SpeechRecognitionResult.prototype.isFinal;


/**
 * @constructor
 */
function SpeechRecognitionResultList() {}

/**
 * @type {number}
 */
SpeechRecognitionResultList.prototype.length;

/**
 * @type {function(number): SpeechRecognitionResult}
 */
SpeechRecognitionResultList.prototype.item = function(index) {};


/**
 * @constructor
 * @extends {Event}
 */
function SpeechRecognitionEvent() {}

/** @type {number} */
SpeechRecognitionEvent.prototype.resultIndex;

/** @type {SpeechRecognitionResultList} */
SpeechRecognitionEvent.prototype.results;

/** @type {*} */
SpeechRecognitionEvent.prototype.interpretation;

/** @type {Document} */
SpeechRecognitionEvent.prototype.emma;


/**
 * @constructor
 */
function SpeechGrammar() {}

/** @type {string} */
SpeechGrammar.prototype.src;

/** @type {number} */
SpeechGrammar.prototype.weight;


/**
 * @constructor
 */
function SpeechGrammarList() {}

/**
 * @type {number}
 */
SpeechGrammarList.prototype.length;

/**
 * @type {function(number): SpeechGrammar}
 */
SpeechGrammarList.prototype.item = function(index) {};

/**
 * @type {function(string, number)}
 */
SpeechGrammarList.prototype.addFromUri = function(src, weight) {};

/**
 * @type {function(string, number)}
 */
SpeechGrammarList.prototype.addFromString = function(str, weight) {};


// Webkit implementations of Web Speech API
/**
 * @constructor
 * @extends {SpeechGrammarList}
 */
function webkitSpeechGrammarList() {}


/**
 * @constructor
 * @extends {SpeechGrammar}
 */
function webkitSpeechGrammar() {}


/**
 * @constructor
 * @extends {SpeechRecognitionEvent}
 */
function webkitSpeechRecognitionEvent() {}


/**
 * @constructor
 * @extends {SpeechRecognitionError}
 */
function webkitSpeechRecognitionError() {}


/**
 * @constructor
 * @extends {SpeechRecognition}
 */
function webkitSpeechRecognition() {}



// W3C Web Speech Synthesis API is implemented in Chrome M33
/**
 * @type {SpeechSynthesis}
 * @see https://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html#tts-section
 */
var speechSynthesis;


/**
 * @constructor
 * @param {string} text
 */
function SpeechSynthesisUtterance(text) {}

/** @type {string} */
SpeechSynthesisUtterance.prototype.text;

/** @type {string} */
SpeechSynthesisUtterance.prototype.lang;

/** @type {number} */
SpeechSynthesisUtterance.prototype.pitch;

/** @type {number} */
SpeechSynthesisUtterance.prototype.rate;

/** @type {SpeechSynthesisVoice} */
SpeechSynthesisUtterance.prototype.voice;

/** @type {number} */
SpeechSynthesisUtterance.prototype.volume;

/**
 * @param {Event} event
 */
SpeechSynthesisUtterance.prototype.onstart = function(event) {};

/**
 * @param {Event} event
 */
SpeechSynthesisUtterance.prototype.onend = function(event) {};

/**
 * @param {Event} event
 */
SpeechSynthesisUtterance.prototype.onerror = function(event) {};

/**
 * @constructor
 */
function SpeechSynthesisVoice() {}

/** @type {string} */
SpeechSynthesisVoice.prototype.voiceURI;

/** @type {string} */
SpeechSynthesisVoice.prototype.name;

/** @type {string} */
SpeechSynthesisVoice.prototype.lang;

/** @type {boolean} */
SpeechSynthesisVoice.prototype.localService;

/** @type {boolean} */
SpeechSynthesisVoice.prototype.default;


/**
 * @constructor
 * @extends {Array<!SpeechSynthesisVoice>}
 */
function SpeechSynthesisVoiceList() {}


/**
 * @interface
 * @extends {EventTarget}
 */
function SpeechSynthesis() {}

/**
 * @param {SpeechSynthesisUtterance} utterance
 * @return {undefined}
 */
SpeechSynthesis.prototype.speak = function(utterance) {};

/** @type {function()} */
SpeechSynthesis.prototype.cancel;

/** @type {function()} */
SpeechSynthesis.prototype.pause;

/** @type {function()} */
SpeechSynthesis.prototype.resume;

/**
 * @return {SpeechSynthesisVoiceList}
 */
SpeechSynthesis.prototype.getVoices = function() {};

/**
 * @param {Event} event
 * @see https://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi-errata.html
 */
SpeechSynthesis.prototype.onvoiceschanged = function(event) {};
