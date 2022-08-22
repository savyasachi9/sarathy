package main

import (
	"fmt"
	"os"
)

// wtf

func main() {
	quit := make(chan bool)
	go func() {
		for {
			select {
			case <-quit:
				return
			default:
				// …
				fmt.Println("OK !", os.Args)
			}
		}
	}()
	// …
	//quit <- true
}
