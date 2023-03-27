class helpterm_GR expands GameRules;


function PostBeginPlay()
{
SetTimer(0.1,false); 
}


function timer ()                                          
 { 
 log ("Game Rule " ,stringtoname("[helpterm_gr]"));
 }



function bool AllowChat( PlayerPawn Chatting, out string Msg )
{
   
   if (msg == "/help")
   {
   return false;
   }else{
   return true;
   }
   
}

defaultproperties
{
				bNotifySpawnPoint=True
				bNotifyMessages=True
				bHandleDeaths=True
}
