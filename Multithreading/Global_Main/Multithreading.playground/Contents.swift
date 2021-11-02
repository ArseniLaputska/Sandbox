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
