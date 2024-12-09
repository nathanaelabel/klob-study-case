//
//  JobUsecase.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import Foundation

class JobUsecase: ObservableObject {
    private let BASE_URL = "https://test-server-klob.onrender.com/fakeJob/apple/academy"
    
    func getRecords() async throws -> [Job] {
        guard let url = URL(string: BASE_URL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for HTTP errors
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                throw URLError(.badServerResponse)
            }
            
            // Decode JSON response
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedResponse = try decoder.decode(JobList.self, from: data)
            return decodedResponse
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            throw error
        }
    }
}
