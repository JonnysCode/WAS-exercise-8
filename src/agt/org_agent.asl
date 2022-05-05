// Agent acting_agent in project exercise-8

// Agent org_agent in project exercise-8

/* Initial beliefs and rules */
org_name("lab_monitoring_org").
group_name("monitoring_team").
sch_name("monitoring_scheme").

/* Initial goals */
!start.

// Initialisation Plan
@start
+!start : org_name(OrgName) &
  group_name(GroupName) &
  sch_name(SchemeName)
<-
  .print("I will initialize an organization ", OrgName, " with a group ", GroupName, " and a scheme ", SchemeName, " in workspace ", OrgName);
  
  // 1.2 Discover organization 
  makeArtifact("crawler", "tools.HypermediaCrawler", ["581b07c7dff45162"], CrawlerArtId);
  focus(CrawlerArtId);
  searchEnvironment("Monitor Temperature", FilePath);
  .print("File is at ", FilePath);

  // 1.3 Initialize organization
  makeArtifact(OrgName, "ora4mas.nopl.OrgBoard", [FilePath], OrgArtId);
  focus(OrgArtId);

  // 1.4 Create group and scheme
  createGroup(GroupName, GroupName, GrpArtId);
  focus(GrpArtId);
  createScheme(SchemeName, SchemeName, SchArtId);
  focus(SchArtId);

  // 1.5 Broadcast
  .broadcast(tell, deployedOrg(OrgName, GroupName, SchemeName));

  // 1.6 
  //?formationStatus(ok)[artifact_id(GrpArtId)];
  ?manageFormation(OrgName, GroupName, SchemeName)[artifact_id(GrpArtId)];

  addScheme(SchemeName)[artifact_id(GrpArtId)].


+?manageFormation(OrgName, GroupName, SchemeName)[artifact_id(G)] : role(R, _) & not play(_, R, G) 
<-
  .print("Searching for Role: ", R);
  .broadcast(tell, availableRole(OrgName, GroupName, SchemeName, R) ); 
  .wait(15000);
  ?manageFormation(OrgName, GroupName, SchemeName)[artifact_id(G)].

/*
+?manageFormation(OrgName, GroupName, SchemeName)[artifact_id(G)] : formationStatus(ok)[artifact_id(GrpArtId)] 
<-
  .print("All roles are present").
*/

// Plan to add an organization artifact to the inspector_gui
// You can use this plan after creating an organizational artifact so that you can inspect it
+!inspect(OrganizationalArtifactId) : true
<-
  debug(inspector_gui(on))[artifact_id(OrganizationalArtifactId)].


// Plan to wait until the group managed by the Group Board artifact G is well-formed
// Makes this intention suspend until the group is believed to be well-formed
+?formationStatus(ok)[artifact_id(G)] : group(GroupName,_,G)[artifact_id(OrgName)]
<-
  .print("Waiting for group ", GroupName," to become well-formed")
  .wait({+formationStatus(ok)[artifact_id(G)]}).


// Plan to react on events about an agent Ag adopting a role Role defined in group GroupId
+play(Ag, Role, GroupId) : true
<-
  .print("Agent ", Ag, " adopted the role ", Role, " in group ", GroupId).


// Additional behavior
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// Uncomment if you want to use the organization rules available in https://github.com/moise-lang/moise/blob/master/src/main/resources/asl/org-rules.asl
{ include("$moiseJar/asl/org-rules.asl") }
