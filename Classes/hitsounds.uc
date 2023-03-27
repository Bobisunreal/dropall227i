class hitsounds expands Mutator config (dropall227);


//#exec AUDIO IMPORT FILE="headshot.WAV" NAME="headshot"
//#exec AUDIO IMPORT FILE="QFeedbackArmour.WAV" NAME="QFeedbackArmourwav"
//#exec AUDIO IMPORT FILE="QFeedbackTeamWa.WAV" NAME="QFeedbackTeamWav"
//#exec AUDIO IMPORT FILE="QFeedbackWav.WAV" NAME="QFeedbackWav"


Struct F{	
var() config string player;
var() config bool hitsounds;
        };

var() Config F playerpreferences[50];


var() config  string hitmarkersnd;
var() config  string hitmarkersndteam;
var() config  string hitmarkersndarmor;

var() config  bool loggarbage;




function PostBeginPlay()
{
	AddGameRules();
	SaveConfig();
}


function AddGameRules()
{
	local hitsounds_GR gr;

	gr = Spawn(class'hitsounds_GR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}



function bool handleChat( PlayerPawn Chatting, out string Msg )
{


		  if (caps(msg) == caps("/hitsounds"))
          {  
	      Chatting.ClientMessage("Hitsounds : chat /togglehitsounds  to disable hit notifications ", 'event');			return false;
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
 
  
    // Handle enemy in CoopMatches that are not cows
    if (InstigatedBy !=None  && InstigatedBy.IsA('PlayerPawn') && (Victim != InstigatedBy)  && !victim.IsA('cow'))
	{
	            if (playerpreferences[getnamedata(playerpawn(InstigatedBy))].hitsounds )	
				{
				 PlayerPawn(InstigatedBy).ClientPlaySound(Sound(DynamicLoadObject(hitmarkersnd, Class'Sound' )));
				}
	}
	
	
	// Handle cows in CoopMatches  
    if (InstigatedBy !=None  && InstigatedBy.IsA('PlayerPawn') && victim.IsA('cow'))
	{
	         PlayerPawn(InstigatedBy).PlaySound(Sound(DynamicLoadObject(hitmarkersndteam, Class'Sound' )));
			 if (loggarbage){log("cow");}
	
	}
	
	
    // Handle Player VS Player in CoopMatches  
	if (InstigatedBy !=None  &&  victim.IsA('PlayerPawn') )
	{ 
	   if ( InstigatedBy.IsA('PlayerPawn') )
	   {
	       if (loggarbage){ log ("player vs player" $ string(DamageType));}
	   		
			
		 // Handle Player VS Player in TeamMatches  
		 if ( (Level.Game.bTeamGame) && (Victim.PlayerReplicationInfo.Team == InstigatedBy.PlayerReplicationInfo.Team) )
		 {
		 PlayerPawn(InstigatedBy).ClientPlaySound(Sound(DynamicLoadObject(hitmarkersndteam, Class'Sound' )));
		 }else{
		 PlayerPawn(InstigatedBy).ClientPlaySound(Sound(DynamicLoadObject(hitmarkersnd, Class'Sound' )));
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
