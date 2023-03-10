
enum ExerciseEquipment {
  assisted,
  band,
  barbell,
  bodyWeight,
  cable,
  dumbbell,
  kettleBell,
  machine,
  none,
  stretch,
  weighted,
}

extension ExerciseEquipmentExtension on ExerciseEquipment {
  int get exerciseEquipmentId {
    return index + 1;
  }

  String get name {
    return toString().split('.').last;
  }

  String get description {
    switch (this) {
      case ExerciseEquipment.assisted:
        return 'An assisted exercise machine provides support to the user during the exercise, allowing them to perform the movement with less resistance.';
      case ExerciseEquipment.band:
        return 'A band is a long, thin piece of elastic material that can be used for resistance training.';
      case ExerciseEquipment.barbell:
        return 'A barbell is a long bar with weight plates attached to either end, used for weight training.';
      case ExerciseEquipment.bodyWeight:
        return 'Body-weight exercises use the weight of the individuals own body as resistance, rather than using external weights or machines.';
      case ExerciseEquipment.cable:
        return 'A cable machine uses adjustable cable pulleys to provide resistance and allow for a wide variety of exercises.';
      case ExerciseEquipment.dumbbell:
        return 'Dumbbells are small, handheld weights that can be used for various exercises.';
      case ExerciseEquipment.kettleBell:
        return 'A kettle-bell is a cast iron weight shaped like a ball with a handle, used for exercises that combine cardiovascular, strength, and flexibility training.';
      case ExerciseEquipment.machine:
        return 'A machine is a piece of equipment designed to allow the user to perform one or more specific exercises, typically with adjustable resistance.';
      case ExerciseEquipment.none:
        return 'None refers to exercises that do not require any equipment.';
      case ExerciseEquipment.stretch:
        return 'Stretch exercises involve using the bodys flexibility to improve range of motion and reduce muscle tension.';
      case ExerciseEquipment.weighted:
        return 'Weighted exercises involve using external weights, such as dumbbells or a barbell, to increase the resistance of the exercise.';
    }
  }
}

ExerciseEquipment? getExerciseEquipmentById(int id) {
  for (ExerciseEquipment equipment in ExerciseEquipment.values) {
    if (equipment.exerciseEquipmentId == id) {
      return equipment;
    }
  }
  return null;
}