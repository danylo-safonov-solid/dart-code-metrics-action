@TestOn('vm')
import 'package:action_app/pubspec.dart';
import 'package:test/test.dart';

const _dartPackage = [
  'name: action_app',
  'version: 1.0.0',
  'description: Github action app that helps to run flutterando_metrics in CI/CD flow.',
  'homepage: https://github.com/Flutterando/flutterando-metrics-action',
  'issue_tracker: https://github.com/Flutterando/flutterando-metrics-action/issues',
  'publish_to: none',
  '',
  'environment:',
  '  sdk: ">=2.12.0 <3.0.0"',
  '',
  'dependencies:',
  '  flutterando_metrics: ^4.0.0-dev.5',
  '  github: ^8.1.0',
  '  meta: ^1.4.0',
  '  path: ^1.8.0',
  '',
  'dev_dependencies:',
  '  coverage: ^1.0.2',
  '  mocktail: ^0.1.4',
  '  pedantic: ^1.11.0',
  '  source_span: ^1.8.0',
  '  test: ^1.17.3',
];

const _flutterPackage = [
  'name: mwwm',
  'version: 2.0.0',
  'description: |',
  '  Software architecture pattern for teams with different sizes. Add possibility to work separately. Separate UI, presentation logic and business logic.',
  'repository: "https://github.com/surfstudio/SurfGear/tree/main/packages/mwwm"',
  'issue_tracker: "https://github.com/surfstudio/SurfGear/issues"',
  '',
  'dependencies:',
  '  flutter:',
  '    sdk: flutter',
  '',
  'dev_dependencies:',
  '  flutter_test:',
  '    sdk: flutter',
  '  mocktail: ^0.1.1',
  '  surf_lint_rules: ^1.0.0',
  '',
  'environment:',
  '  sdk: ">=2.12.0 <3.0.0"',
  '',
  'flutter:',
];

void main() {
  group('Pubspec', () {
    group('isFlutterPackage returns', () {
      test('false on empty content', () {
        const pubspec = Pubspec([]);

        expect(pubspec.isFlutterPackage, isFalse);
      });

      test('false on Dart package content', () {
        const pubspec = Pubspec(_dartPackage);

        expect(pubspec.isFlutterPackage, isFalse);
      });

      test('true on Flutter package content', () {
        const pubspec = Pubspec(_flutterPackage);

        expect(pubspec.isFlutterPackage, isTrue);
      });
    });

    group('packageName returns', () {
      test('"unknown" on empty content', () {
        const pubspec = Pubspec([]);

        expect(pubspec.packageName, equals('unknown'));
      });

      test('package name', () {
        const pubspec = Pubspec(_dartPackage);

        expect(pubspec.packageName, equals('action_app'));
      });
    });

    test('readPubspec returns parsed pubspec.yaml', () {
      final invalidPubspec = readPubspec('..');

      expect(invalidPubspec.isFlutterPackage, isFalse);
      expect(invalidPubspec.packageName, equals('unknown'));

      final actionAppPubspec = readPubspec('.');

      expect(actionAppPubspec.isFlutterPackage, isFalse);
      expect(actionAppPubspec.packageName, equals('action_app'));
    });
  });
}
