import { danger, warn } from "danger";

import { licenseAuditor } from "@jpfulton/node-license-auditor-cli";

export default async () => {
  if (!danger.github) {
    return;
  }

  if (!danger.github.pr) {
    warn("This run was not triggered by a PR and will not check for PR specific changes.");
    return;
  }
  else {
    // No PR is too small to include a description of why you made a change
    if (danger.github.pr.body.length < 10) {
      warn("Please include a description of your PR changes.");
    }
  }

  // Run the license auditor plugin
  licenseAuditor({
    failOnBlacklistedLicense: false,
    projectPath: "/github/workspace", // path inside the docker container to the repo root
    remoteConfigurationUrl: "https://raw.githubusercontent.com/jpfulton/jpfulton-license-audits/main/.license-checker.json",
    showMarkdownSummary: true,
    showMarkdownDetails: true,
  });
};