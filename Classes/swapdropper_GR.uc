class swapdropper_GR expands GameRules;


var swapdropper MutatorPtr;


function PostBeginPlay()
{
SetTimer(0.1,false); 
}


function timer ()                                          
 { 
 log ("Game Rule " $ self.class $ " Spawned linked to " $ string (MutatorPtr.name)  ,stringtoname("[swapdropper]"));
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
