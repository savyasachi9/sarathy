/*
206. Reverse Linked List
Given the head of a singly linked list, reverse the list, and return the reversed list.

Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]

Input: head = [1,2]
Output: [2,1]

Input: head = []
Output: []
*/
package main 

type ListNode struct {
	Val int
	Next *ListNode
}

/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func reverseList(head *ListNode) *ListNode {
	var temp *ListNode

	for head != nil {
		// use prepend logic here
		temp = &ListNode{Val: head.Val, Next: temp}
		head = head.Next
	}

	return temp
}

func prepend(l *ListNode, v int) *ListNode {
	if l == nil {
		return &ListNode{Val: v}
	}

	// make new node as the head, also link head with existing list
	return &ListNode{Val: v, Next: l}
}

func display(l *ListNode) {
	for l != nil {
		println(l.Val)
		l = l.Next
	}
}

func main() {
	// var sll *ListNode
	// sll = prepend(sll, 3)
	// sll = prepend(sll, 2)
	// sll = prepend(sll, 1)
	// display(sll)

	// return
	l := &ListNode{Val: 1}
	l.Next = &ListNode{Val: 2}
	l.Next.Next = &ListNode{Val: 3}
	l.Next.Next.Next = &ListNode{Val: 4}

	display(l)
	println("reversing now\n")

	l = reverseList(l)
	display(l)
}