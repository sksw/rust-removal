import Foundation

// +------------+
// | Buy n Sell |
// +------------+
//
// nth element is the price of a given stock on day n.  Create an algorithm to find the maximum profit. You may complete as many transactions as you like (i.e., buy one and sell one share of the stock multiple times).  Note: You may not engage in multiple transactions at the same time (i.e., you must sell the stock before you buy again).

// e.g. given [7,1,5,3,6,4], return 7 based on:  buy day 2 (price = 1), sell day 3 (price = 5) for profit = 5-1 = 4, buy day 4 (price = 3), sell day 5 (price = 6) for profit = 6-3 = 3.

enum Transaction {
    case bought(at: Int)
    case sold
}

func maximizableProfit(basedOn prices: [Int]) -> Int {
    guard let first = prices.first else {
        return 0
    }
    
    let activity = prices.scan(basedOn: .bought(at: first), to: -first) { latestAction, prevPrice, nextPrice, profit -> (Transaction, Int) in
        switch latestAction {
        case .bought:
            if nextPrice > prevPrice {
                return (.sold, profit + nextPrice)
            } else {
                return (.bought(at: nextPrice), profit + prevPrice - nextPrice)
            }
        case .sold:
            if nextPrice < prevPrice {
                return (.bought(at: nextPrice), profit - nextPrice)
            } else {
                return (.sold, profit - prevPrice + nextPrice)
            }
        }
    }
    
    var profit = activity.1
    if case let .bought(buyPrice) = activity.0 {
        profit += buyPrice
    }
    return profit
}

maximizableProfit(basedOn: [7, 1, 5, 3, 6, 4]) // 7
maximizableProfit(basedOn: [16, 16, 8, 4, 2, 1]) // 0
maximizableProfit(basedOn: [1, 2, 4, 8, 16, 16]) // 15
maximizableProfit(basedOn: [3, 3, 1, 1, 2, 2]) // 1
maximizableProfit(basedOn: [3, 2, 1, 3, 5, 7, 11]) // 10
maximizableProfit(basedOn: [1, 1, 1, 1, 1, 1, 1]) // 0

func maximizableProfit2(basedOn prices: [Int]) -> Int {
    prices.scan(to: 0) { prev, next, profit -> Int in
        if prev < next {
            return profit + (next - prev)
        }
        return profit
    }
}

maximizableProfit2(basedOn: [7, 1, 5, 3, 6, 4]) // 7
maximizableProfit2(basedOn: [16, 16, 8, 4, 2, 1]) // 0
maximizableProfit2(basedOn: [1, 2, 4, 8, 16, 16]) // 15
maximizableProfit2(basedOn: [3, 3, 1, 1, 2, 2]) // 1
maximizableProfit2(basedOn: [3, 2, 1, 3, 5, 7, 11]) // 10
maximizableProfit2(basedOn: [1, 1, 1, 1, 1, 1, 1]) // 0
