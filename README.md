# Community Conference Kit

A Salesforce data model and playbook for running a community-led conference: call for papers, reviews, agenda, speakers, sponsors and volunteers.

It comes from organizing a community Salesforce conference every year since 2020. **No real attendee, speaker or sponsor data is included.** All demo data is fictional.

## What's included

| Object | Purpose |
|---|---|
| **Conference** | One edition of the event: dates, city, venue, call-for-papers deadline, status |
| **Track** | A content track, such as Admin, Developer or Architect |
| **Room** | A stage or room, with capacity |
| **Submission** | A talk proposal from the call for papers, with format, level and status |
| **Submission Review** | One reviewer's 1–5 score and comments. Submissions roll up a review count and an average score |
| **Session** | A scheduled agenda slot, linked to its track, room and original submission |
| **Session Speaker** | Links a contact to a session as speaker, panelist, moderator or keynote speaker |
| **Sponsorship** | A sponsor's tier, status, amount and benefit tracking for one conference |
| **Volunteer Shift** | A volunteer's role and shift times |

The Conference Organizer permission set gives the organizing team full access to these objects, without View All or Modify All.

See the [data model diagram](docs/erd.md).

## Automation

- **Submission: Stamp Status Change Date** records when a submission's status last changed.
- **Sponsorship: Stamp Committed Date** records when a sponsor commits.
- **Validation rules** prevent:
  - accepting a submission with no reviews;
  - review scores outside 1–5;
  - sessions and shifts that end before they start;
  - conferences that end before they begin.

Both flows are simple before-save flows. There is no Apex.

## Try it in a scratch org

```bash
sf org create scratch --definition-file config/project-scratch-def.json --alias conference-kit --set-default
sf project deploy start --source-dir force-app
sf org assign permset --name Conference_Organizer
sf apex run --file data/seed-demo-data.apex
sf org open
```

The seed script creates a fictional conference and checks that both flows and the review roll-up worked. If a check fails, the script fails.

## Registration

This kit doesn't handle attendee registration or ticketing. For that, use the open-source [Summit Events App](https://github.com/SFDO-Community/Summit-Events-App) alongside it, rather than rebuilding it here.

## Playbook

Templates for the non-technical side of running the event:

- [Planning timeline](docs/playbook/timeline.md)
- [Call for papers review rubric](docs/playbook/call-for-papers-rubric.md)
- [Sponsor prospectus template](docs/playbook/sponsor-prospectus-template.md)
- [Volunteer roles](docs/playbook/volunteer-roles.md)

## Status

Version 0.1. The metadata passes structural checks and converts cleanly with the Salesforce CLI, but it has not yet been deployed to a scratch org. Please open an issue if a deploy fails.

## Contributing

Issues and suggestions are welcome. Before any commit, run `tools/scrub-check.sh`. It blocks terms listed in your local, git-ignored `.scrub-denylist.txt`, so real names never reach the repository.

## License

MIT. See [LICENSE](LICENSE). Maintained by [Marilo Meta](https://marilometa.github.io/).
