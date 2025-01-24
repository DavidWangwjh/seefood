//
//  ContentView.swift
//  seefood
//
//  Created by David Wang on 1/23/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var analysisResult: FoodAnalysisResult?
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("No Image Selected")
                    .foregroundColor(.gray)
            }

            if let result = analysisResult {
                Text("Food: \(result.title)")
                Text("Calories: \(result.totalCalories)")
                // Display more details as needed
            } else if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }

            HStack {
                Button(action: {
                    // Rule: Add debug log for button action
                    print("Camera button tapped")
                    sourceType = .camera
                    isImagePickerPresented = true
                }) {
                    Text("Capture Image")
                }
                .padding()

                Button(action: {
                    // Rule: Add debug log for button action
                    print("Photo Library button tapped")
                    sourceType = .photoLibrary
                    isImagePickerPresented = true
                }) {
                    Text("Select from Library")
                }
                .padding()
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
                .onDisappear {
                    if let image = selectedImage {
                        // Trigger AI analysis after image selection
                        AIAnalysisService.analyzeFood(image: image) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let analysis):
                                    print("Analysis result: \(analysis)")
                                    analysisResult = analysis
                                case .failure(let error):
                                    print("Analysis error: \(error)")
                                    errorMessage = error.localizedDescription
                                }
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
