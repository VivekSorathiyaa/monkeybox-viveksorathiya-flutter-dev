import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/exercise.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/muscle.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import '../utils/color.dart';
import '../widgets/shadow_container_widget.dart';

class MuscleListSheet extends StatefulWidget {
  MuscleListSheet();

  @override
  _MuscleListSheetState createState() => _MuscleListSheetState();
}

class _MuscleListSheetState extends State<MuscleListSheet> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<WorkoutProvider>(context, listen: false).loadMuscles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<WorkoutProvider>(
        builder: (context, provider, child) {
          List<Muscle> displayedMuscles = provider.allMuscles;

          if (provider.selectedMuscles.isEmpty) {
            provider.selectedMuscles.add(provider.dummyMuscle);
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Filter by muscle group",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: displayedMuscles.length,
                        itemBuilder: (context, index) {
                          var data = displayedMuscles[index];

                          var isContain =
                              provider.selectedMuscles.contains(data);
                          return InkWell(
                            onTap: () {
                              if (data == provider.dummyMuscle) {
                                provider.selectedMuscles.clear();
                              }
                              if (provider.selectedMuscles.isEmpty) {
                                provider.selectedMuscles
                                    .add(provider.dummyMuscle);
                              }
                              if (isContain && data != provider.dummyMuscle) {
                                provider.selectedMuscles.remove(data);
                              } else {
                                provider.selectedMuscles.add(data);

                                provider.selectedMuscles
                                    .remove(provider.dummyMuscle);
                              }
                              // ignore: invalid_use_of_protected_member
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
                            provider.refreshMuscle(provider.selectedMuscles);
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
                            provider.selectedMuscles.length == 1
                                ? "Filter by \"${provider.selectedMuscles.first.name}\""
                                : "Filter by \"${provider.selectedMuscles.length} muscles\"",
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
