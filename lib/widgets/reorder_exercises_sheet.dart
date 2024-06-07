import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/exercise.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/muscle.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/utils/image_widget.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import '../utils/color.dart';
import '../widgets/shadow_container_widget.dart';

class ReorderExerciseSheet extends StatefulWidget {
  ReorderExerciseSheet();

  @override
  _ReorderExerciseSheetState createState() => _ReorderExerciseSheetState();
}

class _ReorderExerciseSheetState extends State<ReorderExerciseSheet> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<WorkoutProvider>(
        builder: (context, provider, child) {
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
                    "Reorder exercises",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    children: [
                      ReorderableListView(
                        children: [
                          for (final item in provider.selectedExercises)
                            Padding(
                              key: ValueKey(item),
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                bottom: 10,
                              ),
                              child: ShadowContainerWidget(
                                padding: 6,
                                blurRadius: 0,
                                widget: Row(
                                  children: [
                                    NetworkImageWidget(
                                      width: 40,
                                      height: 40,
                                      borderRadius: BorderRadius.circular(10),
                                      imageUrl: item.thumbImage,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                              maxLines: 1,
                                            ),
                                            Text(
                                              item.level,
                                              style: TextStyle(
                                                  color: primaryBlack
                                                      .withOpacity(.5),
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.reorder,
                                      color: primaryOrange,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12)
                                  ],
                                ),
                              ),
                            ),
                        ],
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            Exercise item =
                                provider.selectedExercises.removeAt(oldIndex);
                            provider.selectedExercises.insert(newIndex, item);
                          });
                        },
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: ElevatedButton(
                          onPressed: () {
                            provider
                                .refreshExercies(provider.selectedExercises);
                            provider.notifyListeners();

                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: primaryWhite,
                            backgroundColor: Colors.grey,
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
                            "Save",
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
