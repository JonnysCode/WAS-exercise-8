// Agent sensing_agent in project exercise-8

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
<-
	.my_name(Me);
	.print("Hello from ",Me).

// Plan to achieve reading the air temperature using a robotic arm
+!read_temperature : true <-
	makeArtifact("weatherStation", "wot.ThingArtifact", ["https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/weather-station.ttl"], WeatherStatArtId);
  	focus(WeatherStatArtId);
	readProperty("Temperature", _, OutValue);
	.print("output: ", OutValue)
	.nth(0, OutValue, TempValue);
	//.print(TempValue);
	.broadcast(tell, temperature(TempValue));
	.print("Agent temperature reading (Celcius): ", TempValue).


+deployedOrg(OrgName, GroupName, SchemeName): true <-
	.print("Joining deployed org: ", OrgName);

	lookupArtifact(OrgName, OrgArtId);
	focus(OrgArtId);

	lookupArtifact(GroupName, GrpArtId);
	focus(GrpArtId);

	lookupArtifact(SchemeName, SchArtId);
	focus(SchArtId);

	!adoptRoles(GrpArtId).


+!adoptRoles(G) : role(R, _) & i_have_plans_for(R) & .my_name(Me)
<- 
	.print("Adopting role: ", R);
	.broadcast(tell, play(Me, R, G)).


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// Uncomment if you want to use the organization rules available in https://github.com/moise-lang/moise/blob/master/src/main/resources/asl/org-rules.asl
{ include("$moiseJar/asl/org-rules.asl") }
