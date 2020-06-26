import Foundation

// +-------------------+
// | Find Intersection |
// +-------------------+
//
// Have the function FindIntersection(strArr) read the array of strings stored in strArr which will contain 2 elements: the first element will represent a list of comma-separated numbers sorted in ascending order, the second element will represent a second list of comma-separated numbers (also sorted). Your goal is to return a comma-separated string containing the numbers that occur in elements of strArr in sorted order. If there is no intersection, return the string false.

extension Collection where Element: Hashable {
    func intersection(with other:[Self.Element]) -> [Self.Element] {
        return Array(Set(self).intersection(other))
    }
}

extension Collection where Element == Int {
    func intersection2(with other: [Int]) -> [Int] {
        return reduce(into: []) { tracker, next in
            if other.contains(next) {
                tracker.append(next)
            }
        }
    }
}

func findIntersection(_ strArr: [String]) -> String {
    let numbers1 = strArr[0]
        .components(separatedBy: ", ")
        .compactMap { Int($0) }
    let numbers2 = strArr[1]
        .components(separatedBy: ", ")
        .compactMap { Int($0) }
    
    let intersection = numbers1.intersection(with: numbers2)
    guard intersection.count > 0 else {
        return "false"
    }
    return intersection
        .map { String($0) }
        .joined(separator: ", ")
}

findIntersection(["1, 3, 4, 7, 13", "1, 2, 4, 13, 15"])
findIntersection(["1, 3, 9, 10, 17, 18", "1, 4, 9, 10"])
