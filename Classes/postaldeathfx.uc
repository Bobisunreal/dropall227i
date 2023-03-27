//=============================================================================
// postaldeathfx.
//=============================================================================
class postaldeathfx expands Mutator;

function PostBeginPlay()
{
	AddGameRules();
	SaveConfig();
}


function AddGameRules()
{
	local postaldeathfx_GR gr;

	gr = Spawn(class'postaldeathfx_GR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}

function postalplayerdeath(Pawn Player)
{

local Inventory PawnInv, act;
 local string thing;
 local int max;
  max =  0 ;  // Rest The drop item Limit
  foreach AllActors(Class'Inventory',PawnInv)
        {
          if ( PawnInv.Owner == Player )
          {
              if (!PawnInv .IsA('Weapon') && PawnInv .IsA('pickup')  // Aything but Weapons.
                 &&  !PawnInv .IsA('xBaseCommands')
                 &&  !PawnInv .IsA('votething')
                 &&  !PawnInv .IsA('VotingCmdItem')  )  // Dont Spawn Useless Bullshit That Everyone Already Has, So no Votingthings or Basecommands Etc..
              {
                 // It seems that 225 sometimes crashes using this inventory script.
                 // I Added A  Limit To Reduce That and To Limit How Much Crap Spawns at Once.
                if (max < 25)
                {
                   act= spawn(Class<inventory>(DynamicLoadObject(string(PawnInv.class),Class'Class')),,,player.Location + 120 * VRand());
                   if(act != None)
	                {  // Spawned , Well almost.
	                 act.SetPhysics(PHYS_Falling);   // No Flaoting Fakeness.
	                 max ++;                         // Next!
	                 act.respawntime=0;              // Dont Respawn this item (Fakeness)
	                 //Other.DeleteInventory(PawnInv); // It has spawned so delete it  from the player.
	                // PawnInv.Destroy();              // Destroy it again ...LOL
                     //log("Spawn postal_dwkinv- "$PawnInv.class $" " $ max $ " of 25" );
	                }

                }
              }

              //---------------------------
              // Weapons
              // I did this seperatly for some reason that i cant recall now

             If(PawnInv .IsA('Weapon') )
             { // Weapons only!
                thing = string(PawnInv.class);
                act= spawn(Class<inventory>(DynamicLoadObject(thing,Class'Class')),,,player.Location + 120 * VRand());
                if(act != None)
	            {
	             act.SetPhysics(PHYS_Falling);
	             act.respawntime=0;
	            // Other.DeleteInventory(PawnInv);
                 //PawnInv.Destroy();
                 //log("Spawn postal_dwkinv- "$PawnInv.class);
	            }

             }


          }



        }

	
}

defaultproperties
{
}
