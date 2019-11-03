

protocol Bird {}
protocol FlyingType {}
protocol HerbivoreType {
  var favoritePlant: String { get }
}

protocol CarnivoreType {
  var favoriteMeat: String { get }
}

protocol OmnivoreType: CarnivoreType, HerbivoreType {}

protocol Domesticatable {
    var homeAddress: String? { get }
    var hasHomeAddress: Bool { get }
    func printHomeAddress()
}

extension Domesticatable {
    
    var hasHomeAddress: Bool  {
        return homeAddress != nil
    }
    func printHomeAddress() {
      if let address = homeAddress {
        print(address)
      }
    }
}



struct Pigeon: Bird, FlyingType, OmnivoreType, Domesticatable  {
    var favoriteMeat: String
    var favoritePlant: String
    var homeAddress: String?
    
    func printHomeAddress() {
      if let address = homeAddress {
        print("address: \(address.uppercased())")
      }
    }
}


func printFavoriteMeat(forAnimal animal: CarnivoreType) {
  print(animal.favoriteMeat)
}

func printFavoritePlant(forAnimal animal: HerbivoreType) {
  print(animal.favoritePlant)
}


func printHomeAddress(animal: Domesticatable) {
  if let address = animal.homeAddress {
    print(address)
  }
}


let pigeon = Pigeon(favoriteMeat: "Chicken", favoritePlant: "Seeds", homeAddress: "Amsterdam, Leidse Plein 12")


printFavoriteMeat(forAnimal: pigeon)
printFavoritePlant(forAnimal: pigeon)
printHomeAddress(animal: pigeon)


pigeon.printHomeAddress()
