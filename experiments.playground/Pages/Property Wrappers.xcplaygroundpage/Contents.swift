import Foundation

//@propertyWrapper struct PII: CustomStringConvertible {
//    init(_ wrappedValue: String) {
//        self.wrappedValue = wrappedValue
//    }
//
//    var wrappedValue: String
//
//    var description: String {
//        return "[REDACTED]"
//    }
//}
//
//struct User {
//    @PII var uid: String
//    @PII var name: String
//    @PII var email: String
//}
//
//let user = User(
//    uid: "a1-b2-c3",
//    name: "swu",
//    email: "swu@swu.io"
//)


//@propertyWrapper struct NilResettable<T> {
//    private var value: T
//    private var defaultValue: T
//
//    init(_ defaultValue: T) {
//        self.value = defaultValue
//        self.defaultValue = defaultValue
//    }
//
//    var wrappedValue: T {
//        set {
//            if let optional = newValue as? Optional<T>,
//                optional == nil {
//                value = defaultValue
//            } else {
//                value = newValue
//            }
//        }
//        get {
//            return value
//        }
//    }
//
//    func asdf() {
//
//    }
//}
//
//struct Fields {
//    @NilResettable("") var name: String
//    @NilResettable("") var email: String
//    @NilResettable("") var phoneNumber: String
//}
//
//var fields = Fields()
//fields.name = "swu"
//fields.email = "swu@swu.io"
//fields.phoneNumber = "647-111-1111"
//
//
//
//@propertyWrapper class Resettable<T> {
//    private let provider: () -> T
//    private var object: T?
//
//    init(_ provider: @escaping () -> T) {
//        self.provider = provider
//    }
//
//    var wrappedValue: T {
//        if let object = object {
//            return object
//        } else {
//            let newObject = provider()
//            object = newObject
//            return newObject
//        }
//    }
//
//    func reset() {
//        object = nil
//    }
//}



import Combine
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true



enum DummyError: Error {
    case dummy
}

var bag = Set<AnyCancellable>()
let publish = PassthroughSubject<Int, DummyError>()


let a1 = Deferred {
    Future<Int, DummyError> { promise in
        print("---- firing 1")
        publish.sink(
            receiveCompletion: { outcome in
                    print("---- 1 fail")
                    if case .failure(let error) = outcome {
                        promise(.failure(error))
                    }
                }, receiveValue: { value in
                    print("---- 1 success")
                    promise(.success(value))
            }
        )
        .store(in: &bag)
    }
}
let a10 = Deferred {
    Future<Int, DummyError> { promise in
        print("---- firing 10")
        publish.map { $0 * 10 }.sink(
            receiveCompletion: { outcome in
                    print("---- 10 fail")
                    if case .failure(let error) = outcome {
                        promise(.failure(error))
                    }
                }, receiveValue: { value in
                    print("---- 10 success")
                    promise(.success(value))
            }
        )
        .store(in: &bag)
    }
}
let a100 = Deferred {
    Future<Int, DummyError> { promise in
        print("---- firing 100")
        publish.delay(for: 2, scheduler: RunLoop.main).map { $0 * 100 }.sink(
            receiveCompletion: { outcome in
                print("---- 100 fail")
                if case .failure(let error) = outcome {
                    promise(.failure(error))
                }
            }, receiveValue: { value in
                print("---- 100 success")
                promise(.success(value))
        }
        )
        .store(in: &bag)
    }
}

let tasks = [a1, a10, a100]

print("----- before when")

let when = Publishers
    .MergeMany(tasks)
    .collect(3)

let finalThing = when.sink(receiveCompletion: { outcome in
    print("----- outcome \(outcome)")
}, receiveValue: { value in
    print("----- value \(value)")
})

publish.send(1)
