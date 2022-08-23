/*
392. Is Subsequence

Given two strings s and t, return true if s is a subsequence of t, or false otherwise.
A subsequence of a string is a new string that is formed from the original string by deleting some (can be none) of the characters without disturbing the relative positions of the remaining characters. (i.e., "ace" is a subsequence of "abcde" while "aec" is not).

Example 1:
Input: s = "abc", t = "ahbgdc"
Output: true

Example 2:
Input: s = "axc", t = "ahbgdc"
Output: false
 
Constraints:

0 <= s.length <= 100
0 <= t.length <= 104
s and t consist only of lowercase English letters.
 
Follow up: Suppose there are lots of incoming s, say s1, s2, ..., sk where k >= 109, and you want to check one by one to see if t has its subsequence. In this scenario, how would you change your code?
*/

package main

// Answer : check if s exists in t by looping over t
func isSubsequence(s string, t string) bool {
	sLen := len(s)
	sIdx := 0 // occurances of s in t
	tLen := len(t)
	tIdx := 0

	if (sLen == 0) || (sLen == 0 && tLen == 0) {
		return true
	}

	for i := 0; i < tLen; i++ {
		//println(sIdx, i, string(t[i]))

		if sLen > 0 && s [sIdx] == t[i] {
			sIdx ++
		}

		if sIdx == sLen {
			return true
		}

		tIdx ++		
	}

	return false
}

func main() {
	println(isSubsequence("abc", "axbycz")) // true
	println(isSubsequence("axc", "ahbgdc")) // false
	println(isSubsequence("", "ahbgdc"))    // true
	println(isSubsequence("abc", ""))       // false
	println(isSubsequence("", ""))          // true
}