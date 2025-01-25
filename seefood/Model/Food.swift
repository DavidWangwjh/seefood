import Foundation

struct Ingredient: Codable {
    var title: String
    var caloriesPerGram: Double
    var totalGram: Double
    var totalCalories: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case caloriesPerGram = "calories_per_gram"
        case totalGram = "total_gram"
        case totalCalories = "total_calories"
    }
}

struct FoodAnalysisResult: Codable {
    var title: String
    var imageDescription: String
    var ingredients: [Ingredient]
    var totalCalories: Double
    var healthScore: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageDescription = "image_description"
        case ingredients
        case totalCalories = "total_calories"
        case healthScore = "health_score"
    }
}