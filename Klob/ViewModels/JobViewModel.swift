//
//  JobViewModel.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import SwiftUI

struct Job: Identifiable, Codable {
    var id: String { jobVacancyCode }
    let jobVacancyCode: String
    let positionName: String
    let corporateName: String
    let status: String
    let descriptions: String
    let corporateLogo: String
    let salaryFrom: Int
    let salaryTo: Int
    let postedDate: String?
}

class JobViewModel: ObservableObject {
    @Published var jobs: [Job] = []
    @Published var isLoading = false
    
    func fetchJobs() {
        guard let url = URL(string: "https://test-server-klob.onrender.com/fakeJob/apple/academy") else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data {
                    do {
                        let jobs = try JSONDecoder().decode([Job].self, from: data)
                        self.jobs = jobs
                    } catch {
                        print("Error decoding data: \(error)")
                    }
                } else if let error = error {
                    print("Error fetching jobs: \(error)")
                }
            }
        }.resume()
    }
}
