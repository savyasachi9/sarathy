package main

import (
	"fmt"
	"strings"
)

func main() {
	s := "hello world !"
	b := []byte("hello world !")
	b2s := string(b)
	fmt.Printf("string is: %s\nbyte is :%v\nbtye to string is: %v\n", s, b, b2s)

	// str to byte and rune
	fmt.Printf("str to byte: %v\n", []byte(s))
	fmt.Printf("str to rune: %v\n", []rune(s))

	for k, v := range s {
		fmt.Println(k, string(v))
	}

	splitS := strings.Split(s, "")
	//fmt.Printf("type: %t , val: %v", splitS)
	println("\nLooping over split string:", s)
	for k, v := range splitS {
		fmt.Println(k, string(v))
	}
}
