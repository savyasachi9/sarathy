package main

import (
	"fmt"
	"strconv"
	"sync"
)

func main() {
	stringMap := make(map[string]interface{})
	stringMap["hello"] = 78
	stringMap["world"] = 23

	var mu sync.Mutex
	var wg sync.WaitGroup
	// add values concurrently in the map
	wg.Add(9)
	for i := 0; i < 9; i++ {
		go func(iter int) {
			key := "foo" + strconv.Itoa(iter)
			mu.Lock()
			stringMap[key] = iter
			mu.Unlock()

			wg.Done()
		}(i)
	}

	wg.Wait()

	for k, v := range stringMap {
		fmt.Printf("key: %v and val: %v\n", k, v)
	}

	if _, exists := stringMap["hmmm"]; exists {
		println("hmmm")
	}
}
