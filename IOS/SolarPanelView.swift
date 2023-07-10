import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

struct Transaction: Codable {
    var firstName: String
    var lastName: String
    var imagePath1: String
    var imagePath2: String
    var imagePath3: String
    var imagePath4: String
    var transactionDate: Date
}

struct SolarPanelView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var imagePath1: String?
    @State private var imagePath2: String?
    @State private var imagePath3: String?
    @State private var imagePath4: String?
    @State private var currentImageNumber = 1
    @State private var isShowingNextView = false

    var body: some View {
        ZStack {
            Color(hex: "1B463C")
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                                .font(.custom("Avenir", size: 20))
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                                .padding(7)
                                .background(Color.white)
                                .cornerRadius(14)
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    }
                    Group {
                        Spacer()
                            .frame(height: 25)
                        
                        Text("So, you own Solar Panels. First, you'll need to enter some basic information so we can pay you for using solar.")
                            .font(.custom("Avenir", size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 15)
                        
                        TextField("First name", text: $firstName)
                            .autocapitalization(.none)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color(hex: "D9D9D9"))
                            .cornerRadius(14.0)
                            .padding(.horizontal, 25)
                            .font(.custom("Avenir", size: 20).bold())
                            .padding(.bottom, 10)
                        
                        TextField("Last name", text: $lastName)
                            .autocapitalization(.none)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color(hex: "D9D9D9"))
                            .cornerRadius(14.0)
                            .padding(.horizontal, 25)
                            .font(.custom("Avenir", size: 20).bold())
                        
                        Button(action: {
                            isShowingNextView = true
                        }) {
                            Text("Next")
                                .font(.custom("Avenir", size: 20))
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                                .padding(7)
                                .background(Color.white)
                                .cornerRadius(14)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        .sheet(isPresented: $isShowingNextView, onDismiss: uploadImage) {
                            
                            //this is the photo upload view we need to modify
                            PhotoUploadView(firstName: $firstName,
                                            lastName: $lastName,
                                            imagePath1: $imagePath1,
                                            imagePath2: $imagePath2,
                                            imagePath3: $imagePath3,
                                            imagePath4: $imagePath4)
                        }
                    }
                    /*
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    } else {
                        Text("No Image Selected")
                    }
                    
                    Button(action: {
                        currentImageNumber = 1
                        isShowingImagePicker = true
                    }) {
                        Text("Upload Photo 1")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    
                    Button(action: {
                        currentImageNumber = 2
                        isShowingImagePicker = true
                    }) {
                        Text("Upload Photo 2")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    
                    Button(action: {
                        currentImageNumber = 3
                        isShowingImagePicker = true
                    }) {
                        Text("Upload Photo 3")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    
                    Button(action: {
                        currentImageNumber = 4
                        isShowingImagePicker = true
                    }) {
                        Text("Upload Photo 4")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    
                    Button(action: uploadTransaction) {
                        Text("Confirm Transaction")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                     */
                }
                     
                .sheet(isPresented: $isShowingImagePicker, onDismiss: uploadImage) {
                    ImagePicker(selectedImage: $selectedImage)
                }
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
        
        let imageName = "\(UUID().uuidString).jpg"
        let imageRef = storageRef.child("images/\(imageName)") // Create a reference to the image file with a unique filename
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the image data to Firebase Storage
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
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
                if currentImageNumber == 1 {
                    imagePath1 = urlString
                } else if currentImageNumber == 2 {
                    imagePath2 = urlString
                } else if currentImageNumber == 3 {
                    imagePath3 = urlString
                } else if currentImageNumber == 4 {
                    imagePath4 = urlString
                }
            }
        }
        
        // Add a progress observer to track the upload progress
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount) * 100
            print("Upload progress for image \(currentImageNumber): \(percentComplete)%")
        }
    }
    
    
    
    func uploadTransaction() {
        let db = Firestore.firestore()
        let transaction = Transaction(firstName: firstName,
                                      lastName: lastName,
                                      imagePath1: imagePath1 ?? "",
                                      imagePath2: imagePath2 ?? "",
                                      imagePath3: imagePath3 ?? "",
                                      imagePath4: imagePath4 ?? "",
                                      transactionDate: Date())
        
        do {
            try db.collection("transactions").addDocument(from: transaction)
        } catch let error {
            print("Error writing transaction to Firestore: \(error)")
        }
    }
}



