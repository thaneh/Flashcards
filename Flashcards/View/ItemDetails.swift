//
//  ItemDetails.swift
//  Flashcards
//
//  Created by Thane Heninger on 9/10/20.
//

import SwiftUI

struct ItemDetails: View {
    let card: Card
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            Text(card.name)
                .font(.title)
                .padding(.bottom)
                .accessibility(identifier: "ItemDetails.name")
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            Text(card.details)
                .accessibility(identifier: "ItemDetails.description")
            
            if let location = card.location {
                MapView(centerCoordinate: location)
                    .padding()
            }
            Spacer()
        }
        .onAppear {
            PhotosFileService.shared.load(photoID: card.id) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

struct ItemDetails_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetails(card: Card.example)
    }
}
