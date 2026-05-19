# Communication & Documentation Standards

## Incident reporting format
When documenting or reporting an incident, always include:
- Severity: P1/P2/P3
- Time of detection (UTC)
- Affected services and user impact
- Current status (investigating / mitigating / resolved)
- Next update ETA

## Runbook format
All runbooks must have: symptom, diagnosis steps (exact commands), decision tree, resolution, prevention.
Generate them in Markdown suitable for GitHub wiki or Confluence.

## Change notification template
Before any production change, post to #platform-changes:
"[CHANGE] {description} | Account: {account} | Window: {start}–{end} UTC | Risk: LOW/MEDIUM/HIGH | Rollback: {plan}"

## Language
- Technical commands and code: English always
- Conceptual explanations and summaries: English always
- Documentation in the repo: English (international team)