import Foundation

// +-----------+
// | Tree Sort |
// +-----------+
//
// Tree sort is a sorting algorithm that is based on Binary Search Tree data structure. It first creates a binary search tree from the elements of the input list or array and then performs an in-order traversal on the created binary search tree to get the elements in sorted order.

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

extension Node {
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

extension Node where T == Int {
    static func buildTree(from data: [Int]) -> Node<T>? {
        guard data.count > 0,
            let first = data.first else {
            return nil
        }
        let root = Node(data: first)
        for item in data.dropFirst() {
            root.insert(item)
        }
        return root
    }

    func insert(_ item: Int) {
        if item > data {
            if let right = right {
                right.insert(item)
            } else {
                right = Node(data: item)
            }
        } else {
            if let left = left {
                left.insert(item)
            } else {
                left = Node(data: item)
            }
        }
    }

    func inorder(_ root: Node<T>? = nil, to list: inout [Int]){
        guard let root = root else {
            return inorder(self, to: &list)
        }
        if let left = root.left {
            inorder(left, to: &list)
        }
        list.append(root.data)
        if let right = root.right {
            inorder(right, to: &list)
        }
    }
}

let list1 = Node.buildTree(from: [5, 9, 1, 2, 8, 6, 3])!
print(list1.treeDrawing())
//       5
//    1     9
//     2   8
//    3   6
var sorted = [Int]()
list1.inorder(to: &sorted)
print(sorted)

let list2 = Node.buildTree(from: [8, 3, 10, 1, 6, 4, 7, 14, 13])!
print(list2.treeDrawing())
//        8
//    3       10
//  1   6        14
//     4 7     13
sorted = [Int]()
list2.inorder(to: &sorted)
print(sorted)
