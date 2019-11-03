//
//  ContentView.swift
//  Subscriptions
//
//  Created by R.M. de Vos on 02/11/2019.
//  Copyright © 2019 R.M. de Vos. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    @State private var searchString: String = ""
    @State private var show: Bool = true
    
    @State private var showDatePicker: Bool = false
    @State private var datePickerMode: String = "start"
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Subscription.getAllSubscriptions()) var subscriptions: FetchedResults<Subscription>
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Subscriptions")) {
                        HStack {
                            TextField("Search", text: self.$searchString)
                        }
                    }.font(.headline)
                    Section(header: Text("Active")) {
                        if (self.subscriptions.count > 0) {
                            ForEach(self.subscriptions.filter { subscription in
                                self.searchString == ""
                                    ? true
                                    : subscription.title.contains(self.searchString)
                                
                            }) { subscription in
                                SubscriptionView(
                                    title: subscription.title,
                                    createdAt: "\(subscription.createdAt)"
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
                        } else {
                            Text("Add a subscription to get started ...")
                        }
                        
                    }
                    Section(header: Text("Expired")) {
                        Text("Expired goes here ...")
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.show = !self.show
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 48.0, height: 48.0)
                            .foregroundColor(.green)
                    })
                    Spacer()
                }
                .padding()
                
            }
                
            .navigationBarTitle(Text("Subscriptions"))
            .navigationBarItems(trailing: EditButton())
        }
        .sheet(isPresented: $show) {
            NavigationView {
                VStack(alignment: .leading) {
                    List {
                        HStack {
                            Text("Title").bold()
                            Spacer()
                            TextField("Title", text: self.$title).multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Amount").bold()
                            Spacer()
                            TextField("Amount", text: self.$amount).multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Start date").bold()
                            Spacer()
                            Button(action: {
                                self.datePickerMode = "Start"
                                self.showDatePicker = !self.showDatePicker
                            }) {
                                Text("\(self.startDate, formatter: ContentView.self.dateFormatter)")
                            }
                        }
                        HStack {
                            Text("End date").bold()
                            Spacer()
                            Button(action: {
                                self.datePickerMode = "End"
                                self.showDatePicker = !self.showDatePicker
                            }) {
                                Text("\(self.endDate, formatter: ContentView.self.dateFormatter)")
                            }
                        }
                        HStack {
                            Button(action: {
                                let subscription = Subscription(context: self.managedObjectContext)
                                subscription.title = self.title
                                subscription.amount = self.amount
                                subscription.createdAt = Date()
                                subscription.startDate = self.startDate
                                subscription.endDate = self.endDate
                                
                                do {
                                    try self.managedObjectContext.save()
                                } catch {
                                    print("Failed to add object \(error)")
                                }
                                
                                print("Saved object \(subscription)")
                                
                                self.title = ""
                                self.amount = ""
                                self.show = false
                            }) {
                                HStack {
                                    Spacer()
                                    Text("ADD")
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .imageScale(.large)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("Add subscription"))
                .padding(.all)
            }
                
            .sheet(isPresented: self.$showDatePicker) {
                NavigationView {
                    VStack {
                        Text("\(self.datePickerMode) date")
                        DatePicker("",
                                   selection: self.datePickerMode == "Start" ? self.$startDate : self.$endDate,
                                   displayedComponents: .date)
                        Spacer()
                        Text("Add")
                    }
                }
                .padding(.all)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
