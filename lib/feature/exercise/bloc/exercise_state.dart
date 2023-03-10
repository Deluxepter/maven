part of 'exercise_bloc.dart';

enum ExerciseStatus {
  error,
  loading,
  loaded,
}

class ExerciseState extends Equatable {
  const ExerciseState({
    this.status = ExerciseStatus.loading,
    this.exercises = const [],
  });

  final ExerciseStatus status;
  final List<Exercise> exercises;

  ExerciseState copyWith({
    ExerciseStatus Function()? status,
    List<Exercise> Function()? exercises,
  }) {
    return ExerciseState(
      status: status != null ? status() : this.status,
      exercises: exercises != null ? exercises() : this.exercises,
    );
  }

  @override
  List<Object?> get props => [
    status,
    exercises
  ];
}