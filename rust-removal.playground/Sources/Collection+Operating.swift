import Foundation

public extension Collection {
    
    /// 'Scan' a collection and compute a value based on deltas between values.
    ///
    /// - Parameters:
    ///   - initialResult: The starting value of the desired computed outcome.
    ///   - diff: A running window operation that will be called with  (1) previous item in collection, (2) current item in collection, and (3) the computed outcome being passed along.
    /// - Returns: Computed outcome of running `diff` across the entire collection.  Collection must contain at least 2 elements, otherwise `initialResult` is immediately returned.
    func scan<T>(to initialResult: T, basedOn diff: (Self.Element, Self.Element, T) throws -> T) rethrows -> T {
        let outcome = try scan(basedOn: "n/a", to: initialResult) { _, prev, next, result -> (String, T) in
            let newResult = try diff(prev, next, result)
            return ("n/a", newResult)
        }
        return outcome.1
    }
    
    /// 'Scan' a collection and compute am outcome based on deltas between elements, and additional info passed along.
    /// U is type of additional info passed along, and V is the running outcome type.
    ///
    /// - Parameters:
    ///   - seed: The starting value of supplementary info.
    ///   - initialResult: The starting value of the desired computed outcome.
    ///   - operate: A running window operation that will be called with  (1) supplementary info, (2) previous item in collection, (3) current item in collection, and (4) the computed outcome being passed along.
    /// - Returns: The final supplementary info paired with the final computed outcome of running `operate` across the entire collection.    Collection must contain at least 2 elements, otherwise `seed` and `initialResult` are immediately returned.
    func scan<U, V>(basedOn seed: U, to initialResult: V, and operate: (U, Self.Element, Self.Element, V) throws -> (U, V)) rethrows -> (U, V) {
        guard count > 1,
            let first = first else {
            return (seed, initialResult)
        }
        
        let outcome = try reduce((seed, first, initialResult)) { window, next -> (U, Self.Element, V) in
            let newData = try operate(window.0, window.1, next, window.2)
            return (newData.0, next, newData.1)
        }
        return (outcome.0, outcome.2)
    }
    
}
