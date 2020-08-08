import Combine

// Does `CurrentValueSubject` behave exactly like `BahaviourSubject`?
// - fires update immediately?
let num = CurrentValueSubject<Int, Never>(1)
num.sink { value in
    print(value)
}

// Wrapped in `AnyPublisher` – intent conveyance is blurry
let mappedNum = AnyPublisher(num.map { $0 + 10 })
mappedNum.sink { value in
    print(value)
}

// Guessing this does nothing in way of access control
class SomeService {
    private(set) var words = CurrentValueSubject<String, Never>("hello")
}
let service = SomeService()
service.words.value = "world"
// yep

// +---------------------+
// | Stateful Observable |
// +---------------------+

extension StatefulObservable: Publisher {
    typealias Output = T
    typealias Failure = Never

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        source.receive(subscriber: subscriber)
    }
}

class StatefulObservable<T> {
    private let source: AnyPublisher<T, Never>

    init<U: Publisher>(_ source: U) where U.Output == T, U.Failure == Never {
        self.source = AnyPublisher(source)
    }

    var value: Output {
        guard let value = source.valueNow else {
            fatalError("immediately subscription did not yield a value, is the `source` a stateful publisher like `CurrentValueSubject`?")
        }
        return value
    }
}

class SomeOtherService {
    lazy var words: StatefulObservable<String> = { StatefulObservable(__words) }()
    private let __words = CurrentValueSubject<String, Never>("hello")
    func say(_ word: String) {
        __words.value = word
    }
}
let anotherService = SomeOtherService()
print(anotherService.words.value)
anotherService.words.sink { value in
    print(value)
}
anotherService.say("world")
print(anotherService.words.value)
