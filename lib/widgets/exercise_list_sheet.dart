import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/exercise.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/widgets/equipment_list_sheet.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/widgets/muscle_list_sheet.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import '../utils/color.dart';
import '../utils/image_widget.dart';
import '../widgets/shadow_container_widget.dart';

class ExerciseListSheet extends StatefulWidget {
  String exerciseName;
  ExerciseListSheet({required this.exerciseName});

  @override
  _ExerciseListSheetState createState() => _ExerciseListSheetState();
}

class _ExerciseListSheetState extends State<ExerciseListSheet> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutProvider>(context, listen: false).loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<WorkoutProvider>(
        builder: (context, provider, child) {
          List<Exercise> displayedExercises = provider.exercises;

          if (provider.searchQuery.isNotEmpty) {
            displayedExercises = provider.exercises
                .where((exercise) => exercise.name
                    .toLowerCase()
                    .contains(provider.searchQuery.toLowerCase()))
                .toList();
          }

          return Container(
            height: MediaQuery.of(context).size.height - 75,
            decoration: BoxDecoration(
              color: primaryWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            provider
                                .refreshExercies(provider.selectedExercises);
                            provider.notifyListeners();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Add',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Library",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: CupertinoSearchTextField(
                        onChanged: (value) {
                          provider.setSearchQuery(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  builder: (context) => MuscleListSheet(),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (!provider.finalMuscles
                                              .contains(provider.dummyMuscle) &&
                                          provider.finalMuscles.isNotEmpty)
                                      ? primaryBlack
                                      : primaryWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(.3),
                                    width: 1.0,
                                  ),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.menu,
                                      size: 18,
                                      color: (!provider.finalMuscles.contains(
                                                  provider.dummyMuscle) &&
                                              provider.finalMuscles.isNotEmpty)
                                          ? primaryWhite
                                          : primaryBlack,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: Text(
                                        (provider.finalMuscles.contains(
                                                    provider.dummyMuscle) ||
                                                provider.finalMuscles.isEmpty)
                                            ? 'All groups'
                                            : provider.finalMuscles.length == 1
                                                ? provider
                                                    .finalMuscles.first.name
                                                : "${provider.finalMuscles.length} muscles",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (!provider.finalMuscles
                                                      .contains(provider
                                                          .dummyMuscle) &&
                                                  provider
                                                      .finalMuscles.isNotEmpty)
                                              ? primaryWhite
                                              : primaryBlack,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.grey,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  builder: (context) => EquipmentListSheet(),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (!provider.finalEquipment.contains(
                                              provider.dummyEquipment) &&
                                          provider.finalEquipment.isNotEmpty)
                                      ? primaryBlack
                                      : primaryWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(.3),
                                    width: 1.0,
                                  ),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.menu,
                                      size: 18,
                                      color: (!provider.finalEquipment.contains(
                                                  provider.dummyEquipment) &&
                                              provider
                                                  .finalEquipment.isNotEmpty)
                                          ? primaryWhite
                                          : primaryBlack,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: Text(
                                        (provider.finalEquipment.contains(
                                                    provider.dummyEquipment) ||
                                                provider.finalEquipment.isEmpty)
                                            ? 'All equipment'
                                            : provider.finalEquipment.length ==
                                                    1
                                                ? provider
                                                    .finalEquipment.first.name
                                                : "${provider.finalEquipment.length} Equipment",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (!provider.finalEquipment
                                                      .contains(provider
                                                          .dummyEquipment) &&
                                                  provider.finalEquipment
                                                      .isNotEmpty)
                                              ? primaryWhite
                                              : primaryBlack,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.grey,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              provider.clearFilters();
                            },
                            child: const Text(
                              "Clear All Filters",
                              style: TextStyle(color: primaryOrange),
                            )),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: AlphabetScrollView(
                    itemExtent: 100,
                    list: displayedExercises
                        .map((e) => AlphaModel(e.name))
                        .toList(),
                    itemBuilder: (_, k, id) {
                      var isContain = provider.selectedExercises
                          .contains(displayedExercises[k]);
                      return InkWell(
                        onTap: () {
                          if (isContain) {
                            provider.selectedExercises
                                .remove(displayedExercises[k]);
                          } else {
                            provider.selectedExercises
                                .add(displayedExercises[k]);
                          }
                          provider.notifyListeners();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 13, right: 35, left: 15),
                          child: ShadowContainerWidget(
                            padding: 5,
                            borderColor:
                                isContain ? primaryOrange : Colors.transparent,
                            color: isContain
                                ? primaryOrange.withOpacity(.1)
                                : null,
                            widget: Row(
                              children: [
                                NetworkImageWidget(
                                  width: 50,
                                  height: 50,
                                  borderRadius: BorderRadius.circular(15),
                                  imageUrl: displayedExercises[k].thumbImage,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          displayedExercises[k].name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          displayedExercises[k].level,
                                          style: TextStyle(
                                              color:
                                                  primaryBlack.withOpacity(.5),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                isContain
                                    ? const Icon(
                                        CupertinoIcons.checkmark_square_fill,
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
                    selectedTextStyle: const TextStyle(color: primaryOrange),
                    unselectedTextStyle: TextStyle(color: primaryBlack),
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
