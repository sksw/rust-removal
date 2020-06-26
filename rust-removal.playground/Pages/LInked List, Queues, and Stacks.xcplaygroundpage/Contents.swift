import Foundation

// linked list

class Node<T> {
    let data: T
    var next: Node<T>?
    
    init(data: T, next: Node<T>? = nil) {
        self.data = data
        self.next = next
    }
}

// queue with linked list

class Queue<T> {
    private var first: Node<T>? = nil
    private var last: Node<T>? = nil

    init(item: T? = nil) {
        if let item = item {
            first = Node(data: item)
            last = first
        }
    }

    func enqueue(_ item: T) {
        let node = Node(data: item)
        if first == nil {
            first = node
        }
        if let last = last {
            last.next = node
        }
        last = node
    }

    func dequeue() -> T? {
        let node = first
        first = node?.next
        if first == nil {
            last = nil
        }
        return node?.data
    }
}

var queue = Queue<Int>()
queue.enqueue(1)
queue.dequeue()

queue = Queue(item: 3)
queue.dequeue()
queue.dequeue()
queue.enqueue(5)
queue.enqueue(7)
queue.enqueue(11)
queue.dequeue()
queue.dequeue()
queue.dequeue()

// stack with linked list

class Stack<T> {
    private var root: Node<T>? = nil

    init(item: T? = nil) {
        if let item = item {
            root = Node(data: item)
        }
    }
    
    func push(_ item: T ) {
        let node = Node(
            data: item,
            next: root
        )
        root = node
    }
    
    func pop() -> T? {
        let node = root
        root = root?.next
        return node?.data
    }
}

var stack = Stack<Int>()
stack.push(1)
stack.pop()

stack = Stack(item: 3)
stack.pop()
stack.pop()
stack.push(5)
stack.push(7)
stack.push(11)
stack.pop()
stack.pop()
stack.pop()

// queue with stack

class StackQueue<T> {
    private let ordered: Stack<T>
    private let reversed: Stack<T>
    
    init(item: T? = nil) {
        ordered = Stack<T>()
        reversed = Stack<T>()
        if let item = item {
            ordered.push(item)
        }
    }
    
    func enqueue(_ next: T) {
        while let item = ordered.pop() {
            reversed.push(item)
        }
        reversed.push(next)
        while let item = reversed.pop() {
            ordered.push(item)
        }
    }
    
    func dequeue() -> T? {
        return ordered.pop()
    }
}

var stackedQueue = StackQueue<Int>()
stackedQueue.enqueue(1)
stackedQueue.dequeue()

stackedQueue = StackQueue(item: 3)
stackedQueue.dequeue()
stackedQueue.dequeue()
stackedQueue.enqueue(5)
stackedQueue.enqueue(7)
stackedQueue.enqueue(11)
stackedQueue.dequeue()
stackedQueue.dequeue()
stackedQueue.dequeue()
