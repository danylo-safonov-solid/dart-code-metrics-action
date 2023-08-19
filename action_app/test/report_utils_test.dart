import 'package:action_app/report_utils.dart';
import 'package:flutterando_metrics/lint_analyzer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ReportMock extends Mock implements Report {}

void main() {
  test('isReportContainIssueWithTargetSeverity', () {
    final report = [
      LintFileReport(
        path: '',
        relativePath: '',
        file: ReportMock(),
        classes: {},
        functions: {},
        issues: [],
        antiPatternCases: [],
      ),
    ];

    expect(
      isReportContainIssueWithTargetSeverity(
        report: report,
        severity: Severity.error,
      ),
      isFalse,
    );
  });
}
