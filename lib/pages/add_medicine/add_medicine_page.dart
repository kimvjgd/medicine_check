import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_check/components/dory_constants.dart';
import 'package:medicine_check/components/dory_page_route.dart';
import 'package:medicine_check/components/dory_widgets.dart';
import 'package:medicine_check/pages/add_medicine/add_alarm_page.dart';
import 'package:medicine_check/pages/add_medicine/components/add_page_widget.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _nameController = TextEditingController();
  File? _medicineImage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        child: AddPageBody(
          children: [
            Text('어떤 약이에요?', style: Theme.of(context).textTheme.headline4),
            const SizedBox(
              height: largeSpace,
            ),
            Center(child: MedicineImageButton(
              changeImageFile: (File? value) {
                _medicineImage = value;
              },
            )),
            const SizedBox(height: largeSpace + regularSpace),
            Text('약 이름', style: Theme.of(context).textTheme.subtitle1),
            TextFormField(
              controller: _nameController,
              maxLength: 20,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                hintText: '복용할 약 이름을 기입해주세요.',
                hintStyle: Theme.of(context).textTheme.bodyText2,
                contentPadding: textFieldContentPadding,
              ),
              onChanged: (str) {
                setState(() {});
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomSubmitButton(
          onPressed: _nameController.text.isEmpty ? null : _onAddAlarmPage,
          text: '다음'),
    );
  }

  void _onAddAlarmPage() {
    Navigator.push(
        context,
        FadePageRoute(
            page: AddAlarmPage(
          medicineImage: _medicineImage,
          medicineName: _nameController.text,
        )));
  }
}

class MedicineImageButton extends StatefulWidget {
  MedicineImageButton({Key? key, required this.changeImageFile})
      : super(key: key);

  final ValueChanged<File?> changeImageFile;

  @override
  State<MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<MedicineImageButton> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: CupertinoButton(
        padding: _pickedImage == null ? null : EdgeInsets.zero,
        onPressed: _showModalBottomSheet,
        child: _pickedImage == null
            ? const Icon(
                CupertinoIcons.photo_camera_solid,
                size: 30,
                color: Colors.white,
              )
            : CircleAvatar(
                radius: 40,
                foregroundImage: FileImage(_pickedImage!),
              ),
      ),
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PickImageBottomSheet(
            onPressedCamera: () => onPressed(ImageSource.camera),
            onPressedGallery: () => onPressed(ImageSource.gallery),
          );
        });
  }

  void onPressed(ImageSource source) {
    ImagePicker().pickImage(source: source).then((xfile) {
      if (xfile != null) {

      setState(() {
        _pickedImage = File(xfile.path);
        widget.changeImageFile(_pickedImage);
      });
      }
    Navigator.maybePop(context);
    },).onError((error, stackTrace) {
      // show setting
      showPermissionDenied(context, permission: '카메라 및 갤러리 접근');
    });
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet(
      {Key? key, required this.onPressedCamera, required this.onPressedGallery})
      : super(key: key);

  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(
      children: [
        TextButton(onPressed: onPressedCamera, child: Text('카메라로 촬영')),
        TextButton(onPressed: onPressedGallery, child: Text('갤러리에서 가져오기')),
      ],
    );
  }
}
