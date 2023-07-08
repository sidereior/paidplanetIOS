import SwiftUI
import Firebase
import FirebaseStorage
import UIKit

struct SolarPanelView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImage: UIImage?
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    
    var body: some View {
        ZStack{
            Color(hex: "1B463C")
                .ignoresSafeArea()
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
<<<<<<< HEAD
                }
                
                Spacer()
                
                
                TextField("First Name", text: $firstName)
                    .font(.custom("Avenir", size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(14)
                    .padding(.horizontal)
                    .autocapitalization(.words)
                
                TextField("Last Name", text: $lastName)
                    .font(.custom("Avenir", size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(14)
                    .padding(.horizontal)
                    .autocapitalization(.words)
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } else {
                    Text("No Image Selected")
=======
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
>>>>>>> refs/remotes/origin/main
                }
                
                
                Button(action: {
                    uploadImage(selectedImage: selectedImage, firstName: firstName, lastName: lastName)
                    presentationMode.wrappedValue.dismiss()
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
        }
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


struct Transaction {
    let transactionID: String
    let userID: String
    let firstName: String
    let lastName: String
    let uploadedImages: [String]
    
    var dictionary: [String: Any] {
        return [
            "transactionID": transactionID,
            "userID": userID,
            "firstName": firstName,
            "lastName": lastName,
            "uploadedImages": uploadedImages
        ]
    }
}



func uploadImage(selectedImage: UIImage?, firstName: String, lastName: String) {
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
    imageRef.putData(imageData, metadata: metadata) { (_, error) in
        if let error = error {
            print("Error uploading image: \(error.localizedDescription)")
            return
        }
        
        // Image uploaded successfully
        print("Image uploaded successfully")
        
        // Get the download URL for the uploaded image
        imageRef.downloadURL { (result) in
            switch result {
            case .success(let url):
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                
                // Create a new transaction object with the entered data
                let transaction = Transaction(transactionID: UUID().uuidString,
                                          userID: "", // Replace with the actual user ID
                                          firstName: firstName,
                                          lastName: lastName,
                                          uploadedImages: [urlString]) // Store the image URL in the uploadedImages array
                
                // Save the transaction to Firebase
                let database = Firestore.firestore() // Get reference to the Firebase Firestore database
                let transactionsCollection = database.collection("transactions") // Reference to the "transactions" collection

                transactionsCollection.document(transaction.transactionID).setData(transaction.dictionary) { error in
                    if let error = error {
                        print("Error saving transaction: \(error.localizedDescription)")
                    } else {
                        print("Transaction saved successfully")
                    }
                }
            case .failure(let error):
                print("Error downloading URL: \(error.localizedDescription)")
            }
            //test
        }
    }
}
