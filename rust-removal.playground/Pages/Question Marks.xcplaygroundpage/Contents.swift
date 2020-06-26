import Foundation

// +-----------------+
// | Questions Marks |
// +-----------------+
//
// Have the function QuestionsMarks(str) take the str string parameter, which will contain single digit numbers, letters, and question marks, and check if there are exactly 3 question marks between every pair of two numbers that add up to 10. If so, then your program should return the string true, otherwise it should return the string false. If there aren't any two numbers that add up to 10 in the string, then your program should return false as well.
//
// For example: if str is "arrb6???4xxbl5???eee5" then your program should return true because there are exactly 3 question marks between 6 and 4, and 3 question marks between 5 and 5 at the end of the string.

extension String {
    func containsProperQuestionMarksPairings() -> Bool {
        var num = -1
        var count = 0
        var foundPair = false
        for char in self {
            if let nextNum = Int(String(char)) {
                if num + nextNum == 10 {
                    foundPair = true
                    if count != 3 {
                        return false
                    }
                }
                num = nextNum
                count = 0
            } else if char == "?" {
                count += 1
            }
        }
        return foundPair
    }
}

func questionsMarks(_ str: String) -> String {
    return str.containsProperQuestionMarksPairings() ? "true" : "false"
}

"arrb6???4xxbl5???eee5".containsProperQuestionMarksPairings()
"acc?7??sss?3rr1??????5".containsProperQuestionMarksPairings()
"aa6?9".containsProperQuestionMarksPairings()
