package main

import (
	_ "fmt"
	_ "os"
)

// func main() {
// 	quit := make(chan bool)
// 	go func() {
// 		for {
// 			select {
// 			case <-quit:
// 				return
// 			default:
// 				// …
// 				fmt.Println("OK !", os.Args)
// 			}
// 		}
// 	}()
// 	// …
// 	//quit <- true
// }

func main() {
	jobs := make(chan int, 9)
	workers := make(chan int, 9)

	for i := 0; i < 9; i++ {
		jobs <- i
		workers <- i
	}

	for i := 0; i < 21; i++ {
		select {
		case m1 := <-jobs:
			println("jobs: ", m1)
		case m2 := <-workers:
			println("workers: ", m2)
		default:
			println("default")
		}
	}
}

func work(j chan, w chan) {

}
