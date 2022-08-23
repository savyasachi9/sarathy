package main

import (
	"fmt"
	"strings"
)

// TODO: optimize soln using single map ???
func wordPattern(pattern string, s string) bool {
	sWords := strings.Split(s, " ")
	pLen   := len(pattern)

	if pLen != len(sWords) {
		return false
	}

	pMap := make(map [byte] int, pLen)
	sMap := make(map [string] int, pLen)

	// fill first idx into maps
	pMap [pattern[0]] = 0
	sMap [sWords[0]]  = 0

	for i := 0; i < pLen; i++ {

		// check if value of maps differ ?
		//fmt.Printf("%v --- %v\n", pMap [pattern[i]], sMap [sWords[i]])
		if pMap [pattern[i]] != sMap [sWords[i]] {
			return false
		}

		// fill map with idxs > 0 IFF value doesn't exist already
		j := i + 1
		if j < pLen {
			if _, ok := pMap [pattern[j]]; !ok {
				pMap [pattern[j]] = j
			}

			if _, ok := sMap [sWords[j]]; !ok {
				sMap [sWords[j]] = j
			}
		}
	}

	return true
}

func main() {
	println(wordPattern("abba", "dog cat cat dog"))
	println(wordPattern("abba", "dog cat cat fish"))
	println(wordPattern("aaaa", "dog cat cat dog"))

	// TODO: this should return false
	println(wordPattern("aaa", "aa aa aa aa"))
	
	fmt.Println("\n")
}