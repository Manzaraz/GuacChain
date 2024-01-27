//
//  QtySelectionView.swift
//  GuacChain
//
//  Created by Christian Manzaraz on 26/01/2024.
//

import SwiftUI

struct QtySelectionView: View {
    @Binding var qty: Int
    var menuString: String
      
    var body: some View {
        // Add a label containing default text "0". Font: System, Size: 48pt, Weight: Heavy, The number should be in a frame of with 70.
        HStack {
            Text("\(qty)")
                .font(Font.custom("System", size: 48))
                .fontWeight(.heavy)
                .frame(width: 70)
            VStack (alignment: .leading, spacing: 0) {
                Text(menuString)
                Stepper("", value: $qty, in: 0...99)
                    .labelsHidden()
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        
    }
}

#Preview {
    QtySelectionView(qty: .constant(0), menuString: "The Satoshi 'Taco' moto")
}
