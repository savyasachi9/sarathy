/*
121. Best Time to Buy and Sell Stock / Easy
You are given an array prices where prices[i] is the price of a given stock on the ith day.
You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.
Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.

Example 1:
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.
Note that buying on day 2 and selling on day 1 is not allowed because you must buy before you sell.

Example 2:
Input: prices = [7,6,4,3,1]
Output: 0
Explanation: In this case, no transactions are done and the max profit = 0.
 
Constraints:
1 <= prices.length <= 105
0 <= prices[i] <= 104
*/

package main

// loop over arr and find array min/max value
// also reset the max when we find a new min
func maxProfit(prices []int) int {
	buy := prices[0] // buy price
	sell := prices[0] // sell price
	len := len(prices)
	profit := 0

	for k, v := range prices {
		if v > sell {
			sell = v
		}

		if sell - buy > profit {
			profit = sell - buy
		}

		if v < buy && k < len - 1 {
			buy = v
			sell = v
		}
	}

	return profit
}

func main() {
	println(maxProfit([]int {1}))
	println(maxProfit([]int {1, 2, 3}))
	println(maxProfit([]int {7, 1, 5, 3, 6, 4})) // 5
	println(maxProfit([]int {7, 6, 4, 3, 1})) // 0
	println(maxProfit([]int {2, 4, 1})) // 2

	println(maxProfit([]int {3, 2, 6, 5, 0, 3})) // 4
}