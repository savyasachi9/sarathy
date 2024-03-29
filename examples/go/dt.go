package main

import "fmt"

/*
bool, string, int, bytes, rune
arr, slice, map, chan
*/

type int_arr_3 [3]int

func main() {
	var int_test int
	var int_arr_test = int_arr_3{1, 2, 3}
	var int_slice_test = []int{1, 2, 3}
	//var byte_test byte = `byte`

	print_var_type(true)
	print_var_type("hmmm")
	print_var_type(`hmmm ?`)
	print_var_type([]byte("wth"))
	print_var_type([]rune("wth"))
	print_var_type(int_test)
	print_var_type(int_arr_test)
	print_var_type(int_slice_test)
}

func print_var_type(v interface{}) {
	switch vType := v.(type) {
	case int:
		fmt.Printf("type is %T, val is %v\n", vType, v)
	case bool:
		fmt.Printf("type is %T, val is %v\n", vType, v)
	case string:
		fmt.Printf("type is %T, val is %v\n", vType, v)
	case []byte:
		fmt.Printf("type is %T, val is %v\n", vType, v)
	case []rune:
		fmt.Printf("type is rune %T, val is %v\n", vType, v)
	case []int:
		fmt.Printf("type is slice %T, val is %v\n", vType, v)
	default:
		fmt.Printf("default type is %T, val is %v\n", vType, v)
	}
}
