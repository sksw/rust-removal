import Foundation

// +--------+
// | Plus 1 |
// +--------+
//
// Given a non-empty array of digits representing a non-negative integer, plus one to the integer.  The digits are stored such that the most significant digit is at the head of the list, and each element in the array contain a single digit.  You may assume the integer does not contain any leading zero, except the number 0 itself.
// e.g. [1,2,3] --> [1,2,4]

enum ArithmeticError: Error {
    case overflow
}

func increment(_ number: inout [Int]) throws {
    var digit = number.count-1
    while digit >= 0 {
        if number[digit] == 9 {
            number[digit] = 0
            digit -= 1
        } else {
            number[digit] = number[digit] + 1
            return
        }
    }
    number.insert(1, at: 0)
//    throw ArithmeticError.overflow
}

var num = [1]
do {
    try increment(&num)
    print(num)
    num = [1 ,2, 3]
    try increment(&num)
    print(num)
    num = [1 ,2, 9]
    try increment(&num)
    print(num)
    num = [1 ,9, 9]
    try increment(&num)
    print(num)
    num = [9 ,9, 9]
    try increment(&num)
    print(num)
} catch {
    print("\(error)")
}
