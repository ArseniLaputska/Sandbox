import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
var imageF = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
imageF.backgroundColor = .gray
imageF.contentMode = .scaleAspectFit
view.addSubview(imageF)

PlaygroundPage.current.liveView = view

let imageURL: URL = URL(string: "https://cdn.f1ne.ws/userfiles/williams/156578.jpg")!

// ### Loading with 'classic' method
func fetchImage() {
  let queue = DispatchQueue.global(qos: .utility)
  queue.async {
    if let data = try? Data(contentsOf: imageURL) {
      DispatchQueue.main.async {
        imageF.image = UIImage(data: data)
      }
    }
  }
}

// ### Loading with URLSession
func fetchImage1() {
  let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
    if let imageData = data {
      DispatchQueue.main.async {
        print("Show image data")
        imageF.image = UIImage(data: imageData)
      }
      print("Did download image data")
    }
  }
  task.resume()
}

// ### Loading with DispatchWorkItem
func fetchImage2() {
  var data: Data?
  let queue = DispatchQueue.global(qos: .utility)
  let workItem = DispatchWorkItem(qos: .userInteractive) {data = try? Data(contentsOf: imageURL)}
  queue.async(execute: workItem)
  workItem.notify(queue: DispatchQueue.main) {
    if let imageData = data {
      imageF.image = UIImage(data: imageData)
    }
  }
}

// ### Async on sync operation
func asyncLoadImage(imageURL: URL, runQueue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (UIImage?, Error?) -> ()) {
  runQueue.async {
    do {
      let data = try Data(contentsOf: imageURL)
      completionQueue.async {
        completion(UIImage(data: data), nil)
      }
    } catch let error {
      completionQueue.async {
        completion(nil, error)
      }
    }
  }
}

func fetchImage3() {
  asyncLoadImage(imageURL: imageURL, runQueue: DispatchQueue.global(), completionQueue: DispatchQueue.main) { result, error in
    guard let image = result else {return}
    imageF.image = image
  }
}

fetchImage1()
fetchImage2()
fetchImage3()
