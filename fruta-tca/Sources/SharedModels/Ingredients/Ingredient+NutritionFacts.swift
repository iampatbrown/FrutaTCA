extension Ingredient {
  public var nutritionFact: NutritionFact? {
    NutritionFact.lookupFoodItem(id, forVolume: .cups(1))
  }
}
