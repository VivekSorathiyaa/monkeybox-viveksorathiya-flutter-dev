import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/helper/database_helper.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/main.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/set_model.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/workout.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/utils/color.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/utils/image_widget.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/widgets/exercise_list_sheet.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/widgets/reorder_exercises_sheet.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/widgets/shadow_container_widget.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';

class ExerciseDetailSheet extends StatefulWidget {
  Workout workout;
  ExerciseDetailSheet({required this.workout});

  @override
  _ExerciseDetailSheetState createState() => _ExerciseDetailSheetState();
}

class _ExerciseDetailSheetState extends State<ExerciseDetailSheet> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutProvider>(context, listen: false)
        .refreshExercies(widget.workout.exerciseList);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(builder: (context, provider, child) {
      int totalSet = 0;
      for (var data in provider.finalExercises) {
        for (var set in data.setList) {
          totalSet++;
        }
      }
      return SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height - 60,
          decoration: BoxDecoration(
            color: primaryWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                color: backgroundColor,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.workout.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await dbHelper
                              .updateWorkout(Workout(
                                  exerciseList: provider.finalExercises,
                                  name: widget.workout.name))
                              .whenComplete(() {
                            DatabaseHelper().getAllWorkouts(context);

                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text('Save',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
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
                        PopupMenuButton<String>(
                          onSelected: (String value) {
                            switch (value) {
                              case 'Edit name':
                                Navigator.of(context).pop();
                                _showCupertinoDialog(
                                    context: context,
                                    workout: Workout(
                                        exerciseList: provider.finalExercises,
                                        name: widget.workout.name));

                                // Handle edit name
                                break;
                              case 'Reorder exercises':
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  builder: (context) => ReorderExerciseSheet(),
                                );
                                // Handle reorder exercises
                                break;
                              case 'Delete workout':
                                // Handle delete workout
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Edit name',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Edit name'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Reorder exercises',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.reorder_sharp,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Reorder exercises'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Delete workout',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Delete workout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ];
                          },
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
                    const SizedBox(height: 30),
                    Column(
                      children: provider.finalExercises.map((exercise) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ShadowContainerWidget(
                            padding: 0,
                            blurRadius: 1,
                            widget: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ShadowContainerWidget(
                                        padding: 0,
                                        widget: NetworkImageWidget(
                                          imageUrl: exercise.thumbImage,
                                          width: 40,
                                          height: 40,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exercise.name,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              exercise.level,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: primaryBlack
                                                      .withOpacity(.6)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (String value) {
                                          provider.finalExercises
                                              .remove(exercise);
                                          provider.notifyListeners();
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return <PopupMenuEntry<String>>[
                                            const PopupMenuItem<String>(
                                              value: 'Delete workout',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Remove workout',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ];
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.withOpacity(.2),
                                ),
                                ...exercise.setList.map((set) {
                                  var indexOfExercise =
                                      provider.finalExercises.indexOf(exercise);
                                  var indexOfSet = provider
                                      .finalExercises[indexOfExercise].setList
                                      .indexOf(set);

                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            (exercise.setList.indexOf(set) + 1)
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          child: ShadowContainerWidget(
                                            padding: 0,
                                            blurRadius: 0,
                                            color: backgroundColor,
                                            widget: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      initialValue:
                                                          '${set.weight}',
                                                      onChanged: (value) {
                                                        provider
                                                            .finalExercises[
                                                                indexOfExercise]
                                                            .setList[indexOfSet]
                                                            .weight = value;
                                                        provider
                                                            .notifyListeners();
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: '0',
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    'kg',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          child: ShadowContainerWidget(
                                            padding: 0,
                                            blurRadius: 1,
                                            color: backgroundColor,
                                            widget: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        provider
                                                            .finalExercises[
                                                                indexOfExercise]
                                                            .setList[indexOfSet]
                                                            .reps = value;
                                                        provider
                                                            .notifyListeners();
                                                      },
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      initialValue:
                                                          '${set.reps}',
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: '0',
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    'reps',
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            exercise.setList.remove(set);
                                            provider.notifyListeners();
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            exercise.setList.add(
                                                SetModel(reps: '', weight: ''));
                                            provider.notifyListeners();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            foregroundColor: primaryBlack,
                                            backgroundColor: primaryLightGrey,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            textStyle: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: const Text('Add set'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                builder: (context) {
                                  return ExerciseListSheet(
                                    exerciseName: widget.workout.name,
                                  );
                                },
                              );
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
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Add exercise +'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await dbHelper.deleteWorkout(widget.workout.name);
                        await dbHelper.getAllWorkouts(context);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        foregroundColor: primaryOrange,
                        backgroundColor: primaryOrange.withOpacity(.1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: primaryOrange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Delete workout'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showCupertinoDialog(
      {required BuildContext context, required Workout workout}) {
    TextEditingController _textFieldController =
        TextEditingController(text: workout.name);
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Update workout name'),
          content: Column(
            children: <Widget>[
              const Text('update a name for this workout'),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _textFieldController,
                placeholder: 'update workout',
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () async {
                if (_textFieldController.text.isNotEmpty) {
                  await dbHelper
                      .updateWorkoutName(
                          workout, _textFieldController.text.toString())
                      .whenComplete(() {
                    DatabaseHelper().getAllWorkouts(context);

                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
