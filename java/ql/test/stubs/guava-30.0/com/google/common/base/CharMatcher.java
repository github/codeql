// Generated automatically from com.google.common.base.CharMatcher for testing purposes

package com.google.common.base;

import com.google.common.base.Predicate;

abstract public class CharMatcher implements Predicate<Character>
{
    protected CharMatcher(){}
    public CharMatcher and(CharMatcher p0){ return null; }
    public CharMatcher negate(){ return null; }
    public CharMatcher or(CharMatcher p0){ return null; }
    public CharMatcher precomputed(){ return null; }
    public String collapseFrom(CharSequence p0, char p1){ return null; }
    public String removeFrom(CharSequence p0){ return null; }
    public String replaceFrom(CharSequence p0, CharSequence p1){ return null; }
    public String replaceFrom(CharSequence p0, char p1){ return null; }
    public String retainFrom(CharSequence p0){ return null; }
    public String toString(){ return null; }
    public String trimAndCollapseFrom(CharSequence p0, char p1){ return null; }
    public String trimFrom(CharSequence p0){ return null; }
    public String trimLeadingFrom(CharSequence p0){ return null; }
    public String trimTrailingFrom(CharSequence p0){ return null; }
    public abstract boolean matches(char p0);
    public boolean apply(Character p0){ return false; }
    public boolean matchesAllOf(CharSequence p0){ return false; }
    public boolean matchesAnyOf(CharSequence p0){ return false; }
    public boolean matchesNoneOf(CharSequence p0){ return false; }
    public int countIn(CharSequence p0){ return 0; }
    public int indexIn(CharSequence p0){ return 0; }
    public int indexIn(CharSequence p0, int p1){ return 0; }
    public int lastIndexIn(CharSequence p0){ return 0; }
    public static CharMatcher any(){ return null; }
    public static CharMatcher anyOf(CharSequence p0){ return null; }
    public static CharMatcher ascii(){ return null; }
    public static CharMatcher breakingWhitespace(){ return null; }
    public static CharMatcher digit(){ return null; }
    public static CharMatcher forPredicate(Predicate<? super Character> p0){ return null; }
    public static CharMatcher inRange(char p0, char p1){ return null; }
    public static CharMatcher invisible(){ return null; }
    public static CharMatcher is(char p0){ return null; }
    public static CharMatcher isNot(char p0){ return null; }
    public static CharMatcher javaDigit(){ return null; }
    public static CharMatcher javaIsoControl(){ return null; }
    public static CharMatcher javaLetter(){ return null; }
    public static CharMatcher javaLetterOrDigit(){ return null; }
    public static CharMatcher javaLowerCase(){ return null; }
    public static CharMatcher javaUpperCase(){ return null; }
    public static CharMatcher none(){ return null; }
    public static CharMatcher noneOf(CharSequence p0){ return null; }
    public static CharMatcher singleWidth(){ return null; }
    public static CharMatcher whitespace(){ return null; }
}
