class exception {};

class specific_exception : public exception {};

class other_throwable {};


struct ThrowsDirectly {
    int i;

    ~ThrowsDirectly() noexcept(false) {
        if (i == 0) {
            throw exception(); // BAD

        } else if (i == 1) {
            try {
                if (i == 1)
                    throw exception(); // GOOD
            } catch (...) {
            }

        } else if (i == 2) {
            try {
                if (i == 2)
                    throw exception(); // GOOD
            } catch (const exception &) {
            }

        } else if (i == 3) {
            try {
                if (i == 3)
                    throw specific_exception(); // GOOD
            } catch (const exception &) {
            }

        } else if (i == 4) {
            try {
                if (i == 4)
                    throw specific_exception(); // GOOD
            } catch (exception) {
                // The exception is _sliced_ because we catch by value, but
                // that's a separate problem for a separate query.
            }

        } else if (i == 5) {
            try {
                if (i == 5)
                    throw exception(); // BAD
            } catch (const specific_exception &) {
            }

        } else if (i == 6) {
            try {
                if (i == 6)
                    throw exception(); // BAD
            } catch (const other_throwable &) {
            }
        }
    }
};


struct ThrowsIndirectly {
    int i;

    void throw_exception() {
        throw exception();
    }

    void throw_specific_exception() {
        throw specific_exception();
    }

    ~ThrowsIndirectly() {
        if (i == 0) {
            throw_exception(); // BAD [FALSE NEGATIVE]

        } else if (i == 1) {
            try {
                if (i == 1)
                    throw_exception(); // GOOD
            } catch (...) {
            }

        } else if (i == 2) {
            try {
                if (i == 2)
                    throw_exception(); // GOOD
            } catch (const exception &) {
            }

        } else if (i == 3) {
            try {
                if (i == 3)
                    throw_specific_exception(); // GOOD
            } catch (const exception &) {
            }

        } else if (i == 4) {
            try {
                if (i == 4)
                    throw_specific_exception(); // GOOD
            } catch (exception) {
                // The exception is _sliced_ because we catch by value, but
                // that's a separate problem for a separate query.
            }

        } else if (i == 5) {
            try {
                if (i == 5)
                    throw_exception(); // BAD [FALSE NEGATIVE]
            } catch (const specific_exception &) {
            }

        } else if (i == 6) {
            try {
                if (i == 6)
                    throw_exception(); // BAD [FALSE NEGATIVE]
            } catch (const other_throwable &) {
            }
        }
    }
};
