package closestmatch

import (
	"encoding/gob"
	"math/rand"
	"os"
	"sort"
	"strings"
)

// ClosestMatch is the structure that contains the
// substring sizes and carrys a map of the substrings for
// easy lookup
type ClosestMatch struct {
	SubstringSizes []int
	SubstringToID  map[string]map[uint32]struct{}
	ID             map[uint32]IDInfo
}

// IDInfo carries the information about the keys
type IDInfo struct {
	Key           string
	NumSubstrings int
}

// New returns a new structure for performing closest matches
func New(possible []string, subsetSize []int) *ClosestMatch {
	cm := new(ClosestMatch)
	cm.SubstringSizes = subsetSize
	cm.SubstringToID = make(map[string]map[uint32]struct{})
	cm.ID = make(map[uint32]IDInfo)
	for i, s := range possible {
		substrings := cm.splitWord(strings.ToLower(s))
		cm.ID[uint32(i)] = IDInfo{Key: s, NumSubstrings: len(substrings)}
		for substring := range substrings {
			if _, ok := cm.SubstringToID[substring]; !ok {
				cm.SubstringToID[substring] = make(map[uint32]struct{})
			}
			cm.SubstringToID[substring][uint32(i)] = struct{}{}
		}
	}

	return cm
}

// Load can load a previously saved ClosestMatch object from disk
func Load(filename string) (*ClosestMatch, error) {
	cm := new(ClosestMatch)

	f, err := os.Open(filename)
	defer f.Close()
	if err != nil {
		return cm, err
	}
	err = gob.NewDecoder(f).Decode(&cm)
	return cm, err
}

// Save writes the current ClosestSave object as a gzipped JSON file
func (cm *ClosestMatch) Save(filename string) error {
	f, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer f.Close()
	enc := gob.NewEncoder(f)
	return enc.Encode(cm)
}

func (cm *ClosestMatch) worker(id int, jobs <-chan job, results chan<- result) {
	for j := range jobs {
		m := make(map[string]int)
		if ids, ok := cm.SubstringToID[j.substring]; ok {
			weight := 200000 / len(ids)
			for id := range ids {
				if _, ok2 := m[cm.ID[id].Key]; !ok2 {
					m[cm.ID[id].Key] = 0
				}
				m[cm.ID[id].Key] += 1 + 0*weight
			}
		}
		results <- result{m: m}
	}
}

type job struct {
	substring string
}

type result struct {
	m map[string]int
}

func (cm *ClosestMatch) match(searchWord string) map[string]int {
	searchSubstrings := cm.splitWord(searchWord)
	searchSubstringsLen := len(searchSubstrings)

	jobs := make(chan job, searchSubstringsLen)
	results := make(chan result, searchSubstringsLen)
	workers := 8

	for w := 1; w <= workers; w++ {
		go cm.worker(w, jobs, results)
	}

	for substring := range searchSubstrings {
		jobs <- job{substring: substring}
	}
	close(jobs)

	m := make(map[string]int)
	for a := 1; a <= searchSubstringsLen; a++ {
		r := <-results
		for key := range r.m {
			if _, ok := m[key]; ok {
				m[key] += r.m[key]
			} else {
				m[key] = r.m[key]
			}
		}
	}

	return m
}

// Closest searches for the `searchWord` and returns the closest match
func (cm *ClosestMatch) Closest(searchWord string) string {
	for _, pair := range rankByWordCount(cm.match(searchWord)) {
		return pair.Key
	}
	return ""
}

// ClosestN searches for the `searchWord` and returns the n closests matches
func (cm *ClosestMatch) ClosestN(searchWord string, n int) []string {
	matches := make([]string, n)
	j := 0
	for i, pair := range rankByWordCount(cm.match(searchWord)) {
		if i == n {
			break
		}
		matches[i] = pair.Key
		j = i
	}
	return matches[:j+1]
}

func rankByWordCount(wordFrequencies map[string]int) PairList {
	pl := make(PairList, len(wordFrequencies))
	i := 0
	for k, v := range wordFrequencies {
		pl[i] = Pair{k, v}
		i++
	}
	sort.Sort(sort.Reverse(pl))
	return pl
}

type Pair struct {
	Key   string
	Value int
}

type PairList []Pair

func (p PairList) Len() int           { return len(p) }
func (p PairList) Less(i, j int) bool { return p[i].Value < p[j].Value }
func (p PairList) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

