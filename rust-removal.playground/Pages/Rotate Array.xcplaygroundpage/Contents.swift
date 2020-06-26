import Foundation

// +--------------+
// | Rotate Array |
// +--------------+
//
// Given an array, rotate the array to the right by k steps, where k is non-negative.

extension Collection {
    func rotateRight(by amount: Int = 1) -> [Self.Element] {
        if amount >= count {
            return Array(self)
        }
        let tail = suffix(amount)
        let head = prefix(count - amount)
        return Array(tail) + Array(head)
    }
}

[1, 2, 3, 4, 5, 6, 7].rotateRight(by: 3)
[-1, -100, 3, 99].rotateRight(by: 2)
["hi", "hello", "world", "greeting"].rotateRight()

enum Direction {
    case right
    case left
}

extension Array {
    func rotate(_ direction: Direction, by amount: Int = 1) -> [Self.Element] {
        guard let first = first else {
            return []
        }
        var rotated = Array(repeating: first, count: count)
        for index in 0..<count {
            let shiftedIndex: Int!
            switch direction {
            case .right: shiftedIndex = (index + amount) % count
            case .left: shiftedIndex = (index + count - amount) % count
            }
            rotated[shiftedIndex] = self[index]
        }
        return rotated
    }
}

[1, 2, 3, 4, 5, 6, 7].rotate(.right, by: 3)
[-1, -100, 3, 99].rotate(.right, by: 2)
["hi", "hello", "world", "greeting"].rotate(.right)

[1, 2, 3, 4, 5, 6, 7].rotate(.left, by: 3)
[-1, -100, 3, 99].rotate(.left, by: 2)
["hi", "hello", "world", "greeting"].rotate(.left)
