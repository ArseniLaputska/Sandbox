import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

image.backgroundColor = UIColor.gray
image.contentMode = .scaleAspectFill
view.addSubview(image)

PlaygroundPage.current.liveView = view

func fetchImage() {
  let imageURL: URL = URL(string: "https://cdn.f1ne.ws/userfiles/williams/156578.jpg")!
  let queue = DispatchQueue.global(qos: .utility)
  queue.async {
    if let data = try? Data(contentsOf: imageURL) {
      DispatchQueue.main.async {
        image.image = UIImage(data: data)
        print("Show image data")
      }
      print("Did download image")
    }
  }
}

fetchImage()

func task1() {
  print("task1")
}
func task2() {
  print("task2")
}
func task3() {
  print("task3")
}
func task4() {
  print("task4")
}
func task5() {
  print("task5")
}
func task6() {
  print("task6")
}
func task7() {
  print("task7")
}
func task8() {
  print("task8")
}

// Task
let serialQueue = DispatchQueue(label: "ru.arseni.serial-queue")
let concurrentQueue = DispatchQueue(label: "ru.arseni.concurrent-queue", attributes: .concurrent)

concurrentQueue.async {
    task1()
    
    serialQueue.async(execute: task2)
}

concurrentQueue.sync {
    serialQueue.sync(execute: task3)
    
    serialQueue.sync(execute: task4)
    
    serialQueue.async(execute: task5)
}

task6()

serialQueue.async {
    concurrentQueue.sync(execute: task7)
}

task8()
