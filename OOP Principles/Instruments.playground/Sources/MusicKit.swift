final public class Music {
  public let notes: [String]
  
  public init(notes: [String]) {
    self.notes = notes
  }
  
  public func prepared() -> String {
    return notes.joined(separator: " ")
  }
}

// base class
open class Instrument {
  // property
  public let brand: String
  
  public init(brand: String) {
    self.brand = brand
  }
  
  // method
  open func tune() -> String {
    fatalError("Implement this method for \(brand)")
  }
  
  open func play(_ music: Music) -> String {
    return music.prepared()
  }
  
  final public func perform(_ music: Music) {
    print(tune())
    print(play(music))
  }
}
