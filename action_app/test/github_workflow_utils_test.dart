import 'package:action_app/github_workflow_utils.dart';
import 'package:test/test.dart';

const path = '/project/lib/source.dart';
const message = 'simple message';
const branchHeadSHA = '1357908642';

void main() {
  group('GitHubWorkflowUtils', () {
    test('currentCommitSHA throws exception', () {
      expect(
        () {
          const GitHubWorkflowUtils(environmentVariables: {})
              .currentCommitSHA();
        },
        throwsArgumentError,
      );
    });

    group('currentCommitSHA returns commit sha', () {
      test('taken from branch head', () {
        expect(
          const GitHubWorkflowUtils(
            environmentVariables: {'GITHUB_SHA': branchHeadSHA},
          ).currentCommitSHA(),
          equals(branchHeadSHA),
        );
      });

      test('taken from pull request json', () {
        expect(
          const GitHubWorkflowUtils(
            environmentVariables: {
              'GITHUB_SHA': branchHeadSHA,
              'GITHUB_EVENT_PATH': './test/resources/github_pr1_event.json',
            },
          ).currentCommitSHA(),
          equals(branchHeadSHA),
        );

        expect(
          const GitHubWorkflowUtils(
            environmentVariables: {
              'GITHUB_SHA': branchHeadSHA,
              'GITHUB_EVENT_PATH': './test/resources/github_pr2_event.json',
            },
          ).currentCommitSHA(),
          equals('67890'),
        );
      });
    });

    test('currentPullRequestNumber returns null', () {
      expect(
        const GitHubWorkflowUtils(environmentVariables: {})
            .currentPullRequestNumber(),
        isNull,
      );

      expect(
        const GitHubWorkflowUtils(environmentVariables: {
          'GITHUB_EVENT_PATH': './test/resources/github_pr1_event.json',
        }).currentPullRequestNumber(),
        equals(67890),
      );

      expect(
        const GitHubWorkflowUtils(environmentVariables: {
          'GITHUB_EVENT_PATH': './test/resources/github_pr2_event.json',
        }).currentPullRequestNumber(),
        isNull,
      );
    });

    test('currentRepositorySlug returns defined slug of the repository', () {
      expect(
        () {
          const GitHubWorkflowUtils(environmentVariables: {})
              .currentRepositorySlug();
        },
        throwsArgumentError,
      );

      const slug = 'dart-code-checker/flutterando-metrics-action';

      expect(
        const GitHubWorkflowUtils(
          environmentVariables: {'GITHUB_REPOSITORY': slug},
        ).currentRepositorySlug(),
        equals(slug),
      );
    });

    test('currentPathToRepoRoot returns workspase path', () {
      expect(
        () {
          const GitHubWorkflowUtils(environmentVariables: {})
              .currentPathToRepoRoot();
        },
        throwsArgumentError,
      );

      const workspacePath = '/user/builder/repository';

      expect(
        const GitHubWorkflowUtils(
          environmentVariables: {'GITHUB_WORKSPACE': workspacePath},
        ).currentPathToRepoRoot(),
        equals(workspacePath),
      );
    });

    test('isTestMode returns true only for current repo', () {
      const slug = 'dart-code-checker/flutterando-metrics-action';

      expect(
        const GitHubWorkflowUtils(
          environmentVariables: {'GITHUB_REPOSITORY': slug},
        ).isTestMode(),
        isTrue,
      );

      expect(
        const GitHubWorkflowUtils(
          environmentVariables: {'GITHUB_REPOSITORY': 'slug'},
        ).isTestMode(),
        isFalse,
      );
    });
  });
}
