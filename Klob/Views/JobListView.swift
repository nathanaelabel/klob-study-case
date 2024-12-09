//
//  JobListView.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import SwiftUI

struct JobListView: View {
    @StateObject private var viewModel = JobViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    List(viewModel.jobs) { job in
                        NavigationLink(destination: JobDetailView(job: job)) {
                            JobCardView(job: job)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchJobs()
            }
            .navigationTitle("Lowongan Pekerjaan")
        }
    }
}

struct JobCardView: View {
    let job: Job
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: job.corporateLogo)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text(job.positionName)
                    .font(.headline)
                Text(job.corporateName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(job.status)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
}
