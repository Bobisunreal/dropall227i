class sn_shit_mutator expands Mutator
 Config(dropall227);

var() config bool blogin,blogout;
var () config color somecolor;

var string cachedactors[16];
var actor cachedowners[16];
var bool hunting;
var playerpawn j;

function BeginPlay()
{
	log( "Loading spawn notify replacer V1.1" ,stringtoname("[SN_SHIT]"));
	AddGameRules();
	Addtracker();

}



function AddGameRules()
{
	local sn_shit_GR gr;

	gr = Spawn(class'sn_shit_GR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}

function Addtracker()
{
	local sn_shit gr;
	gr = Spawn(class'sn_shit');
	gr.MutatorPtr = self;


}



function bool handleChat( PlayerPawn Chatting, out string Msg )
{

   if (msg == "/help")
   {
   //chatting.ClientMessage("[spawnnotify_toy]  Persistant decoration  build 2022.8.0 '/debugspawn' to dump objects");
    // chatting.ClientMessage("[spawnnotify_toy]  Persistant decoration  build 2023.3.9 '/debugspawn' to dump objects"); 
      chatting.ClientMessage("[spawnnotify_toy]  Persistant decoration  build 2023.3.14 '/debugspawn' to dump objects"); 	
     return true;
   }

   if (msg == "/debugspawn")
   {
   j = Chatting;   // playerpawn chatting
   cleanindex();   // clear the list
   hunting = true; // start logging
   SetTimer(8,false,'hunractors'); // disable after 10 seconds
   return false;
   }



  return true;// pass it on
}



function receivenotify( actor A )
{
 // basicly send every spawn to the player.
 if(hunting)
{
 //log(a.name, stringtoname("[Sn_Shit debug]"));
  if (checkindex(string(a.CLASS))) // check if already there false = found
  {
   
   buildindex(string(a.CLASS),a);   // add it
  }

// log(a.name, stringtoname("[Sn_Shit debug]"));
}

}








function buildindex(string acto,actor a) // this is silly , but its added on later
{
local int i;
 For( i = 0; i <  15 ; i++  )
     {
       if (cachedactors[i] == "")
       {
       cachedactors[i]=acto;
	   cachedowners[i]=a.owner;
	   // log(acto$ " " $ i, stringtoname("[Sn_Shit debug_new1]"));

	   return;
       }
     }

}

function dumpindex()
{
local int i;
 For( i = 0; i <  15 ; i++  )
     {
       if (cachedactors[i] != "")
       {
       j.ClientMessage(txtclr() $ "Spawndebug - (#sn"$i$ ") " $ cachedactors[i] $ "  (" $ string(cachedowners[i]) $ ")");
       }
     }

}


function string txtclr()
{
 return Level.Game.MakeColorCode(somecolor);

}

function bool checkindex(string g)
{
local int i;
 For( i = 0; i <  15 ; i++  )
     {
       if (cachedactors[i] != "" && cachedactors[i] != " ")
       {
         if (cachedactors[i] == g)
         {
         return false;
         }


       }
      }
	  return true;
}


function cleanindex()
{
local int i;
 For( i = 0; i <  15 ; i++  )
     {
     cachedactors[i] = "";
     cachedowners[i] = none;
     }


}

function hunractors()
{
hunting = false;
dumpindex();
}











defaultproperties
{

}
