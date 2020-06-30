import Foundation

// +-----------------------+
// | Reverse a linked list |
// +-----------------------+
//
// Given pointer to the head node of a linked list, the task is to reverse the linked list. We need to reverse the list by changing links between nodes.

class Node<T> {
    let data: T
    var next: Node<T>?

    init(data: T, next: Node<T>? = nil) {
        self.data = data
        self.next = next
    }
}

extension Node {
    func reverse() -> Node<T> {
        let newRoot = recurvieReverse()
        next = nil
        return newRoot
    }
    private func recurvieReverse() -> Node<T> {
        if let next = next {
            let newRoot = next.reverse()
            next.next = self
            return newRoot
        } else {
            return self
        }
    }

    var listString: String {
        var listString = ""
        var node: Node<T>? = self
        while let next = node {
            listString += "\(next.data) "
            node = next.next
        }
        return listString
    }
}

let root = Node<Int>(
    data: 1,
    next: Node<Int>(
        data: 2,
        next: Node<Int>(
            data: 3,
            next: Node<Int>(
                data: 4,
                next: Node<Int>(
                    data: 5
                )
            )
        )
    )
)

print(root.listString)
print(root.reverse().listString)
