//
//  JobDetailView.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import SwiftUI

struct JobDetailView: View {
    let job: Job
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Job Title
                Text(job.positionName)
                    .font(.largeTitle)
                    .bold()
                
                // Company Name
                Text(job.corporateName)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                // Job Status
                Text(job.status.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Job Description
                Divider()
                Text("Job Description")
                    .font(.headline)
                Text(cleanHTMLString(job.descriptions))
                    .font(.body)
                
                // Salary Information
                if job.salaryFrom > 0 || job.salaryTo > 0 {
                    Divider()
                    Text("Salary Range")
                        .font(.headline)
                    Text("From \(formatCurrency(job.salaryFrom)) to \(formatCurrency(job.salaryTo))")
                        .font(.body)
                }
                
                // Apply Button
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
    
    // Helper Functions
    func cleanHTMLString(_ html: String) -> String {
        guard let data = html.data(using: .utf8) else { return html }
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) {
            return attributedString.string
        }
        return html
    }
    
    func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "IDR "
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}
