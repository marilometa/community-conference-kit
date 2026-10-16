# Data model

```mermaid
erDiagram
    CONFERENCE ||--o{ TRACK : "has"
    CONFERENCE ||--o{ ROOM : "has"
    CONFERENCE ||--o{ SUBMISSION : "receives"
    CONFERENCE ||--o{ SESSION : "schedules"
    CONFERENCE ||--o{ SPONSORSHIP : "has"
    CONFERENCE ||--o{ VOLUNTEER_SHIFT : "staffs"
    SUBMISSION ||--o{ SUBMISSION_REVIEW : "scored by"
    SUBMISSION |o--o{ SESSION : "becomes"
    TRACK |o--o{ SUBMISSION : "proposed for"
    TRACK |o--o{ SESSION : "groups"
    ROOM |o--o{ SESSION : "hosts"
    SESSION ||--o{ SESSION_SPEAKER : "features"
    CONTACT ||--o{ SESSION_SPEAKER : "speaks in"
    CONTACT |o--o{ SUBMISSION : "submits"
    CONTACT |o--o{ VOLUNTEER_SHIFT : "works"
    ACCOUNT |o--o{ SPONSORSHIP : "sponsors"
    USER |o--o{ SUBMISSION_REVIEW : "reviews"
```

## Relationship choices

- **Everything that belongs to one edition is a master-detail child of Conference.** Sharing follows the conference, and deleting a test conference cleans up its records.
- **Submission Review is a master-detail child of Submission.** That gives native roll-ups of review count and score total. The average score is a formula, because roll-up summaries can't average.
- **Session links back to its Submission by lookup.** Not every session comes from the call for papers: keynotes and breaks don't.
- **Speakers, volunteers and sponsors are standard Contacts and Accounts.** The same person can speak one year and volunteer the next without duplicate records.
