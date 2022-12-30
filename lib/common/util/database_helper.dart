import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Maven/common/model/active_exercise_group.dart';
import 'package:Maven/common/model/active_exercise_set.dart';
import 'package:Maven/common/model/active_workout.dart';
import 'package:Maven/common/model/exercise.dart';
import 'package:Maven/common/model/exercise_group.dart';
import 'package:Maven/common/model/exercise_set.dart';
import 'package:Maven/common/model/workout.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

///
/// Helps with basic CRUD operations on database. Stored on users system.
///
class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    await deleteDatabase('testy125.db');
    String path = join(documentsDirectory.path, 'testy125.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<List<Exercise>> _loadExerciseJson() async {
    String jsonString = await rootBundle.loadString('assets/exercises.json');
    List<Map<String, dynamic>> jsonList = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    return jsonList.map((json) => Exercise.fromMap(json)).toList();
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercise (
        exerciseId INTEGER PRIMARY KEY,
        name TEXT,
        muscle TEXT,
        picture TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE workout (
        workoutId INTEGER PRIMARY KEY,
        name TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE exerciseGroup (
        exerciseGroupId INTEGER PRIMARY KEY,
        exerciseId INTEGER,
        workoutId INTEGER,
        FOREIGN KEY (exerciseId) REFERENCES exercise(exerciseId),
        FOREIGN KEY (workoutId) REFERENCES workout(workoutId)
      );
    ''');
    await db.execute('''
      CREATE TABLE exerciseSet (
        exerciseSetId INTEGER PRIMARY KEY,
        weight INTEGER,
        reps INTEGER,
        exerciseGroupId INTEGER,
        workoutId INTEGER,
        FOREIGN KEY (exerciseGroupId) REFERENCES exerciseGroup(exerciseGroupId),
        FOREIGN KEY (workoutId) REFERENCES workout(workoutId)
      );
    ''');

    await db.execute('''
      CREATE TABLE activeWorkout (
        activeWorkoutId INTEGER PRIMARY KEY,
        name TEXT,
        isPaused INTEGER
      );
    ''');
    await db.execute('''
      CREATE TABLE activeExerciseGroup (
        activeExerciseGroupId INTEGER PRIMARY KEY,
        exerciseId INTEGER,
        activeWorkoutId INTEGER,
        FOREIGN KEY (exerciseId) REFERENCES exercise(exerciseId),
        FOREIGN KEY (activeWorkoutId) REFERENCES activeWorkout(activeWorkoutId)
      );
    ''');
    await db.execute('''
      CREATE TABLE activeExerciseSet (
        activeExerciseSetId INTEGER PRIMARY KEY,
        weight INTEGER,
        reps INTEGER,
        activeExerciseGroupId INTEGER,
        activeWorkoutId INTEGER,
        FOREIGN KEY (activeExerciseGroupId) REFERENCES activeExerciseGroup(activeExerciseGroupId),
        FOREIGN KEY (activeWorkoutId) REFERENCES activeWorkout(activeWorkoutId)
      );
    ''');


    List<Exercise> exercises = await _loadExerciseJson();
    for (var exercise in exercises) {
      await db.execute(
        'INSERT INTO exercise (exerciseId, name, muscle, picture) VALUES (?, ?, ?, ?)',
        [exercise.exerciseId, exercise.name, exercise.muscle, exercise.picture],
      );
    }
  }

  ///
  ///
  ///
  /// CRUD for non-active models
  ///
  ///
  ///

  ///
  /// Workout Methods
  ///
  Future<int> addWorkout(Workout workout) async {
    Database db = await instance.database;
    return await db.insert('workout', workout.toMap());
  }

  Future<Workout?> getWorkout(int workoutId) async {
    final db = await instance.database;
    final workout = await db
        .query('workout', where: 'workoutId = ?', whereArgs: [workoutId]);
    return workout.isNotEmpty ? Workout.fromMap(workout.first) : null;
  }

  Future<List<Workout>> getWorkouts() async {
    Database db = await instance.database;
    var workouts = await db.query('workout', orderBy: 'name');
    List<Workout> workoutList = workouts.isNotEmpty
        ? workouts.map((c) => Workout.fromMap(c)).toList()
        : [];
    return workoutList;
  }

  Future<int> updateWorkout(Workout workout) async {
    final db = await instance.database;
    return await db.update(
      'workout',
      workout.toMap(),
      where: 'workoutId = ?',
      whereArgs: [workout.workoutId],
    );
  }

  Future<int> deleteWorkout(int id) async {
    final db = await instance.database;
    return await db.delete('workout', where: 'workoutId = ?', whereArgs: [id]);
  }

  ///
  /// Exercise methods
  ///
  Future<Exercise?> getExercise(int exerciseId) async {
    final db = await instance.database;
    final exercise = await db
        .query('exercise', where: 'exerciseId = ?', whereArgs: [exerciseId]);
    return exercise.isNotEmpty ? Exercise.fromMap(exercise.first) : null;
  }

  Future<List<Exercise>> getExercises() async {
    Database db = await instance.database;
    var exercises = await db.query('exercise');
    List<Exercise> exerciseList = exercises.isNotEmpty
        ? exercises.map((c) => Exercise.fromMap(c)).toList()
        : [];
    return exerciseList;
  }

  ///
  /// ExerciseGroup methods
  ///
  Future<int> addExerciseGroup(ExerciseGroup exerciseGroup) async {
    Database db = await instance.database;
    return await db.insert('exerciseGroup', exerciseGroup.toMap());
  }

  Future<List<ExerciseGroup>> getExerciseGroups() async {
    final db = await instance.database;
    final exerciseGroups = await db.query('exerciseGroup');
    return exerciseGroups.isNotEmpty
        ? exerciseGroups.map((c) => ExerciseGroup.fromMap(c)).toList()
        : [];
  }

  Future<List<ExerciseGroup>> getExerciseGroupsByWorkoutId(int workoutId) async {
    final db = await instance.database;
    var exerciseGroups = await db.query(
      'exerciseGroup',
      where: 'workoutId = ?',
      whereArgs: [workoutId],
    );
    List<ExerciseGroup> exerciseGroupList = exerciseGroups.isNotEmpty
        ? exerciseGroups.map((c) => ExerciseGroup.fromMap(c)).toList()
        : [];
    return exerciseGroupList;
  }

  Future<int> deleteExerciseGroup(int id) async {
    final db = await instance.database;
    return await db
        .delete('exerciseGroup', where: 'exerciseGroupId = ?', whereArgs: [id]);
  }

  Future<void> deleteExerciseGroupsByWorkoutId(int workoutId) async {
    final db = await instance.database;
    List<Map<String, dynamic>> exerciseGroups = await db
        .query('exerciseGroup', where: 'workoutId = ?', whereArgs: [workoutId]);
    for (var exerciseGroup in exerciseGroups) {
      await deleteExerciseGroup(exerciseGroup['exerciseGroupId']);
    }
  }

  ///
  /// ExerciseSet methods
  ///
  Future<void> addExerciseSet(ExerciseSet exerciseSet) async {
    Database db = await instance.database;
    await db.insert('exerciseSet', exerciseSet.toMap());
  }

  Future<List<ExerciseSet>> getExerciseSets() async {
    final db = await instance.database;
    final exerciseSets = await db.query('exerciseSet');
    return exerciseSets.isNotEmpty
        ? exerciseSets.map((c) => ExerciseSet.fromMap(c)).toList()
        : [];
  }

  Future<List<ExerciseSet>> getExerciseSetsByExerciseGroupId(int exerciseGroupId) async {
    final db = await instance.database;
    var exerciseSets = await db.query(
      'exerciseSet',
      where: 'exerciseGroupId = ?',
      whereArgs: [exerciseGroupId],
    );
    List<ExerciseSet> exerciseSetList = exerciseSets.isNotEmpty
        ? exerciseSets.map((c) => ExerciseSet.fromMap(c)).toList()
        : [];
    return exerciseSetList;
  }

  Future<void> deleteExerciseSetsByWorkoutId(int workoutId) async {
    final db = await instance.database;
    List<Map<String, dynamic>> exerciseSets = await db
        .query('exerciseSet', where: 'workoutId = ?', whereArgs: [workoutId]);
    for (var exerciseSet in exerciseSets) {
      await deleteExerciseSet(exerciseSet['exerciseSetId']);
    }
  }

  Future<int> deleteExerciseSet(int exerciseSetId) async {
    final db = await instance.database;
    return await db.delete('exerciseSet',
        where: 'exerciseSetId = ?', whereArgs: [exerciseSetId]);
  }

  ///
  ///
  ///
  /// CRUD for active models
  ///
  ///
  ///

  ///
  /// activeWorkout
  ///
  Future<int> addActiveWorkout(ActiveWorkout activeWorkout) async {
    final db = await instance.database;
    return await db.insert('activeWorkout', activeWorkout.toMap());
  }

  Future<ActiveWorkout?> getActiveWorkout(int activeWorkoutId) async {
    final db = await instance.database;
    final activeWorkout = await db.query('activeWorkout', where: 'activeWorkoutId = ?', whereArgs: [activeWorkoutId]);
    return activeWorkout.isNotEmpty ? ActiveWorkout.fromMap(activeWorkout.first) : null;
  }

  Future<List<ActiveWorkout>> getActiveWorkouts() async {
    final db = await instance.database;
    var activeWorkouts = await db.query('activeWorkout', orderBy: 'name');
    List<ActiveWorkout> activeWorkoutList = activeWorkouts.isNotEmpty
        ? activeWorkouts.map((c) => ActiveWorkout.fromMap(c)).toList()
        : [];
    return activeWorkoutList;
  }

  Future<List<ActiveWorkout>> getPausedActiveWorkouts() async {
    final db = await instance.database;
    var activeWorkouts = await db.query(
      'activeWorkout',
      where: 'isPaused = ?',
      whereArgs: [1],
    );
    List<ActiveWorkout> activeWorkoutList = activeWorkouts.isNotEmpty
        ? activeWorkouts.map((c) => ActiveWorkout.fromMap(c)).toList()
        : [];
    return activeWorkoutList;
  }

  Future<void> updateActiveWorkout(ActiveWorkout activeWorkout) async {
    final db = await instance.database;
    await db.update(
      'activeWorkout',
      activeWorkout.toMap(),
      where: 'activeWorkoutId = ?',
      whereArgs: [activeWorkout.activeWorkoutId],
    );
  }

  Future<int> deleteActiveWorkout(int activeWorkoutId) async {
    final db = await instance.database;
    return await db.delete('activeWorkout', where: 'activeWorkoutId = ?', whereArgs: [activeWorkoutId]);
  }

  ///
  /// activeExerciseGroup
  ///
  Future<int> addActiveExerciseGroup(ActiveExerciseGroup activeExerciseGroup) async {
    final db = await instance.database;
    return await db.insert('activeExerciseGroup', activeExerciseGroup.toMap());
  }

  Future<List<ActiveExerciseGroup>> getActiveExerciseGroups() async {
    Database db = await instance.database;
    var activeExerciseGroups = await db.query('activeExerciseGroup');
    List<ActiveExerciseGroup> activeExerciseGroupList = activeExerciseGroups.isNotEmpty
        ? activeExerciseGroups.map((c) => ActiveExerciseGroup.fromMap(c)).toList()
        : [];
    return activeExerciseGroupList;
  }

  Future<List<ActiveExerciseGroup>> getActiveExerciseGroupsByActiveWorkoutId(int activeWorkoutId) async {
    final db = await instance.database;
    var activeExerciseGroups = await db.query(
      'activeExerciseGroup',
      where: 'activeWorkoutId = ?',
      whereArgs: [activeWorkoutId],
    );
    List<ActiveExerciseGroup> activeExerciseGroupList = activeExerciseGroups.isNotEmpty
        ? activeExerciseGroups.map((c) => ActiveExerciseGroup.fromMap(c)).toList()
        : [];
    return activeExerciseGroupList;
  }

  Future<int> deleteActiveExerciseGroup(int activeExerciseGroupId) async {
    final db = await instance.database;
    return await db.delete('activeExerciseGroup',
        where: 'activeExerciseGroupId = ?', whereArgs: [activeExerciseGroupId]);
  }

  Future<void> deleteActiveExerciseGroupsByActiveWorkoutId(int activeWorkoutId) async {
    final db = await instance.database;
    List<Map<String, dynamic>> activeExerciseGroups = await db
        .query('activeExerciseGroup', where: 'activeWorkoutId = ?', whereArgs: [activeWorkoutId]);
    for (var activeExerciseGroup in activeExerciseGroups) {
      await deleteActiveExerciseGroup(activeExerciseGroup['activeExerciseGroupId']);
    }
  }

  ///
  /// activeExerciseSet
  ///
  Future<int> addActiveExerciseSet(ActiveExerciseSet activeExerciseSet) async {
    final db = await instance.database;
    return await db.insert('activeExerciseSet', activeExerciseSet.toMap());
  }

  Future<List<ActiveExerciseSet>> getActiveExerciseSets() async {
    final db = await instance.database;
    var activeExerciseSets = await db.query('activeExerciseSet');
    List<ActiveExerciseSet> activeExerciseSetList = activeExerciseSets.isNotEmpty
        ? activeExerciseSets.map((c) => ActiveExerciseSet.fromMap(c)).toList()
        : [];
    return activeExerciseSetList;
  }

  Future<List<ActiveExerciseSet>> getActiveExerciseSetsByActiveExerciseGroupId(int activeExerciseGroupId) async {
    final db = await instance.database;
    var activeExerciseSets = await db.query(
      'activeExerciseSet',
      where: 'activeExerciseGroupId = ?',
      whereArgs: [activeExerciseGroupId],
    );
    List<ActiveExerciseSet> activeExerciseSetsList = activeExerciseSets.isNotEmpty
        ? activeExerciseSets.map((c) => ActiveExerciseSet.fromMap(c)).toList()
        : [];
    return activeExerciseSetsList;
  }

  Future<int> deleteActiveExerciseSet(int activeExerciseSetId) async {
    final db = await instance.database;
    return await db.delete('activeExerciseSet',
        where: 'activeExerciseSetId = ?', whereArgs: [activeExerciseSetId]);
  }

  Future<void> deleteActiveExerciseSetsByActiveWorkoutId(int activeWorkoutId) async {
    final db = await instance.database;
    List<Map<String, dynamic>> activeExerciseSets = await db
        .query('activeExerciseSet', where: 'activeWorkoutId = ?', whereArgs: [activeWorkoutId]);
    log(activeExerciseSets.length.toString());
    for (var activeExerciseSet in activeExerciseSets) {
      await deleteActiveExerciseSet(activeExerciseSet['activeExerciseSetId']);
    }
  }

  ///
  /// other
  ///
  Future<int> generateActiveWorkoutTemplate(int workoutId) async {
    Workout? workout = await getWorkout(workoutId);
    ActiveWorkout activeWorkout = ActiveWorkout.workoutToActiveWorkout(workout!);
    int activeWorkoutId = await addActiveWorkout(activeWorkout);

    List<ExerciseGroup> exerciseGroups = await getExerciseGroupsByWorkoutId(workoutId);
    for (var exerciseGroup in exerciseGroups) {
      int activeExerciseGroupId = await addActiveExerciseGroup(ActiveExerciseGroup.exerciseGroupToActiveExerciseGroup(exerciseGroup, activeWorkoutId));

      List<ExerciseSet> exerciseSets = await getExerciseSetsByExerciseGroupId(exerciseGroup.exerciseGroupId!);
      for(var exerciseSet in exerciseSets){
        addActiveExerciseSet(ActiveExerciseSet.exerciseSetToActiveExerciseSet(exerciseSet, activeExerciseGroupId, activeWorkoutId));
      }
    }

    return activeWorkoutId;
  }
}