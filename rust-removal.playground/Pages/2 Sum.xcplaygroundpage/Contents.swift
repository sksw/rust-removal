import Foundation


// +-------+
// | 2 Sum |
// +-------+
//
// Find all the pairs of two integers in an unsorted array that sum up to a given number.
// e.g. [3, 5, 2, -4, 8, 11] with sum 7 should return [(11, -4), (2, 5)].

extension Array where Element == Int {
    func pairs(sumTo sum: Int) -> [(Int, Int)] {
        guard count > 1 else {
            return []
        }
        var pairs = [(Int, Int)]()
        for ref in 0..<count-1 {
            for idx in ref + 1..<count {
                let num1 = self[ref]
                let num2 = self[idx]
                if num1 + num2 == sum {
                    pairs.append((num1, num2))
                }
            }
        }
        return pairs
    }
}

[0].pairs(sumTo: 0)
[0].pairs(sumTo: 1)
[0, 1].pairs(sumTo: 0)
[0, 1].pairs(sumTo: 1)
[1, 1].pairs(sumTo: 2)
[1, 2].pairs(sumTo: 2)
[1, 2].pairs(sumTo: 3)
[1, 1, 1].pairs(sumTo: 2)
[3, 5, 2, -4, 8, 11].pairs(sumTo: 7)
