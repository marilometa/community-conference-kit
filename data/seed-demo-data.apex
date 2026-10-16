// Fictional demo data only. Run with:
//   sf apex run --file data/seed-demo-data.apex --target-org <alias>
// The script checks its own results and fails if a flow or roll-up didn't work.

Conference__c conf = new Conference__c(
    Name = 'Example Community Conference 2027',
    Start_Date__c = Date.newInstance(2027, 5, 15),
    End_Date__c = Date.newInstance(2027, 5, 15),
    City__c = 'Example City',
    Venue__c = 'Example Convention Hall',
    CFP_Close_Date__c = Date.newInstance(2027, 2, 28),
    Status__c = 'Call for Papers Open');
insert conf;

List<Track__c> tracks = new List<Track__c>{
    new Track__c(Name = 'Admin', Conference__c = conf.Id),
    new Track__c(Name = 'Developer', Conference__c = conf.Id),
    new Track__c(Name = 'Architect', Conference__c = conf.Id),
    new Track__c(Name = 'Nonprofit', Conference__c = conf.Id)};
insert tracks;

List<Room__c> rooms = new List<Room__c>{
    new Room__c(Name = 'Main Stage', Capacity__c = 300, Conference__c = conf.Id),
    new Room__c(Name = 'Room A', Capacity__c = 80, Conference__c = conf.Id)};
insert rooms;

Account sponsorAccount = new Account(Name = 'Example Partner Co');
insert sponsorAccount;

List<Contact> people = new List<Contact>{
    new Contact(FirstName = 'Sample', LastName = 'Speaker'),
    new Contact(FirstName = 'Sample', LastName = 'Volunteer')};
insert people;

Submission__c sub = new Submission__c(
    Name = 'Flow Patterns That Scale', Conference__c = conf.Id,
    Speaker__c = people[0].Id, Track__c = tracks[0].Id,
    Format__c = 'Talk', Level__c = 'Intermediate', Status__c = 'Submitted',
    Abstract__c = 'Fictional demo abstract.');
insert sub;

insert new Submission_Review__c(Submission__c = sub.Id, Reviewer__c = UserInfo.getUserId(), Score__c = 4, Comments__c = 'Clear takeaways.');
sub.Status__c = 'Accepted';
update sub;

Session__c ses = new Session__c(
    Name = sub.Name, Conference__c = conf.Id, Track__c = tracks[0].Id, Room__c = rooms[1].Id,
    Submission__c = sub.Id, Format__c = 'Talk',
    Start__c = DateTime.newInstance(2027, 5, 15, 10, 0, 0),
    End__c = DateTime.newInstance(2027, 5, 15, 10, 45, 0));
insert ses;
insert new Session_Speaker__c(Session__c = ses.Id, Speaker__c = people[0].Id, Role__c = 'Speaker');

Sponsorship__c sp = new Sponsorship__c(Conference__c = conf.Id, Sponsor__c = sponsorAccount.Id, Tier__c = 'Gold', Status__c = 'Proposal Sent');
insert sp;
sp.Status__c = 'Committed';
update sp;

insert new Volunteer_Shift__c(
    Conference__c = conf.Id, Volunteer__c = people[1].Id, Role__c = 'Registration Desk',
    Shift_Start__c = DateTime.newInstance(2027, 5, 15, 7, 30, 0),
    Shift_End__c = DateTime.newInstance(2027, 5, 15, 11, 0, 0));

// Checks
Submission__c check = [SELECT Status_Changed_On__c, Review_Count__c, Average_Score__c FROM Submission__c WHERE Id = :sub.Id];
System.assertEquals(Date.today(), check.Status_Changed_On__c, 'Submission status change date should be stamped by the flow');
System.assertEquals(1, check.Review_Count__c, 'Review count roll-up should be 1');
System.assert(check.Average_Score__c == 4, 'Average score should be 4');
Sponsorship__c spCheck = [SELECT Committed_On__c FROM Sponsorship__c WHERE Id = :sp.Id];
System.assertEquals(Date.today(), spCheck.Committed_On__c, 'Sponsorship committed date should be stamped by the flow');
System.debug('Demo data loaded. Open "Example Community Conference 2027".');
