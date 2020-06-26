import Foundation

// +--------------+
// | Longest Word |
// +--------------+
//
// Have the function LongestWord(sen) take the sen parameter being passed and return the largest word in the string. If there are two or more words that are the same length, return the first word from the string with that length. Ignore punctuation and assume sen will not be empty.

func longestWord(in sen: String) -> String {
    return sen
        .components(separatedBy: .punctuationCharacters)
        .joined()
        .components(separatedBy: " ")
        .reduce(into: "") { result, next in
            if next.count > result.count {
                result = next
            }
    }
}

longestWord(in: "I love dogs")
longestWord(in: "fun&!! time")

// hmmm, see if we can skip a few functional operators to be a little more efficient

func longestWord(of sen: String) -> String {
    return sen
        .components(separatedBy: " ")
        .reduce(into: "") { result, next in
            if next.punctuationFreeLength() > result.punctuationFreeLength() {
                result = next
            }
    }
}

extension String {
    func punctuationFreeLength() -> Int {
        return reduce(0) { count, character in
            if CharacterSet.punctuationCharacters.contains(character.unicodeScalars.first!) {
                return count
            }
            return count + 1
        }
    }
}

longestWord(of: "I love dogs")
longestWord(of: "fun&!! time")
