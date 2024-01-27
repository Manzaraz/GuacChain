//
//  ContentView.swift
//  GuacChain
//
//  Created by Christian Manzaraz on 26/01/2024.
//

import SwiftUI

enum Currency: String, CaseIterable {
    case usd = "$ USD", gbp = "£ GBP", eur = "€ EUR"
}
enum Price: Double {
    case taco = 5.00
    case burrito = 8.00
    case chips = 3.00
    case horchata = 2.00
}

struct ContentView: View {
    @StateObject var currencyVM = CurrencyViewModel()
    
    @State private var tacoQty = 0
    @State private var burritoQty = 0
    @State private var chipsQty = 0
    @State private var horchataQty = 0
    @State private var currencySelection: Currency = .usd
    @State private var symbol = "$"
    
    var body: some View {
        VStack {
            HStack {
                Text("Guac")
                    .foregroundStyle(.green)
                
                Text("Chain")
                    .foregroundStyle(.red)
            }
            .font(Font.custom("Marker Felt", size: 48))
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Text("The World's Tastiest Tacos - But We Only Accept Bitcoin")
                .font(Font.custom("Papyrus", size: 20))
                .bold()
                .multilineTextAlignment(.center)
            
            Text("🌮")
                .font(Font.custom("System", size: 80))
            
            VStack (alignment: .leading ) {
                QtySelectionView(qty: $tacoQty, menuString: "The Satoshi 'Taco' moto")
                
                QtySelectionView(qty: $burritoQty, menuString: "Bitcoin Burrito")
                
                QtySelectionView(qty: $chipsQty, menuString: "CryptoChips")
                
                QtySelectionView(qty: $horchataQty, menuString: "'No Bubble' Horchata")
                
            }
            
            Spacer()
            
            
            Picker("", selection: $currencySelection) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Text(currency.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: currencySelection) {
                symbol = String(currencySelection.rawValue.prefix(1))
//                switch currencySelection {
//                case .usd:
//                    symbol = "$"
//                case .gbp:
//                    symbol = "£"
//                case .eur:
//                    symbol = "€"
//                }
                print(symbol)
            }
            HStack (alignment: .top) {
                Text("Total:")
                    .font(.title)
                VStack(alignment: .leading) {
                    Text("\(String(format: "฿ %.7f", calcBillInBitcoin()))")
                    Text("\(symbol) \(String(format: "%.2f", calcBillInCurrency()))")
                }
            }
        }
        .padding()
        .task {
            await  currencyVM.getData()
        }
    }
    
    func calcBillInCurrency() -> Double {
        let tacoTotal = Price.taco.rawValue * Double(tacoQty)
        let burritoTotal = Price.burrito.rawValue * Double(burritoQty)
        let chipsTotal = Price.chips.rawValue * Double(chipsQty)
        let horchataTotal = Price.horchata.rawValue * Double(horchataQty)
        
        let usdTotal = tacoTotal + burritoTotal + chipsTotal + horchataTotal
        
        switch currencySelection {
            case .usd:
                return usdTotal
            case .gbp:
                return usdTotal * (currencyVM.gbpPerBTC / currencyVM.usdPerBTC)
            case .eur:
                return usdTotal * (currencyVM.eurPerBTC / currencyVM.usdPerBTC)
        }
    }
    
    func calcBillInBitcoin() -> Double {
        let tacoTotal = Price.taco.rawValue * Double(tacoQty)
        let burritoTotal = Price.burrito.rawValue * Double(burritoQty)
        let chipsTotal = Price.chips.rawValue * Double(chipsQty)
        let horchataTotal = Price.horchata.rawValue * Double(horchataQty)
        
        let usdTotal = tacoTotal + burritoTotal + chipsTotal + horchataTotal
        
        return usdTotal / currencyVM.usdPerBTC
    }
}

#Preview {
    ContentView()
}
