import 'package:Maven/feature/workout/bloc/workout/workout_bloc.dart';
import 'package:Maven/widget/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../common/model/workout.dart';
import '../../../common/theme/app_themes.dart';
import '../../../screen/add_exercise_screen.dart';
import '../../../widget/custom_app_bar.dart';
import '../model/exercise_block.dart';
import '../widget/exercise_block_widget.dart';

class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  List<ExerciseBlockData> exerciseBlocks = List.empty(growable: true);
  final workoutTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold.build(
      context: context,
      appBar: CustomAppBar.build(
        title: 'Create Workout',
        context: context,
        actions: [
          TextButton(
              onPressed: _createWorkout,
              child: Text(
                'Save',
                style: TextStyle(color: colors(context).accentTextColor),
              )
          ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: workoutTitleController,
            decoration: const InputDecoration(
                hintText: 'Workout title'
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exerciseBlocks.length,
              itemBuilder: (BuildContext context, int index) {
                ExerciseBlockData exerciseBlockData = exerciseBlocks[index];
                return ExerciseBlockWidget(
                  exerciseBlockData: exerciseBlockData,
                  onChanged: (exerciseBlockData) {
                    exerciseBlocks[index] = exerciseBlockData;
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createWorkout() {
    if (workoutTitleController.text.isEmpty) {
      const snackBar = SnackBar(
        content: Text('Enter a workout title'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    context.read<WorkoutBloc>().add(
        AddWorkout(
            workout: Workout(name: workoutTitleController.text),
            exerciseBlocks: exerciseBlocks
        )
    );

    Navigator.pop(context);
  }

  void _addExercise() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddExerciseScreen())
    ).then((exercise) {
      setState(() {
        exerciseBlocks.add(
            ExerciseBlockData(
                exercise: exercise,
                sets: List.empty(growable: true)
            )
        );
      });
    });
  }
}