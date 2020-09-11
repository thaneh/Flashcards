//
//  ItemCellView.swift
//  Flashcards
//
//  Created by Thane Heninger on 9/9/20.
//

import SwiftUI

struct ItemCellView: View {
    let card: Card
    @State private var image: UIImage?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: card.created)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50, maxHeight: 50)
            }
            HStack {
                Text(card.name)
                    .padding(.leading, 60)
                Spacer()
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(height: 40)
        .onAppear {
            PhotosFileService.shared.load(photoID: card.id) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

struct ItemCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ItemCellView(card: Card.example)
//            ItemCellView(image: UIImage(systemName: "photo"), title: "Title", date: Date())
                .padding()
            
//            ItemCellView(image: nil, title: "Title", date: Date())
//                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
