//
//  tanController.swift
//  NewsFeed
//
//  Created by Sarowar H. Mishkat on 9/3/20.
//  Copyright © 2020 Sarowar H. Mishkat. All rights reserved.
//

import SwiftUI
import BottomBar_SwiftUI

struct tabController: View {
    @State private var selection = 3

    var body: some View {
        VStack {
            loadSelectedView()
            Spacer()
            BottomBar(selectedIndex: $selection, items: items)
        }
    }
    func loadSelectedView() -> AnyView{
        switch selection {
        case 0:
            return AnyView(ContentView())
        case 1:
            return AnyView(favoriteList())
        case 2:
            return AnyView(settings())
        default:
                break
        }
        return AnyView(ContentView())
    }
    
}

struct tanController_Previews: PreviewProvider {
    static var previews: some View {
        tabController()
    }
}