struct PhotoUploadView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var imagePath1: String?
    @Binding var imagePath2: String?
    @Binding var imagePath3: String?
    @Binding var imagePath4: String?
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var currentImageNumber = 1
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingNextView = false
    
    var body: some View {
        ZStack {
            Color(hex: "1B463C")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Back")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding(7)
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                
                Group {
                    Text("Next, we need some proof of identification. Upload a picture of your driver's license, passport, or other form of ID so we can confirm your info.")
                        .font(.custom("Avenir", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 15)
                    
                    Button(action: {
                        currentImageNumber = 1
                        isShowingImagePicker = true
                    }) {
                        Text("Upload Identification")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    
                    Button(action: {
                        currentImageNumber = 2
                        isShowingImagePicker = true
                    }) {
                        Text("(Optional) Upload Identification 2")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    
                    Button(action: {
                        isShowingNextView = true
                    }) {
                        Text("Next")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    .sheet(isPresented: $isShowingNextView) {
                        PhotoUploadView2(firstName: $firstName,
                                         lastName: $lastName,
                                         imagePath1: $imagePath1,
                                         imagePath2: $imagePath2,
                                         imagePath3: $imagePath3,
                                         imagePath4: $imagePath4)
                    }
                }
                
                Spacer()
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
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imageName = "\(UUID().uuidString).jpg"
        let imageRef = storageRef.child("images/\(imageName)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard error == nil else {
                print("Error uploading image: \(error!.localizedDescription)")
                return
            }
            
            print("Image uploaded successfully")
            
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    }
                    return
                }
                
                let urlString = downloadURL.absoluteString
                print("Download URL: \(urlString)")
                
                if currentImageNumber == 1 {
                    imagePath1 = urlString
                } else if currentImageNumber == 2 {
                    imagePath2 = urlString
                } else if currentImageNumber == 3 {
                    imagePath3 = urlString
                } else if currentImageNumber == 4 {
                    imagePath4 = urlString
                }
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount) * 100
            print("Upload progress for image \(currentImageNumber): \(percentComplete)%")
        }
    }
}

struct PhotoUploadView2: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var imagePath1: String?
    @Binding var imagePath2: String?
    @Binding var imagePath3: String?
    @Binding var imagePath4: String?
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var currentImageNumber = 3
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(hex: "1B463C")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Back")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding(7)
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                
                Group {
                    Text("Now, we need proof of your ownership of the Solar Panels. This can be an invoice, electric bill, or even a picture of the panels. We require at least two images.")
                        .font(.custom("Avenir", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 15)
                    
                    Button(action: {
                        currentImageNumber = 3
                        isShowingImagePicker = true
                    }) {
                        Text("Proof of ownership 1")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    
                    Button(action: {
                        currentImageNumber = 4
                        isShowingImagePicker = true
                    }) {
                        Text("Proof of ownership 2")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    
                    
                    Button(action: {
                        currentImageNumber = 5
                        isShowingImagePicker = true
                    }) {
                        Text("Proof of ownership 3")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                
                    Button(action: {
                        // Code to confirm transaction
                    }) {
                        Text("Confirm Transaction")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                }
                
                Spacer()
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
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imageName = "\(UUID().uuidString).jpg"
        let imageRef = storageRef.child("images/\(imageName)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard error == nil else {
                print("Error uploading image: \(error!.localizedDescription)")
                return
            }
            
            print("Image uploaded successfully")
            
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    }
                    return
                }
                
                let urlString = downloadURL.absoluteString
                print("Download URL: \(urlString)")
                
                if currentImageNumber == 3 {
                    imagePath3 = urlString
                } else if currentImageNumber == 4 {
                    imagePath4 = urlString
                }
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount) * 100
            print("Upload progress for image \(currentImageNumber): \(percentComplete)%")
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
