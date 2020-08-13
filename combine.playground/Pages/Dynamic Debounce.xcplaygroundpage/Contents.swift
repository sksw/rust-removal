import Foundation
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let source = PassthroughSubject<Int, Never>()
var time: RunLoop.SchedulerTimeType.Stride = .seconds(0.1)

let fireTest: (Int) -> Void = { value in
    source.send(value)
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
        source.send(value + 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            source.send(value + 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                source.send(value + 3)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    source.send(value + 4)
                }
            }
        }
    }
}

func staticTest() {
    print("---- static test")
    let ref = Date()
    let staticallyDebounced = source.debounce(for: time, scheduler: RunLoop.main)
    staticallyDebounced.sink {
        print("> static: \(Date().timeIntervalSince(ref)): \($0)")
    }
    fireTest(1)
}

func naiveDynamicTest() {
    print("---- naive dynamic test")
    let ref = Date()
    let naiveDynamicallyDebounced = source
        .flatMap { Just($0).debounce(for: time, scheduler: RunLoop.main) }
    naiveDynamicallyDebounced.sink {
        print("> dynamic-X: \(Date().timeIntervalSince(ref)): \($0)")
    }
    fireTest(11)
}

let dynamicallyDebounced = source
    .map { CurrentValueSubject<Int, Never>($0).debounce(for: time, scheduler: RunLoop.main) }
    .switchToLatest()
//dynamicallyDebounced.sink {
//    print("> dynamic-Y: \(Date().timeIntervalSince(ref)): \($0)")
//}

RunLoop.main.run(until: Date(timeInterval: 10, since: Date()))
staticTest()
