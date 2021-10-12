//
//  HomeView.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 02/06/2021.
//

import CoreData
import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    @StateObject var viewModel: ViewModel

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(viewModel.projects, content: ProjectSummaryView.init)
                        }
                        .padding([.horizontal, .top])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }

                VStack(alignment: .leading) {

                    ItemListView(title: "Up next", items: viewModel.upNext)
                    ItemListView(title: "More to explore", items: viewModel.moreToExplore)

                            Button {
                                viewModel.addSampleData()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color.secondarySystemGroupedBackground)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5)

                                    Text("Add Data")
                                }
                            }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .padding(.bottom)
                }
                .padding(.horizontal)
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: DataController.preview)
    }
}
