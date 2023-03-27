class SwarmHost extends ScriptedPawn;

var(swarmhost) config string PawnToSpawn;  // ANY ACTORCLASS not limited to pawns.
var(swarmhost) config int    SpawnNumber;  // HowMany To Try To spawn
var(swarmhost) config int    Spawnspace;   // Specify Random Radius *For Large Pawns Like Titans Etc..
var(swarmhost) config bool   logspawns;    // Log The Spawns Or Spawn Failures
var(swarmhost) config int    giveuptimes;  // Times To Attempt to spawn Before Giving Up.
var() Class<Pawn> Spawns;
var int Num,givin;



function eAttitude AttitudeToCreature(Pawn Other){ return ATTITUDE_Ignore;}
simulated function tick(float deltatime){SetPhysics(Phys_none);}

simulated function PostBeginPlay()
{
//log("spawn born");
BMovable = False;
AttitudeToPlayer = ATTITUDE_Ignore;
HearingThreshold = 0;
SightRadius=0;
Settimer(0.01,false);

}

simulated function Timer()
{
local actor p;
//log("warmhost.timerspawn thing numb"$ num);
//log("warmhost.timerspawn thing znum"$ spawnnumber);
//log("warmhost.timerout cycle" $ num $ " of " $  spawnnumber);
if(num < SpawnNumber)
{
   //log("warmhost.timercycle" $ num $ " of " $  spawnnumber);

   P = Spawn(Class<actor>(DynamicLoadObject(PawnToSpawn,Class'Class')),,,Location + Spawnspace * VRand());
   
   //log("swarmhost.timer.spawn thing");
	if(p != None)
	{
        num++;         // unless you are somhow tracking it serverside?
	   
	   p.tag = tag; // pass on flags
	                // specificly, if the level is respawned.
	   
	   // Log(" - "$ string(self.class) $ " ("$ PawnToSpawn $ ")"$string(num) @ "/" @ string(SpawnNumber),'SwarmHost');  
    }else{
        givin++;// We have Failed. .
        // This could reoccur %numspawns% Times each time having to use resources for nothing.
        if (givin > giveuptimes )
           {  // Since we are asking it to keep tryng forever till it reaches max , We need a backup plan....
              num = SpawnNumber;
             // Log(" - "$ string(self.class) $ " Couldn't Spawn < " $ PawnToSpawn $ ">! - Gaveup After "$ givin$ " Attempts",'SwarmHost');
              Destroy();
			  //log ( "warmhost.timer (fail) we done bitch");
           }

       //  Log(" - "$ string(self.class) $ " Couldn't Spawn < " $ PawnToSpawn $ ">!",'SwarmHost');

	}
    Settimer(0.1,false);
 }else{
 //log ( "warmhost.timer.we done bitch");
 Destroy();
 }
}


auto state StartUp
{
	function InitAmbushLoc()	{	}
	function InitPatrolLoc()	{ 	}
	function SetHome()	{	}
	function SetTeam()	{	}
	function SetAlarm() {	}
	function BeginState()	{	}

Begin:
}


function PlayHit(float Damage, vector HitLocation, name damageType, float MomentumZ){}
function PlayHitAnim(vector HitLocation, float Damage){}
function PlayDeathHit(float Damage, vector HitLocation, name damageType){}

defaultproperties
{
				PawnToSpawn="Unreali.Brute"
				SpawnNumber=3
				Spawnspace=256
				giveuptimes=10
				bCollideWhenPlacing=True
				Tag="'"
				CollisionRadius=1.671130
				CollisionHeight=12.617900
				bCollideActors=False
				bBlockActors=False
				bBlockPlayers=False
}