func (cm *ClosestMatch) splitWord(word string) map[string]struct{} {
	wordHash := make(map[string]struct{})
	for _, j := range cm.SubstringSizes {
		for i := 0; i < len(word)-j; i++ {
			substring := string(word[i : i+j])
			if len(strings.TrimSpace(substring)) > 0 {
				wordHash[string(word[i:i+j])] = struct{}{}
			}
		}
	}
	return wordHash
}

// AccuracyMutatingWords runs some basic tests against the wordlist to
// see how accurate this bag-of-characters method is against
// the target dataset
func (cm *ClosestMatch) AccuracyMutatingWords() float64 {
	rand.Seed(1)
	percentCorrect := 0.0
	numTrials := 0.0

	for wordTrials := 0; wordTrials < 200; wordTrials++ {

		var testString, originalTestString string
		testStringNum := rand.Intn(len(cm.ID))
		i := 0
		for id := range cm.ID {
			i++
			if i != testStringNum {
				continue
			}
			originalTestString = cm.ID[id].Key
			break
		}

		var words []string
		choice := rand.Intn(3)
		if choice == 0 {
			// remove a random word
			words = strings.Split(originalTestString, " ")
			if len(words) < 3 {
				continue
			}
			deleteWordI := rand.Intn(len(words))
			words = append(words[:deleteWordI], words[deleteWordI+1:]...)
			testString = strings.Join(words, " ")
		} else if choice == 1 {
			// remove a random word and reverse
			words = strings.Split(originalTestString, " ")
			if len(words) > 1 {
				deleteWordI := rand.Intn(len(words))
				words = append(words[:deleteWordI], words[deleteWordI+1:]...)
				for left, right := 0, len(words)-1; left < right; left, right = left+1, right-1 {
					words[left], words[right] = words[right], words[left]
				}
			} else {
				continue
			}
			testString = strings.Join(words, " ")
		} else {
			// remove a random word and shuffle and replace 2 random letters
			words = strings.Split(originalTestString, " ")
			if len(words) > 1 {
				deleteWordI := rand.Intn(len(words))
				words = append(words[:deleteWordI], words[deleteWordI+1:]...)
				for i := range words {
					j := rand.Intn(i + 1)
					words[i], words[j] = words[j], words[i]
				}
			}
			testString = strings.Join(words, " ")
			letters := "abcdefghijklmnopqrstuvwxyz"
			if len(testString) == 0 {
				continue
			}
			ii := rand.Intn(len(testString))
			testString = testString[:ii] + string(letters[rand.Intn(len(letters))]) + testString[ii+1:]
			ii = rand.Intn(len(testString))
			testString = testString[:ii] + string(letters[rand.Intn(len(letters))]) + testString[ii+1:]
		}
		closest := cm.Closest(testString)
		if closest == originalTestString {
			percentCorrect += 1.0
		} else {
			//fmt.Printf("Original: %s, Mutilated: %s, Match: %s\n", originalTestString, testString, closest)
		}
		numTrials += 1.0
	}
	return 100.0 * percentCorrect / numTrials
}

// AccuracyMutatingLetters runs some basic tests against the wordlist to
// see how accurate this bag-of-characters method is against
// the target dataset when mutating individual letters (adding, removing, changing)
func (cm *ClosestMatch) AccuracyMutatingLetters() float64 {
	rand.Seed(1)
	percentCorrect := 0.0
	numTrials := 0.0

	for wordTrials := 0; wordTrials < 200; wordTrials++ {

		var testString, originalTestString string
		testStringNum := rand.Intn(len(cm.ID))
		i := 0
		for id := range cm.ID {
			i++
			if i != testStringNum {
				continue
			}
			originalTestString = cm.ID[id].Key
			break
		}
		testString = originalTestString

		// letters to replace with
		letters := "abcdefghijklmnopqrstuvwxyz"

		choice := rand.Intn(3)
		if choice == 0 {
			// replace random letter
			ii := rand.Intn(len(testString))
			testString = testString[:ii] + string(letters[rand.Intn(len(letters))]) + testString[ii+1:]
		} else if choice == 1 {
			// delete random letter
			ii := rand.Intn(len(testString))
			testString = testString[:ii] + testString[ii+1:]
		} else {
			// add random letter
			ii := rand.Intn(len(testString))
			testString = testString[:ii] + string(letters[rand.Intn(len(letters))]) + testString[ii:]
		}
		closest := cm.Closest(testString)
		if closest == originalTestString {
			percentCorrect += 1.0
		} else {
			//fmt.Printf("Original: %s, Mutilated: %s, Match: %s\n", originalTestString, testString, closest)
		}
		numTrials += 1.0
	}

	return 100.0 * percentCorrect / numTrials
}
