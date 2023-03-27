class SpawnProtection expands Mutator
	config(dropall227);


var config float protecttime;
var godtimer gt;

function PostBeginPlay()
{
	log( "Loading spawn protector protecttime=" $ protecttime ,stringtoname("[SpawnProtect]"));
    AddGameRules();
	SaveConfig();
}

function AddGameRules()
{
	local SpawnProtectionGR gr;

	gr = Spawn(class'SpawnProtectionGR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}


function protectme(Pawn Other)
{

if (other.ReducedDamageType =='all')
{
log ("mod / mutator/ armour conflict " $ string(other) $ " already has invulnerability before we gave them spawn protection",'spawnprotect');
}

other.ReducedDamageType ='all';
other.ReducedDamagePct = 100;
other.style=sty_modulated;

gt =  Spawn(class'godtimer',,,other.location,other.Rotation);
        if (gt != none)
        {
        gt.p = playerpawn(other);
        }
		gt.settimer(protecttime, true);


}

defaultproperties
{
}
