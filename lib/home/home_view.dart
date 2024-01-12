// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:rfid_access_management_app/home/home_controller.dart';
import 'package:rfid_access_management_app/home/home_model.dart';
import 'package:rfid_access_management_app/widget/custom_button.dart';
import 'package:rfid_access_management_app/widget/custom_textfield.dart';
import 'package:timer_builder/timer_builder.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = Get.put(HomepageController());

  String formatDate(DateTime dateTime) {
    // Create a custom date format
    final customFormat = DateFormat("d 'of' MMM, y");

    // Format the DateTime object using the custom format
    return customFormat.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    if (_controller.accessDataList.isEmpty == true) {
      _controller.getAccessData();
    } else {
      _controller.refreshData();
    }
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[700],
        unselectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (value) {
          print("Value: $value");
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_25),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.document_upload5),
            label: "",
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          selectedIndex == 0 ? "Home" : "Create",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: GetBuilder<HomepageController>(
        init: HomepageController(),
        builder: (_) {
          return selectedIndex == 0 ? _buildHomePage() : _buildCreatePage();
        },
      ),
    );
  }

  _buildHomePage() {
    if (_controller.loading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return TimerBuilder.periodic(
        const Duration(minutes: 1),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
            child: ListView.builder(
              reverse: false,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _controller.accessDataList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Colors.teal,
                        width: 2,
                      ),
                    ),
                    // tileColor: Colors.teal.withOpacity(0.3),
                    title: Row(
                      children: [
                        Text(
                          "${_controller.accessDataList[index].holderName ?? ""} ",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "(${_controller.accessDataList[index].id ?? ""})",
                        ),
                      ],
                    ),
                    subtitle: Text(
                      _controller.accessDataList[index].isTimed == false
                          ? _controller.accessDataList[index].grantAccess ==
                                  true
                              ? "Access Granted Indefinitely"
                              : "Access Denied Indefinitely"
                          : "Access end time: ${formatDate(DateTime.fromMicrosecondsSinceEpoch(_controller.accessDataList[index].endTime!))}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _controller.accessDataList[index].isTimed ==
                                false
                            ? _controller.accessDataList[index].grantAccess ==
                                    true
                                ? Colors.green
                                : Colors.red.shade700
                            : Colors.amber.shade800,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _showOptionsDialog(_controller.accessDataList[index]);
                      },
                      icon: const Icon(
                        Icons.edit_document,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }

  _showOptionsDialog(AccessDataModel accessData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    width: 300,
                    color: accessData.isTimed == false &&
                            accessData.grantAccess == true
                        ? Colors.red.shade800
                        : Colors.green,
                    child: Text(
                      accessData.isTimed == false &&
                              accessData.grantAccess == true
                          ? "Deny Access Indefinitely"
                          : "Grant Access Indefinitely",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      bool grantAccessState = accessData.grantAccess ?? true;

                      AccessDataModel updatedAccessData = accessData.copyWith(
                        isTimed: false,
                        grantAccess: !grantAccessState,
                      );
                      _controller.updateAccessData(updatedAccessData);
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    width: 300,
                    color: Colors.amber,
                    child: const Text(
                      "Set Access End Time",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      selectEndDateTime(accessData);
                    },
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  _buildCreatePage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          CustomTextfield(
            textEditingController: _controller.rfidController,
            labelText: 'RFID',
            hintText: 'Enter the holder\'s RFID',
          ),
          const SizedBox(height: 20),
          CustomTextfield(
            textEditingController: _controller.holderNameController,
            labelText: 'Holder Name',
            hintText: 'Enter the holder\'s name',
          ),
          const SizedBox(height: 60),
          _controller.loading == true
              ? const CircularProgressIndicator()
              : CustomButton(
                  width: 200,
                  color: Colors.amber[700],
                  child: const Text(
                    "Upload",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (_controller.rfidController.text.trim().isNotEmpty ==
                            true &&
                        _controller.holderNameController.text
                                .trim()
                                .isNotEmpty ==
                            true) {
                      _controller.uploadAccessData();
                    }
                  },
                ),
        ],
      ),
    );
  }

  selectEndDateTime(AccessDataModel accessData) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );

    if (dateTime != null) {
      // return dateTime;
      AccessDataModel updatedAccessData = accessData.copyWith(
          endTime: dateTime.microsecondsSinceEpoch, isTimed: true);
      _controller.updateAccessData(updatedAccessData);
      print("Updated time: $dateTime");
    } else {
      // return null;
      print("Null time: $dateTime");
    }
  }
}
