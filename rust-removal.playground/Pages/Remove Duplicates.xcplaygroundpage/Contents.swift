import Foundation

// +-------------------------------------+
// | Remove Duplicates from Sorted Array |
// +-------------------------------------+
//
// Given a sorted array nums, remove the duplicates in-place such that each element appear only once and return the new length.  Do not allocate extra space for another array, you must do this by modifying the input array in-place with O(1) extra memory.
//
// e.g. given [0,0,1,1,1,2,2,3,3,4], return length = 5, with the first five elements of nums being modified to 0, 1, 2, 3, and 4 respectively.  It doesn't matter what values are set beyond the returned length.

func removeDuplicates(in list: inout [Int]) -> Int {
    guard list.count > 0 else {
        return 0
    }
    
    var index = 0
    var value = list[0]
    for item in 0..<list.count {
        if list[item] != value {
            value = list[item]
            list[index] = value
            index += 1
        }
    }
    return index + 1
}

var list = [0,0,1,1,1,2,2,3,3,4]

removeDuplicates(in: &list)
print(list)

list = [0,0,1,2,3,3,5,5,5,5,7,11]
removeDuplicates(in: &list)
print(list)
