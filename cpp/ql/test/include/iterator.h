#if !defined(CODEQL_ITERATOR_H)
#define CODEQL_ITERATOR_H

typedef unsigned long size_t;

#include "type_traits.h"

namespace std {
	struct ptrdiff_t;

	template<class I> struct iterator_traits;

	template <class Category,
			  class value_type,
			  class difference_type = ptrdiff_t,
			  class pointer_type = value_type*,
			  class reference_type = value_type&>
	struct iterator {
		typedef Category iterator_category;

		iterator();
		iterator(iterator<Category, remove_const_t<value_type> > const &other); // non-const -> const conversion constructor

		iterator &operator++();
		iterator operator++(int);
		iterator &operator--();
		iterator operator--(int);
		bool operator==(iterator other) const;
		bool operator!=(iterator other) const;
		reference_type operator*() const;
		pointer_type operator->() const;
		iterator operator+(int);
		iterator operator-(int);
		iterator &operator+=(int);
		iterator &operator-=(int);
		int operator-(iterator);
		reference_type operator[](int);
	};

	struct input_iterator_tag {};
	struct forward_iterator_tag : public input_iterator_tag {};
	struct bidirectional_iterator_tag : public forward_iterator_tag {};
	struct random_access_iterator_tag : public bidirectional_iterator_tag {};

	struct output_iterator_tag {};

	template<class Container>
	class back_insert_iterator {
	protected:
		Container* container = nullptr;
	public:
		using iterator_category = output_iterator_tag;
		using value_type = void;
		using difference_type = ptrdiff_t;
		using pointer = void;
		using reference = void;
		using container_type = Container;
		constexpr back_insert_iterator() noexcept = default;
		constexpr explicit back_insert_iterator(Container& x);
		back_insert_iterator& operator=(const typename Container::value_type& value);
		back_insert_iterator& operator=(typename Container::value_type&& value);
		back_insert_iterator& operator*();
		back_insert_iterator& operator++();
		back_insert_iterator operator++(int);
	};

	template<class Container>
	constexpr back_insert_iterator<Container> back_inserter(Container& x) {
		return back_insert_iterator<Container>(x);
	}

	template<class Container>
	class front_insert_iterator {
	protected:
		Container* container = nullptr;
	public:
		using iterator_category = output_iterator_tag;
		using value_type = void;
		using difference_type = ptrdiff_t;
		using pointer = void;
		using reference = void;
		using container_type = Container;
		constexpr front_insert_iterator() noexcept = default;
		constexpr explicit front_insert_iterator(Container& x);
		constexpr front_insert_iterator& operator=(const typename Container::value_type& value);
		constexpr front_insert_iterator& operator=(typename Container::value_type&& value);
		constexpr front_insert_iterator& operator*();
		constexpr front_insert_iterator& operator++();
		constexpr front_insert_iterator operator++(int);
	};
	template<class Container>
	constexpr front_insert_iterator<Container> front_inserter(Container& x) {
		return front_insert_iterator<Container>(x);
	}
}

#endif