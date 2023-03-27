class toasty227 expands Mutator config(dropall227);

Struct T{	var() config string Trigger;	var() config string PlaySnd;  var() config string namerelevant;};
Struct F{	var() config string player;	var() config bool taunts;	var() config bool chatnotice;};
Struct v{	var() config string textin;	var() config string PlaySnd;  var() config string textout;};


var ()config array<f> Player_Preferences;
var ()config array<t> Sound_Triggers;
var ()config array<v> v_Triggers;
var ()config bool bforceserverpackages,Antispam;
var bool soundinque;
var ()config int spamthreshold;
var ()config string leftescape,rightescape,chatnoticesound,questionescape;
var string wordlist[500];
var int spamtime;



//features:
//-Automattic Bulk import sounds from any file using /importtaunts <packagename>   ingame.
//-name relevency:
//   sound bite can be name dependednt, so everyone can have there perrsonal "lol" "haha" etc
//   this can also be used to control abused taunts maybe , or set to bogus name to disable taunt.
//- client opt out.
//  clients can opt out of hearing the taunts on there client using /toggeltaunts
//- taunt listing
//   typing /taunts will list all avalible taunts in the client console.
//-"vsay" taunts
//    vsay taunts are like the taunts in EDM , you can say a pharse such as LEFT< "eat t"  not instr
///    it will play a matching sound if available , and replace your text with the full quote.
//    such as  "eat t"  replace with "eat THat!". this replaces the entire chat string!
//- left/right/mid chooice.
//   having a << >> in the triggerword start/end will dicate weather the trigger word is explicitly  the left/right
//   having a ??? in the triggerword   indicates that it must have a "?" anywhere in the string to trigger off
//    no  << >> means instring anywhere.
// - !ns  in chat plays no sounds regardless of triggers
// antispam
//   time seconds based. if enabled taunts will not play intill spamthreshold has past in seconds
// random:
// for random , you may add more then one sound in playsnd seperated by comma  "x11taunts1.dog1,x11taunts1.dog2,x11taunts1.dog3"





function PostBeginPlay()
{
	AddGameRules();
	SaveConfig();
	if (bforceserverpackages)
	{
	forceserverpackages(); // fuck lucas
	}
}


function AddGameRules()
{
	local toasty227_GR gr;
	gr = Spawn(class'toasty227_GR');
	gr.MutatorPtr = self;
	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}



function  bool isokpackage(string xsound)
{
local int index;
local string package;
  index = instr(xsound,".");
  if( index != -1 )
    package = left(xsound,index);

   If (IsInPackageMap(package))
              {
               return true;
              }

  return false;
 // log("test: fail avalibility" $ package);

}



function string stpackage(string map)
{
local int index;
  index = instr(map," ");
  if( index != -1 )
  return ReplaceStr(map, "/importtaunts ", "");
}

function string stpackage1(string map)
{
local int index;
  index = instr(map," ");
  if( index != -1 )
  return ReplaceStr(map, "/pokepackage ", "");
}






//function bool evaluatechatstring(string chat)
//{
		//todo :
		// ingore sound for single chars such as 1 in long sentences.
        // ignore numbers when the string contains more then one possible occurance.
        // we can handle this using the  to many sounds ? if theres already one sound in the  sentance , but we see another , play none.

//}



