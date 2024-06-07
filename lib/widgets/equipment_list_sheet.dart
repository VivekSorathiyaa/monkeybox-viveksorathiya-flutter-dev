import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/equipment.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/exercise.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/muscle.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import '../utils/color.dart';
import '../widgets/shadow_container_widget.dart';

class EquipmentListSheet extends StatefulWidget {
  EquipmentListSheet();

  @override
  _EquipmentListSheetState createState() => _EquipmentListSheetState();
}

class _EquipmentListSheetState extends State<EquipmentListSheet> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<WorkoutProvider>(context, listen: false).loadEquipment();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<WorkoutProvider>(
        builder: (context, provider, child) {
          List<Equipment> displayedEquipment = provider.allEquipment;

          if (provider.selectedEquipment.isEmpty) {
            provider.selectedEquipment.add(provider.dummyEquipment);
          }

          return Container(
            height: MediaQuery.of(context).size.height / 1.4,
            decoration: BoxDecoration(
              color: primaryWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Filter by equipment",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: displayedEquipment.length,
                        itemBuilder: (context, index) {
                          var data = displayedEquipment[index];

                          var isContain =
                              provider.selectedEquipment.contains(data);
                          return InkWell(
                            onTap: () {
                              if (data == provider.dummyEquipment) {
                                provider.selectedEquipment.clear();
                              }
                              if (provider.selectedEquipment.isEmpty) {
                                provider.selectedEquipment
                                    .add(provider.dummyEquipment);
                              }
                              if (isContain &&
                                  data != provider.dummyEquipment) {
                                provider.selectedEquipment.remove(data);
                              } else {
                                provider.selectedEquipment.add(data);

                                provider.selectedEquipment
                                    .remove(provider.dummyEquipment);
                              }
                              provider.notifyListeners();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, right: 15, left: 15),
                              child: ShadowContainerWidget(
                                borderColor: isContain
                                    ? primaryOrange
                                    : Colors.transparent,
                                color: isContain
                                    ? primaryOrange.withOpacity(.1)
                                    : null,
                                widget: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                        maxLines: 1,
                                      ),
                                    ),
                                    isContain
                                        ? const Icon(
                                            CupertinoIcons
                                                .checkmark_square_fill,
                                            color: primaryOrange,
                                            size: 20,
                                          )
                                        : const Icon(
                                            CupertinoIcons.square,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                    const SizedBox(width: 12)
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            provider
                                .refreshEquipment(provider.selectedEquipment);
                            provider.filterExercises();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: primaryWhite,
                            backgroundColor: primaryBlack,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30), // Adjust the radius as needed
                            ),
                          ),
                          child: Text(
                            provider.selectedEquipment.length == 1
                                ? "Filter by \"${provider.selectedEquipment.first.name}\""
                                : "Filter by \"${provider.selectedEquipment.length} equipment\"",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
