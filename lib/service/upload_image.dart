// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

// Future<String?> uploadImageToFirebase() async {
//   final picker = ImagePicker();
//   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedFile != null) {
//     File image = File(pickedFile.path);
//     try {
//       // Tạo tên file duy nhất
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();

//       // Tham chiếu đến vị trí lưu trữ trên Firebase Storage
//       Reference ref =
//           FirebaseStorage.instance.ref().child('temp_images/$fileName.jpg');

//       // Upload file
//       await ref.putFile(image);

//       // Lấy URL download của file vừa upload
//       String downloadURL = await ref.getDownloadURL();

//       return downloadURL;
//     } catch (e) {
//       print("Lỗi khi upload ảnh: $e");
//       return null;
//     }
//   } else {
//     print("Không có ảnh nào được chọn");
//     return null;
//   }
// }
