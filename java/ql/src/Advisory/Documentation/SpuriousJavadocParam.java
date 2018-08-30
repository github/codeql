/**
 * BAD: The following param tag is empty.
 *
 * @param   
 */ 
public void emptyParamTag(int p){ ... }


/**
 * BAD: The following param tag has a misspelled value.
 *
 * @param prameter The parameter's value.
 */ 
public void typo(int parameter){ ... }


/**
 * BAD: The following param tag appears to be outdated
 * since the method does not take any parameters.
 *
 * @param sign The number's sign.
 */ 
public void outdated(){ ... }


/**
 * BAD: The following param tag uses html within the tag value.
 *
 * @param <code>ordinate</code> The value of the y coordinate.
 */ 
public void html(int ordinate){ ... }


/**
 * BAD: Invalid syntax for type parameter.
 *
 * @param T The type of the parameter.
 * @param parameter The parameter value.
 */ 
public <T> void parameterized(T parameter){ ... }


/**
 * GOOD: A proper Javadoc comment.
 *
 * This method calculates the absolute value of a given number.
 *
 * @param <T> The number's type.
 * @param x The number to calculate the absolute value of.
 * @return The absolute value of <code>x</code>.
 */ 
public <T extends Number> T abs(T x){ ... }
