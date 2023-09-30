import { danger, warn } from "danger";

export default async () => {
  if (!danger.github) {
    return;
  }

  // No PR is too small to include a description of why you made a change
  if (danger.github.pr.body.length < 10) {
    warn("Please include a description of your PR changes.");
  }

};