//
//  EditProjectView.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 11/06/2021.
//

import SwiftUI

struct EditProjectView: View {
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(project: Project) {
        self.project = project
        
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Project Name", text: $title.onChange(update))
                TextField("Project Detail", text: $detail.onChange(update))
            }
            
            Section(header: Text("Custom Project Colour")) {
                VStack {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                            
                        }
                        .onTapGesture {
                            color = item
                            update()
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(
                            item == color ? [.isButton, .isSelected] : .isButton
                        )
                        .accessibilityLabel(LocalizedStringKey(item))
                    }
                }
                .padding(.vertical)
                    VStack {
                        
                        Text("\(color)")
                            .foregroundColor(.secondary)
                            .opacity(1.2)
                        
                        ProgressView(value: Double.random(in: 0.25...1))
                            .accentColor(Color(project.projectColor))
                            .padding(.vertical)
                    }
                }
            }
            
            Section(footer: Text("Closing a project moves it from the open to closed tab; deleting it removes the project along with all of its data entirely")) {
                
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }
                
                Button("Delete Project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete Project?"), message: Text("Do you want to delete this project and all of its data?"), primaryButton: .destructive(Text("Delete"), action: delete), secondaryButton: .cancel())
        }
    }
    
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }
    
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
}
    

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
