import 'package:image_picker/image_picker.dart';

import 'camera_gallery_service.dart';

class CameraGalleryServiceImpl extends CameraGalleryService {
  final ImagePicker _imagePicker = ImagePicker();
  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear);
    return photo?.path;
  }

  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    return photo?.path;
  }
}
