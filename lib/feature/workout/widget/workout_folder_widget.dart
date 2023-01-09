import 'package:Maven/common/model/workout.dart';
import 'package:Maven/common/model/workout_folder.dart';
import 'package:Maven/feature/workout/bloc/workout/workout_bloc.dart';
import 'package:Maven/feature/workout/widget/workout_card_widget.dart';
import 'package:Maven/theme/m_themes.dart';
import 'package:Maven/widget/m_flat_button.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutFolderWidget extends StatefulWidget {
  final WorkoutFolder workoutFolder;
  final List<Workout> workouts;

  const WorkoutFolderWidget({Key? key,
    required this.workoutFolder,
    required this.workouts
  }) : super(key: key);

  @override
  State<WorkoutFolderWidget> createState() => _WorkoutFolderWidgetState();
}

class _WorkoutFolderWidgetState extends State<WorkoutFolderWidget> {
  final double borderRadius = 15;

  final ExpandableController _expandableController = ExpandableController();

  @override
  void initState() {
    super.initState();
    if(widget.workoutFolder.expanded == 1){
      _expandableController.toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    _expandableController.addListener(() {
      WorkoutFolder workoutFolder = widget.workoutFolder;
      workoutFolder.expanded = _expandableController.expanded ? 1 : 0;
      context.read<WorkoutBloc>().add(UpdateWorkoutFolder(
        workoutFolder: workoutFolder
      ));
    });
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: 1,
          color: mt(context).workoutFolder.borderColor,
        )
      ),
      child: Material(
        color: mt(context).workoutFolder.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: (){
            setState(() {
              if(!_expandableController.expanded) {
                _expandableController.toggle();
              }
            });
          },
          borderRadius: BorderRadius.circular(borderRadius),
          child: ExpandablePanel(
            controller: _expandableController,
            theme: ExpandableThemeData(
              iconColor: mt(context).accentColor,
              iconPlacement: ExpandablePanelIconPlacement.right,
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              iconPadding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
              inkWellBorderRadius: BorderRadius.circular(borderRadius),
              iconSize: 30,
              useInkWell: false
            ),
            header: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: const EdgeInsets.fromLTRB(12, 12, 0, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.workoutFolder.name,
                    style: TextStyle(
                      color: mt(context).text.primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child : Material(
                        color: Colors.transparent,
                        child : InkWell(
                          child : Padding(
                            padding : const EdgeInsets.all(5),
                            child : Icon(
                              Icons.more_horiz,
                              color: mt(context).icon.accentColor,
                            ),
                          ),
                          onTap : () {
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            collapsed: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 18),
              child: Text(
                '${widget.workouts.length.toString()} workouts',
                style: TextStyle(
                  color: mt(context).text.primaryColor,
                  fontSize: 16
                ),
              ),
            ),
            expanded: widget.workouts.isNotEmpty ? Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: ReorderableListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                proxyDecorator: proxyDecorator,
                children: widget.workouts.map((workout) {
                  return Padding(
                    key: UniqueKey(),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                    child: WorkoutCard(
                      workout: workout,
                    ),
                  );
                }).toList(),
                onReorder: (oldIndex, newIndex) => _reorder(oldIndex, newIndex),
              ),
            ) : Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Icon(
                    Icons.folder_copy_rounded,
                    color: mt(context).icon.secondaryColor,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Text(
                      'This folder is empty.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mt(context).text.secondaryColor
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        MFlatButton(
                          text: Text(
                            'Create New',
                            style: TextStyle(
                              color: mt(context).text.primaryColor
                            ),
                          ),
                          borderColor: mt(context).borderColor,
                          onPressed: (){},
                        ),
                        const SizedBox(width: 16,),
                        MFlatButton(
                          text: Text(
                            'Move Existing',
                            style: TextStyle(
                              color: mt(context).text.primaryColor
                            ),
                          ),
                          borderColor: mt(context).borderColor,
                          onPressed: (){},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// Functions
  ///

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      List<Workout> workouts = widget.workouts;

      final Workout item = workouts.elementAt(oldIndex);
      workouts.removeAt(oldIndex);
      workouts.insert(newIndex, item);

      context.read<WorkoutBloc>().add(ReorderWorkouts(
        workouts: workouts
      ));
    });
  }

  ///
  /// Widgets
  ///

  /// Creates a shadow underneath item when reordering.
  /// Accounts for padding.
  ///
  /// [Source](https://github.com/flutter/flutter/issues/76706#issuecomment-986181379)
  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 12,
                child: Material(
                  borderRadius: BorderRadius.circular(borderRadius),
                  elevation: 5,
                  shadowColor: mt(context).workoutFolder.dragShadowColor,
                ),
              ),
              child!,
            ],
          ),
        );
      },
      child: child,
    );
  }
}