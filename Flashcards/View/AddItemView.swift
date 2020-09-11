//
//  AddItemView.swift
//  Flashcards
//
//  Created by Thane Heninger on 9/9/20.
//

import MapKit
import SwiftUI

struct ImagePortion: View {
    @Binding var image: UIImage?
    @State private var showingImagePicker = false

    var body: some View {
        VStack {
            if image == nil {
                Button("Add Photo") {
                    showingImagePicker = true
                }
            } else {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
                    .padding([.leading, .trailing])
                
                Button("Change Photo") {
                    showingImagePicker = true
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(image: $image)
        }
    }
}

struct LocationPortion: View {
    @Binding var location: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            if location == nil {
                Button("Add Current Location") {
                    location = LocationFetcher.shared.lastKnownLocation
                }
            } else {
                MapView(centerCoordinate: location!)
                    .padding([.leading, .trailing])
                Button("Remove Location") {
                    location = nil
                }
            }
        }
        .onAppear(perform: LocationFetcher.shared.start)
    }
}

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var details = ""
    @State private var image: UIImage?
    @State private var location: CLLocationCoordinate2D?
    
    var canSave: Bool {
        !title.isEmpty
    }
    
    var doneButtonTitle: String {
        canSave ? "Save" : "Cancel"
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(doneButtonTitle, action: donePressed)
                .accessibility(identifier: "AddItemView.dismiss")
                .padding()
            
            VStack {
                Text("Add Card")
                    .font(.title)
                    .padding()
                TextField("title", text: $title)
                    .accessibility(identifier: "AddItemView.title")
                    .font(.title)
                    .padding()
                TextField("description", text: $details)
                    .accessibility(identifier: "AddItemView.description")
                    .padding()
                
                ImagePortion(image: $image)
                    .padding(.bottom)
                
                LocationPortion(location: $location)
                
                Spacer()
            }
        }
    }
    
    func donePressed() {
        try? Store.shared.addItem(name: title, details: details, image: image, location: location)
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
