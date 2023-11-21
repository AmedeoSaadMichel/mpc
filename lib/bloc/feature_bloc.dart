import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// Events
abstract class ImageEvent {}

class PickImagesEvent extends ImageEvent {}
class DeleteImageEvent extends ImageEvent {
  final int index;

  DeleteImageEvent(this.index);
}
// States
abstract class ImageState {}

class ImageInitialState extends ImageState {}

class ImagesLoadedState extends ImageState {
  final List<File> images;

  ImagesLoadedState(this.images);
}

// BLoC
class ImageBloc extends Cubit<ImageState> {
  ImageBloc() : super(ImageInitialState());

  final List<File> _selectedImages = [];

  void pickImages() async {
    List<XFile>? pickedImages =
    await ImagePicker().pickMultiImage(imageQuality: 50);

    if (pickedImages != null) {
      _selectedImages.addAll(pickedImages.map((image) => File(image.path)));
      emit(ImagesLoadedState(List.from(_selectedImages)));
    }
  }

  void deleteImage(int index) {
    _selectedImages.removeAt(index);
    emit(ImagesLoadedState(List.from(_selectedImages)));
  }
}
