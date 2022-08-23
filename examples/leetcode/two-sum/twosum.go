package main
import(
	"fmt"
)

func twoSum(nums []int, target int) []int {
	mp := make(map[int]int)

	for k, v := range nums {
		if idx, ok := mp [target - v]; ok {
			return []int{idx, k}
		}

		mp [v] = k
	}

	return nil
}

func main(){
	fmt.Printf("%v\n", twoSum([]int{1, 2, 3}, 5))
	// fmt.Printf("%+v\n", twoSum([]int{1, 2, 3}, 5))
	// fmt.Printf("%#v\n", twoSum([]int{1, 2, 3}, 5))
	// fmt.Printf("%+q\n", twoSum([]int{1, 2, 3}, 5))
	fmt.Printf("%v\n", twoSum([]int{1, 0, 3}, 1))
}