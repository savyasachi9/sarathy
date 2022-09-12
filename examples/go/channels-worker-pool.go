package main

import (
	"fmt"
	"time"
)

// https://gobyexample.com/worker-pools
// func main() {

// 	const numJobs = 5
// 	jobs := make(chan int, numJobs)
// 	results := make(chan int, numJobs)

// 	for w := 1; w <= 3; w++ {
// 		go worker(w, jobs, results)
// 	}

// 	for j := 1; j <= numJobs; j++ {
// 		jobs <- j
// 	}
// 	close(jobs)

// 	for a := 1; a <= numJobs; a++ {
// 		res := <-results
// 		fmt.Printf("res is %v:\n", res)
// 	}
// }

func worker(id int, jobs <-chan int, results chan<- int) {
	for j := range jobs {
		fmt.Println("worker", id, "started  job", j)
		time.Sleep(time.Second)
		fmt.Println("worker", id, "finished job", j)
		results <- j * 2
	}
}

func w(id int, jobs <-chan int, results chan<- int) {
	for j := range jobs {
		results <- j * j
	}
}

func main() {
	jobsCnt := 9
	jobs := make(chan int, jobsCnt)
	results := make(chan int, jobsCnt)

	// let's create 3 workers todo work
	for i := 0; i < 3; i++ {
		go func(id int, jobs <-chan int, results chan<- int) {
			for j := range jobs {
				r := j * j
				results <- r
			}
		}(i, jobs, results)
		//go w(i, jobs, results)
		// go func(id int, jobs <-chan int, results chan<- int) {
		// 	for j := range jobs {
		// 		results <- j * j
		// 	}
		// }(i, jobs, results)
	}

	// create work over unbuffered channel
	for i := 0; i < jobsCnt; i++ {
		jobs <- i // send i to chan as work
	}
	close(jobs)

	for i := 0; i < jobsCnt; i++ {
		res := <-results
		fmt.Printf("res is : %v\n", res)
	}
}
