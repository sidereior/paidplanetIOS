//
//  fontviewer.swift
//  IOS
//
//  Created by Alexander Nanda on 5/9/23.
//

import SwiftUI
import UIKit

/// Displays all available fonts in a vertically scrolling view.
struct FontsView: View {
    private static let fontNames: [String] = {
        var names = [String]()
        for familyName in UIFont.familyNames {
            names.append(contentsOf: UIFont.fontNames(forFamilyName: familyName))
        }
        return names.sorted()
    }()

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(FontsView.fontNames, id: \.self) { fontName in
                    Text(fontName)
                        .font(Font.custom(fontName, size: 17))
                }
            }
            .padding()
        }
    }
}

struct FontsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FontsView()
                .navigationBarTitle("Fonts", displayMode: .inline)
        }
    }
}