function string handleChat( PlayerPawn Chatting,string Msg )
{
local int i;
local sound TheSound;
// local string js;
local bool notataunt;

notataunt = true;

          if (msg == "/help")
          {
           Chatting.ClientMessage("[TauntControl]  /taunts  -Chat sounds settings ");

          }


		  if (instr(msg,"/importtaunts")!=-1)
          {

		    if (chatting.badmin)
                {
                Chatting.ClientMessage("[TauntControl]");
		        importsoundpack(stpackage(msg),chatting);
                return "";
                }else{
				Chatting.ClientMessage("only admin can import sounds.");
				return "";
				}
          }



		    if (instr(msg,"/pokepackage")!=-1)
          {

		    if (chatting.badmin)
                {
                Chatting.ClientMessage("[TauntControl]");
		        pokesoundpack(stpackage1(msg),chatting);
                return "";
                }else{
				Chatting.ClientMessage("only admin can import sounds.");
				return "";
				}
          }


	 	  if (msg == "/toggletaunts")
          {
		    if (Player_Preferences[getnamedata(chatting)].taunts)
		    {
		     Player_Preferences[getnamedata(chatting)].taunts = false;
		     Chatting.ClientMessage("clientside taunts disabled", 'event');
			 saveconfig();
		    }else{
		     Player_Preferences[getnamedata(chatting)].taunts = true;
		     Chatting.ClientMessage("clientside taunts enabled", 'event');
			 saveconfig();
		    }
		      return "";
		   }

		  if (msg == "/togglechatnotice")
          {
		    if (Player_Preferences[getnamedata(chatting)].chatnotice)
		   {
		     Player_Preferences[getnamedata(chatting)].chatnotice = false;
		     Chatting.ClientMessage("clientside chatnotice disabled", 'event');
			 saveconfig();
		   }else{
		     Player_Preferences[getnamedata(chatting)].chatnotice = true;
		     Chatting.ClientMessage("clientside chatnotice enabled", 'event');
			 saveconfig();
		    }
		      return "";
		   }


		   if (msg == "/taunts")
          {
		   Chatting.ClientMessage("TauntControl :Play taunts = "$Player_Preferences[getnamedata(chatting)].taunts, 'event');
		   Chatting.ClientMessage("TauntControl :Play chat notice = "$ Player_Preferences[getnamedata(chatting)].chatnotice, 'event');
		   Chatting.ClientMessage("TauntControl :chat /toggletaunts  to disable hearing taunts", 'event');
		   Chatting.ClientMessage("TauntControl :chat /togglechatnotice  to disable hearing chat sound (not beep)", 'event');
		   Chatting.ClientMessage("TauntControl : /pokepackage <package> ,  /importtaunts <package name>", 'event');
           Chatting.ClientMessage("TauntControl :Available taunts", 'event');

    	   For( i = 0; i <  Array_Size(Sound_Triggers) ; i++  )
	         {
				If( Sound_Triggers[i].PlaySnd != "")
		        {
		            if (isokpackage(Sound_Triggers[i].PlaySnd))
		            {
					  if (Sound_Triggers[i].namerelevant != "" && Sound_Triggers[i].namerelevant != " ")
					  {
					     // only to playername
					     Chatting.ClientMessage("TauntControl : #" $ I $ " String Text : "$ Sound_Triggers[i].Trigger $ " -    Sound: " $Sound_Triggers[i].PlaySnd  $ " Relevent only to " $ Sound_Triggers[i].namerelevant , 'event');
                      }else{
					     // all users
					     Chatting.ClientMessage("TauntControl : #" $ I $ " String Text : "$ Sound_Triggers[i].Trigger $ " -    Sound: " $Sound_Triggers[i].PlaySnd  , 'event');

					  }

					}else{
                    Chatting.ClientMessage("TauntControl : #" $ I $ " String Text : "$ Sound_Triggers[i].Trigger $ " -    Sound: Unavalible on server" , 'event');

                    }
		        }

			 }


				//vsay
				Chatting.ClientMessage("TauntControl : Available vsay quotes", 'event');
				For( i = 0; i <  Array_Size(v_Triggers) ; i++  )
	           {
				   If( v_Triggers[i].PlaySnd != "" )
		           {
		           Chatting.ClientMessage("TauntControl vsay: #" $ i $
				                          " trigger Text : "$ v_Triggers[i].textin $ "-" $
										  "  Sound: " $ v_Triggers[i].PlaySnd $
										  "     output Qoute: " $ v_Triggers[i].textout , 'event');
				   }
     	        }


			 Chatting.ClientMessage("TauntControl : ---end of list---", 'event');
	        return "";
		   }


	For( i = 0; i <  Array_Size(Sound_Triggers) ; i++  )
    {
		If( Sound_Triggers[i].Trigger != "" )
		{





			if(managepatterns(Sound_Triggers[i].trigger,msg) && isokpackage(Sound_Triggers[i].PlaySnd)   && isnamerelevent(i ,chatting) && checkspam(chatting) )
			{
			   log ("spamtime = "$ Level.TimeSeconds);
			   spamtime = Level.TimeSeconds;

			    notataunt = false;
				if (soundinque)
				{
				// ignore multiple trigger words in one sentance.
				//Chatting.ClientMessage("TauntControl - You have to many sounds in the cue to play.", 'event');
				}


				  TheSound = Sound(DynamicLoadObject(handlerandom(Sound_Triggers[i].PlaySnd), Class'Sound' ));
				  //Log("Attempting to load "$handlerandom(Sound_Triggers[i].PlaySnd)$", if none, failed: "$TheSound);
				  if ( TheSound != None )
				  {
				    if (!soundinque)
				    {
				 	 Playersplay(TheSound,"taunt");
					 soundinque = true;
					 }else{
					 log ("to many sounds");
					}

				  }



			}
		}
	}

    soundinque = false;
// not the greatest implementation
// handle vsay
	For( i = 0; i <  Array_Size(v_Triggers) ; i++  )
	{
		If( v_Triggers[i].textin != "" )
		{
			 if(msg ==v_Triggers[i].textin  && isokpackage(v_Triggers[i].PlaySnd))
			{
			    notataunt = false;
				TheSound = Sound(DynamicLoadObject( v_Triggers[i].PlaySnd, Class'Sound' ));
				Log("Attempting to load "$v_Triggers[i].PlaySnd$", if none, failed: "$TheSound);
				if ( TheSound != None )
				{
					Playersplay(TheSound,"taunt");
					Msg = v_Triggers[i].textout;
				}
			}
		}
	}




soundinque = false;



    if (notataunt && isokpackage("G_assests_snds.chat"))
	  {
	    	TheSound = Sound(DynamicLoadObject("G_assests_snds.chat", Class'Sound' ));
	        Playersplay(TheSound,"beep");
	      //  log(getname(chatter) $ " causes a chat notification");
	  }


	     // sanitize  this
	     if (instr(msg,"!ns")!=-1)
         {
		 msg = ReplaceStr(msg, "!ns", "");
	     }




	Return msg;
}




