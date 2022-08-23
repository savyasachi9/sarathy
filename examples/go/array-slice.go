package main

import (
	"fmt"
)

func main() {
	var arr [3]int
	var slice []int
	fmt.Printf("%T :: %T\n", arr, slice)

	arr[0] = 1
	//slice[0] = 1
	slice = append(slice, 3)

	test_arr_slice(arr, slice)
}

func test_arr_slice(a [3]int, sl []int) {
	for k, v := range a {
		println("arr ", k, v)
	}

	for k, v := range sl {
		println("slice ", k, v)
	}
}
