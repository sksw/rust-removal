import Foundation

// +----------+
// | Move 0's |
// +----------+
//
// Given an array nums, write a function to move all 0's to the end of it while maintaining the relative order of the non-zero elements.
// e.g. [0,1,0,3,12] --> [1,3,12,0,0]

extension Collection where Element == Int {
    func moving0sToTail() -> [Int] {
        let nonZeroNumbers = filter { $0 > 0 }
        let trailingZeros = [Int](repeating: 0, count: count - nonZeroNumbers.count)
        return nonZeroNumbers + trailingZeros
    }
}

func move0sToTail(_ numbers: inout [Int]) {
    var nextSlot = 0
    var zeroCount = 0
    for index in 0..<numbers.count {
        if numbers[index] == 0 {
            zeroCount += 1
        } else {
            numbers[nextSlot] = numbers[index]
            nextSlot += 1
        }
    }
    for index in numbers.count - zeroCount ..< numbers.count {
        numbers[index] = 0
    }
}


print([].moving0sToTail())
print([0].moving0sToTail())
print([1].moving0sToTail())
print([1,0].moving0sToTail())
print([0,1].moving0sToTail())
print([0,1,0,3,12].moving0sToTail())
print([0,0,0,5,0,0,6,1].moving0sToTail())
print([0,0,0,5,0,0,6,0,0,0,0,1,0,1,0,1].moving0sToTail())

var numbers = [Int]()
move0sToTail(&numbers)
numbers = [0]
move0sToTail(&numbers)
numbers = [1]
move0sToTail(&numbers)
numbers = [1,0] //
move0sToTail(&numbers)
numbers = [0,1]
move0sToTail(&numbers)
numbers = [0,1,0,3,12]
move0sToTail(&numbers)
numbers = [0,0,0,5,0,0,6,1]
move0sToTail(&numbers)
numbers = [0,0,0,5,0,0,6,0,0,0,0,1,0,1,0,1]
move0sToTail(&numbers)
