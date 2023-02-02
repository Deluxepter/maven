import 'package:floor/floor.dart';

import '../../../../common/model/workout_exercise_set.dart';

@dao
abstract class WorkoutExerciseSetDao {

  @insert
  Future<int> addWorkoutExerciseSet(WorkoutExerciseSet workoutExerciseSet);

  @Query('SELECT * FROM workout_exercise_set')
  Future<List<WorkoutExerciseSet>> getWorkoutExerciseSets();

  @Query('SELECT * FROM workout_exercise_set WHERE workout_exercise_group_id = :workoutExerciseGroupId')
  Future<List<WorkoutExerciseSet>> getWorkoutExerciseSetsByWorkoutExerciseGroupId(int workoutExerciseGroupId);

  @update
  Future<void> updateWorkoutExerciseSet(WorkoutExerciseSet workoutExerciseSet);

  @Query('DELETE * FROM workout_exercise_set WHERE workout_exercise_set_id = :workoutExerciseSetId')
  Future<void> deleteWorkoutExerciseSet(int workoutExerciseSetId);

  @Query('DELETE * FROM workout_exercise_set WHERE workout_id = :workoutId')
  Future<void> deleteWorkoutExerciseSetsByWorkoutId(int workoutId);

}