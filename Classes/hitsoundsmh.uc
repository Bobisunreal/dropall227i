class hitsoundsmh expands Mutator config (dropall227);


//#exec AUDIO IMPORT FILE="headshot.WAV" NAME="headshot"
//#exec AUDIO IMPORT FILE="QFeedbackArmour.WAV" NAME="QFeedbackArmourwav"
//#exec AUDIO IMPORT FILE="QFeedbackTeamWa.WAV" NAME="QFeedbackTeamWav"
//#exec AUDIO IMPORT FILE="QFeedbackWav.WAV" NAME="QFeedbackWav"


Struct F{	
var() config string player;
var() config bool hitsounds;
var() config int vol;
        };

var() Config F playerpreferences[50];


var() config  string hitmarkersnd;
var() config  string hitmarkersndteam;
var() config  string hitmarkersndarmor;

var() config  bool loggarbage;

var() config float HitVolume;



function PostBeginPlay()
{
	AddGameRules();
	HitVolume = 2;
	SaveConfig();
}


function AddGameRules()
{
	local hitsoundsmh_GR gr;

	gr = Spawn(class'hitsoundsmh_GR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}



function bool handleChat( PlayerPawn Chatting, out string Msg )
{


   if (msg == "/help")
   {
   chatting.ClientMessage("[Hitsounds_MH]  enemy hitsound 2022.8.22 '/hitsounds' for more help");
   return true;
   }





		  if (caps(msg) == caps("/hitsounds"))
          {  
	      Chatting.ClientMessage("Hitsounds : chat /togglehitsounds  to disable hit notifications ", 'event');			return false;
		  Chatting.ClientMessage("Hitsounds : chat /hitsoundsvolup  /hitsoundsvoldown for volume", 'event');			return false;
		  return false;
		  } 

 	 	  if (msg == "/togglehitsounds")
          {  
		    if (playerpreferences[getnamedata(chatting)].hitsounds)
		    {
		     playerpreferences[getnamedata(chatting)].hitsounds = false;
		     Chatting.ClientMessage("Hitsounds :clientside hitsounds disabled", 'event');
			 saveconfig();
		    }else{
		     playerpreferences[getnamedata(chatting)].hitsounds = true;
		     Chatting.ClientMessage("Hitsounds : clientside hitsounds enabled", 'event');
			 saveconfig();
		    }
		    return false;
		   }
		   
		   
		     if (msg == "/hitsoundsvolup")
          {  
		     playerpreferences[getnamedata(chatting)].vol ++;
		     Chatting.ClientMessage("Hitsounds :clientside volume" $ playerpreferences[getnamedata(chatting)].vol , 'event');
			 saveconfig();
		     return false;
		   }
		   
		   
		     if (msg == "/hitsoundsvoldown")
          {  
		     playerpreferences[getnamedata(chatting)].vol --;
		     Chatting.ClientMessage("Hitsounds :clientside volume" $ playerpreferences[getnamedata(chatting)].vol , 'event');
			 saveconfig();
		     return false;
		   }
		   
	
return true;   

}




function int getnamedata(playerpawn p)
{ // find the fuckers data slot
local int i;
local PlayerReplicationInfo PRI;
local int yes;
local bool found;
PRI=p.PlayerReplicationInfo;


For( i = 0; i < 50; i++ )
	      {   			 
			 if (playerpreferences[i].player == PRI.PlayerName)
			 {
			 yes = i;
			 found = true;
			 return yes;
			 }
			 
			 if (!found)
			 { if (playerpreferences[i].player == "")
			    {
			      playerpreferences[i].player = PRI.PlayerName;
			      playerpreferences[i].hitsounds = true;
		          playerpreferences[i].vol =HitVolume;
		
				if (loggarbage){log ("new  hitsound player" $ PRI.PlayerName $  " slot " $ i );}	
				p.ClientMessage("Hitsounds : chat /hitsounds for help", 'event');
				
			    found = true;
				yes = i;
				saveconfig();
			    return yes;
			    }
			 }
			 
         }
}


















function checkDamage( Pawn victim, Pawn InstigatedBy, out int Damage, vector HitLocation, name DamageType, out vector Momentum )
{
 
 if (InstigatedBy !=None  && InstigatedBy.IsA('PlayerPawn') && (Victim != InstigatedBy) )
	{
		// When player shoot other player
		if( Victim.IsA('PlayerPawn') || Victim.IsA('Bot') )
		{
			// Play sound on all slot except talk so incoming sound does not interfere
			// Remove Playsound Slot_Ambient to stop native error on server
			
			 if (playerpreferences[getnamedata(playerpawn(InstigatedBy))].hitsounds )	
				{
			PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersndteam, Class'Sound' )), SLOT_None, HitVolume, false);
			PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersndteam, Class'Sound' )), SLOT_Interface, HitVolume, false);
			PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersndteam, Class'Sound' )), SLOT_Interact, HitVolume, false);
			    }
		}

		// When player shoot ScriptedPawn
		if( Victim.IsA('ScriptedPawn') )
		{
			// Nali and animal are friends
			if(
				Victim.IsA('Nali')
				|| Victim.IsA('NaliPriest')
				|| Victim.IsA('Cow')
				|| Victim.IsA('BabyCow')
				|| Victim.IsA('NaliRabbit')
			)
			{
			
			    if (playerpreferences[getnamedata(playerpawn(InstigatedBy))].hitsounds )	
				{
				PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersndteam, Class'Sound' )), SLOT_None, HitVolume, false);
				PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersndteam, Class'Sound' )), SLOT_Interface, HitVolume, false);
				PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersndteam, Class'Sound' )), SLOT_Interact, HitVolume, false);
				}
			}
			else // ScriptedPawn is ennemy
			{
			    if (playerpreferences[getnamedata(playerpawn(InstigatedBy))].hitsounds )	
				{
				PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersnd, Class'Sound' )), SLOT_None, HitVolume, false);
				PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersnd, Class'Sound' )), SLOT_Interface, HitVolume, false);
				PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersnd, Class'Sound' )), SLOT_Interact, HitVolume, false);
				}
			}
		}
	} 
   
   
   

}


//if ( None == Victim.Inventory.PrioritizeArmor(ActualDamage, DamageType, HitLocation) )




defaultproperties
{
hitmarkersnd="G_assests_snds.QFeedbackWav"
hitmarkersndteam="G_assests_snds.QFeedbackteamWav"
hitmarkersndarmor="G_assests_snds.QFeedbackArmourwav"

}
