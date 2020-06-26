import Foundation

// +--------------------+
// | Contains Duplicate |
// +--------------------+
//
// Given an array of integers, find if the array contains any duplicates.

extension Collection where Element: Hashable {
    
    func containsDuplicate() -> Bool {
        return Set(self).count == count
    }
    
    func containsDuplicate2() -> Bool {
        var dict = Set<Self.Element>()
        for item in self {
            if dict.contains(item) {
                return false
            }
            dict.update(with: item)
        }
        return true
    }
    
}

[1,2,3,1].containsDuplicate()
[1,2,3,4].containsDuplicate()
[1,1,1,3,3,4,3,2,4,2].containsDuplicate()

[1,2,3,1].containsDuplicate2()
[1,2,3,4].containsDuplicate2()
[1,1,1,3,3,4,3,2,4,2].containsDuplicate2()
