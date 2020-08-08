import Combine

extension Publisher {
    func dematerialize() -> AnyPublisher<Result<Output, Failure>, Never> {
        map { Result.success($0) }
            .catch { Just(Result.failure($0)) }
            .eraseToAnyPublisher()
    }
}

enum NoodleError: Error {
    case notEnoughSoup
}
enum Noodles {
    case ramen
    case pasta
}

var vendor1 = PassthroughSubject<Noodles, NoodleError>()
var vendor2 = PassthroughSubject<Noodles, NoodleError>()
//let type = vendor1.dematerialize()

Publishers.Merge(
    vendor1.dematerialize(),
    vendor2.dematerialize()
).sink { print($0) }

vendor1.send(.ramen)
vendor2.send(.ramen)
vendor1.send(completion: .failure(.notEnoughSoup))
vendor2.send(.pasta)
vendor2.send(completion: .failure(.notEnoughSoup))

// Is there a nicer way of doing this without type erasure?

extension Publisher {
    func dematerialize2() -> some Publisher {
        map { Result.success($0) }
            .catch { Just(Result.failure($0)) }
    }
}

print("-----")
vendor1 = PassthroughSubject<Noodles, NoodleError>()
vendor2 = PassthroughSubject<Noodles, NoodleError>()
//let type = vendor1.dematerialize2()

Publishers.Merge(
    vendor1.dematerialize2(),
    vendor2.dematerialize2()
).sink(
    receiveCompletion: { print("2f: \($0)") },
    receiveValue: { print("2v: \($0)") }
)

vendor1.send(.ramen)
vendor2.send(.ramen)
vendor1.send(completion: .failure(.notEnoughSoup))
vendor2.send(.pasta)
vendor2.send(completion: .failure(.notEnoughSoup))

// [1] requires `receiveCompletion` because not explicitly `Never`
// [2] `let type = vendor1.dematerialize2()` offers no type info

// Another way?

let typeConstruction = vendor1
    .map { Result.success($0) }
    .catch { Just(Result.failure($0)) }
// Publishers.Catch<
// Publishers.Map<PassthroughSubject<Noodles, NoodleError>, Result<Noodles, NoodleError>>,
// Just<Result<Noodles, NoodleError>>
// >

extension Publishers {
    struct Dematerialize<Upstream>: Publisher where Upstream: Publisher {
        typealias Output = Result<Upstream.Output, Upstream.Failure>
        typealias Failure = Never

        // very hard to type this up, use above `typeConstruction` to,
        // [1] grab chain
        // [2] replace with `Upstream` generic contraints
        let pipe: Publishers.Catch<
        Publishers.Map<Upstream, Result<Upstream.Output, Upstream.Failure>>,
        Just<Result<Upstream.Output, Upstream.Failure>>
        >

        init(upstream: Upstream) {
            self.pipe = upstream
                .map { Result.success($0) }
                .catch { Just(Result.failure($0)) }
        }

        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            pipe.receive(subscriber: subscriber)
        }
    }
}

extension Publisher {
    func dematerialize3() -> Publishers.Dematerialize<Self> {
        return Publishers.Dematerialize(upstream: self)
    }
}

print("-----")
vendor1 = PassthroughSubject<Noodles, NoodleError>()
vendor2 = PassthroughSubject<Noodles, NoodleError>()
//let type = vendor1.dematerialize3()

Publishers.Merge(
    vendor1.dematerialize3(),
    vendor2.dematerialize3()
).sink(
    receiveCompletion: { print("3f: \($0)") },
    receiveValue: { print("3v: \($0)") }
)

vendor1.send(.ramen)
vendor2.send(.ramen)
vendor1.send(completion: .failure(.notEnoughSoup))
vendor2.send(.pasta)
vendor2.send(completion: .failure(.notEnoughSoup))
