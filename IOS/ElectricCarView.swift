import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit




struct ElectricCarView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var imagePath1: String?
    @State private var imagePath2: String?
    @State private var imagePath3: String?
    @State private var imagePath4: String?
    @State private var imagePath5: String?
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
                        
                        Text("So, you own an Electric Car. First, you'll need to enter some basic information so we can pay you for using your electric car.")
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
                            .foregroundColor(.black)
                            .padding(.bottom, 10)
                            .accentColor(.black)
                        
                        TextField("Last name", text: $lastName)
                            .autocapitalization(.none)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color(hex: "D9D9D9"))
                            .cornerRadius(14.0)
                            .padding(.horizontal, 25)
                            .font(.custom("Avenir", size: 20).bold())
                            .foregroundColor(.black)
                            .accentColor(.black)
                        
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
                            
                            ElectricPhotoUploadView(firstName: $firstName,
                                            lastName: $lastName,
                                            imagePath1: $imagePath1,
                                            imagePath2: $imagePath2,
                                            imagePath3: $imagePath3,
                                            imagePath4: $imagePath4,
                                            imagePath5: $imagePath5)
                        }
                    }
                   
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
                } else if currentImageNumber == 5 {
                    imagePath5 = urlString
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
}


struct ElectricPhotoUploadView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var imagePath1: String?
    @Binding var imagePath2: String?
    @Binding var imagePath3: String?
    @Binding var imagePath4: String?
    @Binding var imagePath5: String?
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
                    Text("Next, we need some proof of identification. Upload a picture of your driver's license, passport, or other form of ID so we can confirm your info. The more information you provide, the easier it will be for us to issue you payment.")
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
                        ElectricPhotoUploadView2(firstName: $firstName,
                                         lastName: $lastName,
                                         imagePath1: $imagePath1,
                                         imagePath2: $imagePath2,
                                         imagePath3: $imagePath3,
                                         imagePath4: $imagePath4,
                                         imagePath5: $imagePath5)
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
                } else if currentImageNumber == 5 {
                    imagePath5 = urlString
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

struct ElectricPhotoUploadView2: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var imagePath1: String?
    @Binding var imagePath2: String?
    @Binding var imagePath3: String?
    @Binding var imagePath4: String?
    @Binding var imagePath5: String?
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var currentImageNumber = 3
    @State private var isShowingNextView = false
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
                    Text("Now, we need proof of your ownership and usage of your Electric Car. This can be an picture/output of the odometer or a picture of a data export from your car, or even proof of charging. The more information you provide, the easier it will be for us to issue you payment.")
                        .font(.custom("Avenir", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 15)
                    
                    Button(action: {
                        currentImageNumber = 3
                        isShowingImagePicker = true
                    }) {
                        Text("Proof of ownership")
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
                        Text("Proof of usage")
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
                        Text("(Optional) Proof of ownership or usage")
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
                        ElectricConfirmTransactionView(firstName: $firstName,
                                               lastName: $lastName,
                                               imagePath1: $imagePath1,
                                               imagePath2: $imagePath2,
                                               imagePath3: $imagePath3,
                                               imagePath4: $imagePath4,
                                               imagePath5: $imagePath5)
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
                } else if currentImageNumber == 5 {
                    imagePath5 = urlString
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


struct ElectricCarView_Previews: PreviewProvider {
    static var previews: some View {
        ElectricCarView()
    }
}


struct ElectricConfirmTransactionView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var imagePath1: String?
    @Binding var imagePath2: String?
    @Binding var imagePath3: String?
    @Binding var imagePath4: String?
    @Binding var imagePath5: String?
    @State private var image1: UIImage?
    @State private var image2: UIImage?
    @State private var image3: UIImage?
    @State private var image4: UIImage?
    @State private var image5: UIImage?

    var body: some View {
        ZStack {
            Color(hex: "1B463C")
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle back button action
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

                ScrollView {
                    VStack {
                        Group{
                            Text("Finally, preview your Electric Car transaction before confirming it.")
                                .font(.custom("Avenir", size: 30))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.horizontal, 15)
                                .padding(.top, 30)
                            
                            Text("First Name: \(firstName)")
                                .font(.custom("Avenir", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.top, 20)
                            
                            Text("Last Name: \(lastName)")
                                .font(.custom("Avenir", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.top, 10)
                            
                            Text("Proof of identification 1: ")
                                .font(.custom("Avenir", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.top, 10)
                        }

                        if let imageURL1 = URL(string: imagePath1 ?? ""),
                           let image1 = image1 {
                            Image(uiImage: image1)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .padding(.top, 20)
                        }

                        Text("(Optional) Proof of identification 2:")
                            .font(.custom("Avenir", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.top, 10)
                        
                        if let imageURL2 = URL(string: imagePath2 ?? ""),
                           let image2 = image2 {
                            Image(uiImage: image2)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .padding(.top, 20)
                        }

                        Text("Proof of ownership:")
                            .font(.custom("Avenir", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(.top, 10)
                        
                        if let imageURL3 = URL(string: imagePath3 ?? ""),
                           let image3 = image3 {
                            Image(uiImage: image3)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .padding(.top, 20)
                        }

                        Group{
                            Text("Proof of usage:")
                                .font(.custom("Avenir", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.top, 10)
                            
                            if let imageURL4 = URL(string: imagePath4 ?? ""),
                               let image4 = image4 {
                                Image(uiImage: image4)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .padding(.top, 20)
                            }
                            
                            Text("(Optional) Proof of usage or ownership:")
                                .font(.custom("Avenir", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.top, 10)
                            
                            if let imageURL5 = URL(string: imagePath5 ?? ""),
                               let image5 = image5 {
                                Image(uiImage: image5)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 200, height: 200)
                                    .padding(.top, 20)
                            }
                        }

                        Button(action: {
                            uploadTransaction()
                        }) {
                            Text("Confirm Greenback")
                                .font(.custom("Avenir", size: 20))
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(14)
                                .padding(.top, 30)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            loadImage(from: URL(string: imagePath1 ?? ""), into: $image1)
            loadImage(from: URL(string: imagePath2 ?? ""), into: $image2)
            loadImage(from: URL(string: imagePath3 ?? ""), into: $image3)
            loadImage(from: URL(string: imagePath4 ?? ""), into: $image4)
            loadImage(from: URL(string: imagePath5 ?? ""), into: $image5)
        }
    }

    private func loadImage(from url: URL?, into binding: Binding<UIImage?>) {
        guard let url = url else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    binding.wrappedValue = image
                }
            } else {
                print("Failed to load image: \(String(describing: error))")
            }
        }.resume()
    }
    
    func uploadTransaction() {
        let db = Firestore.firestore()
        let transaction = Transaction(firstName: firstName,
                                      lastName: lastName,
                                      imagePath1: imagePath1 ?? "",
                                      imagePath2: imagePath2 ?? "",
                                      imagePath3: imagePath3 ?? "",
                                      imagePath4: imagePath4 ?? "",
                                      imagePath5: imagePath5 ?? "",
                                      transactionDate: Date(),
                                      progress: "Pending") // Set the initial progress value
        
        do {
            try db.collection("transactions").addDocument(from: transaction) { error in
                if let error = error {
                    print("Error writing transaction to Firestore: \(error)")
                } else {
                    print("Transaction uploaded successfully")
                }
            }
        } catch let error {
            print("Error writing transaction to Firestore: \(error)")
        }
    }


    
}


