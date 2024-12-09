//
//  JobListView.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import SwiftUI

struct JobListView: View {
    @StateObject private var viewModel = JobListViewModel()
    
    var body: some View {
        TabView {
            JobListingsView(viewModel: viewModel)
                .tabItem {
                    Label("Lowongan Kerja", systemImage: "briefcase")
                }
            
            SentApplicationsView(viewModel: viewModel)
                .tabItem {
                    Label("Lowongan Terkirim", systemImage: "paperplane")
                }
        }
    }
}

struct JobListingsView: View {
    @ObservedObject var viewModel: JobListViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
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
                                    salaryRange: job.salaryRange,
                                    isApplied: viewModel.sentApplications.contains(where: { $0.id == job.id }),
                                    showApplyButton: true,
                                    onApply: {
                                        viewModel.applyForJob(job)
                                    }
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: navbarIcon)
            .navigationTitle("Lowongan Pekerjaan")
        }
    }
    
    private var navbarIcon: some View {
        HStack {
            Image("klobnavbar")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
}

struct SentApplicationsView: View {
    @ObservedObject var viewModel: JobListViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if viewModel.sentApplications.isEmpty {
                    Text("Belum ada lowongan terkirim")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.sentApplications) { job in
                                JobCard(
                                    title: job.positionName,
                                    company: job.corporateName,
                                    jobType: job.status.rawValue,
                                    postedDaysAgo: job.postedDaysAgo,
                                    companyLogoURL: job.corporateLogo,
                                    salaryRange: job.salaryRange,
                                    isApplied: true,
                                    showApplyButton: false,
                                    onApply: {}
                                )
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Lamaran Terkirim!")
        }
    }
}

struct JobCard: View {
    let title: String
    let company: String
    let jobType: String
    let postedDaysAgo: String
    let companyLogoURL: String
    let salaryRange: String?
    let isApplied: Bool
    let showApplyButton: Bool
    let onApply: () -> Void
    
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
                        if showApplyButton {
                            Button(action: onApply) {
                                Text(isApplied ? "LAMARAN TERKIRIM" : "LAMAR")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(isApplied ? Color(hex: "#CCCCCC") : Color(hex: "#273569"))
                                    .cornerRadius(8)
                            }
                            .disabled(isApplied)
                        }
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
