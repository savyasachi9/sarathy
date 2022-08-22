package main

import "sync"

var wg sync.WaitGroup

type container struct {
	val int
	mu sync.Mutex
}

func test(s string) {
	println("given string is : ", s)
}

func main() {
	wg.Add(1)

	go func() {
		test("hello")
		wg.Done()
	}()

	wg.Wait()
}
