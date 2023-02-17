//
//  ContentView.swift
//  Shared
//
//  Created by Deirdre Saoirse Moen on 2/7/22.
//

import SwiftUI
import CoreData

struct HomeView: View {
	static let tag: String? = "Home"

	@StateObject var viewModel: ViewModel

	@Environment(\.managedObjectContext) private var viewContext

 	init(persistence: Persistence) {
		let viewModel = ViewModel(persistence: persistence)
		_viewModel = StateObject(wrappedValue: viewModel)
	}

    var body: some View {
        NavigationView {
            List {
				ForEach(viewModel.guitars) { guitar in
                    NavigationLink {
                        Text("\(guitar.guitarName)")
                    } label: {
                        Text(guitar.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newGuitar = Guitar(context: viewContext)
            newGuitar.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
			offsets.map { viewModel.guitars[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct HomeView_Previews: PreviewProvider {
	static var persistence = Persistence.preview

    static var previews: some View {
		HomeView(persistence: persistence)
    }
}
