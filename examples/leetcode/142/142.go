/*
142. Linked List Cycle II / Medium

Given the head of a linked list, return the node where the cycle begins. If there is no cycle, return null.

There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the next pointer.
Internally, pos is used to denote the index of the node that tail's next pointer is connected to (0-indexed). 
It is -1 if there is no cycle. Note that pos is not passed as a parameter.

Do not modify the linked list. !!!

Example 1:
Input: head = [3,2,0,-4], pos = 1
Output: tail connects to node index 1
Explanation: There is a cycle in the linked list, where tail connects to the second node.

Example 2:
Input: head = [1,2], pos = 0
Output: tail connects to node index 0
Explanation: There is a cycle in the linked list, where tail connects to the first node.

Example 3:
Input: head = [1], pos = -1
Output: no cycle
Explanation: There is no cycle in the linked list.

Constraints:
The number of the nodes in the list is in the range [0, 104].
-105 <= Node.val <= 105
pos is -1 or a valid index in the linked-list.

Follow up: Can you solve it using O(1) (i.e. constant) memory ?
*/

package main

type ListNode struct {
	Val int
	Next *ListNode
}

// loop over the list and keep a track of what all nodes have already been visited
func detectCycle(head *ListNode) *ListNode {
	nodesVisited := make(map[*ListNode]int)
	posIdx := 0
	for head != nil {

		// if key found AKA cycle detected
		if val, key := nodesVisited [head]; key {
			println("cycle detected at : ", val)
			return head
		}

		nodesVisited [head] = posIdx
		head = head.Next
		posIdx ++
	}

	return nil
}

func display(l *ListNode) {
	ll := 12
	i := 0
	for l != nil && i < ll{
		println(l.Val)
		l = l.Next
		i++
	}
}

func main() {
	l := &ListNode{Val: 1} // head
	l.Next = &ListNode{Val: 2}
	l.Next.Next = &ListNode{Val: 3}
	l.Next.Next.Next = &ListNode{Val: 4, Next: l.Next} // cycle

	detectCycle(l)
	display(l)
}

/*
1 1 0xc000096000
1 2 0xc000096010
2 2 0xc000096010
2 3 0xc000096020
3 3 0xc000096020
3 4 0xc000096030
4 4 0xc000096030
4 2 0xc000096010

*/