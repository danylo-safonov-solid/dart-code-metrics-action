<!-- markdownlint-disable MD041 -->
[![Build Status](https://shields.io/github/actions/workflow/status/dart-code-checker/flutterando-metrics-action/action_app_analyze.yaml?logo=github&logoColor=white&branch=main)](https://github.com/dart-code-checker/flutterando-metrics-action/)
[![Action Version](https://img.shields.io/github/v/release/dart-code-checker/flutterando-metrics-action?color=blue&label=action&logo=github&logoColor=white)](https://github.com/marketplace/actions/flutterando-metrics-action/)
[![License](https://img.shields.io/github/license/dart-code-checker/flutterando-metrics-action)](https://github.com/dart-code-checker/flutterando-metrics-action/blob/master/LICENSE)
[![GitHub popularity](https://img.shields.io/github/stars/dart-code-checker/flutterando-metrics-action?logo=github&logoColor=white)](https://github.com/dart-code-checker/flutterando-metrics-action/stargazers/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dkrutskikh/flutterando_metrics_action?label=runs&logo=github&logoColor=white)](https://github.com/marketplace/actions/flutterando-metrics-action/)
<!-- markdownlint-enable MD041 -->

<img
  src="https://raw.githubusercontent.com/dart-code-checker/flutterando-metrics-action/main/doc/.assets/logo.svg"
  alt="Flutterando logo"
  height="150" width="150"
  align="right">

# Flutterando Action

This action allows to use Flutterando from GitHub Actions.

## What is Flutterando?

[Flutterando](https://github.com/dart-code-checker/dart-code-metrics) is a static analysis tool that helps you analyze and improve your code quality.

## Usage

Create `dartcodemetrics.yaml` under `.github/workflows` With the following contents.

### Default configuration

```yml
name: Flutterando

on: [push]

jobs:
  check:
    name: flutterando-metrics-action

    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: dart-code-metrics
        uses: dart-code-checker/flutterando-metrics-action@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Inputs

| Name                                  | Required                                                                  | Description                                                                                                                                                                                                                                                                                                         | Default                                                 |
| :------------------------------------ | :------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------------------------------------------------ |
| **github_token**                      | ☑️                                                                         | Required to post a report on GitHub. *Note:* the secret [`GITHUB_TOKEN`](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token) is already provided by GitHub and you don't have to set it up yourself.                                              |                                                         |
| **github_pat**                        | Required if you had private GitHub repository in the package dependencies | [**Personal access token**](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) must access to *repo* and *read:user* [scopes](https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps#available-scopes) |                                                         |
| **folders**                           |                                                                           | List of folders whose contents will be scanned.                                                                                                                                                                                                                                                                     | [`lib`]                                                 |
| **relative_path**                     |                                                                           | If your package isn't at the root of the repository, set this input to indicate its location.                                                                                                                                                                                                                       |                                                         |
| **pull_request_comment**              |                                                                           | Publish detailed report commented directly into your pull request.                                                                                                                                                                                                                                                  | `false`                                                 |
| **analyze_report_title_pattern**      |                                                                           | Configurable analyze report title pattern.                                                                                                                                                                                                                                                                          | `Flutterando analyze report of $packageName`      |
| **fatal_warnings**                    |                                                                           | Treat warning level issues as fatal.                                                                                                                                                                                                                                                                                | `false`                                                 |
| **fatal_performance**                 |                                                                           | Treat performance level issues as fatal.                                                                                                                                                                                                                                                                            | `false`                                                 |
| **fatal_style**                       |                                                                           | Treat style level issues as fatal.                                                                                                                                                                                                                                                                                  | `false`                                                 |
| **check_unused_files**                |                                                                           | Additional scan for find unused files in package.                                                                                                                                                                                                                                                                   | `false`                                                 |
| **check_unused_files_folders**        |                                                                           | List of folders whose contents will be scanned for find unused files.                                                                                                                                                                                                                                               | Taken from `folders` argument                           |
| **unused_files_report_title_pattern** |                                                                           | Configurable unused files report title pattern.                                                                                                                                                                                                                                                                     | `Flutterando unused files report of $packageName` |

### Output Example

* Check run output:

  <img
  src="https://raw.githubusercontent.com/dart-code-checker/flutterando-metrics-action/master/doc/.assets/check_run_output.png"
  alt="annotation"
  height="341,5" width="597"
  align="center">

* Annotation:

  <img
  src="https://raw.githubusercontent.com/dart-code-checker/flutterando-metrics-action/master/doc/.assets/annotation.png"
  alt="annotation"
  height="197" width="608"
  align="center">

## How to contribute

If you would like to help contribute to this GitHub Action, please see [CONTRIBUTING](./CONTRIBUTING.md)

## LICENSE

The scripts and documentation in this project are released under the [MIT License](./LICENSE)
