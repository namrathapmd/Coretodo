//
//  ContentView.swift
//  CoreDataToDo
//
//  Created by Namratha PM on 10/3/20.
//

import SwiftUI

struct ContentView: View {
    //property wrapper
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var toDoItems:FetchedResults<ToDoItem>
    
    @State private var newTodoItem = ""
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Whats next?")) {
                    HStack {
                        TextField("New item", text: self.$newTodoItem) //to bind with other todoitems
                        Button(action: {
                            let toDoItem = ToDoItem(context: self.managedObjectContext)
                            toDoItem.title = self.newTodoItem
                            toDoItem.createdAt = Date()
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                            
                            self.newTodoItem = "" //clear to create new item
                        })  {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                            }
                        }
                    }.font(.headline)
                Section(header: Text("To Do's")) {
                    ForEach(self.toDoItems) { todoItem in
                        ToDoItemView(title: todoItem.title!, createdAt: "\(todoItem.createdAt!)")
                    }.onDelete {indexSet in
                        let deleteItem = self.toDoItems[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)
                    
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("My List"))
            .navigationBarItems(trailing: EditButton())
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
