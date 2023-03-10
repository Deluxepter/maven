import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

import 'template_folder.dart';

@Entity(
  tableName: 'template',
  foreignKeys: [
    ForeignKey(
      childColumns: ['template_folder_id'],
      parentColumns: ['template_folder_id'],
      entity: TemplateFolder
    )
  ],
  primaryKeys: [
    'template_id',
  ],
)
class Template extends Equatable {
  @ColumnInfo(name: 'template_id')
  @PrimaryKey(autoGenerate: true)
  final int? templateId;

  @ColumnInfo(name: 'name')
  final String name;

  @ColumnInfo(name: 'sort_order')
  final int? sortOrder;

  @ColumnInfo(name: 'template_folder_id')
  final int? templateFolderId;

  const Template({
    this.templateId,
    required this.name,
    this.sortOrder,
    this.templateFolderId,
  });

  Template copyWith({
    int? templateId,
    String? name,
    int? sortOrder,
    int? templateFolderId,
  }) {
    return Template(
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      templateFolderId: templateFolderId ?? this.templateFolderId,
    );
  }

  @override
  List<Object?> get props => [templateId, name, sortOrder, templateFolderId];
}