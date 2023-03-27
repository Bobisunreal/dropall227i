class toasty227_GR expands GameRules;


var toasty227 MutatorPtr;






function PlayersPlay( sound X )
{

local pawn p;
	for( P = level.pawnlist; P != None; P=P.NextPawn )
	{
		If ( P.IsA('playerpawn') )
		{
		Playerpawn(P).ClientPlaysound(X);
		}
    }		
	

}

















function bool AllowChat( PlayerPawn Chatting, out string Msg )
{
local string bs;
   if  (MutatorPtr!= none)      
   {  
    bs = MutatorPtr.handleChat(Chatting,Msg);
    //  allow
    if (bs == "")
    {
	//log ("bs" $ bs);
    return false;
    }

    //pass
    if (bs != "")
    {
	//log ("bs" $ bs);
    Msg = bs;
	return true;
    }

   
   
  } 


}






function bool AllowBroadcast( Actor Broadcasting, string Msg )
{
local sound TheSound;






if(instr(msg,"was incinerated")!=-1)
{
PlayersPlay(Sound(DynamicLoadObject("bbbtaunts.toasty", Class'Sound' )));
}




if(msg == "5 minutes left for this map")
{
PlayersPlay(Sound(DynamicLoadObject("announcer.cd5min", Class'Sound' )));
}

if(msg == "3 minutes left for this map")
{
TheSound = Sound(DynamicLoadObject("announcer.cd3min", Class'Sound' ));
PlayersPlay(thesound);
}


if(msg == "1 minute left for this map")
{
TheSound = Sound(DynamicLoadObject("announcer.cd1min", Class'Sound' ));
PlayersPlay(thesound);
}


if(msg == "30 seconds left!")
{
TheSound = Sound(DynamicLoadObject("announcer.cd30sec", Class'Sound' ));
PlayersPlay(thesound);
}

if(msg == "10 seconds left!")
{
TheSound = Sound(DynamicLoadObject("announcer.cd10", Class'Sound' ));
PlayersPlay(thesound);
}

if(msg == "5 seconds and counting...")
{
TheSound = Sound(DynamicLoadObject("announcer.cd5", Class'Sound' ));
PlayersPlay(thesound);
}
if(msg == "4...")
{
TheSound = Sound(DynamicLoadObject("announcer.cd4", Class'Sound' ));
PlayersPlay(thesound);
}

if(msg == "3...")
{
TheSound = Sound(DynamicLoadObject("announcer.cd3", Class'Sound' ));
PlayersPlay(thesound);
}

if(msg == "2...")
{
TheSound = Sound(DynamicLoadObject("announcer.cd2", Class'Sound' ));
PlayersPlay(thesound);
}

if(msg == "1...")
{
TheSound = Sound(DynamicLoadObject("announcer.cd1sec", Class'Sound' ));
PlayersPlay(thesound);
}


//ScriptLog: bcast BobIsUnreal was killed



   if(msg == "Time Up!")
   {
   }

    log("bcast " $ msg);
	Return True;
}




// stuff we can do here > hide player join messages , enter / exit sfx, etc
//ScriptLog: bcast BobIsUnreal was incinerated

defaultproperties
{
				bNotifyMessages=True
}
