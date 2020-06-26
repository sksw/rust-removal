import Foundation

// +---------------+
// | Single Number |
// +---------------+
//
// Given a non-empty array of integers, every element appears twice except for one. Find that single one.

func singleNumber(in list: [Int]) -> Int {
    return list
        .reduce(into: [Int: Int]()) { buckets, num in
            if let count = buckets[num] {
                buckets[num] = count + 1
            } else {
                buckets[num] = 1
            }
        }
        .filter { $0.value == 1 }
        .reduce(0) { $1.key }
}

singleNumber(in: [2,2,1])
singleNumber(in: [4,1,2,1,2])

func singleNumberNinja(in list: [Int]) -> Int {
    return list.reduce(0) { $0 ^ $1 }
}

singleNumberNinja(in: [2,2,1])
singleNumberNinja(in: [4,1,2,1,2])