function breakstring(string cmd,string breakerdelimiter)
{
    local int i, words;
   cmd=cmd$breakerdelimiter;
   for(i=0;i<500;i++)
   {
     if (i > 499) break;
	 WordList[i]="";
   }
  while ((len(cmd)) > 1)
   {      while(left(cmd,1) != breakerdelimiter )
       { wordlist[words]=wordlist[words]$left(cmd,1);
        cmd=right(cmd,len(cmd)-1);}
     // found one word....
     cmd=right(cmd,len(cmd)-1);
     if ( (wordlist[words]!=breakerdelimiter)&&(wordlist[words]!="") )  words++;  // ignore " " / "" as word itself
   } // end while len(Command) > 1)
  cmd="";
  // executing commands
}




function string handlerandom(string stringdata)
{
// if more then one sound is in the
local int i,f;
local string lol;
breakstring(stringdata,",");

 For( i = 0; i <  25 ; i++  )
     {
       if (wordlist[i] != "" && wordlist[i] != " " && wordlist[i] != "nil")
       {
	   f++;
	   }
     }
     lol = wordlist[rand(f)];
	 //log ("rand = " $ lol);

	 return lol;
}



function bool checkspam(playerpawn p)
{
               if ( int(Level.TimeSeconds) - spamtime < spamthreshold)
			   {
			    if (Antispam)
			    {
			    return false;
			    }else{
				return true;
				}

			   }

			   return true;

}

function bool managepatterns(string trigger,string chat)
{
// manage < or > or none
//  we dont influence the trigger word
// all we do is return if the chat should execute based on the trigger.

local string action,realstring;
        action = "";


		// check for nosounds
		 if (instr(chat,"!ns")!=-1 )
             {
				 return false;
			 }




         // check for left position
         if (instr(trigger,"<<")!=-1)
         {
		 action = "left";
		 realstring = ReplaceStr(trigger, "<<", "");
	         if  (left(chat,len(realstring)) == realstring)
		     {
			  return true;
			 }
		 }

		 // check for Right position
		 if (instr(trigger,">>")!=-1)
         {
		     action = "right";
		     realstring = ReplaceStr(trigger, ">>", "");
		     if  (right(chat,len(realstring)) == realstring)
		     {
			 return true;
			 }
		 }


		 // trigger only if  there is a ? within the chat string
		 // and our string it in the chat
		 if (instr(trigger,"???")!=-1)
         {

    		 realstring = ReplaceStr(trigger, "???", "");
		     if (instr(chat,"?")!=-1 && instr(chat,realstring)!=-1)
             {
			 action = "question";
			 return true;
			 }

		 }


		 // check for else center position
		 if (action =="")
		 {
		   realstring = trigger;
		   if (instr(chat,trigger)!=-1)
           {
		   return true;
		   }

		 }

return false;
}






function bool isnamerelevent(int h ,playerpawn p)
{
local string pp,ll;

//log (h);
// true === play sound
 //no execute if nam != blank && name != name

 pp = getname(p);
 ll = Sound_Triggers[h].namerelevant;

   if (pp == ""  )
   {
   return true;
   }

    if (pp == " "  )
   {
   return true;
   }

  //  blanky
  if (Sound_Triggers[h].namerelevant == ""  )
  {
  return true;
  }

  if (Sound_Triggers[h].namerelevant == " ")
  {
  return true;
  }

  // not blanky and a matchy pass!@
  // player specific
  if ( caps(pp) == caps(ll))
  {
  return true;
  }

  // not blanky and not players
  // allow
  if (Sound_Triggers[h].namerelevant != pp)
  {
  return false;
  }



return true;
}



