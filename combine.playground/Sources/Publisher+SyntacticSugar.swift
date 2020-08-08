import Combine

public extension Publisher {
    var valueNow: Self.Output? {
        var result: Self.Output?
        let sub = sink(
            receiveCompletion: { _ in },
            receiveValue: { result = $0 }
        )
        sub.cancel()
        return result
    }
    var errorNow: Self.Failure? {
        var result: Self.Failure?
        let sub = sink(
            receiveCompletion: { outcome in
                switch outcome {
                case .failure(let error): result = error
                case .finished: break
                } },
            receiveValue: { _ in }
        )
        sub.cancel()
        return result
    }
}
