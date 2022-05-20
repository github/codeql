package pkg1

import (
	"fmt"
)

// `base` and `*base` have method `f`; `*base` also has method `g`
type base struct{}

func (base) f() int {
	return 1
}

func (*base) g() int {
	return 2
}

// `embedder` and `*embedder` have promoted method `f` from `base`; `*embedder` also has method `g` from `*base`
type embedder struct{ base }

// `ptrembedder` and `*ptrembedder` have promoted methods `f` from `base` and `g` from `*base`
type ptrembedder struct{ *base }

// `embedder2` and `*embedder2` have promoted method `f` from `base`; `*embedder2` also has method `g` from `*base`
type embedder2 struct{ embedder }

// `embedder3` and `*embedder3` have their own version of `f`; `*embedder3` also has promoted method `g` from `*base`
type embedder3 struct{ embedder }

func (embedder3) f() int {
	return 3
}

// `embedder4` and `*embedder4` do not have a method `f`; `*embedder4` has promoted method `g` from `*base`
type embedder4 struct {
	base
	f int
}

func main() {
	var (
		b   base
		bp  *base = &b
		e   embedder
		ep  *embedder    = &e
		pe  ptrembedder  = ptrembedder{bp}
		pep *ptrembedder = &pe
		e2  embedder2
		e2p *embedder2 = &e2
		e3  embedder3
		e3p *embedder3 = &e3
		e4  embedder4
		e4p *embedder4 = &e4
	)
	fmt.Println(base.f(b), (*base).f(bp) /*base.g(b),*/, (*base).g(bp))
	fmt.Println(embedder.f(e), (*embedder).f(ep) /*embedder.g(e),*/, (*embedder).g(ep))
	fmt.Println(ptrembedder.f(pe), (*ptrembedder).f(pep), ptrembedder.g(pe), (*ptrembedder).g(pep))
	fmt.Println(embedder2.f(e2), (*embedder2).f(e2p) /*embedder2.g(e2),*/, (*embedder2).g(e2p))
	fmt.Println(embedder3.f(e3), (*embedder3).f(e3p) /*embedder3.g(e3),*/, (*embedder3).g(e3p))
	fmt.Println( /*embedder4.f(e4), (*embedder4).f(e4p), embedder4.g(e3),*/ (*embedder4).g(e4p))
}
