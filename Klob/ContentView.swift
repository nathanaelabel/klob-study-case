//
//  ContentView.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            JobListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Jobs")
                }
            
            SubmittedApplicationsView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Applications")
                }
        }
    }
}

#Preview {
    ContentView()
}
