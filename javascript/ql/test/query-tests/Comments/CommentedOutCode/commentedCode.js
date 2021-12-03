/**
 * @return {String}
 */
function sayHello() {
  /*
  this line is fine, but the following is not
  if (something) {
  */

  // the following line is not ok
  // if (something) {
	
  // and neither are the following lines
  // if (x) {
  //   alert("Hi");
  // }
	
  // // commented-out comments are bad

  /*// commented-out comments are bad*/

  /* // commented-out comments are bad*/

  // /// commented-out comments are bad //

  /*//// commented-out comments are bad */

  /* /// commented-out comments are bad */

  //// this is not a commented-out comment

  // and neither is this http://www.example.com

  // nor is this //

  /*
   * This comment is fine, since it contains an explicit "code" block.
   * 
   * <code>
   * {
   *   f();
   *   g();
   *   h();
   *   k();
   *   if (x) {
   *     m();
   *   }
   * }
   * </code>
   */

  /*
   * This comment is fine, since it contains an explicit "pre" block.
   * 
   * <pre>
   * {
   *   f();
   *   g();
   *   h();
   *   k();
   *   if (x) {
   *     m();
   *   }
   * }
   * </pre>
   */

  /*
   * This comment is fine, since it contains an explicit "example" tag.
   * 
   * @example
   * {
   *   f();
   *   g();
   *   h();
   *   k();
   *   if (x) {
   *     m();
   *   }
   * }
   */

  // good

  // ====
  // ----
  // ++++

  /** @type {!String} */

  /*
   * This comment is fine, since it contains a Markdown code block.
   * 
   * ```
   * {
   *   f();
   *   g();
   *   h();
   *   k();
   *   if (x) {
   *     m();
   *   }
   * }
   * ```
   */
}

/** @private {(int|boolean)} */
var x;

/** @private {*} */
var y;

/** @type {function(this: !A, ?string=, int[]) : Object.<string, int>} */
var z;

/** @typedef {{msg: string}} */
var MessageContainer;

/** @type {$tp} */
var foo;

var empty = ""; //$NON-NLS-1$ 
var alsoEmpty = "" + ""; //$NON-NLS-1$ //$NON-NLS-2$

/*: type foo = number; */

/*::
 * type foo = number;
 * type bar = string; */

/* flow-include type foo = number; */

/** @type {!./ampdoc-impl.AmpDoc} */
var ampdoc;

// something like this: { foo, bar }

//alert("reached here yo");

// false positive:
// scale to {0, 255}

// false negative:
// if(x instanceof Array) {
