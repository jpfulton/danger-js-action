# danger-js-action

A GitHub Action for running [Danger JS](https://danger.systems/js/) against pull requests.
It will comment inline with the PR and can be configured to fail the build if the Danger run fails.
It is implemented inside a Docker container to allow DangerJS to be run without adding it as
a dependency to your project if your project is implemented in NodeJS or uses a NPM compatible
package manager. This implementation also allows the action to be used in projects implemented
in any language as a result.

The Dangerfile can be stored locally or remotely. If stored remotely, it will be downloaded
over HTTP or HTTPS. This implementation expects the Dangerfile to be implemented in
[TypeScript](https://www.typescriptlang.org/) and end with the `.ts` extension.

## Action Inputs

| Name | Description | Required | Default |
| --- | --- | --- |
| `dangerfile` | The path to the Dangerfile to run. This path may be local to the repository or a remote URL. | Yes | - |
| `debug_mode` | Whether to run the action in debug mode. | No | `false` |
| `github_token` | The GitHub token to use to authenticate with the GitHub API. | Yes | - |

Further details on the inputs can be found in the [action.yml](action.yml) file.

## Usage in a GitHub Actions Workflow

The job under which the action is run must have the following permissions:

```yaml
permissions:
  checks: write
  pull-requests: write
  issues: write
```

The following example shows how to use the action in a GitHub Actions workflow:

```yaml
  - name: Run Local Action
    uses: jpfulton/danger-js-action@main
    with:
      dangerfile: "tests/dangerfile.ts"
      debug_mode: true
      token: ${{ secrets.GITHUB_TOKEN }}
```
