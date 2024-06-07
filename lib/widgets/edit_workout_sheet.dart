import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/exercise.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/muscle.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/workout.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/utils/image_widget.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/widgets/exercise_detail_sheet.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import '../utils/color.dart';
import '../widgets/shadow_container_widget.dart';

class EditWorkoutSheet extends StatefulWidget {
  Workout workout;
  EditWorkoutSheet({required this.workout});

  @override
  _EditWorkoutSheetState createState() => _EditWorkoutSheetState();
}

class _EditWorkoutSheetState extends State<EditWorkoutSheet> {
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
          int totalSet = 0;
          for (var data in widget.workout.exerciseList) {
            for (var set in data.setList) {
              totalSet++;
            }
          }

          return Container(
            height: MediaQuery.of(context).size.height / 1.7,
            decoration: BoxDecoration(
              color: primaryWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.workout.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Text(
                      provider.selectedExercises.isNotEmpty
                          ? '${provider.finalExercises.length} exercises' +
                              (provider.finalExercises.isNotEmpty
                                  ? ', ${totalSet} sets'
                                  : '')
                          : 'Start by adding an exercise to customize a personal workout plan.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryBlack.withOpacity(.6))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(color: Colors.grey.withOpacity(.4)),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          itemCount: widget.workout.exerciseList.length,
                          itemBuilder: (context, index) {
                            var data = widget.workout.exerciseList[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  NetworkImageWidget(
                                    width: 40,
                                    height: 40,
                                    borderRadius: BorderRadius.circular(10),
                                    imageUrl: data.thumbImage,
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
                                            data.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            data.level,
                                            style: TextStyle(
                                                color: primaryBlack
                                                    .withOpacity(.5),
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                builder: (context) => ExerciseDetailSheet(
                                  workout: widget.workout,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              foregroundColor: primaryBlack,
                              backgroundColor: primaryLightGrey,
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
                              "Edit workout",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
