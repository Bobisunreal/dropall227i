class hitsoundsmh_GR expands GameRules;


var hitsoundsmh MutatorPtr;




function ModifyDamage( Pawn Injured, Pawn EventInstigator, out int Damage, vector HitLocation, name DamageType, out vector Momentum )
{if (mutatorptr == none){destroy();}; 
MutatorPtr.checkdamage(Injured,EventInstigator,Damage,HitLocation,DamageType,Momentum);
}


function bool AllowChat( PlayerPawn Chatting, out string Msg )
{

   if  (MutatorPtr!= none)      
   {  
    return MutatorPtr.handleChat(Chatting,Msg);
   }else{  
    log("no hitsounds to reference",'hitsoundsgr'); // wouldn't care but this could stop chat from working if we don't get our return
	return true; 
   //destroy();
   }
}





defaultproperties
{
bNotifyMessages=true;
bModifyDamage=true;
}
