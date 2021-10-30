//
//  ViewController.swift
//  Cycle
//
//  Created by Arseni Laputska on 30.10.21.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    runScenario()
  }
  
  func runScenario() {
    let user = User(name: "Brown")
    let iPhone = Phone(model: "XS")
    user.add(phone: iPhone)
    
    let subscription = CarrierSubscription(name: "TEL", countryCode: "032", number: "322233", user: user)
    iPhone.provision(carrierSubcription: subscription)
    print(subscription.completePhoneNumber())
    
    let greetingMaker: () -> String
    do {
      let mermaid = WWDCGreeting(who: "mermaid")
      greetingMaker = mermaid.greetingMaker
    }
    print(greetingMaker())
  }

}

class User {
  let name: String
  private(set) var phones: [Phone] = []
  var subcriptions: [CarrierSubscription] = []
  
  func add(phone: Phone) {
    phones.append(phone)
    phone.owner = self
  }
  
  init(name: String) {
    self.name = name
    print("User \(name) was initialized")
  }
  
  deinit {
    print("Deallocating user named: \(name)")
  }
}

class Phone {
  let model: String
  weak var owner: User?
  
  var carrierSubcription: CarrierSubscription?
  
  func provision(carrierSubcription: CarrierSubscription) {
    self.carrierSubcription = carrierSubcription
  }
  
  func decommission() {
    carrierSubcription = nil
  }
  
  init(model: String) {
    self.model = model
    print("Phone \(model) was initialized")
  }
  
  deinit {
    print("Deallocating phone named: \(model)")
  }
}

class CarrierSubscription {
  let name: String
  let countryCode: String
  let number: String
  unowned let user: User
  
  lazy var completePhoneNumber: () -> String = { [unowned self] in
    self.countryCode + " " + self.number
  }
  
  init(name: String, countryCode: String, number: String, user: User) {
    self.name = name
    self.countryCode = countryCode
    self.number = number
    self.user = user
    
    user.subcriptions.append(self)
    
    print("CarrierSubscription \(name) is initialized")
  }
  
  deinit {
    print("Deallocating Carrier named: \(name)")
  }
}

class WWDCGreeting {
  let who: String
  
  init(who: String) {
    self.who = who
  }
  
  lazy var greetingMaker: () -> String = { [weak self] in
    guard let self = self else {
      return "No greeting available."
    }
    return "Hello \(self.who)"
  }
}
