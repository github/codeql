
# closestmatch :page_with_curl:

<a href="#"><img src="https://img.shields.io/badge/version-2.1.0-brightgreen.svg?style=flat-square" alt="Version"></a>
<a href="https://travis-ci.org/schollz/closestmatch"><img src="https://img.shields.io/travis/schollz/closestmatch.svg?style=flat-square" alt="Build Status"></a>
<a href="http://gocover.io/github.com/schollz/closestmatch"><img src="https://img.shields.io/badge/coverage-98%25-brightgreen.svg?style=flat-square" alt="Code Coverage"></a>
<a href="https://godoc.org/github.com/schollz/closestmatch"><img src="https://img.shields.io/badge/api-reference-blue.svg?style=flat-square" alt="GoDoc"></a>

*closestmatch* is a simple and fast Go library for fuzzy matching an input string to a list of target strings. *closestmatch* is useful for handling input from a user where the input (which could be mispelled or out of order) needs to match a key in a database. *closestmatch* uses a [bag-of-words approach](https://en.wikipedia.org/wiki/Bag-of-words_model) to precompute character n-grams to represent each possible target string. The closest matches have highest overlap between the sets of n-grams. The precomputation scales well and is much faster and more accurate than Levenshtein for long strings.


Getting Started
===============

## Install

```
go get -u -v github.com/schollz/closestmatch
```

## Use 

####  Create a *closestmatch* object from a list words

```golang
// Take a slice of keys, say band names that are similar
// http://www.tonedeaf.com.au/412720/38-bands-annoyingly-similar-names.htm
wordsToTest := []string{"King Gizzard", "The Lizard Wizard", "Lizzard Wizzard"}

// Choose a set of bag sizes, more is more accurate but slower
bagSizes := []int{2}

// Create a closestmatch object
cm := closestmatch.New(wordsToTest, bagSizes)
```

#### Find the closest match, or find the *N* closest matches

```golang
fmt.Println(cm.Closest("kind gizard"))
// returns 'King Gizzard'

fmt.Println(cm.ClosestN("kind gizard",3))
// returns [King Gizzard Lizzard Wizzard The Lizard Wizard]
```

#### Calculate the accuracy

```golang
// Calculate accuracy
fmt.Println(cm.AccuracyMutatingWords())
// ~ 66 % (still way better than Levenshtein which hits 0% with this particular set)

// Improve accuracy by adding more bags
bagSizes = []int{2, 3, 4}
cm = closestmatch.New(wordsToTest, bagSizes)
fmt.Println(cm.AccuracyMutatingWords())
// accuracy improves to ~ 76 %
```

#### Save/Load

```golang
// Save your current calculated bags
cm.Save("closestmatches.gob")

// Open it again
cm2, _ := closestmatch.Load("closestmatches.gob")
fmt.Println(cm2.Closest("lizard wizard"))
// prints "The Lizard Wizard"
```

### Advantages

*closestmatch* is more accurate than Levenshtein for long strings (like in the test corpus). 

*closestmatch* is ~20x faster than [a fast implementation of Levenshtein](https://groups.google.com/forum/#!topic/golang-nuts/YyH1f_qCZVc). Try it yourself with the benchmarks:

```bash
cd $GOPATH/src/github.com/schollz/closestmatch && go test -run=None -bench=. > closestmatch.bench
cd $GOPATH/src/github.com/schollz/closestmatch/levenshtein && go test -run=None -bench=. > levenshtein.bench
benchcmp levenshtein.bench ../closestmatch.bench
```

which gives the following benchmark (on Intel i7-3770 CPU @ 3.40GHz w/ 8 processors):

```bash
benchmark                 old ns/op     new ns/op     delta
BenchmarkNew-8            1.47          1933870       +131555682.31%
BenchmarkClosestOne-8     104603530     4855916       -95.36%
```

The `New()` function in *closestmatch* is so slower than *levenshtein* because there is precomputation needed.

### Disadvantages

*closestmatch* does worse for matching lists of single words, like a dictionary. For comparison:


```
$ cd $GOPATH/src/github.com/schollz/closestmatch && go test
Accuracy with mutating words in book list:      90.0%
Accuracy with mutating letters in book list:    100.0%
Accuracy with mutating letters in dictionary:   38.9%
```

while levenshtein performs slightly better for a single-word dictionary (but worse for longer names, like book titles):

```
$ cd $GOPATH/src/github.com/schollz/closestmatch/levenshtein && go test
Accuracy with mutating words in book list:      40.0%
Accuracy with mutating letters in book list:    100.0%
Accuracy with mutating letters in dictionary:   64.8%
```

## License

MIT
