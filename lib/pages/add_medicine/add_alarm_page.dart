import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_check/components/dory_colors.dart';
import 'package:medicine_check/components/dory_constants.dart';
import 'package:medicine_check/components/dory_widgets.dart';
import 'package:medicine_check/pages/add_medicine/components/add_page_widget.dart';
import 'package:medicine_check/sesrvices/add_medicine_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      {Key? key, required this.medicineImage, required this.medicineName})
      : super(key: key);
  final File? medicineImage;
  final String medicineName;

  final service = AddMedicineService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: AddPageBody(
        children: [
          Text(
            '매일 복약 잊지 말아요!',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            height: largeSpace,
          ),
          Expanded(
              child: AnimatedBuilder(
                animation: service,
                builder: (context,_) {
                  return ListView(
            children: alarmWidgets,
          );
                },
              )),
        ],
      ),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () {
          // 1. add alarm
          Navigator.pop(context);
          showPermissionDenied(context, permission: '알람');
          // 2. save image (local dir)
          // 3. add medicine model (local DB, hive)


        },
        text: '완료',
      ),
    );
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    children.addAll(
      service.alarms.map(
        (alarmTime) => AlarmBox(
          time: alarmTime,
          service: service,
        ),
      ),
    );
    children.add(AddAlarmButton(
      service: service,
    ));
    return children;
  }
}

class AlarmBox extends StatelessWidget {
  AlarmBox({Key? key, required this.time, required this.service})
      : super(key: key);

  final String time;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: (){service.removeAlarm(time);},
                icon: Icon(CupertinoIcons.minus_circle))),
        Expanded(
            flex: 5,
            child: TextButton(
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle2),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return TimePickerBottomSheet(service: service, initialTime: time,);
                      });
                },
                child: Text(time))),
      ],
    );
  }
}

class TimePickerBottomSheet extends StatelessWidget {
  TimePickerBottomSheet({
    Key? key, required this.initialTime, required this.service,
  }) : super(key: key);

  final String initialTime;
  final AddMedicineService service;
  DateTime? _setDateTime;
  @override
  Widget build(BuildContext context) {
    final initialDateTime = DateFormat('HH:mm').parse(initialTime);

    return BottomSheetBody(children: [
      SizedBox(
        height: 200,
        child: CupertinoDatePicker(
          onDateTimeChanged: (dateTime) {
            _setDateTime = dateTime;
          },
          mode: CupertinoDatePickerMode.time,
          initialDateTime: initialDateTime,
        ),
      ),
      SizedBox(
        height: regularSpace,
      ),
      Row(
        children: [
          Expanded(
              child: SizedBox(
                  height: submitButtonHeight,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.subtitle1,
                          primary: Colors.white,
                          onPrimary: DoryColors.primaryColor),
                      onPressed: () => Navigator.pop(context),
                      child: Text('취소')))),
          SizedBox(
            width: smallSpace,
          ),
          Expanded(
              child: SizedBox(
                  height: submitButtonHeight,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.subtitle1),
                      onPressed: () {
                        service.setAlarm(prevTime: initialTime, setTime: _setDateTime ?? initialDateTime);
                        Navigator.pop(context);
                      },
                      child: Text('선택')))),
        ],
      )
    ]);
  }
}

class AddAlarmButton extends StatelessWidget {
  AddAlarmButton({Key? key, required this.service}) : super(key: key);

  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: service.addNowAlarm,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.plus_circle_fill))),
          Expanded(
              flex: 5,
              child: TextButton(onPressed: service.addNowAlarm, child: Text('복용시간 추가'))),
        ],
      ),
    );
  }
}
