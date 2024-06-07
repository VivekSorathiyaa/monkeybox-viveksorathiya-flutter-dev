import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/exercise_list.dart';

class WorkoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MonkeyBox Fitness'),
      ),
      body: FutureBuilder(
        future: Provider.of<WorkoutProvider>(context, listen: false)
            .loadExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ExerciseList();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
