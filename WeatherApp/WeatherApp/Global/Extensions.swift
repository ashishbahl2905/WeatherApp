//
//  Extensions.swift
//  WeatherApp
//
//  Created by Ashish Bahl on 28/07/25.
//

import UIKit

// MARK: Extensions
extension UIImageView {
    func loadImage(from urlString: String) async throws {
        guard let url = URL(string: urlString) else { return }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            } catch {
                print("Image loading error: \(error)")
            }
        }
    }
}
