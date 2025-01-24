import SwiftUI

struct HomeView: View {
    @State private var isCameraPresented = false
    @State private var isPhotoLibraryPresented = false
    @State private var selectedImage: UIImage?
    @State private var analysisResult: FoodAnalysisResult?
    @State private var showAnalysisSheet = false
    @State private var isAnalyzing = false
    @State private var calendarItems: [Date: FoodAnalysisResult] = [:]
    @State private var selectedDate: Date = Date()

    var body: some View {
        NavigationView {
            VStack {
                Text("Seefood")
                    .font(.largeTitle)
                    .padding()

                // Calendar View
                CalendarView(calendarItems: $calendarItems, selectedDate: $selectedDate)
                    .frame(height: 300)
                    .padding()

                HStack {
                    Button(action: {
                        isCameraPresented = true
                    }) {
                        Image(systemName: "camera")
                            .resizable()
                            .frame(width: 60, height: 50)
                    }
                    .padding()

                    Button(action: {
                        isPhotoLibraryPresented = true
                    }) {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .frame(width: 60, height: 50)
                    }
                    .padding()
                }
            }
            .fullScreenCover(isPresented: $isCameraPresented) {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear {
                        if selectedImage != nil {
                            showAnalysisSheet = true
                        }
                    }
            }
            .fullScreenCover(isPresented: $isPhotoLibraryPresented) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
                    .edgesIgnoringSafeArea(.all)
                    .onDisappear {
                        if selectedImage != nil {
                            showAnalysisSheet = true
                        }
                    }
            }
            .sheet(isPresented: $showAnalysisSheet) {
                if let image = selectedImage {
                    VStack {
                        HStack {
                            Button("Cancel") {
                                showAnalysisSheet = false
                                selectedImage = nil
                                analysisResult = nil
                            }
                            .padding()
                            Spacer()
                            if analysisResult != nil {
                                Button("Add") {
                                    if let result = analysisResult {
                                        calendarItems[selectedDate] = result
                                        showAnalysisSheet = false
                                    }
                                }
                                .padding()
                            }
                        }
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        
                        if isAnalyzing {
                            Text("Analyzing Image...")
                                .padding()
                        } else {
                            Button("Analyze") {
                                isAnalyzing = true
                                if let image = selectedImage {
                                    AIAnalysisService.analyzeFood(image: image) { result in
                                        DispatchQueue.main.async {
                                            isAnalyzing = false
                                            switch result {
                                            case .success(let analysis):
                                                analysisResult = analysis
                                            case .failure(let error):
                                                print("Analysis error: \(error)")
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        
                        if let result = analysisResult {
                            AnalysisResultView(result: result)
                        }
                    }
                }
            }
        }
    }
}

struct AnalysisResultView: View {
    let result: FoodAnalysisResult

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Title: \(result.title)")
                    .font(.headline)
                Text("Description: \(result.imageDescription)")
                Text("Total Calories: \(result.totalCalories)")
                Text("Health Score: \(result.healthScore)")
                Text("Ingredients:")
                ForEach(result.ingredients, id: \.title) { ingredient in
                    Text("- \(ingredient.title): \(ingredient.totalCalories) calories")
                }
            }
            .padding()
        }
    }
} 