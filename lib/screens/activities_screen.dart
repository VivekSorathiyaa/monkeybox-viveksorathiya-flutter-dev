import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/helper/database_helper.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/main.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/models/workout.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/utils/color.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/widgets/edit_workout_sheet.dart';
import 'package:monkeybox_viveksorathiya_flutter_dev/widgets/shadow_container_widget.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/exercise_detail_sheet.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    widgetList = [
      const Center(child: Text('Home')),
      const Center(child: Text('Journal')),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Loading exercises here instead of initState
    Provider.of<WorkoutProvider>(context, listen: false).loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        shadowColor: lightGreyColor,
        title: const Text('Activities',
            style: TextStyle(fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          dividerColor: lightGreyColor,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Workout plans'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: BouncingScrollPhysics(),
        children: [
          const Center(child: Text('Overview Content')),
          WorkoutPlansTab(),
        ],
      ),
    );
  }
}

class WorkoutPlansTab extends StatefulWidget {
  @override
  State<WorkoutPlansTab> createState() => _WorkoutPlansTabState();
}

class _WorkoutPlansTabState extends State<WorkoutPlansTab> {
  @override
  void initState() {
    super.initState();
    DatabaseHelper().getAllWorkouts(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Strength Training',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Text('${provider.allWorkout.length} workouts',
                    style: TextStyle(
                        fontSize: 14,
                        color: primaryBlack.withOpacity(.4),
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
              itemCount: provider.allWorkout.length,
              itemBuilder: (context, index) {
                Workout workout = provider.allWorkout[index];

                int totalSet = 0;
                for (var data in workout.exerciseList) {
                  for (var set in data.setList) {
                    totalSet++;
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ShadowContainerWidget(
                    padding: 0,
                    widget: ListTile(
                      title: Text(
                        workout.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${workout.exerciseList.length} exercises${workout.exerciseList.isNotEmpty ? ', ${totalSet} sets' : ''}',
                        style: TextStyle(
                            fontSize: 12,
                            color: primaryBlack.withOpacity(.6),
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.grey,
                      ),
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
                          builder: (context) => EditWorkoutSheet(
                            workout: workout,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showCupertinoDialog(context);
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
                    child: const Text('Add workout plan +'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _showCupertinoDialog(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();
    showCupertinoDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Workout name'),
          content: Column(
            children: <Widget>[
              const Text('Enter a name for this workout'),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _textFieldController,
                placeholder: 'New workout',
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
                String enteredText = _textFieldController.text;
                print('Entered Text: $enteredText');
                if (_textFieldController.text.isNotEmpty) {
                  await dbHelper
                      .insertWorkout(
                          Workout(exerciseList: [], name: enteredText))
                      .whenComplete(() {
                    DatabaseHelper().getAllWorkouts(context);

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
                        workout: Workout(exerciseList: [], name: enteredText),
                      ),
                    );
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
