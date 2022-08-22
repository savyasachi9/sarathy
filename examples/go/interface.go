package main

type helloworld interface {
	hello() string
	world() string
}

type user struct {
	name string
	age  int
}

type employee struct {
	name string
	dob  int
}

func (u user) hello() string {
	return "hello : " + u.name
}

func (u user) world() string {
	return "world : " + u.name
}

func test(hw helloworld) {
	println(hw.hello())
	println(hw.world())
}

func main() {
	u := user{name: "abc", age: 21}
	test(u)
}
