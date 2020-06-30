import Foundation

// +-----------------------+
// | Reverse a Binary Tree |
// +-----------------------+
//
// An inverted form of a Binary Tree is another Binary Tree with left and right children of all non-leaf nodes interchanged. You may also call it the mirror of the input tree.

class Node<T> {
    let data: T
    var left: Node<T>?
    var right: Node<T>?

    init(data: T,
         left: Node<T>? = nil,
         right: Node<T>? = nil) {
        self.data = data
        self.left = left
        self.right = right
    }
}

extension Int {
    var isPowerOfTwo: Bool {
        return (self > 0) && (self & (self - 1) == 0)
    }
}

extension Node {
    func inverse() {
        let temp = right
        right = left
        left = temp

        if let right = right {
            right.inverse()
        }
        if let left = left {
            left.inverse()
        }
    }

    func treeDrawing() -> String {
        var drawing = ""
        var list = [Node<T>]()
        list.append(self)
        while list.count > 0 {
            let item = list.removeFirst()
            drawing += "\(item.data) "
            if let left = item.left {
                list.append(left)
            }
            if let right = item.right {
                list.append(right)
            }
        }
        return drawing
    }
}

let tree = Node<Int>(
    data: 0,
    left: Node<Int>(data: 2,
        left: Node<Int>(data: 4,
            left: Node<Int>(data: 8)
        ),
        right: Node<Int>(data: 6)
    ),
    right: Node<Int>(data: 1,
        left: Node<Int>(data: 3),
        right: Node<Int>(data: 5)
    )
)

print(tree.treeDrawing())
tree.inverse()
print(tree.treeDrawing())

