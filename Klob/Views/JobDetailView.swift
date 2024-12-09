//
//  JobDetailView.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import SwiftUI

// TODO: future plan, add detail view for each job.
struct JobDetailView: View {
    let job: Job

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(job.positionName)
                    .font(.largeTitle)
                    .bold()
                Text(job.corporateName)
                    .font(.title2)
                    .foregroundColor(.secondary)
                Text(job.status.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Divider()
                Text("Job Description")
                    .font(.headline)
                Text(job.cleanHTMLString())
                    .font(.body)
                
                if job.salaryFrom > 0 || job.salaryTo > 0 {
                    Divider()
                    Text("Salary Range")
                        .font(.headline)
                    Text("From \(job.formatCurrency(job.salaryFrom)) to \(job.formatCurrency(job.salaryTo))")
                        .font(.body)
                }
                
                Spacer()
                if let url = URL(string: "https://example.com/apply?jobCode=\(job.jobVacancyCode)") {
                    Link("Apply Now", destination: url)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
