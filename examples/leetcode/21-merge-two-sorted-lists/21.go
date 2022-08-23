package main

type ListNode struct {
	val int
	next *ListNode
	len int
}

/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func mergeTwoLists(l1 *ListNode, l2 *ListNode) *ListNode {
	if l1 == nil && l2 == nil {
		return nil
	} else if l1 == nil && l2 != nil {
		return l2
	} else if l1 != nil && l2 == nil {
		return l1
	// when l1 < l2, keep checking further using recursion
	} else if l1.val < l2.val {
		l1.next = mergeTwoLists(l1.next, l2)
		return l1
	} else {
		l2.next = mergeTwoLists(l1, l2.next)
		return l2
	}
}

func traverse(l *ListNode) {
	println("\nlen is : ", l.len)
	for l != nil {
		println(l.val)
		l = l.next
	}
}

func prepend(l *ListNode, v int) *ListNode {
	if l == nil {
		return &ListNode{val: v, len: 1}
	}

	// make new node as the head, also link head with existing list
	return &ListNode{val: v, next: l, len: l.len + 1}
}

func main() {
	// var l *ListNode
	// l = prepend(l, 9)
	// l = prepend(l, 99)
	// l = prepend(l, 999)
	// l = prepend(l, 9999)
	// l = prepend(l, 99999)
	// l = prepend(l, 999999)
	// traverse(l)
	// return

	var l1, l2 *ListNode

	l1 = prepend(l1, 3)
	l1 = prepend(l1, 2)
	l1 = prepend(l1, 1)

	l2 = prepend(l2, 3)
	l2 = prepend(l2, 2)
	l2 = prepend(l2, 1)
	//l2 = prepend(l2, 0)

	traverse(l1)
	traverse(l2)
	traverse(mergeTwoLists(l1, l2))

	traverse(mergeTwoLists(&ListNode{}, &ListNode{}))
}