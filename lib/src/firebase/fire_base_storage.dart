import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  // ignore: unused_field, prefer_final_fields
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  String collectionName = 'images';

  Future<String> uploadImage(File imageFile) async {
    String uploadFileName =
        // ignore: prefer_interpolation_to_compose_strings
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference reference =
        _storageRef.ref().child(collectionName).child(uploadFileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
    final String imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

// xoa dua vao imageURL;
  Future<void> deleteImageFromStorage(String imageURL) async {
    Uri uri = Uri.parse(imageURL);
    String path = uri.path;
    String fileName = path.split('F').last; // Extract the file name
    print('filename ' + fileName);
    // Construct the full reference to the image
    Reference reference =
        _storageRef.ref().child(collectionName).child(fileName);
    // Delete the image from Firebase Storage
    await reference.delete();
  }
}
