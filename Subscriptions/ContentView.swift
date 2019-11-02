//
//  ContentView.swift
//  Subscriptions
//
//  Created by R.M. de Vos on 02/11/2019.
//  Copyright © 2019 R.M. de Vos. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Subscription.getAllSubscriptions()) var subscriptions: FetchedResults<Subscription>
    
    @State private var subscription: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add subscription")) {
                    HStack {
                        TextField("New subscription", text: self.$subscription)
                        Button(action: {
                            let subscription = Subscription(context: self.managedObjectContext)
                            subscription.title = self.subscription
                            subscription.createdAt = Date()
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print("Failed to add object \(error)")
                            }
                            
                            self.subscription = ""
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }.font(.headline)
                Section(header: Text("Subscriptions")) {
                    ForEach(self.subscriptions) { subscription in
                        SubscriptionView(
                            title: subscription.title!,
                            createdAt: "\(subscription.createdAt!)"
                        )
                    }
                    .onDelete { indexSet in
                        let deletedSubscription = self.subscriptions[indexSet.first!]
                        self.managedObjectContext.delete(deletedSubscription)
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print("Failed to delete object \(error)")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Subscriptions"))
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
