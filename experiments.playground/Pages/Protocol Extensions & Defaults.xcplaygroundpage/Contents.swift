import Foundation

protocol Movable {
    var speed: Int { get }
}

// +------------------------+
// | default implementation |
// +------------------------+

extension Movable {
    var speed: Int {
        return 2
    }
}

struct Bike: Movable { }
struct Car: Movable {
    let speed = 4
}

let bike = Bike()
let car = Car()
print(bike.speed)
print(car.speed) // expecting 4

let vehicle1 = bike as Movable
let vehicle2 = car as Movable
print(vehicle1.speed)
print(vehicle2.speed) // expecting 2

// +----------------------+
// | protocol inheritance |
// +----------------------+
print("-----")

protocol Rollable: Movable { }
extension Rollable {
    var speed: Int {
        return 10
    }
}

struct Train: Rollable {
    let speed = 9
}

let train = Train()
print(train.speed) // expecting 9
let movingTrain = train as Movable
print(movingTrain.speed) // ? <---- 10
let rollingTrain = train as Rollable
print(rollingTrain.speed) // expecting 10

// +------------------------------------+
// | overriding non-protocol extensions |
// +------------------------------------+
print("-----")

enum Swiftness {
    case slow
    case normal
    case fast
}

extension Rollable {
    var swiftNess: Swiftness {
        return .normal
    }
}

struct LongBoard: Rollable {
    let swiftNess = Swiftness.fast
}

let longboard = LongBoard()
print(train.swiftNess) // expecting .normal
print(longboard.swiftNess) // expecting .fast
let movingLongboard = longboard as Rollable
print(movingLongboard.swiftNess) // expecting .normal

// +-----------------------------------+
// | throw in some generic constraints |
// +-----------------------------------+
print("-----")

protocol SpeedDetecting { }
extension SpeedDetecting where Self: Movable {
    func check() -> Int {
        return speed
    }
}

extension Bike: SpeedDetecting { }
extension Car: SpeedDetecting { }
extension Train: SpeedDetecting { }
extension LongBoard: SpeedDetecting { }

print(bike.check()) // expecting 2
print(car.check()) // expecting 4
print(train.check()) // expecting 9
print(longboard.check()) // expecting 10

// +---------------------------------+
// | throw in some class inheritance |
// +---------------------------------+
print("-----")

class A: Movable, SpeedDetecting { }
class B: A, Rollable { }

print(A().speed) // expecting 2
print(B().speed) // expecting 10

print(A().check()) // expecting 2
print(B().check())  // expecting 10? <---- 2!  why?  because witness table of parent used?

struct Drone: Movable, Rollable, SpeedDetecting { }
print(Drone().check()) // 2? or 10? <---- 10
