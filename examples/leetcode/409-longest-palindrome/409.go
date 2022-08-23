package main
/*
func longestPalindrome(s string) int {
    cache := make(map[byte]struct{})

    for i := range s {
        if _, ok := cache[s[i]]; ok {
            delete(cache, s[i])
        } else {
            cache[s[i]] = struct{}{}
        }
    }

    if len(cache) == 0 {
		println("chk 1")
		return len(s)
    }

	println("chk 2 : ",len(s), len(cache))
    return len(s) - len(cache) + 1
}
*/

func longestPalindrome(s string) int {
	sMap := make(map[byte]int)
	sLen := len(s)

	for k:= range s {
		v := s[k]
		if _, exists := sMap [v]; exists {
			delete(sMap, v)
		} else {
			sMap [v] = k
		}
	}

	// if map len is 0 means it's a full match, so return strlen
	mLen := len(sMap)
	if mLen == 0 {
		return sLen
	}

	// else we gotta do some match
	return (sLen - mLen) + 1
}

func main() {
	println(longestPalindrome("a"))         // 1
	println(longestPalindrome("aba"))       // 3
	println(longestPalindrome("racecar"))   // 7
	println(longestPalindrome("rad"))       // 1
	println(longestPalindrome("rar"))       // 3
}
