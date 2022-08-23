package main
import "fmt"

type ListNode struct {
	Val int
	Next *ListNode
}

type List struct {
	Len int
	Head *ListNode
}

func mergeTwoLists(l1 *ListNode, l2 *ListNode) *ListNode {
    if l1 == nil {
        return l2
    } else if l2 == nil {
        return l1
    } else if l1.Val < l2.Val {
        l1.Next = mergeTwoLists(l1.Next, l2)
        return l1
    } else {
        l2.Next = mergeTwoLists(l1, l2.Next)
        return l2
    }    
} 

func traverse(head *ListNode) {
	fmt.Printf("Linked List: ")
	temp := head
	for temp != nil {
	   fmt.Printf("%d -> ", temp.Val)
	   temp = temp.Next
	}
	fmt.Printf("NULL")
}

func main(){
	head := &ListNode{1, nil}
	head.Next = &ListNode{2, nil}
	head.Next.Next = &ListNode{3, nil}
	traverse(head)
}