function PlayersPlay( sound X,string bobcock )
{

local pawn p;

	for( P = level.pawnlist; P != None; P=P.NextPawn )
	{
		If ( P.IsA('playerpawn') )
		{

		 if (bobcock =="taunt")
		 {
				if (Player_Preferences[getnamedata(playerpawn(p))].taunts  )
				{
				//log(getname(p) $ " requests allow taunt in there settings");
				Playerpawn(P).ClientPlaysound(X);
				}else{
				//log(getname(p) $ " requests disallow taunt in there settings");
				}

		  }


          if (bobcock !="taunt")
		 {

				if (Player_Preferences[getnamedata(playerpawn(p))].chatnotice && bobcock =="beep")
				{
			     // log(getname(p) $ " requests allow chatnotice  in there settings");
				Playerpawn(P).ClientPlaysound(X);
				}else{
                //  log(getname(p) $ " requests  to disallow chat notice  in there settings");
			    }

		  }




		}
	}


}




function string getname(playerpawn p)
{ // find the fuckers name
local PlayerReplicationInfo PRI;

PRI=p.PlayerReplicationInfo;
return PRI.PlayerName;
}



function int getnamedata(playerpawn p)
{ // converted to dynamic array 12/7/2015
local PlayerReplicationInfo PRI;
local int i, n , playerpositionintable;
local bool found;


    For( i = 0; i <  Array_Size(Player_Preferences) ; i++  )
    {
       // Existing data.
	   if (Player_Preferences[i].player == getname(p))
	   {
       playerpositionintable = i;
	   found = true;
	   return playerpositionintable;
       }
    }


    if (!found)
    {
     // New data
     n = Array_Size(Player_Preferences);
     Array_Size(Player_Preferences, n + 1);
     Player_Preferences[n].player = getname(p);
	 Player_Preferences[n].taunts = true;
     playerpositionintable = n;
     found = true;
	 saveconfig();
     return playerpositionintable;

    }

}


function importsoundpack(string pack,playerpawn p)
{
	local array<Object> ObjL;
	local int c,i;
	local sound a;
	if ( !LoadPackageContents(pack,Class'Sound',ObjL) )
	{	return;	};
	c = Array_Size(ObjL);
	if ( c==0 )	{return;	};
	log ("Server is importing assests, lag may occur!");
	for( i=0; i<c; ++i )
	{
		a = Sound(DynamicLoadObject(string(ObjL[i]), Class'Sound' ));
        if(a != None)
		{
		p.ClientMessage("Asset" $ string(ObjL[i]), 'event');


	 addtaunttolist(string(ObjL[i]),p);

		}
	};

}





function pokesoundpack(string pack,playerpawn p)
{
	local array<Object> ObjL;
	local int c,i;
	local sound a;
	if ( !LoadPackageContents(pack,Class'Sound',ObjL) )
	{	return;	};
	c = Array_Size(ObjL);
	if ( c==0 )	{return;	};
	log ("Server is importing assests, lag may occur!");
	for( i=0; i<c; ++i )
	{
		a = Sound(DynamicLoadObject(string(ObjL[i]), Class'Sound' ));
        if(a != None)
		{
		p.ClientMessage("Packaged Asset" $ string(ObjL[i]), 'event');

		}
	};

}




 function removepackageitems(string packx,playerpawn p)
{
local int j;


  For( j = 0; j <  Array_Size(Sound_Triggers) ; j++  )
    {

       //if (InStr(caps(Sound_Triggers[j]),caps(packx)) != -1 )
     //  {

      // }

	}
}


function addtaunttolist(string soundbite,playerpawn p)
{
local int j,n;
local bool herealready;

    // check if existing
    For( j = 0; j <  Array_Size(Sound_Triggers) ; j++  )
    {
        if (Sound_Triggers[j].PlaySnd == soundbite)
	{
	herealready = true;
	p.ClientMessage("Asset " $ soundbite $ " already in list!", 'event');
	//Log("The sound is already in the list.");
	break;
	}

    }

    // Add new data slot
    if (!herealready)
    {
     n = Array_Size(Sound_Triggers);
     Array_Size(Sound_Triggers, n + 1);
     Sound_Triggers[n].PlaySnd = soundbite;
     Sound_Triggers[n].Trigger=soundbite;
     p.ClientMessage("Asset " $ soundbite $ " imported into slot " $ n, 'event');
     saveconfig();

    }

}




function forceserverpackages()
{
local int j;
    For( j = 0; j <  Array_Size(Sound_Triggers) ; j++  )
    {
        if (Sound_Triggers[j].PlaySnd != "")
		{

		     if (!IsInPackageMap(breakpackage(Sound_Triggers[j].PlaySnd)))
		     {
			 log("added sound file  to packages :" $  breakpackage(Sound_Triggers[j].PlaySnd),stringtoname("[Toasty227]" ));
			 addToPackagesMap(breakpackage(Sound_Triggers[j].PlaySnd));

			 }
		}

	}





}

function string breakpackage(string map)
{
local int index;
  index = instr(map,".");
  if( index != -1 )
  map = left(map,index);
  return map;
}

defaultproperties
{
}
