import 'package:flutterando_metrics/lint_analyzer.dart';

bool isReportContainIssueWithTargetSeverity({
  required Iterable<LintFileReport> report,
  required Severity severity,
}) =>
    report.any((file) => [
          ...file.antiPatternCases,
          ...file.issues,
        ].any((issue) => issue.severity == severity));
