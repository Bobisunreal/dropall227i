class essentials_GR expands GameRules;

var essentials MutatorPtr;
// if you dont check none and the mutator gets killed
// you cant travel to a new level or do anything.


function PostBeginPlay()
{
 linkupcopy(); // check if i am already running
 SetTimer(0.1,false);
}

function linkupcopy()
{ // check makesure we donthave 2 running.
 local essentials_GR unfek;
 local int countm;

  foreach AllActors(Class'essentials_GR', unfek)
  {
     countm++;
  }
  
    //log ("grFound "$countm $ " Instances already running", stringtoname("[Essentials]"));
    if (countm > 1)  
    {
    log("double gr found and destroyed",stringtoname("[Essentials]"));
    self.destroy();  
    }

}

function timer ()
{
 log ("Game Rule " $ self.class $ " Spawned linked to " $ string (MutatorPtr.name)  ,stringtoname("[Essentials]"));
}


function NotifyKilled(Pawn Killed, Pawn Killer, name DamageType)
{
 MutatorPtr.xscoreKilled(Killed,Killer,DamageType);
}


function bool AllowChat( PlayerPawn Chatting, out string Msg )
{

   log (self.name );
   log (msg);
   if  (MutatorPtr!= none)
   {
    return MutatorPtr.handleChat(Chatting,Msg);
   }else{
   log("WARNING : no essentials mutator to reference",stringtoname("[Essentials]")); // wouldn't care but this could stop chat from working if we don't get our return
   return true;
   }
}



function bool AllowBroadcast( Actor Broadcasting, string Msg )
{
   if  (MutatorPtr!= none)
   {
    return MutatorPtr.handleChat(none,Msg);
    }else{
    log("WARNING : no essentials mutator to reference",stringtoname("[Essentials]"));
    return true;
   }


}



// Prevent a pawn from dying.
function bool PreventDeath( Pawn Dying, Pawn Killer, name DamageType )
{
  if  (MutatorPtr!= none)
  {
    Return MutatorPtr.handlePreventDeath(dying,killer,damagetype);
  }else{
    log("WARNING : no essentials mutator to reference",stringtoname("[Essentials]"));
  Return true;
  }
}


function string ExecAdminCmd( PlayerPawn Other, string Cmd )
{

    if  (MutatorPtr!= none)
   {

	log (string(other.name) $"admin cmd issued " $ cmd);
	//other.ClientMessage(cmd);
	Return MutatorPtr.handlecmd(other,cmd);
   }else{
  log("WARNING : no essentials mutator to reference",stringtoname("[Essentials]"));
   Return MutatorPtr.handlecmd(other,cmd);
   }
}


function bool CanCoopTravel( Pawn Ender, out string NextURL )
{
local string bs;
if  (MutatorPtr!= none)
   {

		bs = mutatorptr.mutatecooptravel(ender,nexturl);
		// fail
	    if (bs == "")
		{
		return false;
		}	

		//pass
		if (bs != "")
		{
		nexturl = bs;
		return true;
		}

   }else{
        log("WARNING : no essentials mutator to reference",stringtoname("[Essentials]"));
        log(" return true on cooptravel" , stringtoname("[Essentials]"));
        Return true;

   }
}


function ModifyPlayer(Pawn Other)
{
	if (PlayerPawn(Other) == none || Other.IsA('Spectator'))
		return;
	//	log("respaner from gr");
mutatorptr.mutaterespwan(other);
}


function ModifyDamage( Pawn Injured, Pawn EventInstigator, out int Damage, vector HitLocation, name DamageType, out vector Momentum )
{
MutatorPtr.checkdamage(Injured,EventInstigator,Damage,HitLocation,DamageType,Momentum);
}

 //get url with password
function OverridePrelogin( string Options, string PlayerName, out string Error)
{
 local string bs;
 // fuck outs sort of ...
    bs = MutatorPtr.xPrelogin(Options,PlayerName);
    //  allow
    if (bs == "")
    {
     error = "";
    }

    //pass
    if (bs != "")
    {
     error = bs;
    }



}


function bool CanPickupInventory( Pawn Other, Inventory Inv )
{
return MutatorPtr.mutateCanPickupInventory(Other,Inv);
}


// ServerTravel was attempted:
function bool AllowServerTravel( out string URL, bool bItems )
{
log("map switch test" $ url);
return MutatorPtr.mutateservertravel(url);
    //return true;
}


function bool AllowDownload( NetConnection Conn, string PLName, string PLIP, string FileName, int FileSize )
{

return MutatorPtr.mutatedownload(plname,plip,filename,filesize);

}

defaultproperties
{
				bNotifyLogin=True
				bNotifySpawnPoint=True
				bNotifyMessages=True
				bModifyDamage=True
				bHandleDeaths=True
				bHandleMapEvents=True
				bHandleInventory=True
}
