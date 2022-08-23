package main

import (
	"fmt"
)

type Node struct {
	val int
	next *Node
}

type SinglyLinkedList struct {
	len int
	head *Node
	tail *Node
}

func (sll SinglyLinkedList) traverse() {
	for sll.head != nil { // we can also loop using sll.len -- as this is a tmp copy
		fmt.Println(sll.head.val)
		sll.head = sll.head.next
	}
}

func (sll *SinglyLinkedList) prepend(val int) {
	// let's add a node in the beginning
	// first we'll create a tmp/2nd node from head, then create new head node and link head with 2nd/tmp
	// [val, *] -> [val, *] -> [val, *]
	//println(sll)
	// TODO: handle case for when list is empty ??? or is it already taken care of with below logic

	sll.head = &Node{val, sll.head}	
	if sll.len == 0 {
		sll.tail = sll.head
	}
	sll.len ++
}

func (sll *SinglyLinkedList) append(val int) {
	// TODO: handle case for when list is empty ???
	if sll.len == 0 {
		sll.head = &Node{val, nil}
		sll.tail = sll.head
		sll.len++
		return
	}

	// head[4, *] -> [3, *] -> tail[2, *]
	// newNode[1, *] -> add this to curr tail and mark this as the tail 
	newTail := &Node{val, nil}
	// println(sll.tail)
	sll.tail.next = newTail
	sll.tail = newTail

	sll.len ++
}

func (sll *SinglyLinkedList) reverse() *SinglyLinkedList {
	// to reverse we can create a new list by looping over tail -> head
	reversedSll := &SinglyLinkedList{}
	for sll.head != nil {
		reversedSll.prepend(sll.head.val)
		sll.head = sll.head.next
	}

	// reversedSll.traverse()
	// return reversedSll
	sll = reversedSll
	return sll
}

// has to be done using merge sort
func (sll *SinglyLinkedList) sort() {
	// create a tmp list which is sorted using insertion sort ?
}

func mergeSortedLists(sll1 *SinglyLinkedList, sll2 *SinglyLinkedList) {

}

func main() {
	sll := &SinglyLinkedList{}
	sll.prepend(1)
	// return
	// sll.prepend(2)
	// sll.prepend(3)
	// sll.prepend(6)
	// sll.prepend(12)
	// sll.prepend(24)
	// fmt.Println(sll, sll.len)
	// sll.traverse()

	sll.append(4)
	sll.append(5)
	// sll.append(7)
	// sll.append(8)
	sll.traverse()
	// fmt.Println(sll, sll.len)
	// sll = sll.reverse()
	sll.reverse()
	println("reversed list")
	sll.traverse()
}