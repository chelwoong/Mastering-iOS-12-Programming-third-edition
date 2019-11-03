protocol HerbivoreType {
  associatedtype Plant
  var plantsEaten: [Plant] { get set }
  mutating func eat(plant: Plant)
}

extension HerbivoreType {
  mutating func eat(plant: Plant) {
    plantsEaten.append(plant)
  }
}

protocol PlantType {
  var latinName: String { get }
}

struct Grass: PlantType{
  var latinName = "Poaceae"
}

struct Pine: PlantType{
  var latinName = "Pinus"
}



struct Cow<Plant: PlantType>: HerbivoreType {
    var plantsEaten = [Plant]()
}

let grassCow = Cow<Grass>()



func simpleMap<T,U>(_ input: [T], transofrom:(T)-> U) -> [U] {
    var output = [U]()
    
    for item in input {
        output.append(transofrom(item))
    }
    return output
}


let result = simpleMap([1,2,3]) { $0 * 2 }

print(result)
