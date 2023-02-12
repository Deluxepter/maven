import 'package:Maven/feature/workout/template/model/template.dart';
import 'package:Maven/feature/workout/template/model/template_exercise_group.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'template_exercise_set',
  foreignKeys: [
    ForeignKey(
      childColumns: ['template_exercise_group_id'],
      parentColumns: ['template_exercise_group_id'],
      entity: TemplateExerciseGroup,
    ),
    ForeignKey(
      childColumns: ['template_id'],
      parentColumns: ['template_id'],
      entity: Template,
    ),
  ]
)
class TemplateExerciseSet {
  
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: 'template_exercise_set_id')
  int? templateExerciseSetId;

  @ColumnInfo(name: 'option_1')
  int option1;

  @ColumnInfo(name: 'option_2')
  int? option2;

  @ColumnInfo(name: 'template_exercise_group_id')
  int exerciseGroupId;

  @ColumnInfo(name: 'template_id')
  int templateId;

  TemplateExerciseSet({
    this.templateExerciseSetId,
    required this.option1,
    this.option2,
    required this.exerciseGroupId,
    required this.templateId,
  });

}