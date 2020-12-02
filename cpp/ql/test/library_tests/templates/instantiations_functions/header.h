
template <typename BaseT>
struct actor1 : public composite<int> {
    actor1();

    template <typename A>
    inline void
    funx(A& a_) {
        int i;
        composite<int>::eval(i);
    }
};

