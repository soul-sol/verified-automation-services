# AI Agent Skill Acceptance Checklist

A reusable agent skill needs observable behavior, not just a persuasive prompt.

## Contract

- [ ] One job-to-be-done is stated in a single sentence.
- [ ] Required inputs and acceptable missing inputs are explicit.
- [ ] Outputs have a stable structure and completion condition.
- [ ] Forbidden actions and escalation boundaries are named.
- [ ] Tool permissions match the minimum needed for the job.

## Examples and failure cases

- [ ] At least two representative input/output examples exist.
- [ ] One ambiguous input produces a safe clarification or bounded assumption.
- [ ] One hostile or malformed input is rejected safely.
- [ ] Missing credentials or external account actions become explicit blockers.
- [ ] Secrets and private data are never copied into logs or public artifacts.

## Repeatable evaluation

- [ ] Each acceptance case has a fixture and expected result.
- [ ] Tool calls are checked for target, order, and side effects.
- [ ] A regression case exists for every previously observed failure.
- [ ] Human-only actions are clearly separated from automated actions.
- [ ] The final report distinguishes verified facts from assumptions.

If the skill needs fixtures, tool integration, and a repeatable evaluation
harness, [request an agent skill](https://github.com/soul-sol/verified-automation-services/issues/new?template=agent-skill.yml).
