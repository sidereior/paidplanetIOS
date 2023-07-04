import SwiftUI
import Firebase
import FirebaseStorage
import UIKit

struct SolarPanelView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.custom("Avenir", size: 20))
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(14)
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            
            Spacer()
            
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("No Image Selected")
            }
            
            Button(action: {
                isShowingImagePicker = true
            }) {
                Text("Upload Photo")
                    .font(.custom("Avenir", size: 20))
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(14)
            }
        }
        .sheet(isPresented: $isShowingImagePicker, onDismiss: uploadImage) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    func uploadImage() {
        guard let image = selectedImage else {
            return
        }
        
        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        // Create a unique filename for the image
        let filename = UUID().uuidString + ".jpg"
        
        // Reference to the Firebase Storage bucket
        let storageRef = Storage.storage().reference().child(filename)
        
        // Upload the image data to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully")
            }
        }
    }
}

struct SolarPanelView_Previews: PreviewProvider {
    static var previews: some View {
        SolarPanelView()
    }
}
