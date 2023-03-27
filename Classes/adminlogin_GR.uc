class AdminLogin_GR expands GameRules;


var AdminLogin MutatorPtr;




function bool AllowChat( PlayerPawn Chatting, out string Msg )
{
   if  (MutatorPtr!= none)
   {
      return MutatorPtr.handleChat(Chatting,Msg);
   }else{
      log("no mutator to reference",'AdminLoginGR'); // wouldn't care but this could stop chat from working if we don't get our return
      return true;
   }
}


function ModifyPlayer(Pawn Other)
{
	if (PlayerPawn(Other) == none || Other.IsA('Spectator'))
		return;
mutatorptr.MutateRespawningPlayer(other);
}

function bool AllowBroadcast( Actor Broadcasting, string Msg )
{

 if  (MutatorPtr!= none)
   {
      return MutatorPtr.handlecast(Broadcasting,Msg);
   }else{
      log("no mutator to reference",'AdminLoginGR'); // wouldn't care but this could stop chat from working if we don't get our return
      return true;
   }



}
defaultproperties
{
				bNotifySpawnPoint=True
				bNotifyMessages=True
}
