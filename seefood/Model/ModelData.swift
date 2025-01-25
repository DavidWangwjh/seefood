import Foundation

@Observable
class ModelData {
    // Current analysis result
    var foodAnalysisResult: FoodAnalysisResult?
    
    // Calendar data
    var calendarItems: [Date: FoodAnalysisResult] = [:]
    var selectedDate: Date = Date()
    
    // Sample data for previews
    static func preview() -> ModelData {
        let model = ModelData()
        
        // Create sample dates
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: DateComponents(day: -1), to: today) ?? today
        let tomorrow = calendar.date(byAdding: DateComponents(day: 1), to: today) ?? today
        
        // Create sample food items
        let burger = FoodAnalysisResult(
            title: "Cheeseburger",
            imageDescription: "A delicious-looking cheeseburger with sesame seed bun and fresh vegetables",
            ingredients: [
                Ingredient(title: "Sesame seed bun", caloriesPerGram: 2.5, totalGram: 60, totalCalories: 150),
                Ingredient(title: "Beef patty", caloriesPerGram: 2.5, totalGram: 100, totalCalories: 250),
                Ingredient(title: "Cheddar cheese", caloriesPerGram: 4.0, totalGram: 30, totalCalories: 120)
            ],
            totalCalories: 520,
            healthScore: 5
        )
        
        let salad = FoodAnalysisResult(
            title: "Caesar Salad",
            imageDescription: "Fresh caesar salad with romaine lettuce, croutons, and parmesan",
            ingredients: [
                Ingredient(title: "Romaine lettuce", caloriesPerGram: 0.15, totalGram: 100, totalCalories: 15),
                Ingredient(title: "Croutons", caloriesPerGram: 4.0, totalGram: 20, totalCalories: 80),
                Ingredient(title: "Parmesan cheese", caloriesPerGram: 4.3, totalGram: 10, totalCalories: 43)
            ],
            totalCalories: 138,
            healthScore: 8
        )
        
        let pizza = FoodAnalysisResult(
            title: "Pepperoni Pizza",
            imageDescription: "Classic pepperoni pizza with melted cheese and tomato sauce",
            ingredients: [
                Ingredient(title: "Pizza dough", caloriesPerGram: 2.7, totalGram: 120, totalCalories: 324),
                Ingredient(title: "Mozzarella", caloriesPerGram: 2.8, totalGram: 60, totalCalories: 168),
                Ingredient(title: "Pepperoni", caloriesPerGram: 5.5, totalGram: 30, totalCalories: 165)
            ],
            totalCalories: 657,
            healthScore: 4
        )
        
        // Add items to calendar
        model.calendarItems[today] = pizza
        model.calendarItems[yesterday] = salad
        model.calendarItems[tomorrow] = burger
        
        return model
    }
}