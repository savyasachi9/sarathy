package main

import "fmt"

func main() {
	fmt.Println("Hello World go !")

	a := 3
	b := 6
	c := a + b

	fmt.Printf("Sum of a(%d) + b(%d) is c(%d)\n", a, b, c)
}

// go run hello.go
