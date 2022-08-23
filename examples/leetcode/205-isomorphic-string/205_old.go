package main

import (
	"fmt"
	"strings"
)

func isIsomorphic(s string, t string) bool {
	sLen := len(s)

	if sLen != len(t) {
		return false
	}

	m1 := make(map [string]int, sLen)
	m2 := make(map [string]int, sLen)

	// fill maps m1/m2 with 1st char from string s/t
	m1 [s[:1]] = 0
	m2 [t[:1]] = 0

	sChars := strings.Split(s, "")
	tChars := strings.Split(t, "")

	for k, v := range sChars {
		sVal := v
		tVal := tChars [k]

		if m1 [sVal] != m2[tVal] {
			return false
		}

		// fill inner idx's of string s/t into map m1/m2
		// i.e: 0 < ... < n - 1, if not already there/exists
		j := k + 1
		if j < sLen {
			sVal = sChars [j]
			tVal = tChars [j]

			if _, exists := m1 [sVal]; exists == false {
				m1 [sVal] = j
			}

			if _, exists := m2 [tVal]; exists == false {
				m2 [tVal] = j
			}
		}		
	}

	// NOTE: below soln doesn't use sChars & tChars but rather converts byte -> strings for map [key]

	// for i := 0; i < sLen; i++ {
	// 	sVal := string(s[i])
	// 	tVal := string(t[i])

	// 	if m1 [sVal] != m2[tVal] {
	// 		return false
	// 	}

	// 	// fill inner idx's of string s/t into map m1/m2
	// 	// i.e: 0 < ... < n - 1, if not already there/exists
	// 	j := i + 1
	// 	if j < sLen {
	// 		sVal = string(s[j])
	// 		tVal = string(t[j])

	// 		if _, exists := m1 [sVal]; exists == false {
	// 			m1 [sVal] = j
	// 		}

	// 		if _, exists := m2 [tVal]; exists == false {
	// 			m2 [tVal] = j
	// 		}
	// 	}
	// }
	
	return true
}

func main() {
	fmt.Println(isIsomorphic("egg", "add"))
	fmt.Println(isIsomorphic("foo", "bar"))
	fmt.Println(isIsomorphic("abc", "xyz"))
	fmt.Println(isIsomorphic("hamara", "bajaja"))
}