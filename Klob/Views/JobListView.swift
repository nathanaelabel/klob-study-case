//
//  JobListView.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import SwiftUI

struct JobListView: View {
    var body: some View {
        TabView {
            JobListingsView()
                .tabItem {
                    Label("Lowongan Kerja", systemImage: "person.crop.circle")
                }
            
            SentApplicationsView()
                .tabItem {
                    Label("Lowongan Terkirim", systemImage: "paperplane")
                }
        }
    }
}

struct JobListingsView: View {
    @StateObject private var viewModel = JobViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Lowongan Pekerjaan")
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            if viewModel.jobs.isEmpty {
                Text("Loading...")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.jobs) { job in
                            JobCard(
                                title: job.positionName,
                                company: job.corporateName,
                                jobType: job.status.rawValue,
                                postedDaysAgo: job.postedDaysAgo,
                                companyLogoURL: job.corporateLogo,
                                salaryRange: job.salaryRange
                            )
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            Task {
                await viewModel.fetchJobs()
            }
        }
    }
}

struct SentApplicationsView: View {
    @State private var sentApplications: [Job] = []
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Lamaran Terkirim!")
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            if sentApplications.isEmpty {
                Text("Belum ada lowongan terkirim")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(sentApplications) { job in
                            JobCard(
                                title: job.positionName,
                                company: job.corporateName,
                                jobType: job.status.rawValue,
                                postedDaysAgo: job.postedDaysAgo,
                                companyLogoURL: job.corporateLogo,
                                salaryRange: job.salaryRange
                            )
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct JobCard: View {
    let title: String
    let company: String
    let jobType: String
    let postedDaysAgo: String
    let companyLogoURL: String
    let salaryRange: String?
    
    @State private var isApplied = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 8) {
                AsyncImage(url: URL(string: companyLogoURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 40, height: 40)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(company)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(jobType)
                            .font(.footnote)
                        Spacer()
                        if let salaryRange = salaryRange {
                            Text(salaryRange)
                                .font(.footnote)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#D9E7FF"))
                                .cornerRadius(4)
                        }
                    }
                    
                    HStack {
                        Text(postedDaysAgo)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Button(action: {
                            if !isApplied {
                                isApplied = true
                            }
                        }) {
                            Text(isApplied ? "LAMARAN TERKIRIM" : "LAMAR")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(isApplied ? Color(hex: "#CCCCCC") : Color(hex: "#273569"))
                                .cornerRadius(16)
                        }
                        .disabled(isApplied)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
