//
//  Subscription.swift
//  Subscriptions
//
//  Created by R.M. de Vos on 02/11/2019.
//  Copyright © 2019 R.M. de Vos. All rights reserved.
//

import Foundation
import CoreData

public class Subscription: NSManagedObject, Identifiable {
    @NSManaged public var createdAt: Date
    @NSManaged public var title: String
    @NSManaged public var amount: String

    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?

}

extension Subscription {
    static func getAllSubscriptions() -> NSFetchRequest<Subscription> {
        let request: NSFetchRequest<Subscription> = Subscription.fetchRequest() as! NSFetchRequest<Subscription>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
