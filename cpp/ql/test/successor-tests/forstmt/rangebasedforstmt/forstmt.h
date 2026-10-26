template<typename T>
struct vector {
    struct iterator {
        iterator& operator++();
        T& operator*() const;

        bool operator!=(iterator right) const;
    };

    iterator begin() const;
    iterator end() const;
};
