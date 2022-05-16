// Agent acting_agent in project exercise-8

/* Initial beliefs and rules */
role_goal(R, G) :-
	role_mission(R, _, M) & mission_goal(M, G).

can_achieve (G) :-
	.relevant_plans({+!G[scheme(_)]}, LP) & LP \== [].

i_have_plans_for(R) :-
    not (role_goal(R, G) & not can_achieve(G)).


/* Initial goals */
!start.

// Initialisation Plan
@start
+!start : true
<- 	.my_name(Me);
	.print("Hello from ",Me).

// Plan to achieve manifesting the air temperature using a robotic arm
+!manifest_temperature : temperature(TempValue)
<-
	.print("Temperature manifesting using leubot: ", TempValue);
	makeArtifact("converter", "tools.Converter", [], ConverterId);
	convert(-20, 30, 200, 830, TempValue, ConvertedValue);
	.print("Converted value ", ConvertedValue);
	makeArtifact("leubot", "wot.ThingArtifact", ["https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/leubot1.ttl"], LeubotId);
	setAPIKey("1a313a6c5340caf9d3dc51bab400e318");
	invokeAction("setWristAngle", ["value"], [ConvertedValue]).


+availableRole(OrgName, GroupName, R) : i_have_plans_for(R) & .my_name(Me)
<-
	lookupArtifact(OrgName, OrgArtId);
	focus(OrgArtId);

	lookupArtifact(GroupName, GrpArtId);
	focus(GrpArtId);

	.print("Adopting role: ", R);
	adoptRole(R).
	//.broadcast(tell, play(Me, R, GrpArtId)).


+formationFailed : true 
<- 
	.print("formationFailed").
	//!manifest_temperature.


// From the book, p. 222 -> Thanks Marc :)
+obligation(Ag, MCond, committed(Ag,Mission,Scheme), Deadline) :
  .my_name(Ag)
  <-
  .print("My obligation is ", Mission);
  commitMission(Mission)[artifact_name(Scheme)];
  lookupArtifact(Scheme, SchemeArtId);
  focus(SchemeArtId).

+obligation(Ag, MCond, done(Scheme,Goal,Ag), Deadline) :
  .my_name(Ag)
  <-
  .print("My goal is ", Goal);
  !Goal[scheme(Scheme)];
  goalAchieved(Goal)[artifact_name(Scheme)].


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// Uncomment if you want to use the organization rules available in https://github.com/moise-lang/moise/blob/master/src/main/resources/asl/org-rules.asl
{ include("$moiseJar/asl/org-rules.asl") }
