//
//  EditProjectView.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 11/06/2021.
//

import CloudKit
import CoreHaptics
import SwiftUI

struct EditProjectView: View {
    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    @State private var showingDeleteConfirm = false
    @State private var showingNotificationsError = false

    @State private var remindMe: Bool
    @State private var reminderTime: Date

    @State private var engine = try? CHHapticEngine()

    @AppStorage("username") var username: String?
    @State private var showingSignIn = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
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
                    ForEach(Project.colors, id: \.self, content: colorButton)
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

                    Section(header: Text("Project Reminders")) {
                        Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
                            .alert(isPresented: $showingNotificationsError) {
                                Alert(
                                    title: Text("Oops!"),
                                    message: Text("There Was a problem. Please check you have notifications enabled!"),
                                    primaryButton: .default(Text("Check Settings"), action: showAppSettings),
                                    secondaryButton: .cancel()
                                )
                            }

                        if remindMe {
                            DatePicker(
                                "ReminderTime",
                                selection: $reminderTime.onChange(update),
                                displayedComponents: .hourAndMinute
                            )
                        }
                    }
                }
            }

            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a project moves it from the open to closed tab; deleting it removes the project along with all of its data entirely")) {

                Button(project.closed ? "Reopen this project" : "Close this project", action: toggleClosed)

                Button("Delete Project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
        .toolbar {
            Button(action: uploadToCloud) {
                Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
            }
        }
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete Project?"),
                message: Text("Do you want to delete this project and all of its data?"), // swiftlint:disable:this line_length
                primaryButton: .destructive(Text("Delete"), action: delete),
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color

        if remindMe {
            project.reminderTime = reminderTime

            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false

                    showingNotificationsError = true
                }
            }
        } else {
            project.reminderTime = nil

            dataController.removeReminders(for: project)
        }
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    func toggleClosed() {
            project.closed.toggle()

            if project.closed {
                do {
                    try? engine?.start()

                    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

                    let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                    let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

                    let parameter = CHHapticParameterCurve(
                        parameterID: .hapticIntensityControl,
                        controlPoints: [start, end],
                        relativeTime: 0
                    )

                    let event1 = CHHapticEvent(
                        eventType: .hapticTransient,
                        parameters: [intensity, sharpness],
                        relativeTime: 0
                    )

                    let event2 = CHHapticEvent(
                        eventType: .hapticContinuous,
                        parameters: [sharpness, intensity],
                        relativeTime: 0.125,
                        duration: 1
                    )

                    let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

                    let player = try engine?.makePlayer(with: pattern)
                    try? player?.start(atTime: 0)
                } catch {
                    return
                }
            }
        }

    func colorButton(for item: String) -> some View {
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

    func showAppSettings() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }

    func uploadToCloud() {
        if let username = username {
            let records = project.prepareCloudRecords(owner: username)
            let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            operation.savePolicy = .allKeys
            operation.modifyRecordsCompletionBlock = { _, _, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }

            CKContainer.default().publicCloudDatabase.add(operation)
        } else {
            showingSignIn = true
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
