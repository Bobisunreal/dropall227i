class massh extends ScriptedPawn  Config(dropall227);

//-------------------------------------------------------------
// this class is largly pointless
// the usfulness is you can call pre-configured subclasses of this like swarmhosts
// and use this class in a monster spawner.
// and also could hardcode to masshost functions if you wanted.
//--------------------------------------------------------------

var(swarmhost) config string spawnclass;  // ANY ACTORCLASS not limited to pawns.
var(swarmhost) config int    SpawnNumber;  // HowMany To Try To spawn




function eAttitude AttitudeToCreature(Pawn Other){ return ATTITUDE_Ignore;}
simulated function tick(float deltatime){SetPhysics(Phys_none);}

simulated function PostBeginPlay()
{

BMovable = False;
AttitudeToPlayer = ATTITUDE_Ignore;
HearingThreshold = 0;
SightRadius=0;
Settimer(1.0,false);
//log("helper spawn");

//Destroy();
}

simulated function Timer()
{
local masshost mh;
mh = Spawn(class'masshost');
mh.SpawnMass(self,spawnnumber,spawnclass);
mh.tag = tag; // pass
Destroy();
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


				Tag="'"
				CollisionRadius=0.5
				CollisionHeight=0.5
				bCollideActors=False
				bBlockActors=False
				bBlockPlayers=False
}

