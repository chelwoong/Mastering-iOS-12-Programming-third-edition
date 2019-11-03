protocol HerbivoreType {
  // 1
  associatedtype Plant: PlantType
  var plantsEaten: [Plant] { get set }
  mutating func eat(plant: Plant)
}

extension HerbivoreType {
  mutating func eat(plant: Plant) {
    // 2
    print("eating a (plant.latinName)")
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

struct Cow: HerbivoreType {
   var plantsEaten = [Grass]()
}

struct Carrot: PlantType {
    let latinName = "Daucus carota"
}

struct Rabbit: HerbivoreType {
    var plantsEaten = [Carrot]()
}

var cow = Cow()
let pine = Pine()

