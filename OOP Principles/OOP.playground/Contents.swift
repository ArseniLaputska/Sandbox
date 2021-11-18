import UIKit

// declared a class
class Person {
  // personal attributes and abilities can be defined here
  var age: Int
  var gender: String
  
  //calling an initializer method
  init(age: Int, gender: String) {
    self.age = age
    self.gender = gender
  }
  
  // method
  func play(sport: String) {
    // how we will make our person play
  }
  
  // method overloading (same name bu different parameters)
  func play(instrument: String) {
  }
}

//created an object of the class
let man = Person(age: 25, gender: "male")


// Encapsulation = Инкапсуляция
// 1. declared a Math class which does some math. calculations
class Math {
  
  //declared 2 vars for input
  let a: Int!
  let b: Int!
  private var result: Int?
  
  // init our variables
  init(a: Int, b: Int) {
    self.a = a
    self.b = b
  }
  
  //declared a method to add 2 vars
  func add() {
    result = a + b
  }
  
  // display method
  func displayResult() {
    print("Resul \(result)")
  }
}

let calculation = Math(a: 2, b: 3)
calculation.add()
calculation.displayResult()

// In the above example, we encapsulated the variable “result” by using the access specifier “private”. We hide the data of variable “result” from any outside intervention and usage.

// Abstraction = Абстракция
  // In our example in encapsulation, we are exposing displayTotal() and add() method to the user to perform the calculations, but hiding the internal calculations.

// Inheritance = Наследие

// declared a child class
class Men: Person {
  
  // overriding method (same name, parameters but one of this method at defining parent class)
  override func play(sport: String) {
    print("Men playing")
  }
}

// since child inherits parent class, it can also access its properties
let andy = Men(age: 20, gender: "M")
print(andy.age)

// Polymorphism = Полиморфизм
class Player {
  let name: String
  
  init(name: String) {
    self.name = name
  }
  
  func play() {
    
  }
}

class Batsman: Player {
  override func play() {
    bat()
  }
  private func bat() {
    print("\(name) is batting")
  }
}

class Bowler: Player {
  override func play() {
    bowl()
  }
  
  private func bowl() {
    print("\(name) is bowling")
  }
}

class CricketTeam {
  let name: String
  let team: [Player]
  
  init(name: String, team: [Player]) {
    self.name = name
    self.team = team
  }
  
  func play() {
    team.forEach {
      $0.play()
    }
  }
}

let john = Batsman(name: "John")
let dale = Bowler(name: "Dale")

let USATeam = CricketTeam(name: "USA", team: [john, dale])
USATeam.play()
