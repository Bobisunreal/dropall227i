class sn_tracker_GR expands GameRules;


var sn_mutator MutatorPtr;


function PostBeginPlay()
{
SetTimer(0.1,false); 
}


function timer ()                                          
 { 
 log ("Game Rule " $ self.class $ " Spawned linked to " $ string (MutatorPtr.name)  ,stringtoname("[sn_mutator]"));
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

defaultproperties
{
				bNotifySpawnPoint=True
				bNotifyMessages=True
				bHandleDeaths=True
}
