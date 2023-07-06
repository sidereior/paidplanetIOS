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
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let storage = Storage.storage() // Get reference to the Firebase Storage
        let storageRef = storage.reference() // Get the root reference

        
        
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg") // Create a reference to the image file with a unique filename
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the image data to Firebase Storage
        let _ = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard error == nil else {
                print("Error uploading image: \(error!.localizedDescription)")
                return
            }
            
            // Image uploaded successfully
            print("Image uploaded successfully")
            
            // Access the download URL for the uploaded image
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    }
                    return
                }
                
                // Use the download URL for further operations (e.g., save it to a database)
                let urlString = downloadURL.absoluteString
                print("Download URL: \(urlString)")
            }
        }
    }
}

struct SolarPanelView_Previews: PreviewProvider {
    static var previews: some View {
        SolarPanelView()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


