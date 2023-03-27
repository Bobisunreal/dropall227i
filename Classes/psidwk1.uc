//=============================================================================
// psitest.
//=============================================================================
class psidwk1 expands SwarmHost;


var int SpawnCount;

var Class<Pawn> cp;




event PreBeginPlay ()
{
//PawnToSpawn="present1.present1";
     //SpawnNumber=1;
  Super.PreBeginPlay();
  if ( PawnToSpawn != "" )
  {
    if ( InStr(PawnToSpawn,".") == -1 )
    {
      PawnToSpawn = "unreali." $ PawnToSpawn;
    }
    cp = Class<Pawn>(DynamicLoadObject(PawnToSpawn,Class'Class'));
    if ( cp == None )
    {
      Log("Couldn't DynamicLoadClass <" $ PawnToSpawn $ ">!",'bccpsishit');
      Destroy();
    }
  } else {
    Destroy();
  }
}

function BecomePickup ()
{
}

function BecomeItem ()
{
}

auto state Pickup
{
  function bool ValidTouch (Actor Other)
  {
    return False;
  }

  function CheckTouching ()
  {
  }

  function Timer ()
  {
    local Pawn P;
    local int i;

    if ( cp != None )
    {
      i = 0;
      if ( i < 25 )
      {
        P = Spawn(cp,,,Location + i * 15 * vect(0.00,0.00,4.00) + i * 16 * VRand(),Rotation);
        if ( P != None )
        {
        }
        i++;
         }
    }
    if ( P != None )
    {
    //P.SetPhysics(PHYS_Falling);
     // P.Velocity = VRand() * 280;
    } else {
      Log("Couldn't spawn " @ string(cp),'psidwk1');
    }
    SpawnCount++;
    Log(string(SpawnCount) @ "/" @ string(SpawnNumber),'psidwk1');
    if ( SpawnCount >= SpawnNumber )
    {
      Destroy();
    }
  }

  function BeginState ()
  {

    bCollideWorld = True;
    SetTimer(0.13,True);
  }

  function EndState ()
  {
    //GotoState('Sleeping');
  }

}

state Activated
{
  //ignores  Activate;

}

state Sleeping
{
  //Log("DZpsi state sleeping. returning to state pickup.");
 // GotoState('Pickup');
}

defaultproperties
{
}
