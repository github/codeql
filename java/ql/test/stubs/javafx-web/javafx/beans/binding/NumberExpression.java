// Generated automatically from javafx.beans.binding.NumberExpression for testing purposes

package javafx.beans.binding;

import java.util.Locale;
import javafx.beans.binding.BooleanBinding;
import javafx.beans.binding.NumberBinding;
import javafx.beans.binding.StringBinding;
import javafx.beans.value.ObservableNumberValue;

public interface NumberExpression extends ObservableNumberValue
{
    BooleanBinding greaterThan(ObservableNumberValue p0);
    BooleanBinding greaterThan(double p0);
    BooleanBinding greaterThan(float p0);
    BooleanBinding greaterThan(int p0);
    BooleanBinding greaterThan(long p0);
    BooleanBinding greaterThanOrEqualTo(ObservableNumberValue p0);
    BooleanBinding greaterThanOrEqualTo(double p0);
    BooleanBinding greaterThanOrEqualTo(float p0);
    BooleanBinding greaterThanOrEqualTo(int p0);
    BooleanBinding greaterThanOrEqualTo(long p0);
    BooleanBinding isEqualTo(ObservableNumberValue p0);
    BooleanBinding isEqualTo(ObservableNumberValue p0, double p1);
    BooleanBinding isEqualTo(double p0, double p1);
    BooleanBinding isEqualTo(float p0, double p1);
    BooleanBinding isEqualTo(int p0);
    BooleanBinding isEqualTo(int p0, double p1);
    BooleanBinding isEqualTo(long p0);
    BooleanBinding isEqualTo(long p0, double p1);
    BooleanBinding isNotEqualTo(ObservableNumberValue p0);
    BooleanBinding isNotEqualTo(ObservableNumberValue p0, double p1);
    BooleanBinding isNotEqualTo(double p0, double p1);
    BooleanBinding isNotEqualTo(float p0, double p1);
    BooleanBinding isNotEqualTo(int p0);
    BooleanBinding isNotEqualTo(int p0, double p1);
    BooleanBinding isNotEqualTo(long p0);
    BooleanBinding isNotEqualTo(long p0, double p1);
    BooleanBinding lessThan(ObservableNumberValue p0);
    BooleanBinding lessThan(double p0);
    BooleanBinding lessThan(float p0);
    BooleanBinding lessThan(int p0);
    BooleanBinding lessThan(long p0);
    BooleanBinding lessThanOrEqualTo(ObservableNumberValue p0);
    BooleanBinding lessThanOrEqualTo(double p0);
    BooleanBinding lessThanOrEqualTo(float p0);
    BooleanBinding lessThanOrEqualTo(int p0);
    BooleanBinding lessThanOrEqualTo(long p0);
    NumberBinding add(ObservableNumberValue p0);
    NumberBinding add(double p0);
    NumberBinding add(float p0);
    NumberBinding add(int p0);
    NumberBinding add(long p0);
    NumberBinding divide(ObservableNumberValue p0);
    NumberBinding divide(double p0);
    NumberBinding divide(float p0);
    NumberBinding divide(int p0);
    NumberBinding divide(long p0);
    NumberBinding multiply(ObservableNumberValue p0);
    NumberBinding multiply(double p0);
    NumberBinding multiply(float p0);
    NumberBinding multiply(int p0);
    NumberBinding multiply(long p0);
    NumberBinding negate();
    NumberBinding subtract(ObservableNumberValue p0);
    NumberBinding subtract(double p0);
    NumberBinding subtract(float p0);
    NumberBinding subtract(int p0);
    NumberBinding subtract(long p0);
    StringBinding asString();
    StringBinding asString(Locale p0, String p1);
    StringBinding asString(String p0);
}
