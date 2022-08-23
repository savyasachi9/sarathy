package main

import "fmt"

// Node
type Node struct {
	val int
	next *Node
}

type List struct {
	head *Node
	len int
}

func (l *Node) add(val int) {
	// first goto end of list
	for l.next != nil {
		l = l.next
	}

	// then add new node
	l.next = &Node{val, nil}
}

func (sll *Node) display() {
	for sll != nil {
		fmt.Printf("%v\n", sll.val)
		sll = sll.next
	}
}

func (sll *Node) prepend(val int) {
	if sll == nil {
		println("chk 1")
		println(sll == nil)
		sll = &Node{val, nil}
		println(sll == nil)
		return
	}

	println("chk 3", sll)
	//sll.next = &Node{val, sll.next}
	//sll.next = &Node{val, sll.next}
}

func main() {
	// sll := &Node{1, nil}
	// sll.next = &Node{2, nil}
	// sll.next.next = &Node{3, nil}
	// sll.add(4)
	// sll.add(5)
	// sll.add(6)

	//sll.next = &Node{9, nil}
	var sll *Node
	sll.prepend(99)
	sll.prepend(96)
	sll.prepend(93)
	sll.display()
}