import 'package:actions_toolkit_dart/core.dart';
import 'package:flutterando_metrics/lint_analyzer.dart';
import 'package:github/github.dart';

import 'arguments.dart';
import 'github_checkrun_utils.dart';
import 'github_workflow_utils.dart';
import 'report_utils.dart';
import 'task.dart';

const _emptyLintConfig = LintConfig(
  excludePatterns: [],
  excludeForMetricsPatterns: [],
  metrics: {},
  rules: {},
  excludeForRulesPatterns: [],
  antiPatterns: {},
  shouldPrintConfig: false,
  analysisOptionsPath: null,
);

// ignore: long-parameter-list
Future<void> analyze(
  String packageName,
  String rootFolder,
  Iterable<String> foldersToAnalyze,
  GitHubCheckRunReporter reporter,
  GitHubWorkflowUtils workflowUtils,
  Arguments arguments,
) async {
  final checkRunUtils = GitHubCheckRunUtils(workflowUtils);

  const analyzer = LintAnalyzer();

  final report = await analyzer.runCliAnalysis(
    foldersToAnalyze,
    rootFolder,
    _emptyLintConfig,
  );

  final summary = analyzer.getSummary(report);

  final conclusion = isReportContainIssueWithTargetSeverity(
            report: report,
            severity: Severity.error,
          ) ||
          (arguments.fatalWarnings &&
              isReportContainIssueWithTargetSeverity(
                report: report,
                severity: Severity.warning,
              )) ||
          (arguments.fatalPerformance &&
              isReportContainIssueWithTargetSeverity(
                report: report,
                severity: Severity.performance,
              )) ||
          (arguments.fatalStyle &&
              isReportContainIssueWithTargetSeverity(
                report: report,
                severity: Severity.style,
              ))
      ? CheckRunConclusion.failure
      : CheckRunConclusion.success;

  reporter.report(
    conclusion: conclusion,
    output: CheckRunOutput(
      title: 'Analysis report for $packageName',
      summary: _generateSummary(report, summary),
      annotations: report
          .map(
            (file) => [...file.issues, ...file.antiPatternCases].map(
              (issue) => checkRunUtils.issueToAnnotation(file.path, issue),
            ),
          )
          .expand((issues) => issues)
          .toList(),
    ),
  );

  if (conclusion == CheckRunConclusion.failure) {
    setFailed(message: 'Found fatal issues!');
  }
}

String _generateSummary(
  Iterable<LintFileReport> report,
  Iterable<SummaryLintReportRecord<Object>> summary,
) {
  final issuesCount = report.fold<int>(
    0,
    (prevValue, fileReport) =>
        prevValue +
        fileReport.issues.length +
        fileReport.antiPatternCases.length,
  );

  final buffer = StringBuffer()..writeln('## Summary');

  for (final record in summary) {
    buffer
      ..writeln()
      ..writeln('* ${_summaryRecordToString(record)}');
  }

  buffer
    ..writeln()
    ..writeln('* Found issues: $issuesCount ${issuesCount > 0 ? '⚠' : '✅'}');

  return buffer.toString();
}

String _summaryRecordToString(SummaryLintReportRecord<Object?> record) {
  final buffer = StringBuffer()..write(record.title);

  final value = record.value;
  buffer.write(': ${_valueToString(value)}');

  if (record.violations > 0) {
    buffer.write(' / ${_valueToString(record.violations)}');
  }

  if (record.status != SummaryLintReportRecordStatus.none) {
    const statusMapping = {
      SummaryLintReportRecordStatus.ok: '✅',
      SummaryLintReportRecordStatus.warning: '⚠',
      SummaryLintReportRecordStatus.error: '❌',
    };

    buffer.write(' ${statusMapping[record.status]}');
  }

  return buffer.toString();
}

String _valueToString(Object? value) {
  if (value == null) {
    return '';
  }

  if (value is Iterable<Object>) {
    return value.map(_valueToString).join(', ');
  } else if (value is double) {
    return value.toStringAsFixed(2);
  }

  return value.toString();
}
