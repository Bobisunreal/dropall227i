class sn_shit_GR expands GameRules;

// we use this to return spawn data to the client 

var sn_shit_mutator MutatorPtr;


function PostBeginPlay()
{
SetTimer(0.1,false); 
}


function timer ()                                          
 { 
 log ("Game Rule " $ self.class $ " Spawned linked to " $ string (MutatorPtr.name)  ,stringtoname("[sn_shit_gr]"));
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
