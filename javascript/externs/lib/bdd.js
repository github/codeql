/*
 * Copyright 2018 Semmle
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
 * @fileoverview Simple externs definitions for various BDD and TDD APIs.
 *
 * The goal is to declare global functions provided by frameworks like Chai,
 * Mocha and Jasmine. No type information is included at the moment.
 *
 * @externs
 */

/** @param {...*} args */
function after(args) {}

/** @param {...*} args */
function afterAll(args) {}

/** @param {...*} args */
function afterEach(args) {}

/** @param {...*} args */
function assert(args) {}

/** @param {...*} args */
function before(args) {}

/** @param {...*} args */
function beforeAll(args) {}

/** @param {...*} args */
function beforeEach(args) {}

/** @param {...*} args */
function context(args) {}

/** @param {...*} args */
function describe(args) {}

/** @param {...*} args */
function expect(args) {}

/** @param {...*} args */
function fdescribe(args) {}

/** @param {...*} args */
function fit(args) {}

/** @param {...*} args */
function it(args) {}

/** @param {...*} args */
function pending(args) {}

/** @param {...*} args */
function setup(args) {}

/** @param {...*} args */
function specify(args) {}

/** @param {...*} args */
function spyOn(args) {}

/** @param {...*} args */
function suite(args) {}

/** @param {...*} args */
function suiteSetup(args) {}

/** @param {...*} args */
function suiteTeardown(args) {}

/** @param {...*} args */
function teardown(args) {}

/** @param {...*} args */
function test(args) {}

/** @param {...*} args */
function xdescribe(args) {}

/** @param {...*} args */
function xit(args) {}
