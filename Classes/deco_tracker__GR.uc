class deco_tracker_GR expands GameRules;


var deco_mutator MutatorPtr;


function PostBeginPlay()
{
SetTimer(0.1,false);
}


function timer ()
 {
 log ("Game Rule " $ self.class $ " Spawned linked to " $ string (MutatorPtr.name)  ,stringtoname("[deco_mutator]"));
 }



function NotifyKilled(Pawn Killed, Pawn Killer, name DamageType)
{
//log("i am seeing a kiill");
	MutatorPtr.scorepawnKill(Killer,killed);
}


function bool AllowChat( PlayerPawn Chatting, out string Msg )
{
   if  (MutatorPtr!= none)
   {
    return MutatorPtr.handleChat(Chatting,Msg);
   }else{

   }
}

// ServerTravel was attempted:
function bool AllowServerTravel( out string URL, bool bItems )
{
 if  (MutatorPtr!= none)
   {
   MutatorPtr.gofuckyourwife();
   //log ("saves config");
   }



	return true;
}


defaultproperties
{
				bNotifySpawnPoint=True
				bNotifyMessages=True
				bHandleDeaths=True
				bHandleMapEvents=true
}
