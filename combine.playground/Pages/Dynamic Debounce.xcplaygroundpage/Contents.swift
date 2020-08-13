import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let source = PassthroughSubject<Int, Never>()
var debounceTime: RunLoop.SchedulerTimeType.Stride = .seconds(0.1)

let fireTest: (Int) -> Void = { value in
    source.send(value)
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
        source.send(value + 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            source.send(value + 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                source.send(value + 3)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                    source.send(value + 4)
                }
            }
        }
    }
}

func staticTest() -> AnyCancellable {
    print("---- static test")
    let ref = Date()
    let staticallyDebounced = source.debounce(for: debounceTime, scheduler: RunLoop.main)
    return staticallyDebounced.sink {
        print("> static: \(Date().timeIntervalSince(ref)): \($0)")
    }
}

func naiveDynamicTest() -> AnyCancellable {
    print("---- naive dynamic test")
    let ref = Date()
    let naiveDynamicallyDebounced = source
        .flatMap { Just($0).debounce(for: debounceTime, scheduler: RunLoop.main) }
    return naiveDynamicallyDebounced.sink {
        print("> naive dynamic: \(Date().timeIntervalSince(ref)): \($0)")
    }
}

func dynamicTest() -> AnyCancellable {
    print("---- dynamic test")
    let ref = Date()
    let dynamicallyDebounced = source
        .map { CurrentValueSubject<Int, Never>($0).debounce(for: debounceTime, scheduler: RunLoop.main) }
        .switchToLatest()
    return dynamicallyDebounced.sink {
        print("> dynamic: \(Date().timeIntervalSince(ref)): \($0)")
    }
}

RunLoop.main.run(until: Date(timeInterval: 10, since: Date()))
//let sub = staticTest()
//fireTest(1)
// ---- static test
// > static: 0.16721796989440918: 2
// > static: 0.276278018951416: 3
// > static: 0.546502947807312: 5

//let sub = naiveDynamicTest()
//fireTest(1)
// ---- naive dynamic test
// ^ `Just` finishes right away, so debounce never get triggered, we need a `Never` version

//let sub = dynamicTest()
//DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
//    debounceTime = .seconds(0.5)
//}
//fireTest(1)
// ---- dynamic test
// > dynamic-Y: 0.1816030740737915: 2
// > dynamic-Y: 0.9858440160751343: 5

// +---------------------------------+
// | Lets put this into an extension |
// +---------------------------------+

extension Publisher {
    func dynamicDebounce<S: Scheduler>(
        for dueTimeProvider: @escaping () -> S.SchedulerTimeType.Stride,
        schedler: S,
        options: S.SchedulerOptions? = nil
    ) -> some Publisher {
        return map { value in
            CurrentValueSubject(value).debounce(
                for: dueTimeProvider(),
                scheduler: schedler,
                options: options
            )
        }
        .switchToLatest()
    }
}

print("---- final test")
let ref = Date()
let sub = source
    .dynamicDebounce(for: { debounceTime }, schedler: RunLoop.main)
    .sink(receiveCompletion: { _ in }) {
        print("> dynamic-Y: \(Date().timeIntervalSince(ref)): \($0)")
}
DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
    debounceTime = .seconds(0.5)
}
fireTest(1)
