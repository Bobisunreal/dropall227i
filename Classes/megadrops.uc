class megadrops expands Mutator
 Config(dropall227);
 
var(admin) config  String    picklist[264];

function PostBeginPlay()
{
	AddGameRules();
	SaveConfig();
}


function AddGameRules()
{
	local megadrops_GR gr;

	gr = Spawn(class'megadrops_GR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}


function pawnKill( Pawn Killer, Pawn Other )
{

 local Inventory act;
 local int max;
 max = 0;
           if (max < 10)
                {
                   act= spawn(Class<inventory>(DynamicLoadObject(picklist[Rand(200)],Class'Class')),,,other.Location + 120 * VRand());
                   if(act != None)
	                {  // Spawned , Well almost.
	                 act.SetPhysics(PHYS_Falling);   // No Flaoting Fakeness.
	                 max ++;                         // Next!
	                 act.respawntime=0;              // Dont Respawn this item (Fakeness)
	                 log("Spawn mega_dwkinv- "$act.class  );
	                }

                }



}



defaultproperties
{
}
