//
//  CapsuleView.swift
//  MovieDB_nosql
//
//  Created by Emmanuel Flores on 12/20/22.
//

import SwiftUI

struct CapsuleView: View {
    var text: String

    var body: some View {
        Text(text)
            .padding(.leading,6)
            .padding(.trailing,6)
            .padding(.top, 2)
            .padding(.bottom,2)
            .font(.system(size: 15, design: .default))
            .foregroundColor(.white)
            .background(Capsule().fill(Color(.systemGray4)))
    }
}

struct CapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleView(text: "TEST")
    }
}
