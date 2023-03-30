//
//  ProjectsView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import CoreData
import SwiftUI

struct ProjectsView: View {

	@StateObject var viewModel: ViewModel
	@State private var showingSortOrder = false

	static let openTag: String? = "Open"
	static let closedTag: String? = "Closed"

    var body: some View {
		SimpleStackNavigationView {
			Group {
				if viewModel.projects.isEmpty {
					Text("There's nothing here right now.")
						.foregroundColor(.secondary)
				} else {
					projectsList
				}
			}
			.navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
			.toolbar {
				addProjectToolbarItem
				sortOrderToolbarItem
			}
			.sheet(isPresented: $viewModel.showingUnlockView) {
				UnlockView()
			}
#if os(iOS)
			.actionSheet(isPresented: $showingSortOrder) {
				ActionSheet(title: Text("Sort items"), message: nil, buttons: [
					.default(Text("Optimized")) { viewModel.sortDescriptor = nil },
					.default(Text("Created On")) { viewModel.sortDescriptor =
						NSSortDescriptor(keyPath: \Item.createdOn, ascending: false) },
					.default(Text("Title")) { viewModel.sortDescriptor = NSSortDescriptor(keyPath: \Item.title, ascending: true) }
				]) // ActionSheet
			} // .actionSheet
#elseif os(macOS)
#endif
			SelectSomethingView()
		}
	}

	var projectsList: some View {
		List(selection: $viewModel.selectedItem) {
			ForEach(viewModel.projects) { project in
				Section(header: ProjectHeaderView(project: project)) {
					ForEach(viewModel.items(for: project)) { item in
						ItemRowView(project: project, item: item)
							.contextMenu {
								Button("Delete", role: .destructive) {
									viewModel.delete(item)
								}
							}
							.tag(item)
					}
					.onDelete { offsets in
						viewModel.delete(offsets, from: project)
					}

					if viewModel.showClosedProjects == false {
						Button {
							withAnimation {
								viewModel.addItem(to: project)
							}
						} label: {
							Label("Add New Item", systemImage: "plus")
						}
						Button {
							viewModel.addItem(to: project)
						} label: {
							HStack {
								Image(systemName: "plus")
									.foregroundColor(.secondary)
								Text("Add New Item")
							}
						}
						.buttonStyle(.borderless)
					}
				}
				.disableCollapsing()
			}
		} // List
		.listStyle(InsetGroupedListStyle())
		.onDeleteCommand {
			guard let selectedItem = viewModel.selectedItem else { return }
			viewModel.delete(selectedItem)
		}
	}

	var addProjectToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .primaryAction) {
			if viewModel.showClosedProjects == false {
				Button {
					withAnimation {
						viewModel.addProject()
					}
				} label: {
					Label("Add Project", systemImage: "plus")
				}
			}
		}
	}

	var sortOrderToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .cancellationAction) {
			Menu {
				Button("Optimized") { viewModel.sortOrder = .optimized }
				Button("Creation Date") { viewModel.sortOrder = .createdOn }
				Button("Title") { viewModel.sortOrder = .title }
			} label: {
				Label("Sort", systemImage: "arrow.up.arrow.down")
			}
		}
	}

	init(persistence: Persistence, showClosedProjects: Bool) {
		let viewModel = ViewModel(persistence: persistence, showClosedProjects: showClosedProjects)
		_viewModel = StateObject(wrappedValue: viewModel)
	}
}

struct ProjectsView_Previews: PreviewProvider {
	static var persistence = Persistence.preview

    static var previews: some View {
		ProjectsView(persistence: Persistence.preview, showClosedProjects: false)
			.environment(\.managedObjectContext, persistence.container.viewContext)
    }
}
