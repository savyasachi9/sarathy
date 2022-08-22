package main

// n! = n * (n -1) * (n-2) * 1
func fact(n int) int {
	if n == 0 {
		return 1
	}

	return n * fact(n-1)
}

// Fn = Fn-1 + Fn-2
// F0 = 0 and F1 = 1
func fib(n int) int {
	if n >= 0 && n <= 1 {
		return n
	}

	return fib(n-1) + fib(n-2)
}

func main() {
	println(fact(0))
	println(fact(1))
	println(fact(2))
	println(fact(3))
	println(fact(4))
	println(fact(5))

	println("doing fib now")
	println(fib(1))
	println(fib(2))
	println(fib(3))
	println(fib(9)) // 34
}
