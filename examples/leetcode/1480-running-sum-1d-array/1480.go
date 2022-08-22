package main
import "fmt"

func runningSumOld(nums []int) []int {
	len  := len(nums)
	sum  := 0 
	rSum := make([] int, len)

	for k, v := range nums {
		sum += v
		rSum[k] = sum
	}

	return rSum
}

func runningSum(nums []int) []int {
	numLen  := len(nums)
	runSum  := make([]int, numLen)
	currSum := 0

	for k, v := range nums {
		currSum += v
		runSum [k] = currSum
	}

	return runSum
}

func main() {
	fmt.Println(runningSum([]int{1, 2, 3}))
}