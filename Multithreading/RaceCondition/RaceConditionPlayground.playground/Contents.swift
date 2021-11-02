import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// ## Using Global Queues
// 1. Global serial maim queue
let mainQueue = DispatchQueue.main
// 2. Global concurrent dispatch queues
let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
let userInitQueue = DispatchQueue.global(qos: .userInitiated)
let utilityQueue = DispatchQueue.global(qos: .utility)
let backgroundQueue = DispatchQueue.global(qos: .background)
// Global concurrent .default dispatch queue
let defaultQueue = DispatchQueue.global()

// ## Challenges:

func task(_ symbol: String) { for i in 1...10 {
  print("\(symbol) \(i) priority = \(qos_class_self().rawValue)")
}}

func taskHigh(_ symbol: String) {
  print("\(symbol) HIGH priority = \(qos_class_self().rawValue)")
}

// ## Async and sync
print("------------")
print(" SYNC ")
print(" Global .concurrent q1 - .userInitiated ")
print("------------")
userInitQueue.sync {
  task("😀")
}
task("👿")
sleep(2)

print("------------")
print(" ASYNC ")
print(" Global .concurrent q1 - .userInitiated ")
print("------------")
userInitQueue.async {
  task("😀")
}
task("👿")
// ## Private serial Queue
// ### Serial queue
let mySerialQueue = DispatchQueue(label: "com.arseni.mySerial")
print("------------")
print(" SYNC ")
print(" Private .serial q1 - no ")
print("------------")
mySerialQueue.sync {
  task("😀")
}
task("👿")

print("------------")
print(" ASYNC ")
print(" Private .serial q1 - no ")
print("------------")
mySerialQueue.async {
  task("😀")
}
task("👿")

// Serial queue with priority
print("------------")
print(" Private .serial q1 - userInititated ")
print("------------")
let serialPriorityQueue = DispatchQueue(label: "com.arseni.serialPriority", qos: .userInitiated)
serialPriorityQueue.async {
  task("😀")
}
serialPriorityQueue.async {
  task("👿")
}
sleep(1)

// Serial queues with varios priority
print("------------")
print(" Private .serial q1 - userInititated ")
print("                 q2 - background ")
print("------------")
let serialPriorityQueue1 = DispatchQueue(label: "com.arseni.serialPriority", qos: .userInitiated)
let serialPriorityQueue2 = DispatchQueue(label: "com.arseni.serialPriority", qos: .background)
serialPriorityQueue1.async {
  task("😀")
}
serialPriorityQueue2.async {
  task("👿")
}

// asyncAfter with changing priority
print("------------")
print(" asyncAfter (.userInteractiv) on q2 ")
print(" Private .serial q1 - utility ")
print("                 q2 - background ")
print("------------")
let serialUtilityQueue = DispatchQueue(label: "com.arseni.serialUtility", qos: .utility)
let serialBackgroundQueue = DispatchQueue(label: "com.arseni.serialBackground", qos: .background)
serialBackgroundQueue.asyncAfter(deadline: .now() + 0.1, qos: .userInteractive) {
  task("👿")
}
serialUtilityQueue.async {
  task("😀")
}
sleep(1)

// highPriorityItem = DispatchWorkItem
let highPriorityItem = DispatchWorkItem(qos: .userInteractive, flags: [.enforceQoS]) {
  taskHigh("🌺")
}

// Private concurrent queue with priority
print("------------")
print(" Private .concurrent q - .userInititated ")
print("------------")
let workerQueue = DispatchQueue(label: "com.arseni.workerConcurrent", qos: .userInitiated, attributes: .concurrent)
workerQueue.async {
  task("😀")
}
workerQueue.async {
  task("👿")
}
sleep(2)

// Concurrent queue with delay start
print("------------")
print(" Private .concurrent q - .userInititated, .initiallyInactive ")
print("------------")
let workerDelayQueue = DispatchQueue(label: "com.arseni.workerConcurrent", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
workerDelayQueue.async {
  task("😀")
}
workerDelayQueue.async {
  task("👿")
}

// Concurrent queues with varios priority
print("------------")
print(" .concurrent q1 - .userInitiated ")
print("             q2 - .background ")
print("------------")
let workerQueue1 = DispatchQueue(label: "com.arseni.workerConcurrent1", qos: .userInitiated, attributes: .concurrent)
let workerQueue2 = DispatchQueue(label: "com.arseni.workerConcurrent1", qos: .background, attributes: .concurrent)
workerQueue2.async {
  task("😀")
}
workerQueue1.async {
  task("👿")
}
sleep(1)

// Activate concurrent tasks with delay
workerDelayQueue.activate()
sleep(1)

//: ###   asyncAfter with changing priority
print("---------------------------------------------------")
print("   asynAfter (.userInteractive) на Q2")
print("   Private .concurrent Q1 - .userInitiated")
print("                       Q2 - .background")
print("---------------------------------------------------")

workerQueue2.asyncAfter(deadline: .now() + 0.1, qos: .userInteractive) {
  task("👿")
}
workerQueue1.async {
  task("😀")
}
workerQueue2.async(execute: highPriorityItem)
workerQueue1.async(execute: highPriorityItem)
sleep(1)

// Sync change between queues
print(" --- Imitation of race condition --- ")

var value = "✈️"
func changeValue(variant: Int) {
  sleep(1)
  value = value + "😀";
  print("\(value) - \(variant)")
}
// Starting 'changeValue()' ASYNC and show 'value' on current thread
mySerialQueue.async {
  changeValue(variant: 1)
}
value
// Block current thread
value = "🛩"
mySerialQueue.sync {
  changeValue(variant: 2)
}
value
sleep(3)
// Starting 'changeValue()' SYNC and show 'value' on current thread
print(" --- Killing race condition with help SYNC ---")
value = "✈️"
mySerialQueue.sync {
  changeValue(variant: 1)
}
value
// Rechange 'value'
value = "🛩"
mySerialQueue.sync {
  changeValue(variant: 2)
}
value
sleep(2)

mainQueue.async {
    let a = 0
    print("main queue: a = \(a)")
}
print("Running on default queue")

defaultQueue.async {
    let a = 42
    print("default queue: a = \(a)")
}

sleep(2)
