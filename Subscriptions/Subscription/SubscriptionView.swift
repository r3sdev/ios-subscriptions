//
//  SubscriptionView.swift
//  Subscriptions
//
//  Created by R.M. de Vos on 02/11/2019.
//  Copyright © 2019 R.M. de Vos. All rights reserved.
//

import SwiftUI

struct SubscriptionView: View {
    var title: String = ""
    var createdAt: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(createdAt).font(.caption)
            }
        }
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(title: "title", createdAt: "date")
    }
}
