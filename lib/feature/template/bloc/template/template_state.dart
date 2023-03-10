part of 'template_bloc.dart';

enum TemplateStatus {
  error,
  loading,
  loaded,
  add,
  update,
  delete,
  reorder,
  toggle,
}

class TemplateState extends Equatable {
  const TemplateState({
    this.status = TemplateStatus.loading,
    this.statusMessage = "",
    this.templates = const [],
    this.templateFolders = const [],
  });

  final TemplateStatus status;
  final String statusMessage;
  final List<Template> templates;
  final List<TemplateFolder> templateFolders;

  TemplateState copyWith({
    TemplateStatus Function()? status,
    String Function()? statusMessage,
    List<Template> Function()? templates,
    List<TemplateFolder> Function()? templateFolders,
  }) {
    return TemplateState(
      status: status != null ? status() : this.status,
      statusMessage: statusMessage != null ? statusMessage() : this.statusMessage,
      templates: templates != null ? templates() : this.templates,
      templateFolders: templateFolders != null ? templateFolders() : this.templateFolders,
    );
  }

  @override
  List<Object?> get props => [
    status,
    statusMessage,
    templates,
    templateFolders,
  ];
}