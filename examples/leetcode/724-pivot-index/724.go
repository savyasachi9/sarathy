package main 

func pivotIndex(nums []int) int {
	lSum := 0
	nLen := len(nums)
	tSum := 0
	pIdx := -1

	// calculate total sum
	for i:= 0; i< nLen; i++ {
		tSum += nums[i]
	}

	// set rSum
	rSum := tSum
	for k, v :=  range nums {
		// update rSum & pivot
		rSum -= v
		pIdx = k

		if (lSum == rSum) {
			return pIdx
		}

		// update lSum
		lSum += v
	}

	return -1
}

func main() {
	println(pivotIndex([]int{1, 2, 3}))
	println(pivotIndex([]int{1, 7, 3, 6, 5, 6}))
}