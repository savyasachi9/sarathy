/*
Given two strings s and t, determine if they are isomorphic.
Two strings s and t are isomorphic if the characters in s can be replaced to get t.
All occurrences of a character must be replaced with another character while preserving the order of characters. No two characters may map to the same character, but a character may map to itself.

Example 1:
Input: s = "egg", t = "add"
Output: true

Example 2:
Input: s = "foo", t = "bar"
Output: false

Example 3:
Input: s = "paper", t = "title"
Output: true
 
Constraints:
1 <= s.length <= 5 * 104
t.length == s.length
s and t consist of any valid ascii character.
*/
package main

func isIsomorphic(s string, t string) bool {
	// sLen := len(s)
	// tLen := len(t)
	// if sLen != tLen {
	// 	return false
	// }

	// we'll use 2 maps m1 & m2 to store last occurance of each char for the str idxs
	m1 := make(map[string]int)
	m2 := make(map[string]int)

	// then we'll loop over them and check for if m1[k] != m2[k] while setting m1 & m2 if keys don't exist
	for sKey, _ := range s {
		sVal := string(s[sKey])
		tVal := string(t[sKey])

		if _ , ok := m1 [sVal]; !ok {
			m1 [sVal] = sKey
		}

		if _, ok := m2 [tVal]; ! ok {
			m2 [tVal] = sKey
		}

		println(sKey, sVal, tVal)
		if m1 [sVal] != m2[tVal] {
			return false
		}

	}

	return true
}

func main() {
	println(isIsomorphic("add", "egg"))
	println(isIsomorphic("foo", "bar"))
	println(isIsomorphic("abc", "xyz"))
	println(isIsomorphic("hamara", "bajaja"))
}