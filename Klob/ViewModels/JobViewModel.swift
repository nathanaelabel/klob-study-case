//
//  JobViewModel.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import Foundation

@MainActor
class JobListViewModel: ObservableObject {
    @Published var jobs: [Job] = []
    @Published var sentApplications: [Job] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let usecase = JobUsecase()

    func fetchJobs() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedJobs = try await usecase.getRecords()
            jobs = fetchedJobs
        } catch {
            errorMessage = "Failed to load jobs: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func applyForJob(_ job: Job) {
        if !sentApplications.contains(where: { $0.id == job.id }) {
            sentApplications.append(job)
        }
    }
}
