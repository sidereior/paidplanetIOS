//
//  SwipeTabTest.swift
//  IOS
//
//  Created by Alexander Nanda on 6/27/23.
//

import Foundation
import CITTopTabBar
import SwiftUI
struct CITTopTabBarExampleView: View {
    @State var selectedTab: Int = 0
    @State var tabs: [CITTopTab] = [
        .init(
            title: "Home" ,
            icon: .init(systemName: "house.fill"),
            iconColorOverride: .white,
            selectedIconColorOverride: .green
        ),
        .init(
            title: "Scan" ,
            icon: .init(systemName: "camera.viewfinder"),
            iconColorOverride: .white,
            selectedIconColorOverride: .green
        ),
        .init(
            title: "Transactions",
            icon: .init(systemName: "archivebox.fill"),
            iconColorOverride: .white,
            selectedIconColorOverride: .green
        ),
        .init(
            title: "Profile",
            icon: .init(systemName: "person.crop.square.fill"),
            iconColorOverride: .white,
            selectedIconColorOverride: .green
        )
    ]

    var config: CITTopTabBarView.Configuration {
        var example: CITTopTabBarView.Configuration = .exampleUnderlined
        example.textColor = .white
        example.backgroundColor = .black
        example.font = Font.custom("Avenir", size: 14).bold() // Set the desired font here
        example.iconSize = CGSize(width: 30, height: 30) // Set the desired icon size here
        return example
    }


    var body: some View {
        VStack {
            CITTopTabBarView(selectedTab: $selectedTab, tabs: $tabs, config: config)

            TabView(selection: $selectedTab) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { offset, tab in
                    Text(tab.title)
                        .font(.system(size: 16, weight: .bold))
                        .tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color.green)
        .preferredColorScheme(.dark)
        .edgesIgnoringSafeArea(.all)
    }
}

struct swipeTabView_Previews: PreviewProvider {
    static var previews: some View {
        CITTopTabBarExampleView()
    }
}
