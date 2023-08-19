import 'dart:convert';
import 'dart:io';

import 'package:actions_toolkit_dart/core.dart' as toolkit;

const _envVarGitHubWorkspace = 'GITHUB_WORKSPACE';
const _envVarGitHubRepositorySlug = 'GITHUB_REPOSITORY';
const _envVarGitHubSHA = 'GITHUB_SHA';

const _checkOutError =
    "Make sure you call 'actions/checkout' in a previous step. Invalid environment variable";

class GitHubWorkflowUtils {
  final Map<String, String> _environmentVariables;

  const GitHubWorkflowUtils({
    required Map<String, String> environmentVariables,
  }) : _environmentVariables = environmentVariables;

  /// Returns head SHA of the commit associated to the current workflow.
  String currentCommitSHA() {
    final commitSha = _environmentVariables[_envVarGitHubSHA];
    if (commitSha == null) {
      throw ArgumentError.value(
        commitSha,
        _envVarGitHubRepositorySlug,
        _checkOutError,
      );
    }

    toolkit.debug(message: 'SHA that triggered the workflow: $commitSha');

    final pullRequest = _getPullRequestJson();
    if (pullRequest != null) {
      final baseSha =
          (pullRequest['base'] as Map<String, Object?>)['sha'] as String;
      final headSha =
          (pullRequest['head'] as Map<String, Object?>)['sha'] as String;
      if (commitSha != headSha) {
        toolkit.debug(message: 'Base SHA: $baseSha');
        toolkit.debug(message: 'Head SHA: $headSha');

        return headSha;
      }
    }

    return commitSha;
  }

  /// Returns number of current Pull Request or null.
  int? currentPullRequestNumber() {
    final pullRequest = _getPullRequestJson();
    if (pullRequest != null && pullRequest.containsKey('number')) {
      return pullRequest['number'] as int;
    }

    // ignore: avoid_returning_null
    return null;
  }

  /// Returns slug of the repository.
  String currentRepositorySlug() {
    final repoPath = _environmentVariables[_envVarGitHubRepositorySlug];
    if (repoPath == null) {
      throw ArgumentError.value(
        repoPath,
        _envVarGitHubRepositorySlug,
        _checkOutError,
      );
    }

    return repoPath;
  }

  /// Path to the folder containing the entire repository.
  String currentPathToRepoRoot() {
    final repoPath = _environmentVariables[_envVarGitHubWorkspace];
    if (repoPath == null) {
      throw ArgumentError.value(
        repoPath,
        _envVarGitHubWorkspace,
        _checkOutError,
      );
    }

    return repoPath;
  }

  bool isTestMode() =>
      currentRepositorySlug() == 'dart-code-checker/flutterando-metrics-action';

  Map<String, Object?>? _getPullRequestJson() {
    final pathEventPayload = _environmentVariables['GITHUB_EVENT_PATH'];
    if (pathEventPayload == null) {
      return null;
    }

    final eventPayload = jsonDecode(File(pathEventPayload).readAsStringSync())
        as Map<String, dynamic>;

    return eventPayload['pull_request'] as Map<String, Object?>?;
  }
}
