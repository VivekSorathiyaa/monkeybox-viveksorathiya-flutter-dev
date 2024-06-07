import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../screens/exercise_detail_screen.dart';

class ExerciseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.exercises.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                provider.exercises[index].name,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetailScreen(
                      exercise: provider.exercises[index],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
