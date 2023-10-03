# danger-js-action

![License](https://img.shields.io/badge/License-MIT-blue)
![Visitors](https://visitor-badge.laobi.icu/badge?page_id=jpfulton.danger-js-action)

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
| --- | --- | --- | --- |
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
  statuses: write
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

The following example shows how to use the action with a remotely hosted Dangerfile:

```yaml
  - name: Run Remote Action
    uses: jpfulton/danger-js-action@main
    with:
      dangerfile: "https://raw.githubusercontent.com/jpfulton/danger-js-action/main/tests/dangerfile.ts"
      debug_mode: true
      token: ${{ secrets.GITHUB_TOKEN }}
```

## Usage with a Personal Access Token

The action can be used with a personal access token instead of the default GitHub token.
Although, this may not be preferable, it is possible to do so by setting the `token` input
to a repository secret that contains the personal access token.

## Usage of the NodeJS File System APIs in the Dangerfile

The action runs the Dangerfile in a Docker container. As a result, the NodeJS file system APIs
may be used to read files from the workflow file system. The working directory of the Docker
container is the root of the repository. The following example shows how to read the contents
of a file in the repository:

```typescript
import { readFileSync } from "fs";

const fileContents = readFileSync("./path/to/file.txt", "utf8");
```

The following example shows how to check for the existence of a file in the repository
file system:

```typescript
import { existsSync } from "fs";

if (existsSync("./path/to/file.txt")) {
  // Do something
}
```

Workflow steps that run before the action can be used to create files that can be read
by the Dangerfile. For example, a previous step could be used to create a Jest test run
output file that can be read by the Dangerfile to report test results. Unless a step following
this action is used to create a commit to the repository, the file will not be persisted
at the end of the workflow run.

## Included Plugins

A complete list of the plugins included in the Docker image can be found in the
[package.json](./package.json) file in the root of the repository as devDependencies.

Key plugins include:

- [@jpfulton/node-license-auditor-cli](https://www.npmjs.com/package/@jpfulton/node-license-auditor-cli)
- [@seadub/danger-plugin-eslint](https://www.npmjs.com/package/@seadub/danger-plugin-eslint)
- [danger-plugin-jest](https://www.npmjs.com/package/danger-plugin-jest)
- [danger-plugin-yarn](https://www.npmjs.com/package/danger-plugin-yarn)

### Using the Node License Auditor Plugin within the Dangerfile

The Node License Auditor plugin is included in the Docker image. It can be used within the
Dangerfile to report on the licenses of the dependencies of the project. The following
example shows how to use the plugin within the Dangerfile:

```typescript
import { licenseAuditor } from "@jpfulton/node-license-auditor-cli";

export default async () => {
  await licenseAuditor({
    failOnBlacklistedLicense: false,
    projectPath: ".",
    remoteConfigurationUrl:
      "https://raw.githubusercontent.com/jpfulton/jpfulton-license-audits/main/.license-checker.json",
    showMarkdownSummary: true,
    showMarkdownDetails: true,
  });
};
```

Further details on the configuration options can be found in the host repository of the
[plugin](https://github.com/jpfulton/node-license-auditor-cli).

## The Docker Image and Repository Workflows

The Docker image is split into two parts. The first part is the base image that contains
the DangerJS package, the TypeScript compiler, associated plugins and NodeJS. The base
image is built and published by a workflow to the Github Container Registry to accelerate
the build of the action image in referencing workflows. The second part is the action
image that is derived from the base image and is referenced by the action. The action
Dockerfile is used by the [action.yml](./action.yml) file to build and execute the action.

## Contributing

Contributions are welcome. Please see the [contributing](CONTRIBUTING.md) file for details.

## Code of Conduct

Please see the [code of conduct](CODE_OF_CONDUCT.md) file for details.

## Security

Please see the [security](SECURITY.md) file for details.
