//
//  SubmittedApplicationsView.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import SwiftUI

struct SubmittedApplicationsView: View {
    @State private var appliedJobs: [Job] = []
    
    var body: some View {
        List(appliedJobs) { job in
            Text(job.positionName)
                .font(.headline)
        }
        .navigationTitle("Submitted Applications")
    }
}
