/*
876. Middle of the Linked List / Easy

Given the head of a singly linked list, return the middle node of the linked list.
If there are two middle nodes, return the second middle node.

Example 1:
Input: head = [1,2,3,4,5]
Output: [3,4,5]
Explanation: The middle node of the list is node 3.

Example 2:
Input: head = [1,2,3,4,5,6]
Output: [4,5,6]
Explanation: Since the list has two middle nodes with values 3 and 4, we return the second one.
 

Constraints:

The number of nodes in the list is in the range [1, 100].
1 <= Node.val <= 100
*/
package main 

type ListNode struct {
	Val int
	Next *ListNode
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

// soln for 876
// TODO: solve this using array/slice of *ListNode instead of Map ? or doesn't really matter
func middleNode(head *ListNode) *ListNode {
	// loop over the list and get it's len
	// keep a track of node pointers inside a map / array
	nodePointers := make(map[int] *ListNode)

	listLen := 0
	for head != nil {
		nodePointers [listLen + 1] = head
		head = head.Next
		listLen ++
	}

	listMiddle := (listLen / 2) + 1

	return nodePointers [listMiddle]
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

	//display(l)
	println("reversing now\n")

	//display(l)
	l.Next.Next.Next.Next = &ListNode{Val: 5}
	l.Next.Next.Next.Next.Next = &ListNode{Val: 6}
	display(middleNode(l))
} 
