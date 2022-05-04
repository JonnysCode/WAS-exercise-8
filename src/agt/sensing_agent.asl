// Agent sensing_agent in project exercise-8

/* Initial beliefs and rules */
role_goal(R, G) :-
	role_mission(R, _, M) & mission_goal(M, G).

can_achieve (G) :-
	.relevant_plans({+!G[scheme(_)]}, LP) & LP \== [].	

i_have_plans_for(R) :-
	not (role_goal(R, G) & not can_achieve(G)).

my_role(R) :-
	role(R, _) & i_have_plans_for(R).

/* Initial goals */
!start.

// Initialisation Plan
@start
+!start : true
<-
	.my_name(Me);
	.print("Hello from ",Me).

// Plan to achieve reading the air temperature using a robotic arm
+!read_temperature : true <-
	.print("Mock temperature reading (Celcious): 12.3").


+deployedOrg(OrgName, GroupName): true <-
	.print("Joining deployed org: ", OrgName);

	lookupArtifact(OrgName, OrgArtId);
	focus(OrgArtId);

	lookupArtifact(GroupName, GrpArtId);
	focus(GrpArtId);

	!adoptRoles.


+!adoptRoles : role(R, _) & i_have_plans_for(R) <- 
	.print("Adopting role: ", R).


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// Uncomment if you want to use the organization rules available in https://github.com/moise-lang/moise/blob/master/src/main/resources/asl/org-rules.asl
{ include("$moiseJar/asl/org-rules.asl") }
