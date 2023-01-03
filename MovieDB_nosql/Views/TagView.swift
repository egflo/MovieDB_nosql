//
//  TestWrappedHStackView.swift
//  LearnGrid
//
//  Created by Mohammad Azam on 9/5/21.
//

import SwiftUI



struct TagView: View {
    
    let items: [Keyword]
    var groupedItems: [[Keyword]] = [[Keyword]]()
    let screenWidth = UIScreen.main.bounds.width
    
    init(items: [Keyword]) {
        self.items = items
        self.groupedItems = createGroupedItems(items)
    }
    
    private func createGroupedItems(_ items: [Keyword]) -> [[Keyword]] {
        
        var groupedItems: [[Keyword]] = [[Keyword]]()
        var tempItems: [Keyword] =  [Keyword]()
        var width: CGFloat = 0
        
        for word in items {
            
            let label = UILabel()
            label.text = word.name
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 32
            
            if (width + labelWidth + 55) < screenWidth {
                width += labelWidth
                tempItems.append(word)
            } else {
                width = labelWidth
                groupedItems.append(tempItems)
                tempItems.removeAll()
                tempItems.append(word)
            }
            
        }
        
        groupedItems.append(tempItems)
        return groupedItems
        
    }
    
    var body: some View {
        ScrollView {
        VStack(alignment: .leading) {
            
            ForEach(groupedItems, id: \.self) { subItems in
                HStack {
                    ForEach(subItems, id: \.self) { word in
                        CapsuleView(text: word.name)
                    }
                }
            }
            
            Spacer()
        }
    }
    }
    
}



