class essentials expands Mutator;


var bool serverabrupt;
// decrare our avalible achevment count!
var int achevmentcount;


//var SQLite SQLDB;
var string wordlist[500];      // Putting full command in word pieces
var  playerpawn tempp;

//ending
var  bool endable;
var int badendattempts;
var databaseinterationclass dbobject;
var string beentoldonce[64];

Struct urldata_structure
{
// save 3 bits to attenticate.
var() string url, ip,player;
};

var () config  array<urldata_structure> cached_player_urls;


Struct killlogrraystructure
{
	var() string pawnname, player,damage;
};


Struct spotarraystructure
{
	var() string mapname, warpname;
	var() vector zlocation;
};



Struct tprequeststructure
{
	var() int requester,personaskedtoteleport ,fromid, toid;
	var() int timestamp;
	var() bool hasbeenaccepted;
};

var() tprequeststructure tprequests[32];

Struct autovoteendstructure
{
var() config string player;
var() config bool vote;
};

var() Config bool bnostatlogging,benoLoginSystem;


// var() config array<string> maps;
var() config array<string> chatlog;
var() config array<string> hookmutators;
var() Config autovoteendstructure autovoteend[32];


Struct adminundostructure
{
var() config string player, action,oldvalue,shortprop;
};

var () config  array<adminundostructure> undoarray;
var () config  array<spotarraystructure> spotarray;
// var () config  array<killlogrraystructure> killlog;
var () config  string EscapePhrase,databasename;
var () config bool returnfreindlyfire;
//var () config float returnfreindlyfireprc;
var () config color somecolor,redcolor,greencolor;

 Struct initpawnlist
     {
      var() string       pawnname;
      var() int          pawncount;
      var() bool         hate;
     };

// auto list for summon/ load
Struct actor_list{var() string objpack, objclass;};
var () array<actor_list> avalibleobjectsarray;



var() int shutdowncountdown;
var() playerpawn serverkiller;
var actor aimbind[32];
var actor spawnbind[32];
var string aimclass[32];
var string packageclasscontents[500];

// ic mutare/read/write storage
var int endblock,ic_len;
var string eatinglist[500];

var string eatinglist_inv[100];
var int endblock_inv;

var string extra_url_args;




function PostBeginPlay()
{
    local string CreatechatDBQuery,CreateAdminCommandDBQuery,dbtest;
	//local int Column, Row;
	//local string Value,a,b,c;
	local string testname;
	//local float appsex,appsex2;
	//AppSeconds(appsex);
    local string S;
	local int i;
    local ESSENTIALS unfek;
    local int countm;

  ic_len = 198;
  foreach AllActors(Class'ESSENTIALS', unfek)
  {
  // log ("Found "$unfek.name$ " Instances already running" );
     countm++;
  }
  //log ("Found "$countm $ " Instances already running" );
  if (countm > 1)  {
                   log("double found -bye-bye");
                   destroy();
                   }

	if (databasename !="" || databasename !=" ")
	{
	databasename = "essentials.sqlite3db";
	}

	S = Level.GetLocalURL();


	log ("-----------------------------------------------------------------------------",stringtoname("------------"));
	log (" Loading Essentials v1a for 227i",stringtoname("[Essentials]"));
	log ("-----------------------------------------------------------------------------",stringtoname("------------"));
    // need to spawn db before we do map switch!
    dbobject = spawn(class'databaseinterationclass');
	if(dbobject != None)
	{
	 log("db spawned",stringtoname("[Essentials]"));
	 dbobject.addintvalue("system" , "serverstartups");

	}

    if( InStr(S,"?crash=true")!=-1 )
	{
      // we land here if the running.ini is present at launch.

        if (InStr(S,"?restarted=true")!=-1)
	    {
	    // already changed our url
	    log ("Travel logger present !",stringtoname("[Essentials]"));
	    dbobject.addintvalue("system" , "uptime_maps");
        //dbobject.updatedatavalue ("system", "abruptstart","false");
	    log ("Server last Restrated Abnormaly!",stringtoname("[Essentials]"));

        }else{
        // server started abruptly - wrestart the counters and add our tag
        log ("Attaching travel logger!",stringtoname("[Essentials]"));
        log ("Server last Restrated Abnormaly!",stringtoname("[Essentials]"));
        dbobject.updatedatavalue ("system", "uptime_maps","none");
        dbobject.updatedatavalue ("system", "abruptstart","true");
        // jump to same map with new arguments!
        serverabrupt = true;

        //Server switch level 0.0.0.0/
        //Level.ServerTravel(S$"?restarted=true",false);
        //ReplaceStr(s, "0.0.0.0/", "")
        log (">>> Navagating with restarted=true token ",stringtoname("[Essentials]"));
        //Level.ServerTravel(ReplaceStr(s, "0.0.0.0/", "")$"?restarted=true",false);
		//Level.ServerTravel(ReplaceStr(s, "0.0.0.0/", "")$"?restarted=true",false);
		log ("extra_url_args Has pending flags.",stringtoname("[Essentials]"));
		extra_url_args = "?restarted=true";
        log ("-----------------------------------------------------------------------------",stringtoname("------------"));
        return;
        }




    }else{
         // server started up "normaly"


        if (InStr(S,"?restarted=true")!=-1)
	    {
	    // already tagged
	    log ("travel logger present !",stringtoname("[Essentials]"));
        dbobject.addintvalue("system" , "uptime_maps");
        dbobject.updatedatavalue ("system", "abruptstart","false");
        }else{
        // not yet tagged
        log ("attaching travel logger!",stringtoname("[Essentials]"));
        dbobject.updatedatavalue ("system", "uptime_maps","none");
        dbobject.updatedatavalue ("system", "abruptstart","false");
        // jump to same map with new arguments!
        //Level.ServerTravel(ReplaceStr(s, "0.0.0.0/", "")$"?restarted=true",false);
		extra_url_args = "?restarted=true";
		log ("extra_url_args Has pending flags.",stringtoname("[Essentials]"));

        }
    }





    log ("server uptime = " $dbobject.getdatavalue ("system" , "uptime_maps"),stringtoname("[Essentials]"));
	log (" Command Escape string is " $ EscapePhrase,stringtoname("[Essentials]"));
	//log (" Initaliing sql DataBase   " $ databasename,stringtoname("[Essentials]"));

	//CreateChatDBQuery = "CREATE TABLE if NOT EXISTS ChatDB(Player STRING,Chat STRING,DateTime STRING, PRIMARY KEY(DateTime,Chat));";
	//CreateAdminCommandDBQuery = "CREATE TABLE if NOT EXISTS AdminCommandDB(Player STRING,Action STRING,Oldvalue STRING,Shortprop STRING,DateTime STRING, PRIMARY KEY(DateTime,Action));";
    //dbtest = "CREATE TABLE if NOT EXISTS configDB(Player STRING,property STRING,value STRING, PRIMARY KEY(player,property));";
	//log ("Setting endable to true!",stringtoname("[Essentials]"));
	endable = true;

    //declare achvment count !
	achevmentcount = 10;







	//SQLDB = spawn(class'SQLite');
	//if(SQLDB != None)
    //	{
	//	SQLDB.InitDatabase(databasename);
	//	SQLDB.Query(CreateChatDBQuery);
	//	SQLDB.Query(CreateAdminCommandDBQuery);
	//	SQLDB.Query(DBtest);
    //
	//	testname = "testplayer";


        // SQLDB.Query("INSERT INTO configDB SET player='Marty', property='0' , value='true';" );
        // "insert or replace into configDB (player, property, value) values ((select player from configdb where Name = 'playername' && property = 'namez'), 'SearchName', ...);"


         //SQLDB.Query("INSERT INTO configDB SET Name='" $ testname $ "', property=name , value='" $ testname$"';");
         //SQLDB.Query("UPDATE configDB SET value='altereddata' WHERE Name='testplayer' , property='name';");
	   // this works
	   //foreach SQLDB.GetQueries("select player,Chat,DateTime from ChatDB where Player = 'Bob';",Column,Row,Value)
	    // {

	   //  if (string(row) == "0") {a = Value;}
	   //  if (string(row) == "1") {b = Value;}
		// if (string(row) == "2") {
		// c = Value;
		// log (c$" "$a$" "$b);
		// }

		//log("Column '" $ Column $"' Row '" $ Row $"' Value '" $ Value $ "'");
	    // }

	//    log ("sql DataBase initalized " ,stringtoname("[Essentials]"));
	//}

	AddGameRules();
	SaveConfig();
	MakeEndingsVisible();
	spawnmutators();
	//AppSeconds(appsex2);
	//log("Init time " $ appsex2-appsex  ,stringtoname("[Essentials]"))


buildsutolist();


}


function string xPrelogin(string Options,string PlayerName)
{
addurltocache(Options , consolecommand("GetPreLoginAddress"), playername);
log("options look like " $ Options $ "  user ip is " $ consolecommand("GetPreLoginAddress"),stringtoname("[Essentials]"));

adminmessage("Prelogin : " $consolecommand("GetPreLoginAddress")$ " :  " $playername $" "  $ Options );

//if ( consolecommand("GetPreLoginAddress") == "24.14.27.144")
//{
 //adminmessage("Prelogin : denied troll player at prelogin");
 //return "Troll ;)";
//}


if (InStr(caps(playername),"PLAYER")!=-1 )
	    {
	      adminmessage("Prelogin Rejected : Server requires A Valid name to join!");
          return "Server requires A Valid name to join!";
        }
 //?Password=z?Class=UnrealShare.FemaleOne?Name=bob?Skin=Female1Skins.Drace?Face=?Team=1
 }

function addurltocache (string url , string ip , string xplayer)
{
local int i;

// log the user to the db
// set this up better later
dbobject.updatedatavalue ("loggedplayer" , xplayer,ip);



if (Array_Size(cached_player_urls) < 1)
{
i = 0;
}else{
i = Array_Size(cached_player_urls) -1;
}

	                     Array_Insert(cached_player_urls,Array_Size(cached_player_urls),1);
	                   	 cached_player_urls[i].url=url;
						 cached_player_urls[i].ip=ip;
						 cached_player_urls[i].player=xplayer;

}


function string txtclr()
{
 return Level.Game.MakeColorCode(somecolor);

}



event NotifyLevelChange() //No idea if this even gets this call..
{
	Super.NotifyLevelChange();
	//if(SQLDB != None)
	//{
	//	SQLDB.CloseDatabase();
	//	log (" Closing sql DataBase   ",stringtoname("[Essentials]"));
	//}
}

event destroyed()
{
	//if(SQLDB != None)
	//{
	//	SQLDB.CloseDatabase();
	//	log (" Closing sql DataBase   ",stringtoname("[Essentials]"));
	//}
}



function playerstats()
{
local string localbs,values,dodgebs;
local int i,achivemintcount,avalibleachevments;
 local mutator mut;

 if (!bhasaccount(tempp))
 {
 tempp.ClientMessage("you need to register a account to use this feature!");
 tempp.ClientMessage("register a account");
 return;
 }

	 localbs = dbobject.concatgroups ("player."$getplayername(tempp)$".Killstats");
     ExecuteCommand(localbs);
     For( i = 0; i <  200 ; i++  )
     {
       if (wordlist[i] != "" && wordlist[i] != " " && wordlist[i] != "nil")
       {
       values =  dbobject.getdatavalue ("player."$getplayername(tempp)$".Killstats" , wordlist[i]);
        if (values != "nil")
        {
          tempp.ClientMessage("killed " $ values $ " " $ wordlist[i]);
        }
       }

     }

         // levels ended
        values = dbobject.getdatavalue ("player."$getplayername(tempp) , "levelsended");
        if (values != "nil")
        {
          tempp.ClientMessage("Levels ended by you " $ values);
        }else{
          tempp.ClientMessage("Levels ended by you  none");
        }

         // levels participation
        values = dbobject.getdatavalue ("player."$getplayername(tempp) , "levelspartake");
        if (values != "nil")
        {
          tempp.ClientMessage("Levels ended with you" $ values);
        }else{
          tempp.ClientMessage("Levels ended with you  none");
        }

      // achivments
      localbs = dbobject.concatgroups (getplayername(tempp)$".achivments");
      ExecuteCommand(localbs);
      //tempp.ClientMessage("[achivments]");
      //tempp.ClientMessage(localbs);
      //log (localbs);
      For( i = 0; i <  200 ; i++  )
     {
       if (wordlist[i] != "" && wordlist[i] != " " && wordlist[i] != "nil")
       {

         values =  dbobject.getdatavalue (getplayername(tempp)$".achivments" , wordlist[i]);
        if (values != "nil")
        {
          tempp.ClientMessage("" $ wordlist[i] $ "  " $values);
          achivemintcount ++;
        }


       }


     }


     // try to get avalible achevments from other mods!
     // this is a clever hack !
     foreach AllActors(Class'mutator',mut)
   	 {
   	      dodgebs = "0";
    	  dodgebs = consolecommand("get "$string(mut.class) $" achevmentcount");
    	  //log(dodgebs);
   	      if (dodgebs != "" && dodgebs != " " && instr(dodgebs,"Unrecognized")==-1 )
   	      {
   	      //log("yes " $ dodgebs);
   	      //Unrecognized property
   	      tempp.ClientMessage("Mod "$ string(mut.class)$ " adds " $ dodgebs $ " achevments" );
   	      avalibleachevments  = avalibleachevments + int(dodgebs);
   	      }
   	 }




   tempp.ClientMessage( achivemintcount$" of " $avalibleachevments $ "unlocked");






}


function count_pawns()
  {
     local int  basecnt,i,tempilit;
     local scriptedpawn s_pawn;
     local bool befound;
     local  initpawnlist  initlist[200];


     basecnt = 0;
     foreach AllActors(Class'scriptedpawn',s_pawn)
   	 {
   	      if ( s_pawn != None )
    	  {
    	    befound = false;
            basecnt=(basecnt+1);

            // if the entry existes , increment
            For( i = 0; i <  200 ; i++ )
            {
             if(string(s_pawn.class) == initlist[i].pawnname  && !befound)
               {
                befound = true;
                initlist[i].pawncount++;
                //dbobject.addintvalue("test" , initlist[i].pawnname);
               }

            }


             if (!befound)
             {
               // if we look and didnt find
               For( i = 0; i <  200 ; i++  )
               {
                  if (initlist[i].pawnname == "" && !befound)
                  {
                   initlist[i].pawnname = string(s_pawn.class);
                   //dbobject.addintvalue("test" , initlist[i].pawnname);


                   befound = true;
                   initlist[i].pawncount++;
                  }
               }

             }


          }//none



   	 }//for

   	 //our counting was done!
     tempp.ClientMessage(txtclr() $ "Monstercount is " $ basecnt  $ "  enities");
   	 Log(" Monstercount is " $ basecnt  $ " enemy enity",stringtoname("[Essentials]"));
     //Log("Spread:",'MobManager');
     // Dump the spread
     For( tempilit = 0; tempilit <  200 ; tempilit++  )
     {
        if ( initlist[tempilit].pawnname != "")
        {

          if (initlist[tempilit].pawncount < 10)
          {
          tempp.ClientMessage(txtclr() $"Found 0" $  initlist[tempilit].pawncount  $ "   Of   Entity  " $ initlist[tempilit].pawnname);
          }else{
          tempp.ClientMessage(txtclr() $"Found " $  initlist[tempilit].pawncount  $ "   Of   Entity  " $ initlist[tempilit].pawnname);
          }
        }

     }
}







function toggle_ending()
{
   if (endable)
   {
     endable = false;
	 tempp.ClientMessage(txtclr() $ "]");
   }else{
     endable = true;
	 tempp.ClientMessage(txtclr() $"end on");
   }

}

function bool ismapsafe(string map)
{

local int index;

  // Parse appropriate map name.
  index = instr(map,"#");
  if( index != -1 )
    map = left(map,index);

  index = instr(map,"?");
  if( index != -1 )
    map = left(map,index);

  index = instr(map,"/");
  if( index != -1 )
    map = left(map,index);

  // Attempt load
  return (dynamicLoadObject(map$".MyLevel",class'level') != none);



}


function bool mutateservertravel(string url)
{

// unless we have a good reason , return true.

 // set up any pending url prams we are waiting on.
       if (extra_url_args != "")
	   {
	   log ("appling extra_url_args  flags.",stringtoname("[Essentials]"));
	   url = url$extra_url_args;
	   }else{
	   url = url;
	   }



//extra_url_args = "?restarted=true";

performlevelendactions(none);
return true;
}

function performlevelendactions(playerpawn ender)
{ // log achivents etc for players
local PlayerPawn p;


foreach AllActors(class'PlayerPawn',p)
  {

    // particapnts only , not ender!
    if (ender != p && ender != none)
    {

      dbobject.addintvalue("player." $getplayername(p) , "levelspartake");

      // give particapants credit as well
      if(
      int(left(Level.TimeSeconds,2)) < 60 &&
      dbobject.getdatavalue(getplayername(p)$".achivments" ,"speedrunpartake") == "nil"
      )
      {
       p.ClientMessage("-------------------------------------------------");
       p.ClientMessage("[Achivment]  Speedrun partake!  Be Present when somone else ends a map in under a minute ");
       p.ClientMessage("-------------------------------------------------");
       dbobject.updatedatavalue (getplayername(p)$".achivments", "speedrunpartake","Be Present when somone else ends a map in under a minute " $ stampachevmet(ender));
       }

       if(
       int(left(Level.TimeSeconds,4)) < 3599 &&
       dbobject.getdatavalue(getplayername(p)$".achivments" ,"TakeYourtimepartake") == "nil"
       )
       {
       p.ClientMessage("-------------------------------------------------");
       p.ClientMessage("[Achivment]  Take Your time partake! Be Present when somone takes  more then 1 hour before ending a  map");
       p.ClientMessage("-------------------------------------------------");
       dbobject.updatedatavalue (getplayername(p)$".achivments", "TakeYourtimepartake","Be Present when somone takes  more then 1 hour before ending a  map" $ stampachevmet(ender));
       }
      }

      if (ender == none)
      {
        // server ends map
       if(dbobject.getdatavalue(getplayername(p)$".achivments" ,"stalemate") == "nil" )
       {
       p.ClientMessage("-------------------------------------------------");
       p.ClientMessage("[Achivment]  stalemate The map you played ended with no winner.");
       p.ClientMessage("-------------------------------------------------");
       dbobject.updatedatavalue (getplayername(p)$".achivments", "stalemate","The map you played ended with no winner" $ stampachevmet(ender));
       }
      }




  }






}


function string mutatecooptravel(pawn ender,string nexturl)
{

  // the map is alloed to end via toggleend
  if (endable)
  {

     if (ender == none)
     {
       // A command issued this request and its ok to end

       // check if  next map is broken
       if (!ismapsafe(nexturl))
	   {
	   log("bad map "$ nexturl,stringtoname("[Essentials]"));

	   // if we fail 3 times break out!
	   bypassbrokenmap();
	   badendattempts++;
	   return "";
	   }

     // everything went fine!
	 log (" game ended level " $  nexturl,stringtoname("[Essentials]"));
	 // set up any pending url prams we are waiting on.
       if (extra_url_args != "")
	   {
	   log ("appling extra_url_args  flags.",stringtoname("[Essentials]"));
	   return nexturl$extra_url_args;
	   }else{
	   return nexturl;
	   }
	 }



     // some player hit the ending  and it ok to end
     if (ender.IsA('PlayerPawn'))
     {
	   // check if  next map is broken
	   if (!ismapsafe(nexturl))
	   {
	    playerpawn(ender).ClientMessage("Bad map Url?");
		log("bad map",stringtoname("[Essentials]"));

		// if we fail 3 times break out!
	    bypassbrokenmap();
	    badendattempts++;
        return "";
	    }

        log ("level time " $ Level.TimeSeconds, stringtoname("[Essentials]"));
        log ("level time " $ left(Level.TimeSeconds,2),stringtoname("[Essentials]"));
        playerpawn(ender).ClientMessage(" level  completion time : " $ left(Level.TimeSeconds,2) );
        //float!
	   // everything went fine!
       log ("player ender : " $string(ender.name) $  nexturl,stringtoname("[Essentials]"));
       dbobject.addintvalue("player." $getplayername(playerpawn(ender)) , "levelsended");

     If (
     int(dbobject.getdatavalue("player." $getplayername(playerpawn(ender))$".achivments" ,"levelsended")) > 24 &&
     dbobject.getdatavalue(getplayername(playerpawn(ender))$".achivments" ,"enderzgame") == "nil"
     )
     {
     playerpawn(ender).ClientMessage("-------------------------------------------------");
     playerpawn(ender).ClientMessage("[Achivment]  Enderzgame! End 25 maps");
     playerpawn(ender).ClientMessage("-------------------------------------------------");
     dbobject.updatedatavalue (getplayername(playerpawn(ender))$".achivments", "speedrun","End 25 maps" $ stampachevmet(playerpawn(ender)));
     }


     // leace here for no!
     if(
     int(left(Level.TimeSeconds,2)) < 60 &&
     dbobject.getdatavalue(getplayername(playerpawn(ender))$".achivments" ,"speedrun") == "nil"
     )
     {
     playerpawn(ender).ClientMessage("-------------------------------------------------");
     playerpawn(ender).ClientMessage("[Achivment]  Speedrun! end a map in under 1 minute");
     playerpawn(ender).ClientMessage("-------------------------------------------------");
     dbobject.updatedatavalue (getplayername(playerpawn(ender))$".achivments", "speedrun","End a map in under 1 minute" $ stampachevmet(playerpawn(ender)));
     }

     if(
     int(left(Level.TimeSeconds,4)) < 3599 &&
     dbobject.getdatavalue(getplayername(playerpawn(ender))$".achivments" ,"TakeYourtime") == "nil"
     )
     {
     playerpawn(ender).ClientMessage("-------------------------------------------------");
     playerpawn(ender).ClientMessage("[Achivment]  Take Your time! spend more then a hour before ending a  map");
     playerpawn(ender).ClientMessage("-------------------------------------------------");
     dbobject.updatedatavalue (getplayername(playerpawn(ender))$".achivments", "TakeYourtime","Spend more then a hour before ending a  map" $ stampachevmet(playerpawn(ender)));
     }

       // set up any pending url prams we are waiting on.
       if (extra_url_args != "")
	   {
	   log ("appling extra_url_args  flags.",stringtoname("[Essentials]"));
	   return nexturl$extra_url_args;
	   }else{
	   return nexturl;
	   }
        
       
     }



  }

  // the map is NOT alloed to end via toggleend
  if (!endable)
  {
        //A command issued this request.

        // advance will  be blocked
        // but switchlevel will be ok
        // so we should probably allow this.
        // we can get a call here before level change

        if (ender == none)
        {
	     log ("server requested level switch with end blocked "$  nexturl,stringtoname("[Essentials]"));
	     return "";
	    }


        // some player hit the ending
        if (ender.IsA('PlayerPawn'))
        {
	    playerpawn(ender).ClientMessage(txtclr() $"End Disable by object Essentials.gamerule");
        log ("end blocked " $string(ender.name) $  nexturl,stringtoname("[Essentials]"));
        return "";
	    }

  }





}

 function bypassbrokenmap()
 {
   // if we fall a few times in a row , load somthing else
   if (badendattempts > 2)
   {
       // set up any pending url prams we are waiting on.
       if (extra_url_args != "")
	   {
	   consolecommand("switchcooplevel nyleve"$ extra_url_args);
	   }else{
	   consolecommand("switchcooplevel nyleve");
	   }
   //consolecommand("switchcooplevel nyleve");
   bcastbs("Next Map load failure , loading up nyleve");
   }


 }

function showloggedplayers()
{
local string  localbs,values,values2;
local int  i;
      localbs = dbobject.concatgroups ("loggedplayer");
     ExecuteCommand(localbs);
     For( i = 0; i <  200 ; i++  )
     {

       if (wordlist[i] != "" && wordlist[i] != " " && wordlist[i] != "nil")
       {
       values =  dbobject.getdatavalue ("loggedplayer" , wordlist[i]);
       values2 =  dbobject.getdatavalue (wordlist[i]$".nickserv" , "identity");
        if (values != "nil")
        {
          tempp.ClientMessage("Player  " $ wordlist[i] $ "  IP: " $ values $ " identity: " $ values2);
        }
       }

     }



}




function xscoreKilled(Pawn Killed, Pawn Killer, name DamageType)
{
 //local int I;
 local string l;

if (Killer !=None  && Killer.IsA('PlayerPawn') && !killed.IsA('PlayerPawn'))
	{

	if (!bnostatlogging)
	{
	  l = playerpawn(killer).PlayerReplicationInfo.playername;
	  dbobject.addintvalue("player." $l$".Killstats" , string(Killed.class));
        // we need to do some magic here to know if a we are playing as a monsterplayer
        // and not combine all players named "krall"
    /*
     // should really cache this  istead of checking db every kill?
     if (dbobject.getdatavalue("player." $l$".Killstats" ,"UnrealI.Krall") > "20" &&
         dbobject.getdatavalue(l$".achivments" ,"krallparty") == "nil")
     {
     playerpawn(killer).ClientMessage("------------------------------------------------");
     playerpawn(killer).ClientMessage("[Achivment]  unlocked krallparty - Kill 20 krall");
     playerpawn(killer).ClientMessage("------------------------------------------------");
     dbobject.updatedatavalue (l$".achivments", "krallparty","Kill 20 Krall" $ stampachevmet(playerpawn(killer)));
     }


     if (dbobject.getdatavalue("player." $l$".Killstats" ,"UnrealI.Titan") > "20" &&
         dbobject.getdatavalue(l$".achivments" ,"titanterrorist") == "nil")
     {
     playerpawn(killer).ClientMessage("------------------------------------------------");
     playerpawn(killer).ClientMessage("[Achivment]  unlocked titan terrerist! - Kill 15 titan");
     playerpawn(killer).ClientMessage("------------------------------------------------");
     dbobject.updatedatavalue (l$".achivments", "titanterrorist","titan Terrerist "  $ stampachevmet(playerpawn(killer)));
     }


     if (playerpawn(killer).bAdmin  &&  dbobject.getdatavalue(l$".achivments" ,"hacker") == "nil" &&
     dbobject.getdatavalue(getplayername(playerpawn(killer)) $".nickserv" ,"admingroup") == "nil")
    {
     playerpawn(killer).ClientMessage("------------------------------------------------");
     playerpawn(killer).ClientMessage("[Achivment]  unlocked hacker! - became admin once while not in a admin group!");
     playerpawn(killer).ClientMessage("------------------------------------------------");
     dbobject.updatedatavalue (l$".achivments", "hacker","Become admin while not part of a admin group"  $ stampachevmet(playerpawn(killer)));
     }




    */
	}
   }



}


function MakeEndingsVisible()
{
local actor A;
local texture tex;

//log("Making endings Visible ", stringtoname("[Essentials]"));
  // dont care
	foreach AllActors(class'Actor',A)
	{
		if ( a.isa('Teleporter') && ( InStr( Teleporter(a).URL, "#" ) > -1 || InStr( Teleporter(a).URL, "?" ) > -1 || InStr( Teleporter(a).URL, "/" ) > -1 ) )
		{
		     If (!IsInPackageMap("g_assests_text"))
              {


			  if (ispackageavalible("g_assests_text"))
			       {
				   log("Texture resource 'g_assests_text' not in sandbox  can not replace endsprite " $ string(a.name) , stringtoname("[Essentials]"));
				   addToPackagesMap("g_assests_text"); // we can ty , but we my fail.
				   }else{
				  // log("Texture resource 'g_assests_text' file not installed  can not replace endsprite " $ string(a.name) , stringtoname("[Essentials]"));
				    // this file is gone forever , cant find itin backups.
                   }


              }else{
		       Tex = Texture( DynamicLoadObject("g_assests_text.map_change", Class'Texture' ) );
			   a.Texture = tex;
			   }
			A.bHidden = False;

			a.bAlwaysRelevant = True;
			a.Drawscale = 1;
		}
	}
}



function AddGameRules()
{
	local essentials_GR gr;

	gr = Spawn(class'essentials_GR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}


function tp()
{

local bool onep,twop;
local playerpawn a , b;


 // there is a fail case were the speficfied named player is not present , a
 //a nd it teleports to webadmin.
 //ScriptLog: phrase debug :  essentials /tp xaleros
// [Essentials]: TP DEBUG first ok
// [Essentials]: TP DEBUG really not none


 // # in arg 1
 if (wordlist[1] != "" || wordlist[1] != "" )
 {
   if (returnpfromid(int(wordlist[1])) != none )
   {//first arg is player
      if ( InStr(returnpfromid(int(wordlist[1])),"MessagingSpectator")  != -1)
         {
          log("matched spectator error");
          tempp.ClientMessage(txtclr() $" invalid id/name*");
          }else{
           onep = true;
          }

    log(returnpfromid(int(wordlist[1])));
    log("TP DEBUG first ok",stringtoname("[Essentials]"));
    a = returnpfromid(int(wordlist[1]));
   }
 }

 // # in arg 2
 if (wordlist[2] != "" || wordlist[2] != "" )
 {if (returnpfromid(int(wordlist[1])) != none)
   {//second arg is player
    twop = true;
    log("TP DEBUG second ok",stringtoname("[Essentials]"));
    b = returnpfromid(int(wordlist[2]));
   }
 }


 // name in arg 1
 // there is a fail case were the player is not present , and it teleports to webadmin.
 if (wordlist[1] != "" || wordlist[1] != "" )
 { if (checkisplayername(wordlist[1]) != none)
   {//first arg is player
    onep = true;
    log("TP DEBUG first name ok",stringtoname("[Essentials]"));
    a =  checkisplayername(wordlist[1]);
   }
 }


  // name in arg 2
 if (wordlist[2] != "" || wordlist[2] != "" )
 { if (checkisplayername(wordlist[2]) != none)
   {//first arg is player
     twop = true;
     log("TP DEBUG second name ok",stringtoname("[Essentials]"));
     b =  checkisplayername(wordlist[2]);

   }
 }


 if (!twop && onep && a != none)
 {  // no second argument , move self  to onep;
  //log("one and two ok + not none");
  // none return a reference even tho its none.
  if(checkisplayername(wordlist[1]) != none || returnpfromid(int(wordlist[1])) != none)
  {
   log("TP DEBUG really not none",stringtoname("[Essentials]"));
   jzsummonP(a,tempp);
  }else{
    log("TP DEBUG really  none",stringtoname("[Essentials]"));
    tempp.ClientMessage(txtclr() $" invalid id/name");
   }
 }

 if (!twop && onep && a == none)
 {  // no second argument , move self  to onep;
 log("TP DEBUG one and !two ok + == none",stringtoname("[Essentials]"));
 tempp.ClientMessage(txtclr() $" invalid id/name");
 }

 if (twop && onep)
 {  //  move p1 to p2;
 jzsummonP(a,b);
 log("TP DEBUG one and two",stringtoname("[Essentials]"));
 }


 if (onep == false )
 {
 tempp.ClientMessage(txtclr() $" tp move  <id/player>  to <id/player>");
 tempp.ClientMessage(txtclr() $" tp  goto <id/playe>");
 }



}




function spawnmutators()
{
local int z;

// will regret this implementation later when i want to be a shithead and spawn server actors as mutators
// add support for arguments  mutator ifpackage:serverpackagerequired map:maponly



log ( "Spawning Hookmutators",stringtoname("[Essentials HookMutator]"));

         For( z = 0; z < Array_Size(hookmutators) ; z++ )
        {

           ExecuteCommand(hookmutators[z]);

		             If(hookmutators[z] != ""
					    && InStr(caps(wordlist[0]),"!") == -1
			            && InStr(caps(wordlist[0]),"/") == -1
						&& InStr(caps(wordlist[0]),":") == -1
					   )
                            {

							  //ExecuteCommand(hookmutators[z]);

							   if (wordlist[1] != "" && wordlist[1] != " ")
							   {
							     //log (string(level.outer));
							       // map condition
							       if (InStr(caps(wordlist[1]),caps("Map=")) != -1 && InStr(caps(wordlist[1]),caps(string(level.outer))) != -1)
                                   {

										 log ( " map condition match " $ wordlist[1],stringtoname("[Essentials HookMutator]"));
										  addgamemutator(wordlist[0],z);
                                   }


                                    if(InStr(caps(wordlist[1]),caps("Map!=")) != -1)
                                    {
                                     log ( " map disable match " $ wordlist[1],stringtoname("[Essentials HookMutator]"));


                                    }



                                    // map codition with no match
								   if (InStr(caps(wordlist[1]),caps("Map=")) != -1 && InStr(caps(wordlist[1]),caps(string(level.outer))) == -1)
                                   {
								      log ( " map condition no match " $ wordlist[1],stringtoname("[Essentials HookMutator]"));
								     // map= with no match
								      if (InStr(caps(wordlist[1]),caps("Map!=")) != -1 )
                                      {
								      log ( " map condition DISABLE " $ wordlist[1],stringtoname("[Essentials HookMutator]"));
								      // map= with no match
                                      }
								   }


                                   // not possible
								   if (InStr(caps(wordlist[1]),caps("Map=")) == -1 && InStr(caps(wordlist[1]),caps("Map!=")) == -1)
                                   {
								  // log ( "  Spawning " $ wordlist[0],stringtoname("[Essentials HookMutator]"));
								   // mutator with no argument
								   addgamemutator(wordlist[0],z);
							       }



							   }else{
                                  log ( " Adding mutator " $ wordlist[0],stringtoname("[Essentials HookMutator]"));
							      addgamemutator(wordlist[0],z);

							   }


		                    } // not !
	             }//for


}



function addgamemutator(string hook_mutator,int index )
{

local class<actor> Mut;
local actor M;


			                  Mut = Class<actor>(Dynamicloadobject(hook_mutator,class'Class'));
			                  M=Spawn(Mut);
		                         If( M==None )
		                           {
			                        Log("Failed to create "$hook_mutator$".",stringtoname("[Essentials HookMutator]"));
									hookmutators[index]="!FAIL! " $hook_mutator;
			                        }else{
					                     //log(string(m.outer));




									               if( m.IsA('gamerules')  )
		                                           {
												   log ("Spawned external Gamerule " $  hook_mutator,stringtoname("[Essentials HookMutator   -------------]"));
												   }

												   if( m.IsA('mutator')  )
		                                           {
												   //log ("Spawned external Mutator " $  hook_mutator,stringtoname("[Essentials HookMutator   -------------]"));
												   }

												   if(! m.IsA('gamerules')  &&  ! m.IsA('mutator') )
		                                           {
												   log ("Spawned external object " $  hook_mutator,stringtoname("[Essentials HookMutator  -------------]"));
											   }


									   }




}







function checkDamage( Pawn victim, Pawn InstigatedBy, out int Damage, vector HitLocation, name DamageType, out vector Momentum )
{
   if (InstigatedBy !=None  && InstigatedBy.IsA('PlayerPawn') && (Victim != InstigatedBy) )
	{
		// When player shoot other player
		if( Victim.IsA('PlayerPawn')  )
		{
			if (returnfreindlyfire )
           {
			InstigatedBy.TakeDamage( damage, InstigatedBy, InstigatedBy.Location, Vect(0,0,0), 'all');
			InstigatedBy.ClientMessage("Received return friendly fire -" $ damage);
		    damage = 0;
		    }
        }
    }


}


function createaccount(playerpawn p,string args)
{
log("createlogin " $ args);
  //ExecuteCommand(args);

  //change pw
  // old pw wordlist[0]
  // new pw ?wordlist[1]




 // no data for account
 if (	dbobject.getdatavalue ( getplayername(p) $".nickserv" ,"password") != "nil")
 {
log("createlogin dblookup" $ args);
    // change password to second arg
    if (dbobject.getdatavalue ( getplayername(p) $".nickserv" ,"password") == wordlist[0] && wordlist[0] != "" && wordlist[0] != " " && wordlist[1] != "" && wordlist[1] != " ")
    {
    dbobject.updatedatavalue (getplayername(p) $".nickserv" , "password",wordlist[1]);
    p.ClientMessage("[nicksrv] Password changed! ");
    p.ClientMessage("[nicksrv] you login password is now " $ wordlist[1]);
    p.ClientMessage("[nicksrv] you login password was " $ wordlist[0]);
    p.ClientMessage("[nicksrv] To athenticate in future, type plogin " $ args);
    p.ClientMessage("[nicksrv] Your hash " $ consolecommand("ugetplayeridentity " $ getplayeridfromp(p)));
    dbobject.updatedatavalue (getplayername(p) $".nickserv" , "identity",consolecommand("ugetplayeridentity " $ getplayeridfromp(p)));
    log("nickserv: "$ getplayername(p) $ "changed there account password",stringtoname("[nicksrv]"));
    accountlogin(p,wordlist[1]);
    return;
    }






    // accont exists already
    // dont allow overide existing acconts
    if (	dbobject.getdatavalue ( getplayername(p) $".nickserv" ,"password") == args && args != "" && args != " ")
    {
    // some matching user/password
    p.ClientMessage("[nicksrv] you accounts already registered.  Type createaccount <oldpass> <newpass>  to change password.");
    p.ClientMessage("[nicksrv] some account security info here.");
    }else{
    // this accounts arlready registed, please /login or use another name
    p.ClientMessage("[nicksrv] nick already in use!");
    log("nickserv: "$ getplayername(p) $ " tried to make a account using a unavalibe nick",stringtoname("[nicksrv]"));
    }

 }


 if (	dbobject.getdatavalue ( getplayername(p) $".nickserv" ,"password") == "nil" && args != "" && args != " ")
 {
  dbobject.updatedatavalue (getplayername(p) $".nickserv" , "password",args);
  dbobject.updatedatavalue (getplayername(p) $".nickserv" , "identity",consolecommand("ugetplayeridentity " $ getplayeridfromp(p)));
  p.ClientMessage("nick "  $ getplayername(p) $ " has been registered");
  p.ClientMessage("you login password is now " $ args);
  p.ClientMessage("to athenticate in future, type plogin " $ args);
  p.ClientMessage("your hash" $ consolecommand("ugetplayeridentity " $ getplayeridfromp(p)));
  log("nickserv: "$ getplayername(p) $ " registered there account",stringtoname("[nicksrv]"));
  authuseratjoin(p);

 }

}



function accountlogin(playerpawn p,string args)
{


 if (dbobject.getdatavalue ( getplayername(p) $".nickserv" ,"password") == "nil")
 {



 p.ClientMessage("[Nicksrv]: your nick is not registered.");

      if (isaccountbanned(p))
      {
      p.ClientMessage("[Nicksrv]: The name your using is marked as banned!",'networking');
      p.Destroy();
      }

 }else{

      if (isaccountlocked(p))
      {
      p.ClientMessage("[Nicksrv]: to many password Attempts, Account locked");
      p.ClientMessage("[Nicksrv]: contact a admin for assistance in unlocking your account.");
      return;
      }


      if (isaccountbanned(p))
      {
      p.ClientMessage("[Nicksrv]: Your account has been banned!");
      p.Destroy();
      return;
      }


   if (	dbobject.getdatavalue ( getplayername(p) $".nickserv" ,"password") == args )
   {
     if (isvaladatedp(p))
     {// player already logged in
       p.ClientMessage("[Nicksrv]: Your already logged in");
       showaccountinfo(p);

     }else{
      p.ClientMessage("[Nicksrv]: Password ok., updating session id");
      dbobject.updatedatavalue (getplayername(p) $".nickserv" , "identity",consolecommand("ugetplayeridentity " $ getplayeridfromp(p)));
      dbobject.updatedatavalue (getplayername(p) $".nickserv" , "lastip",consolecommand("ugetplayerip " $ getplayeridfromp(p)));
      dbobject.updatedatavalue (getplayername(p) $".nickserv" , "loginattemps","0");
      authuseratjoin(p);

     }


   }else{
   p.ClientMessage("invalid password.");
  dbobject.addintvalue(getplayername(p) $".nickserv" , "loginattemps");


   }




 }





}


function showaccountinfo(playerpawn p)
{
 p.ClientMessage("[Nicksrv]: last login ip " $ dbobject.getdatavalue(getplayername(p) $".nickserv" ,"lastip"));


}

function bool isaccountlocked(playerpawn p)
{

// password failures
   if (dbobject.getdatavalue (getplayername(p) $".nickserv" , "loginattemps")  != "nil")
      {
            if (int(dbobject.getdatavalue (getplayername(p) $".nickserv" , "loginattemps")) > 5)
            {
            return true;
            }
      }

return false;
}


function bool  isaccountbanned(playerpawn p)
{

   //return true for ban - value = reason
   if (dbobject.getdatavalue (getplayername(p) $".nickserv" , "banned")  != "nil")
      {
        //p.ClientMessage("[Nicksrv]: " $ dbobject.getdatavalue (getplayername(p) $ ".nickserv" , "banned"));
        //p.Destroy();
      return true;

      }

return false;
}




function mutaterespwan( Pawn Spawner )
{
local string ip,gg;
local actor act;
//log("spawner");


if ( Spawner.IsA('PlayerPawn') && Spawner != none )
		{

        //log("Mutate respawn : player spawned" ,stringtoname("[Essentials]"));
        ip=consolecommand("ugetplayerip " $ getplayeridfromp(playerpawn(Spawner)));
		gg=consolecommand("ugetplayeridentity " $ getplayeridfromp(playerpawn(Spawner)));


        dbobject.addintvalue(getplayername(playerpawn(spawner)), "num_of_respawns");
        //playerpawn(spawner).ClientMessage("test data : You have spawned " $ dbobject.getdatavalue(getplayername(playerpawn(spawner)), "num_of_respawns") $ " Times   chat /stats  for full stats" );







              // one shot!
         if (beentoldonce[getplayeridfromp(playerpawn(Spawner))] != "true")
         {
           beentoldonce[getplayeridfromp(playerpawn(Spawner))] = "true";

           //delay the bs!
           spawnblockdelay(playerpawn(Spawner));

         }




        }


}



function string fetchloginpassword(playerpawn p)
{
  local int i;
  local string pass;
  local string bfound;
   For( i = 0; i <  Array_Size(cached_player_urls) ; i++  )
    {
                          // check ther ip + username from prelogin
                          if (cached_player_urls[i].player == getplayername(p) && consolecommand("ugetplayerip " $ getplayeridfromp(p)) == cached_player_urls[i].ip)
					      {
					        // last entry!
                            pass = ParseOption(cached_player_urls[i].url, "Password");
                           // log ("password ="$pass);

                          }


    }
    return pass;
}


function string fetchloginprop(playerpawn p, string prop)
{
  local int i;
  local string pass;
  local string bfound;
   For( i = 0; i <  Array_Size(cached_player_urls) ; i++  )
    {
                          // check ther ip + username from prelogin
                          if (cached_player_urls[i].player == getplayername(p) && consolecommand("ugetplayerip " $ getplayeridfromp(p)) == cached_player_urls[i].ip)
					      {
					        // last entry!
                            pass = ParseOption(cached_player_urls[i].url, prop);
                           // log ("password ="$pass);

                          }


    }
    return pass;
}






function authuseratjoin(playerpawn p)
{
local string gg,hh;
local string cachedplayeridfromdb; //performance

           if ( !benoLoginSystem) {return;};// break out of this

            gg=consolecommand("ugetplayeridentity " $ getplayeridfromp(p));


              //fetchloginprop(playerpawn p, string prop)
              //Voice=publicvoicepack2.publicvoice


        if (!dbobject.returnbool(getplayername(p) , "has_seen_help_once"))
        {
        //p.ClientMessage(txtclr() $ "**** Test is a test server! , game experenance may vary and thing may change or be unstable! **** ");
        displayhelp(p);
        dbobject.setbool(getplayername(p),"has_seen_help_once",true);
        }

              log("voice (" $fetchloginprop(p,"Voice") $ ")");
             If (ispackageavalible(breakpackage(fetchloginprop(p,"Voice"))) )
			       {
                    p.ClientMessage("[voicepacks] your perfered voicepack " $ fetchloginprop(p,"Voice") $ " is avalible on this server");
                   }else{
                   if (fetchloginprop(p,"Voice") != "")
                      {
                       p.ClientMessage("[voicepacks] your perfered voicepack " $ fetchloginprop(p,"Voice") $ " is not installed on this server");
                      }
                   }


            if(IsInPackageMap(breakpackage(fetchloginprop(p,"Skin"))))
           {
            p.ClientMessage("[skinsurf] your perfered skin has been applied");
            log("Skin for player " $  getplayername(p) $ " " $ fetchloginprop(p,"Skin") $ " has been applied", stringtoname("[skinsurf]") );

           }else{
           // not in map

                   If (ispackageavalible(breakpackage(fetchloginprop(p,"Skin"))))
			       {
                    p.ClientMessage("[skinsurf] The skin You Specified  " $ fetchloginprop(p,"Skin") $ " Is not in package map");
                    log("[skinsurf]  perfered skin " $ fetchloginprop(p,"Skin") $ "  not in package map " $ getplayername(p), stringtoname("[skinsurf]") );
                   }else{
                    p.ClientMessage("[skinsurf] The skin You Specified " $ fetchloginprop(p,"Skin") $ " Is not on this server");
                    //p.ClientMessage("[skinsurf] Contact a admin with your skin for inclusion on this server");
                    log("[skinsurf]  perfered skin " $ fetchloginprop(p,"Skin") $ " not installed! " $ getplayername(p), stringtoname("[skinsurf]") );
                   }

           }


           if (isaccountbanned(p) && !benoLoginSystem)
           {
           p.ClientMessage("[Nicksrv]: The name your using is marked as banned!    Reason =  " $ dbobject.getdatavalue (getplayername(p) $".nickserv" , "banned"),'networking');
           p.Destroy();
           }



           // check if you have a account
           if (	dbobject.getdatavalue (getplayername(p) $".nickserv" ,"password") == "nil")
           {
          // p.ClientMessage("[Nicksrv] your nick is not registered.");
           //p.ClientMessage("[Nicksrv] type createlogin <password>  to register your nick.");


		   if (!bnostatlogging)
		   {
          // p.ClientMessage("[Nicksrv] registering your nick saves your inventory and stats to the server");
           }else{
		   p.ClientMessage("[Nicksrv] server is not logging kill  stats  at this time !");
		   }
		   log("nickserv: no registered nick " $ getplayername(p), stringtoname("[nicksrv]") );
           }

           // check if our uid is fucked
           if (gg ==" " || gg == "")
           {
           p.ClientMessage("[Nicksrv]: cant get client indentity ,server busy? Try again in a bit!");
           log(" Player " $ getplayername(p) $ " bad uid return",stringtoname("[nicksrv]"));
           }



            if (isaccountlocked(p))
            {
              p.ClientMessage("[Nicksrv]  Warning ! your account was marked as locked!");
              p.ClientMessage("[Nicksrv]  the last  ip to fail login : " $ dbobject.getdatavalue(getplayername(p) $".nickserv" ,"lastip"));
              dbobject.updatedatavalue (getplayername(p) $".nickserv" , "loginattemps","0");
              p.ClientMessage("[Nicksrv]  locked flag removed.!");
            }




             //join password
            if (fetchloginpassword(p)  == dbobject.getdatavalue (getplayername(p) $".nickserv" ,"password")
             && fetchloginpassword(p) != "" && fetchloginpassword(p) != " "
             && dbobject.getdatavalue (getplayername(p) $".nickserv" ,"password") != "nil")
            {
             p.ClientMessage("[Nicksrv]: Join Password ok ., updating session id");
             dbobject.updatedatavalue (getplayername(p) $".nickserv" , "identity",consolecommand("ugetplayeridentity " $ getplayeridfromp(p)));
             dbobject.updatedatavalue (getplayername(p) $".nickserv" , "lastip",consolecommand("ugetplayerip " $ getplayeridfromp(p)));
             dbobject.updatedatavalue (getplayername(p) $".nickserv" , "loginattemps","0");

            }

            cachedplayeridfromdb=dbobject.getdatavalue(getplayername(p) $".nickserv" ,"identity");
            // possible exploit - if change name in first second




           // check if your uid matched stored
           if (	cachedplayeridfromdb != "nil"
               && cachedplayeridfromdb == gg
               && cachedplayeridfromdb != ""
               && cachedplayeridfromdb != " ")
           {
            p.ClientMessage("[Nicksrv] found identity " $ dbobject.getdatavalue(getplayername(p) $".nickserv" ,"identity"));
            log("nickserv: found nick identity for " $ getplayername(p) ,stringtoname("[nicksrv]"));





               if (dbobject.getdatavalue(getplayername(p) $".nickserv" ,"admingroup") != "nil")
               {

                      if (dbobject.getdatavalue(getplayername(p) $".nickserv" ,"admingroup") == "1")
                      {
                       p.badmin = true;
                       // ugoldmp workaround
                       p.ConsoleCommand("adminlogin geocachegz");
                       if  (serverabrupt)
                       {


                        p.ClientMessage("system: the server restarted abruptly at last restart");
                       }
                       log(" player " $ getplayername(p) $ "admin group 1" ,stringtoname("[nicksrv]"));
                       p.ClientMessage("[Nicksrv] administrative group " $ dbobject.getdatavalue(getplayername(p) $".nickserv" ,"admingroup"));
                      }

               }else{

                      p.ClientMessage("[Nicksrv] no administrative group  assigned");
                      log("[Nicksrv] no admin group!",stringtoname("[nicksrv]"));
               }

              loadsavedinventory(p);
              getmail(p);
              p.ClientMessage("Server uptime = " $dbobject.getdatavalue ("system" , "uptime_maps"));


           }


           // fail if identity dont match
           if (	cachedplayeridfromdb != "nil"
               && cachedplayeridfromdb != gg )
           {
            log("nickserv: stale session" $ getplayername(p) ,stringtoname("[nicksrv]"));
            p.ClientMessage("[Nicksrv] could not validate your account : (Client hash changed)");
            p.ClientMessage("[Nicksrv] please plogin with your password to reestablish session");
            p.ClientMessage("[Nicksrv] Tip: join server with your password to avoid this issue");
            //accountlogin(p,fetchloginpassword(p));


           }




}




function logindelay(playerpawn kplayer)
{

}


function loadsavedinventory(playerpawn p)
{
local string localbs,values,counts;
local int i;
local Class<Inventory> aInventoryClass;
local Inventory  copy,lol;
local PlayerReplicationInfo qp;

 if (dbobject.returnbool(getplayername(p) , "voteend"))
        {
         p.consolecommand("voteend");
		 
		  if (level.game.isa('WolfCoopGame'))
                 {
                   foreach AllActors(class'PlayerReplicationInfo',qp)
                    {
					 if (qp.owner==p && qp.isa('wPRI'))
					     {
						  qp.SetPropertyText("bvoteend", "true");
						 }
	                    
					}
		          }
		 
        }



p.ClientMessage("[inv]loading your collected invententy]"  );
//p.ClientMessage("[inv] ammo counts  not currently recovered , but are stored"  );
//p.ClientMessage("[inv] charge/copies are on the other hand not being stored atm. TODO"  );
localbs = dbobject.concatgroups (getplayername(p)$".inventory");
ExecuteCommand(localbs);
     For( i = 0; i <  200 ; i++  )
     {
       if (wordlist[i] != "" && wordlist[i] != " " && wordlist[i] != "nil")
       {
         values =  dbobject.getdatavalue (getplayername(p)$".inventory" , wordlist[i]);
         if (values != "nil" )
         {

           if( IsInPackageMap(breakpackage(wordlist[i])))
           {
           //log("debug item = " $wordlist[i]);
              aInventoryClass = class<Inventory>( DynamicLoadObject(wordlist[i], class'Class'));
              Copy = p.FindInventoryType(aInventoryClass);
                     if (Copy != NONE)
                     {
                      //p.ClientMessage("[inv]  item " $ wordlist[i] $  " already present ");

                     }else{
                           lol=p.Spawn(aInventoryClass);
                           if(lol!=none)
                           { // spawned!

                               if (caps(wordlist[i]) !=caps("UnrealShare.Nalifruit") && caps(wordlist[i]) !=caps("AssaultPortalgun.slowp") && caps(wordlist[i]) !=caps("AssaultPortalgun.slowb")&& caps(wordlist[i]) !=caps("UnrealShare.health"))
                              {
                              log("pass item = " $wordlist[i]);
                               lol.respawntime=0;
                               lol.pickupmessage="[inv]  recovered  item " $ wordlist[i];
                               lol.touch(p);
                              }else{
                              lol.destroy();

                              }

                             //p.ClientMessage("[inv]  recovered  item " $ wordlist[i]);
                             }else{
                             p.ClientMessage("[inv]  failed to recover  item " $ wordlist[i] $ " spawn error");
                            // log("debug item = " $wordlist[i]);
                             }
                     }

           }else{
            p.ClientMessage("[inv]  " $ wordlist[i] $  "Unable to load - Object not in package map!");
           }

         }

       }

     }





}



function getmail(playerpawn p)
{
local string localbs,values;
local int i,mailcount;
localbs = dbobject.concatgroups (getplayername(p)$".inbox");
ExecuteCommand(localbs);


      // getiing mail is broken due to the return having spaces in it.
     For( i = 0; i <  200 ; i++  )
     {
       if (wordlist[i] != "" && wordlist[i] != " " && wordlist[i] != "nil")
       {
        log (wordlist[i] ,stringtoname("[mailsrv]"));
         values =  dbobject.getdatavalue (getplayername(p)$".inbox" , wordlist[i]);
         if (values != "nil") //&& values == "unread")
         {
         mailcount ++;
         p.ClientMessage("Inbox -" $ wordlist[i]);
         }
       }
     }

if (mailcount > 0)
{
p.ClientMessage("Inbox you have " $ mailcount $ "unread messages in your inbox , chat /inbox markread to ignore them");
}else{
//p.ClientMessage("Inbox you have " $ mailcount  " messages in your inbox");
}



}

function sendmail(playerpawn p,string target,string message)
{
local string localbs;
local int i,mailcount;
local bool isuser,userpassed;

// lookup if a player was ever here
localbs = dbobject.concatgroups ("loggedplayer");
ExecuteCommand(localbs);


   //  check if  the user has been here

     For( i = 0; i <  200 ; i++  )
     {
       if (wordlist[i] != "" && wordlist[i] != " " && wordlist[i] != "nil")
       {
          if (wordlist[i] == target)
          {
           isuser = true;
          }

       }
     }



     if (!isuser )
       {
         // not been here
         p.ClientMessage("The user you requested has probably never been on this server!");

         if (dbobject.getdatavalue (target $".nickserv" ,"password") == "nil")
         {
          // no account
           p.ClientMessage("The user you requested to leave a message for has never setup a account!");
         }else{
           //  account but not logged at prelogin ? lol
           // i lul - but this can happen becuase we only started logging
           // prelogin later on
           userpassed  = true;
         }

       }else{
          // been here

         if (dbobject.getdatavalue (target $".nickserv" ,"password") == "nil")
         {
          //  no account here
         p.ClientMessage("The user you requested to leave a message for has never setup a account!");
         }else{
          //  account !
          userpassed  = true;
         }


       }


  if (userpassed)
  {
  // some user exists


  dbobject.updatedatavalue (target$".inbox" , "message~~~from~~~" $ getplayername(p) $ "~~~" $ stripspaces(message) ,"unread");
  p.ClientMessage("message saved, the user will see it next time he/she logs in!");
  }


}


// delimiter avoidance nonsence
function string stripspaces(string inputstr)
{
local int p,lenn;
lenn = len(inputstr);
For(p = 0; p <  lenn ; p++  )
                       {
                       inputstr = ReplaceStr(inputstr, " ", "~~~");


	                   }
 return inputstr;
}

function string putbackspaces(string inputstr)
{
local int p,lenn;
lenn = len(inputstr);
For(p = 0; p <  lenn ; p++  )
                       {
                       inputstr = ReplaceStr(inputstr, "~~~", " ");
	                   }
return inputstr;
}


function KillAllobj(string this)
{
//mainhandler.jcKillAll(thing,tag,pfly);
local actor mhedning;
local string tempstring;

tempstring = consolecommand("get "$ this $ " bstatic");
if (tempstring =="True")
{
consolecommand("set "$ this $ " bstatic false");
log ("static"  ,stringtoname("[Essentials]"));
tempp.ClientMessage("Server Killall - removing bstatic");
}

tempstring = consolecommand("get "$ this $ " bnodelete");
if (tempstring =="True")
{
consolecommand("set "$ this $ " bnodelete false");
log ("nodelete" ,stringtoname("[Essentials]"));
tempp.ClientMessage("Server Killall - removing nodelete");
}

tempstring = consolecommand("get "$ this $ " bstasis");
if (tempstring =="True")
{
consolecommand("set "$ this $ " bnstasis false");
log ("stasis" ,stringtoname("[Essentials]"));
tempp.ClientMessage("Server Killall - removing stasis");
}


 foreach AllActors(class'actor',mhedning)
  {  // capibale of destroying serverside actors or dynamicly loaded non server packages.
    if (mhedning.IsA(StringToName(this)))
    {
	 tempp.ClientMessage("Server Killall - Destroying " $ mhedning.class);
     mhedning.destroy();

	// if (mhedning != none)
	  //   {
	//	 tempp.ClientMessage("Server Killall - failed to delete " $ mhedning.class);
	  //   }
    }
  }
}




//------------------------------------------------------------------------------
//----------------- handle admin commands here--------------------------
//------------------------------------------------------------------------------

function string  handlecmd(playerpawn playa,string cmdstr)
{
local  string lump,mangle,mingle,bitbang,fulltemp;
local class<actor> ItemClass;
local int lastundo;
local actor snh,sny;
tempp =playa;

ExecuteCommand(cmdstr);


 foreach AllActors(class'actor',snh)
    { if(snh.IsA('sn_shit_mutator'))
      {
       sny = snh;
	   cmdstr = ReplaceStr(cmdstr, "#sn0", sny.GetPropertyText("cachedactors[0]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn1", sny.GetPropertyText("cachedactors[1]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn2", sny.GetPropertyText("cachedactors[2]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn3", sny.GetPropertyText("cachedactors[3]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn4", sny.GetPropertyText("cachedactors[4]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn5", sny.GetPropertyText("cachedactors[5]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn6", sny.GetPropertyText("cachedactors[6]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn7", sny.GetPropertyText("cachedactors[7]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn8", sny.GetPropertyText("cachedactors[8]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn9", sny.GetPropertyText("cachedactors[9]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn10", sny.GetPropertyText("cachedactors[10]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn11", sny.GetPropertyText("cachedactors[11]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn12", sny.GetPropertyText("cachedactors[12]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn13", sny.GetPropertyText("cachedactors[13]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn14", sny.GetPropertyText("cachedactors[14]"));
	   cmdstr = ReplaceStr(cmdstr, "#sn15", sny.GetPropertyText("cachedactors[15]"));
	   break;
      }
    }

 if (wordlist[0] == "players")
   {
    showloggedplayers();
   }

   if (wordlist[0] == "timerfun")
   {
   fucktimers();
   }

   if (wordlist[0] == "timerfun1")
   {
   fucktimers1();
   }

   if (wordlist[0] == "timerfun2")
   {
   fucktimers2();
   }

   if (wordlist[0] == "tickfun")
   {
   tickfun1();
   }

   if (wordlist[0] == "tickfun1")
   {
   tickfun2();
   }


  if (wordlist[0] == "dump_elements")
   {
   testdumpresources();
   }






   if (wordlist[0] == "UGetFullClientList" || wordlist[0] == "UGetBanList" || wordlist[0] == "UGetTBanList" )
   {
   tempp.ClientMessage("passing menu command");
   return  cmdstr;
   }

    if (wordlist[0] == "set")
   {
   
   
        if ( InStr(wordlist[1],".")==-1 )
		{
         fulltemp = returnmatchingfile(wordlist[1])$"." $ wordlist[1];
		   if ( InStr(caps(fulltemp),caps("broken"))==-1 )
		   { 
		   wordlist[1] = fulltemp;
		   tempp.ClientMessage(txtclr()$">Resolved to " $ wordlist[1]);
		   }
        }
		
		
     //try to look it up using get , but we could use getprop?
     lump = consolecommand("get " $ wordlist[1] $" " $  wordlist[2] );
	 mangle = "Unrecognized class "$ wordlist[1];
	 
     if ( lump == mangle)
      {
	  // Fail package not  loaded
            log("package not loaded",stringtoname("[Essentials]"));
            tempp.ClientMessage(txtclr() $  "SET - package not loaded in memory, loading");
            mingle = "unreali." $ wordlist[1];

			 //If (!IsInPackageMap(wordlist[1]))
             //{
             // tempp.ClientMessage(txtclr() $  "mod not in sandbox" , 'Pickup');
             //}
			 
                ItemClass = class<actor>(DynamicLoadObject( mingle, class'Class'));
	             if (ItemClass == none)
                     {
					 // stage 2 failed - package is invalid
					  tempp.ClientMessage(txtclr() $  "SET - tried to load package " $ "unreali."$ wordlist[1] $ ", we failed");
					 }else{
					 // try package load
					     lump = consolecommand(txtclr() $  "get " $ wordlist[1] $" " $  wordlist[2] );
						 if ( lump == mangle)
                            {
							 // package probaly didnt load at all , o well!
							 tempp.ClientMessage(txtclr() $  "SET - tried to get property " $ "unreali."$ wordlist[1] $ ", package unavalible or unregonized.");
     						}else{
							 tempp.ClientMessage(txtclr() $  "prior value = " $wordlist[1] $" " $  wordlist[2] $ " " $ lump);
							 saveundohistory (lump,cmdstr);
							 tempp.consolecommand(cmdstr);
							}


					    }

	   }else{
	   //pass stage1 tests
	   tempp.ClientMessage(txtclr() $  "prior value = " $wordlist[1] $" " $  wordlist[2] $ " " $ lump);
	   saveundohistory (lump,cmdstr);
	   tempp.consolecommand(cmdstr);
	   }



     }//set



	 if (wordlist[0] == "undo")
   {
     lastundo= getlastundo();

					bitbang="set "$undoarray[lastundo].shortprop $ " "$ undoarray[lastundo].oldvalue;
					consolecommand(bitbang);
					tempp.ClientMessage(txtclr() $  "undo: undid set " $ undoarray[lastundo].action  $ "  performed by "$undoarray[lastundo].player);
					undoarray[lastundo].action="";
					undoarray[lastundo].shortprop="";
					undoarray[lastundo].player="";
					undoarray[lastundo].oldvalue="";
					 saveconfig();


   }

    if (wordlist[0] == "undolist")
   {
    getundolist();
   }

      if (wordlist[0] == "get")
   {
    lump = consolecommand ("get " $ wordlist[1] $" " $  wordlist[2] );
    tempp.ClientMessage( lump);
   }



   if (wordlist[0] == "exit")
   {


	shutdowncountdown = 5;
	serverkiller.ClientMessage("Server restart...");
	SetTimer(1,true,'restartserverTimer');
	serverkiller = tempp;

 }

   return  cmdstr;

}



function restartserverTimer()
{


	if (shutdowncountdown > 1)
	{
	bcastbs("Server restarting in " $ shutdowncountdown $ " Seconds");
	log ("Server restarting in " $ shutdowncountdown $ " Seconds" $ " initated by " $ getplayername(serverkiller) ,stringtoname("[Essentials]"));
	}

	if (shutdowncountdown < 1)
	{
	 bcastbs("Server restarting!");
     //if(SQLDB != None)
	// {
	//	SQLDB.CloseDatabase();
	//	serverkiller.ClientMessage("Closing sql DataBase   ",stringtoname("[Essentials]"));
	// }
     //consolecommand("relaunch Ciudad-(E)-.unr?Game=JCoopZ1.JCoopZGame??Mutator=VotingHandler.VotingHandler?Difficulty=3 ini=unreal2014.ini log=create%today%-%now%.log port=6668 -server");
	 consolecommand("exit");
	}

   shutdowncountdown --;


}

function bcastbs(string what)
{
 local PlayerPawn q;
  foreach AllActors(class'PlayerPawn',q)
  {
  q.ClientMessage(what,'redcriticalevent',false);
  }
}



function Acastbs(string what)
{
 local PlayerPawn q;
  foreach AllActors(class'PlayerPawn',q)
  {
  if (q.bAdmin)
    {
     q.ClientMessage(what,'event',false);
    }
  }
}




function saveundohistory(string oldvalue,string cmdstr)
{
    local int I;
	local string UpdateAdminCommandDBQuery,timedate;
	timedate= level.month$"-"$level.day$"-"$level.year$" "$level.hour$":"$level.minute$":"$level.second;

    //basic sql attack prevention
   if(instr(cmdstr,"DROP TABLE")!=-1 || instr(cmdstr,"AdminCommandDB")!=-1 || instr(getplayername(tempp),"DROP TABLE")!=-1 || instr(getplayername(tempp),"AdminCommandDB")!=-1 )
   {
     log ("malformed Sql Query" $ getplayername(tempp) $":" $cmdstr ,stringtoname("[Essentials]"));
     tempp.ClientMessage("malformed Sql Query" $ getplayername(tempp) $":" $cmdstr);

   }else{

     //if(SQLDB != None)
     //{
	  //  //log to database
      // UpdateAdminCommandDBQuery = "INSERT INTO AdminCommandDB (Player,Action,oldvalue,Shortprop,datetime) VALUES ('"$getplayername(tempp)$ "','"$cmdstr$"','"$oldvalue$"','"$wordlist[1] $" " $  wordlist[2]$"','"$timedate$"');";
	//	SQLDB.Query(UpdateAdminCommandDBQuery);
	// }

   }

	i = Array_Size(undoarray) -1;
	Array_Insert(undoarray,Array_Size(undoarray),1);
	undoarray[i].action=cmdstr;
    undoarray[i].shortprop=wordlist[1] $" " $  wordlist[2];
    undoarray[i].player=getplayername(tempp);
    undoarray[i].oldvalue=oldvalue;
	SaveConfig();

}



 function AddMap( string MapName )
{
	local int i;

	//i = Array_Size(maps) -1;
//	  Array_Insert(maps,Array_Size(maps),1);
//	 maps[i]=MapName;

}


function getundolist()
{
local int i;



                       For( i = 0; i <  Array_Size(undoarray) ; i++  )
                       {

        					tempp.ClientMessage( Level.Game.MakeColorCode(somecolor) $ "action " $ undoarray[i].action $ "    old value =  " $ undoarray[i].oldvalue $ " performed by " $ undoarray[i].player);

	                   }
}


function int getlastundo()
{
local int i;
  For( i = 0; i <  Array_Size(undoarray) ; i++  )
                   {
					       if (undoarray[i].action =="")
					      {
						    if (undoarray[i].action =="0")
						    {
						    tempp.ClientMessage("SETundo - no data!" );
						    return 0;
						    }
                            return i - 1;
						  }
				  }


}

function string calcesp(string s)
{
return EscapePhrase $ s;
}


 function pmessage( string msg)
{
   local PlayerPawn q;
    foreach AllActors(class'PlayerPawn',q)
    {

    q.ClientMessage(msg);


    }
}




function string setgoal(string s)
{
local goalwatcher gr;


if (wordlist[1] =="" || wordlist[1] ==" " || wordlist[1] =="help")
       {
         tempp.ClientMessage("usage : goal # ... set kill goal",'Event',true);
	   }


	   if (wordlist[1] !="" && wordlist[1] !=" " )
       {
        gr = Spawn(class'goalwatcher');
        gr.backlink = self;
        gr.goalnum = String2Int(wordlist[1]);
        tempp.ClientMessage(" kill goal set to "$ wordlist[1],'Event',true);
        pmessage(getplayername(tempp) $ " has set server kill goal at " $ String2Int(wordlist[1]));
        pmessage("note score goal only applies to players in the server.");
        dbobject.updatedatavalue (getplayername(tempp)$".achivments", "SetupKillGoal","used teamgoal command" $ stampachevmet(tempp));


       }else{
	    //gr.goalnum   = 1000; // replace later with colision
        tempp.ClientMessage("usage : goal # ... set kill goal",'Event',true);

	   }


}



 function dzreadpawns()
 {  // read values from DZMapMutator ( custom spawned)
    // and copy it to a local array
    // struct MonsterSpawnType

   local actor h,ictarget;
   local int iv;
  local string eatinglist_dz[130];
   local int endblock_dz;

   // find the reference
   foreach AllActors(class'actor',h)
    { if(h.IsA('DZMapMutator'))
      { ictarget = h;  break;}
    }
    // check if it was ever found
    if (ictarget == none)
    {
    tempp.ClientMessage(Level.Game.MakeColorCode(redcolor) $ "Dont seem like DZMapMutator is running." ,'Event');
    log("error:  DZMapMutator probably not running");
    return;
    }

    // do the read
     For( iv = 0; iv <  125; iv++  )
     {
       eatinglist_dz[iv] = ictarget.GetPropertyText("monsterSpawn["$iv$"].PawnClass");
       log(iv $ ")" $ eatinglist_dz[iv]);
       log (ictarget.GetPropertyText("monsterSpawn["$iv$"].PClass"));
     if  (eatinglist_dz[iv]  =="")
      {
      //log("end at " $ iv);
      endblock_dz = iv;
      break;
      }
     }

 }

function icreadinv()
 {  // read values from icmutate.psspawn3 ( custom spawned)
    // and copy it to a local array
   local actor h,ictarget;
   local int iv;

   // find the reference
   foreach AllActors(class'actor',h)
    { if(h.IsA('InvSpawner2'))
      { ictarget = h;  break;}
    }
    // check if it was ever found
    if (ictarget == none)
    {
    tempp.ClientMessage(Level.Game.MakeColorCode(redcolor) $ "Dont seem like icmutator or 'InvSpawner2' is running." ,'Event');
    log("error:  icmutate probably not running");
    return;
    }

    // do the read
     For( iv = 0; iv <  100; iv++  )
     {
       eatinglist_inv[iv] = ictarget.GetPropertyText("inv["$iv$"]");
       log(iv $ ")" $ eatinglist_inv[iv]);
     if  (eatinglist_inv[iv]  =="")
      {
      //log("end at " $ iv);
      endblock_inv = iv;
      break;
      }
     }

 }


 function icread()
 {  // read values from icmutate.psspawn3 ( custom spawned)
    // and copy it to a local array
   local actor h,ictarget;
   local int iv;

   // find the reference
   foreach AllActors(class'actor',h)
    { if(h.IsA('PSSpawn3'))
      { ictarget = h;  break;}
    }
    // check if it was ever found
    if (ictarget == none)
    {
    tempp.ClientMessage(Level.Game.MakeColorCode(redcolor) $ "Dont seem like icmutator or 'PSSpawn3' is running." ,'Event');
    log("error:  icmutate probably not running");
    return;
    }

    // do the read
     For( iv = 0; iv <  ic_len ; iv++  )
     {
       eatinglist[iv] = ictarget.GetPropertyText("MonsterList["$iv$"]");
       log(iv $ ")" $ eatinglist[iv]);
     if  (eatinglist[iv]  =="")
      {
      //log("end at " $ iv);
      endblock = iv;
      break;
      }
     }

 }

 function icaddpackge(string pack)
 {
 // find all actors in a class,
    // only look for pawns
    // apend it to the end of the ic pawns list.
	local array<Object> ObjL;
    local class<actor> NewClass;
    local int i,dist,C,oldblock;
	local string classname;

	oldblock = endblock;

	   if ( LoadPackageContents(pack,Class'class',ObjL) )
	   {
            c = Array_Size(ObjL);            log(c);
            for( i=0; i<c; ++i )
	        {
            classname = string(ObjL[i]);
            NewClass = Class<actor>(DynamicLoadObject(classname,Class'Class'));
              if ( NewClass != None )
                 {
                 if (ClassIsChildOf( newclass, Class'pawn' ) )
                  {
                  //log(" i am pawn");
                  if (eatinglist[0]  =="" || eatinglist[0]  ==" " || eatinglist[0]  =="" )
                  {
                  //log(" i am breaking");
                  return;
                  }


                  if (checkICindex(classname))
                     {

                     if (oldblock > ic_len -1 )
                     {
                      log(" overflow ");
                      tempp.ClientMessage("overflow " $ oldblock $ ">" $ ic_len ,'Event');
                      break;

                     }
                     // log(" i am not in index");
                      eatinglist[oldblock] = classname;
                      log(" adding entry at " $ oldblock $ " " $ classname );
                      tempp.ClientMessage(" Adding Entry at " $ oldblock $ " " $ classname ,'Event');
                      oldblock ++;
                     }else{
                     //log("skip existing entry" );
                     //tempp.ClientMessage(" Skipping " $  classname $ " already in list" ,'Event',true);
                     }


                  // here
                  }
                 }
           }
      };
 }



function bool checkICindex(string g)
{ // return false if we exist in a array already
local int i;
 For( i = 0; i <  ic_len ; i++  )
     {

       if (eatinglist[i] != "" && eatinglist[i] != " ")
       {
       //log(" entry " $ eatinglist[i] $ " ; " $ g);
         if (caps(eatinglist[i]) == caps(g))
         {
         return false;
         }


       }
      }
	  return true;
	 // return false if we exist in a array already
}




 function icwrite()
 {  // write out the temporarry array  back to the extrnal mod.
   local actor h,ictarget;
   local int iv;
   // find refernce
    foreach AllActors(class'actor',h)
    { if(h.IsA('PSSpawn3'))
      {
       ictarget = h;
       break;
      }
    }
    //check if it was ever found
    if (ictarget == none)
    {
    tempp.ClientMessage(Level.Game.MakeColorCode(redcolor) $ "Dont seem like icmutator or 'PSSpawn3' is running." ,'Event');
    log("error:  icmutate probably not running");
    return;
    }

     //  checkif the data is valid, otherwise we could get data loss
     // espesally if you never read data first.
     if (eatinglist[0]  =="" || eatinglist[0]  ==" " || eatinglist[0]  =="" )
     { // i really dont wantto null out somone config, ifthey dont read in first. .
      log("No Data To write or bad data",'icwrite');
      tempp.ClientMessage(Level.Game.MakeColorCode(redcolor) $ "Aborting becuase the data to write may be blank" ,'Event');
      tempp.ClientMessage(" make sure you load the data first" ,'Event');
      return;

     }else{
        if (endblock > 1)
        { // tri again to saftey check
           For( iv = 0; iv <  ic_len ; iv++  )
           {
           ictarget.SetPropertyText("MonsterList["$iv$"]", eatinglist[iv]);
           }
           ictarget.saveconfig();
        }else{
            log("Endblock error",'icwrite');
            tempp.ClientMessage(Level.Game.MakeColorCode(redcolor) $ "Aborting becuase the endblock is 0" ,'Event');
            tempp.ClientMessage(" make sure you load the data first" ,'Event');
           //  make a assumtion that if we read our data , it should always be more then 0
        }
     }
 }




//------------------------------------------------------------------------------`
//----------------- handle any commands here----------------------------
//------------------------------------------------------------------------------

function bool handleChat( PlayerPawn Chatting,out string Msg )
{
  local string UpdatechatDBQuery,timedate,chatter;
  local actor sny,snh;

  //define chatter at system by default
  chatter = "[System]";
  timedate= level.month$"-"$level.day$"-"$level.year$" "$level.hour$":"$level.minute$":"$level.second;


  // string variable stuff
  msg = ReplaceStr(msg, "#time", timedate);

  if(instr(msg,"#aim")!=-1)
  {
           if (aimbind[getplayeridfromp(chatting)] != none)
           {
           msg = ReplaceStr(msg, "#aim", string(aimbind[getplayeridfromp(tempp)].class));
           }else{
           chatting.ClientMessage(txtclr() $ "cant use #aim , use '/traceaim' to bind a actor first");
           }
  }
  
     foreach AllActors(class'actor',snh)
    { if(snh.IsA('sn_shit_mutator'))
      {
       sny = snh;
	   msg = ReplaceStr(msg, "#sn0", sny.GetPropertyText("cachedactors[0]"));
	   msg = ReplaceStr(msg, "#sn1", sny.GetPropertyText("cachedactors[1]"));
	   msg = ReplaceStr(msg, "#sn2", sny.GetPropertyText("cachedactors[2]"));
	   msg = ReplaceStr(msg, "#sn3", sny.GetPropertyText("cachedactors[3]"));
	   msg = ReplaceStr(msg, "#sn4", sny.GetPropertyText("cachedactors[4]"));
	   msg = ReplaceStr(msg, "#sn5", sny.GetPropertyText("cachedactors[5]"));
	   msg = ReplaceStr(msg, "#sn6", sny.GetPropertyText("cachedactors[6]"));
	   msg = ReplaceStr(msg, "#sn7", sny.GetPropertyText("cachedactors[7]"));
	   msg = ReplaceStr(msg, "#sn8", sny.GetPropertyText("cachedactors[8]"));
	   msg = ReplaceStr(msg, "#sn9", sny.GetPropertyText("cachedactors[9]"));
	   msg = ReplaceStr(msg, "#sn10", sny.GetPropertyText("cachedactors[10]"));
	   msg = ReplaceStr(msg, "#sn11", sny.GetPropertyText("cachedactors[11]"));
	   msg = ReplaceStr(msg, "#sn12", sny.GetPropertyText("cachedactors[12]"));
	   msg = ReplaceStr(msg, "#sn13", sny.GetPropertyText("cachedactors[13]"));
	   msg = ReplaceStr(msg, "#sn14", sny.GetPropertyText("cachedactors[14]"));
	   msg = ReplaceStr(msg, "#sn15", sny.GetPropertyText("cachedactors[15]"));
	   break;
      }
    }
	
	 
	
  
  



  // define chatter as player , if it is applicable
  if(chatting != None)
  { //system mesages can have no owner!
    chatter = chatting.PlayerReplicationInfo.Playername;
  }

   //basic sql attack prevention
   //if(instr(msg,"DROP TABLE")!=-1 || instr(msg,"ChatDB")!=-1 || instr(chatter,"DROP TABLE")!=-1 || instr(chatter,"ChatDB")!=-1 )
   //{
   // log ("malformed Sql Query" $ chatter $":" $msg ,stringtoname("[Essentials]"));
   // msg = "bad Data!";
   // chatter = "bad name!";
    //chatting.PlayerReplicationInfo.Playername = "Player_" $ timedate;
   //}


    //log to database
    //UpdatechatDBQuery = "INSERT INTO ChatDB (Player,Chat,DateTime) VALUES ('"$chatter$ "','"$msg$"','"$timedate$"');";
    //if(SQLDB != None)
    //{
	//	SQLDB.Query(UpdatechatDBQuery);
	//}


    //server commands
    if(chatting == None)
    {
    //log(" source test:"  chatting.PlayerReplicationInfo.Playername);
	// server console
    // advance works, butits a obvious hack to the functions.
	if(instr(msg,"/advance")!=-1)	{  jzadvance();	 return false;	}
    //if(instr(msg,"/")!=-1)	{   return false;	}
    // help is sort of broken , it spamms randomly
    // no work since
	if(instr(msg,"/help") != -1  ) { displayhelp(none);};
    }

    if(chatting != None)
    {
          if(instr(msg,"/help") != -1  ) { displayhelp(chatting);};

    }


    // for some pickup to trigger join help!
	if(instr(msg,"/firstjoinoneshot")!=-1  && chatting != None)
	{
      tempp=chatting;
	  firstshotinfo(tempp);
	  return false;

	}

   //"/filename.help"
   // a independent way to get help
   // can call this per mod witout passing it around
   if(instr(msg,EscapePhrase $ string(self.outer)$".help")!=-1  && chatting != None)
   {
   displayhelp(tempp);
   return false;
   }



   //suprise
   //if(instr(msg,"dick")!=-1  )
   //{
   //tempp.ClientTravel("http://i.imgur.com/m79CnJP.jpg", TRAVEL_Absolute,false);
   //}

   // main commands
   if(chatting != None && Left(msg, len(EscapePhrase)) == EscapePhrase)
   {
	     tempp=chatting;	// we pass this to other global functions
         //ExecuteCommand(msg); // just in case ?
	   // general cheats
       log("message:" $ msg);


         if(instr(msg,calcesp("goal"))!=-1){ 	setgoal(msg);	return false;}

         if(instr(msg,calcesp("icread"))!=-1){ 	icread();	return false;}
         if(instr(msg,calcesp("icwrite"))!=-1){ icwrite();   return false;}

         if(instr(msg,calcesp("icaddpackge"))!=-1){
         ExecuteCommand(msg);
         icaddpackge(wordlist[1]);
         return false;}

          if(instr(msg,calcesp("icreadinv"))!=-1){ 	icreadinv();	return false;}
          if(instr(msg,calcesp("dzreadpawns"))!=-1){ 	dzreadpawns();	return false;}

         if(instr(msg,calcesp("readpack"))!=-1){ ExecuteCommand(msg);isclassy(wordlist[1]);return false; }
         if(instr(msg,calcesp("superreadpack"))!=-1){ ExecuteCommand(msg);superclassy(wordlist[1]);return false; }
         if(instr(msg,calcesp("summonpack"))!=-1){ ExecuteCommand(msg);spawnclassy(wordlist[1],wordlist[2]);return false; }
         if(instr(msg,calcesp("arbfuncaim"))!=-1){ ExecuteCommand(msg);arbentryaim();return false; }
	     if(instr(msg,calcesp("arbfunc"))!=-1){ ExecuteCommand(msg);arbentry();return false; }
         if(instr(msg,calcesp("edittrace"))!=-1){ ExecuteCommand(msg); killtracer(wordlist[1],wordlist[2]);return false; }
         if(instr(msg,calcesp("mail"))!=-1){ 	mail(msg);	return false;      }
	     if(instr(msg,calcesp("nicksrv"))!=-1){ 	nicksrv(msg);	return false;      }
	     if(instr(msg,calcesp("createlogin"))!=-1){ ExecuteCommand(msg);createaccount(tempp,wordlist[1]); return false;      }
	     if(instr(msg,calcesp("plogin "))!=-1){ 	;	return false;      }
	     if(instr(msg,calcesp("god"))!=-1){ 	togglegod();	return false;      }
         if(instr(msg,calcesp("words"))!=-1)	           { 	word2actors (msg);	return false;      }
         if(instr(msg,calcesp("butcher"))!=-1){buth();return false;}; // Butcher monsters /objects
		 if(instr(msg,calcesp("keyit"))!=-1)           {    keyit(); return false;  }
		 if(instr(msg,calcesp("pick"))!=-1)            {  keyit(); return false;    }
		 if(instr(msg,calcesp("advance"))!=-1)	       {  jzadvance(); return false;	 }
		 if(instr(msg,calcesp("fly"))!=-1          )   {	jcplayerfly(chatting); return false;        }
		 if(instr(msg,calcesp("walk"))!=-1        )    {	jcplayerwalk(chatting); return false;     }
		 if(instr(msg,calcesp("ghost"))!=-1      )     {	jcplayerghost(chatting); return false;    }
		 if(instr(msg,calcesp("supersummon")) !=-1 || instr(msg,calcesp("ss"))!=-1)	   {	ExecuteCommand(msg);supersummon(); return false;   }
		 if(instr(msg,calcesp("summon"))!=-1 ){ ExecuteCommand(msg); summon(); return false;   }
         if(instr(msg,calcesp("spawnmass"))!=-1 )	{	ExecuteCommand(msg);SpawnMass(String2Int(wordlist[1]),wordlist[2]); return false;    }

         if(instr(msg,calcesp("pawns"))!=-1){ 	count_pawns();	return false;      }
         if(instr(msg,calcesp("stats"))!=-1){ 	playerstats();	return false;      }

        //util
         if(instr(msg,calcesp("autovoteend"))!=-1 )	{	ExecuteCommand(msg); autovend(); return false;    }


		//admin like stuff
         if(instr(msg,calcesp("getteleporters")) !=-1        )	                                                    {	GetTeleporters(); return false;              }
		 if(instr(msg,calcesp("getendteleporters")) !=-1   )	                                                    {	GetendTeleporters(); return false;         }
		 if(instr(msg,calcesp("gr"))!=-1 || instr(msg,calcesp("gamerules"))!=-1)	                        {	ExecuteCommand(msg); gamerules(); return false;    }
	     if(instr(msg,calcesp("killall"))!=-1 ){	ExecuteCommand(msg); KillAllobj(wordlist[1]); return false;    }
         if(instr(msg,calcesp("tickrate"))!=-1 ){	ExecuteCommand(msg);tickrate(tempp,int(wordlist[1])); return false;    }



        // spot teleports
         if(instr(msg,calcesp("getmapspots"))!=-1  || instr(msg,calcesp("warps")) !=-1)	            {	ExecuteCommand(msg); getmapspots(); return false;    }
		 if(instr(msg,calcesp("savespot"))!=-1 || instr(msg,calcesp("setwarp"))!=-1 )	                {	ExecuteCommand(msg); setmapspots(); return false;    }
		 if(instr(msg,calcesp("gotospot"))!=-1  || instr(msg,calcesp("warp"))!=-1)	                    {	ExecuteCommand(msg); gotospots(); return false;    }
		 if(instr(msg,calcesp("viewspot"))!=-1  || instr(msg,calcesp("viewwarp"))!=-1)	            {	ExecuteCommand(msg);viewwarp(); return false;    }
		 if(instr(msg,calcesp("removespot"))!=-1 || instr(msg,calcesp("delwarp"))!=-1 )	            {	ExecuteCommand(msg);delwarp(); return false;    }


		//test
		 if(instr(msg,calcesp("trace2"))!=-1 )       {	ExecuteCommand(msg);traceaim2(); return false;    }
		 if(instr(msg,calcesp("traceaim"))!=-1 )       {	ExecuteCommand(msg);traceaim(); return false;    }
		 if(instr(msg,calcesp("teltrace"))!=-1 )	                                                                        {	TraceX (); return false;    }


        // mutators
		 if(instr(msg,calcesp("removemutator"))!=-1 )	{	ExecuteCommand(msg); removemutator(); return false;    }
		 if(instr(msg,calcesp("addmutator"))!=-1 )	  {	ExecuteCommand(msg); addgmutator(); return false;    }
		 if(instr(msg,calcesp("enablemutator"))!=-1 )   {	ExecuteCommand(msg); enablemutator();return false;    }
		 if(instr(msg,calcesp("getmutators"))!=-1 )	    {	ExecuteCommand(msg); getmutators(); return false;	 }

        //tp accepts
	     if(instr(msg,calcesp("tpaccept"))!=-1){ 	tpaccept(msg);	return false;      }
	     if(instr(msg,calcesp("tpahere"))!=-1){ 	tpahere(msg);	return false;      }
	     if(instr(msg,calcesp("tpdeny"))!=-1){ 	tpaccept(msg);	return false;      }
         if(instr(msg,calcesp("tpa"))!=-1){ 	tpa(msg);	return false;      }
         if(instr(msg,calcesp("tpyes"))!=-1){ 	tpaccept(msg);	return false;      }

       //direct teleports
         if(instr(msg,calcesp("tp"))!=-1  || instr(msg,calcesp("tel"))!=-1)
             {
         	  ExecuteCommand(msg);
         	  tp();
         	  return false;
         	  }

       //ending  controls
		 if(instr(msg,calcesp("endtoggle"))!=-1){ 	toggle_ending();	return false;      }


       // bullshit
         if(instr(msg,calcesp("nyan"))!=-1 )  {	ExecuteCommand(msg);shownyan(); return false;    }
         if(instr(msg,calcesp("crash1"))!=-1 )
             { // execute a bug in 227j,i to crash the client with no error
               // by opening up the current map in sp ;)
         	  ExecuteCommand(msg);
              if (returnpfromid(int(wordlist[1])) != none)
               {
			   returnpfromid(int(wordlist[1])).ClientTravel(string(level.outer), TRAVEL_Absolute,false);
               }
               return false;
             }

		 // if(instr(msg,"/rejectNewConnections")!=-1 )	            {	ExecuteCommand(msg); return false;    }
	     // if(instr(msg,"/enableNewConnections")!=-1 )	                {	ExecuteCommand(msg); return false;    }
         //if(instr(msg,"/tel")!=-1)	    {	ExecuteCommand(msg); return false;    }      // goto xyz
	     //if(instr(msg,"/trigger")!=-1)	    {	ExecuteCommand(msg); return false;    }  // trigger <objective> <add|set> <value>
	     //if(instr(msg,"/give")!=-1)	    {	ExecuteCommand(msg); return false;    }      // give <player> <item> [amount] [data] [dataTag]
	     //if(instr(msg,"/kill")!=-1)	    {	ExecuteCommand(msg); return false;    }
	     if(instr(msg,"/ddos")!=-1)	    {ddos();  }
	     if(instr(msg,"/psay")!=-1)	    {	ExecuteCommand(msg); psay(); return false;    }  // psay
	     //log ("transit[" $ chatter $"]:"$ msg);


}

return true;
}


function mail(string msg)
{
ExecuteCommand(msg);

   if ( caps(wordlist[1]) == caps("markread"))
   {
   tempp.ClientMessage("todo mark all read");
   }

   if ( caps(wordlist[1]) == caps("sendmail"))
   {
   tempp.ClientMessage("todo sendmail");
   //sendmail(playerpawn p,string target,string message)
   sendmail(tempp, wordlist[2] , wordlist[3] $ wordlist[4] $ wordlist[5] $ wordlist[6] $ wordlist[7] $ wordlist[8] $ wordlist[9]$ wordlist[10]$ wordlist[11]$ wordlist[12]);
   }

   if ( caps(wordlist[1]) == caps("showallmail"))
   {
   tempp.ClientMessage("todo showallmail");
   }
 tempp.ClientMessage("test" $ msg);
}



function bool mutateCanPickupInventory( Pawn Other, Inventory Inv)
{
local ammo amm;

if (other != none && other.IsA('PlayerPawn'))
     {

     // we get to deal with prossessing this  later!
     //inv
     if(inv.isa('weapon')  &&  instr(inv.pickupmessage,"inv")==-1) // dont save recovered inv to db!
     {
     Amm = Ammo(Other.FindInventoryType(weapon(inv).AmmoName));
       if (amm != none)
       {
       dbobject.updatedatavalue(getplayername(playerpawn(other)) $".inventory" , string(Inv.class),string(amm.AmmoAmount));
       }
     }


     //if(inv.isa('pickup')  && !inv.isa('weapon' && ! inv.isa('ammo')))
    // {
	    // 7/31/2022
		// ignore ammo for now. one thing i want to work is the goldcounter thing
		// this should be as easy as save copies, but
		// gold is nested, so maybe cant just check for num copies.

	 //   if (pickup(inv).bCanHaveMultipleCopies)
       // {
      //  // save copies
		// so you always pushing the pickup vs the new values.
		// makes this usless.
        //dbobject.updatedatavalue(getplayername(playerpawn(other)) $".inventory" , string(Inv.class), string(pickup(inv).NumCopies));
	//	log(getplayername(playerpawn(other)) $".inventory" $ " " $ string(Inv.class) $ " " $ string(pickup(inv).NumCopies));

	//	}else{
        // save charge
        // dbobject.updatedatavalue(getplayername(playerpawn(other)) $".inventory" , string(Inv.class),string(pickup(inv).charge));


     // }





    // }

     if(inv.isa('ammo'))
     { // spam
	 //playerdatadb=(Player="Hyzoran.inventory",Property="UnrealI.FlakShellAmmo",Value="ammo")
     //dbobject.updatedatavalue(getplayername(playerpawn(other)) $".inventory" , string(Inv.class),"ammo");
     }


    // log (getplayername(playerpawn(other)) $ " " $ string(Inv.class));
     }
return true;
}


function nicksrv(string msg)
{
local playerpawn p;
ExecuteCommand(msg);

//todo have base admin groups  permiasions in db
if (int(dbobject.getdatavalue(getplayername(p) $".nickserv" ,"admingroup")) < 2
  && isvaladatedp(tempp))
                      {
                      tempp.ClientMessage("insufficent permisions");
                      return;
                      }

if ( caps(wordlist[1]) == "SETADMINGROUP")
{
   p = returnpfromid(int(wordlist[1]));

   if (p == tempp)
   {
    tempp.ClientMessage("you cant modify your own permisions");
    return;
   }

   if (!isvaladatedp(p))
   {
   tempp.ClientMessage(" player isnt validated!");
   p.ClientMessage("could not assign you permisions becuase your nick isnt validated!");
   }

   if (wordlist[2] == "" || wordlist[2] == " ")
   {
   tempp.ClientMessage("bad group value");
   }else{
   dbobject.updatedatavalue (getplayername(p) $".nickserv" , "admingroup",wordlist[2]);
   tempp.ClientMessage(getplayername(p) $ "  admin group was set to " $ wordlist[2] $ " by " $ getplayername(tempp));
   p.ClientMessage("{nickserv} your admin group was set to " $ wordlist[2]  $ " by " $ getplayername(tempp));
   log(getplayername(p) $ "  admin group was set to " $ wordlist[2] $ " by " $ getplayername(tempp) ,stringtoname("[Nicksrv]"));
   }

}

tempp.ClientMessage("opps this does work yet");

}


function togglegod()
{
    if ( tempp.ReducedDamageType == 'All' )
	{
		tempp.ReducedDamageType = '';
		tempp.ClientMessage("God mode off");
		return;
	}

	tempp.ReducedDamageType = 'All';
	tempp.ClientMessage("God Mode on");



}


//------------------------------------------------------------
// tp requsat stuff
//------------------------------------------------------------

// tprequests[32]
//var() int requester,personaskedtoteleport ,fromid, toid;
//	var() int timestamp;
//	var() bool hasbeenaccepted;

function tpaccept(string msg)
{
//msg = optional player name , for multiple requests
// would be a good idea to except names
//lookuptprequst("9");
lookuptprequst(getplayeridfromp(tempp),false);

}

function tpa(string msg)
{
local playerpawn ply;
ExecuteCommand(msg);
ply = returnpfromid(int(wordlist[1]));
 if (ply != none)
 {
 ply.ClientMessage( getplayername(tempp) $ " requests to teleport to you , chat " $ calcesp("tpaccept") $ " to accept the request");
 filetprequst(getplayeridfromp( tempp) , int(wordlist[1]) ,getplayeridfromp(tempp) , int(wordlist[1]));
 // filetprequst(int requester , int targetx ,int from , int to)
 }else{
  tempp.ClientMessage("invalid player id on argument 2");
 }



}

function tpahere(string msg)
{ //msg =  player name/ id
local playerpawn ply;
ExecuteCommand(msg);
ply = returnpfromid(int(wordlist[1]));
 if (ply != none)
 {
 ply.ClientMessage( getplayername(tempp) $ " requests to teleport you to there location , chat " $ calcesp("tpaccept") $ " to accept the request");
 filetprequst(getplayeridfromp( tempp) , int(wordlist[1]) ,int(wordlist[1]) , getplayeridfromp( tempp));
 // filetprequst(int requester , int targetx ,int from , int to)
 }else{
  tempp.ClientMessage("invalid player id on argument 2");
 }

}

function tpdeny(string msg)
{
//msg =  optional player name , for multiple requests
lookuptprequst(getplayeridfromp(tempp),true);

}

function filetprequst(int requester , int targetx ,int from , int to)
{
local int z;
local bool wedone;
//log("requester = "$requester $ "targetx="$targetx);
Acastbs("tpstatus: Player " $requester $" requested " $ targetx $ "to  move " $ from $ " to " $ to );
        For( z = 0; z < 31 ; z++ )
        {
		  if (string(tprequests[z].requester) == "0"   && !wedone)
		   {
		   //log("entrypass");
		    tprequests[z].requester =  requester;
			tprequests[z].personaskedtoteleport =  targetx;
			tprequests[z].fromid =  from;
			tprequests[z].toid =  to;
			tprequests[z].hasbeenaccepted = false;
			wedone = true;
		   }
		}




}



function lookuptprequst(int playerid,optional bool bfuckit)
{
local int z,pending;
local bool fnd;
        For( z = 0; z < 31 ; z++ )
        {

		//log ("personasked =" $ tprequests[z].personaskedtoteleport);
		//log ("playerid =" $ playerid);

		  if (tprequests[z].personaskedtoteleport == playerid &&  !tprequests[z].hasbeenaccepted && !fnd)
		   {

		     if (bfuckit)
		     {
		     tempp.ClientMessage("You denied the request! ");
		     tprequests[z].hasbeenaccepted = true;
			 returnpfromid(tprequests[z].requester).ClientMessage(" player denied your request for teleport! ");
			 fnd = true;
		     }else{


			   if (pending < 2)
			   {
			   tempp.ClientMessage(" You accepted the request! " $ "(1/" $pending $")");
			   returnpfromid(tprequests[z].requester).ClientMessage(" player accepted your request for teleport! ");
			   tprequests[z].hasbeenaccepted = true;
			   jzsummonP(returnpfromid(tprequests[z].toid),returnpfromid(tprequests[z].fromid));
			   fnd = true;
			   }

			   if (pending > 1)
			   {
			   tempp.ClientMessage("More then one request pending , to accept a newer request , tpaccept again!");
			   }


		     fnd = true;
			 pending ++;

			 }




		   }
		}

  if (!fnd)
  {
  tempp.ClientMessage("no pending requests! ");
  }


}

//-----------------------------------------------------------------------------





function firstshotinfo( playerpawn p)
{
tempp.ClientMessage("[Essentials] Welcome to server ");
dealwithmutators();
tempp.consolecommand( "say /help");
//displayhelp(tempp);

}




 function displayhelp2( playerpawn p)
{
      if (p == none)
	  {
	  log ("[Essentials]" $ EscapePhrase $"advance  <url index>",stringtoname("[Essentials]"));
   	  }

      if (p != none)
	  {
	   p.ClientMessage(txtclr() $"[Essentials] Command plugin Mutator");
	   p.ClientMessage(txtclr() $"[Essentials]  The Following Commands are available in CHAT, not console");

       if (p.badmin)
	   {
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"advance <url index> , gamerules   <list|disable|enable> , killall <object> , toggleend ");
	   //p.ClientMessage(txtclr() $"" $ EscapePhrase $"tickrate <new tickrate> ");
	   //p.ClientMessage(txtclr() $"" $ EscapePhrase $"removemutator <name>   " $ EscapePhrase $"addmutator <name>  " $ EscapePhrase $"enable mutator <t/f> " $ EscapePhrase $"getmutators ");
	   //p.ClientMessage(txtclr() $"" $ EscapePhrase $"nickserv setadmingroup (id) <level>");
       p.ClientMessage("ADMIN players list registered players ");
       p.ClientMessage("ADMIN timerfun timerfun1 timerfun2 tickfun tickfun1");


       }

	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"fly " $ EscapePhrase $"walk " $ EscapePhrase $" ghost" $ EscapePhrase $" god , " $ EscapePhrase $"supersummon " $ EscapePhrase $"ss ($class.name$) (#howmany#)  (#spacing#)");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"supersummon " $ EscapePhrase $"ss ($class.name$) (#howmany#)  (#spacing#)",'Event',true);
       p.ClientMessage(txtclr() $"" $ EscapePhrase $"summon  " $ EscapePhrase $"s <classname|playerid source|self> <playrid target>");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"spawnmass <class> ");
       p.ClientMessage(txtclr() $"" $ EscapePhrase $"readpack <package>  list classes in a package");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"traceaim    shown class your aiming at ");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"editaim <property, value> ,modify traeaim obj");

       p.ClientMessage(txtclr() $"=============General===========");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"word  <string text>");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"butcher  <radius>");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"pick " $ EscapePhrase $"keyit  pick lock");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"GetTeleporters show end url");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"GetendTeleporters show end url");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"autovoteend ");
       //p.ClientMessage(txtclr() $"" $ EscapePhrase $"Goal  <killgoal>   Set a team killgoal");

	   p.ClientMessage(txtclr() $"============Teleports===========");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"getmapspots " $ EscapePhrase $"warps  <show warps>");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"savespot " $ EscapePhrase $"setwarp  <warpname>");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"gotospot " $ EscapePhrase $"warp   goto <warpname>");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"removespot " $ EscapePhrase $"delwarp   delete <warpname>");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"viewspot " $ EscapePhrase $"viewwarp   viewfrom <warpname>");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"teltrace   goto aim");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"tpaccept , " $ EscapePhrase $"tpyes  accept a teleport request");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"tpdeny   ," $ EscapePhrase $"tpyes refuse a teleport request");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"tpa <id>   request to teleport to somone");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"tpahere  <id>   request to teleport somone to you");

       p.ClientMessage(txtclr() $"============Comms===========");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"mail " $ EscapePhrase $" sendmail  <playername> <message to send>");
       p.ClientMessage(txtclr() $"" $ EscapePhrase $"mail " $ EscapePhrase $" markallread");
       p.ClientMessage(txtclr() $"" $ EscapePhrase $"mail " $ EscapePhrase $" showallmail");
	  }


}





function displayhelp( playerpawn p)
{
      if (p == none)
	  {
	  log ("[Essentials]" $ EscapePhrase $"advance  <url index>",stringtoname("[Essentials]"));

	  }


      if (p != none)
	  {

	   p.ClientMessage(txtclr() $"[Essentials]  Command plugin Mutator");
	   p.ClientMessage(txtclr() $"[Essentials]  The Following Commands are available in CHAT, not console");

       if (p.badmin)
	   {
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"advance  <url index>  ," $ EscapePhrase $ "gamerules <list|disable|enable>, "$ EscapePhrase $ "killall <object>, " $ EscapePhrase $"toggleend ");
	   //p.ClientMessage(txtclr() $"" $ EscapePhrase $"removemutator <name>   " $ EscapePhrase $"addmutator <name>  " $ EscapePhrase $"enable mutator <t/f> " $ EscapePhrase $"getmutators ");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"nickserv setadmingroup (id) <level>");
       }
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"fly " $ EscapePhrase $"walk " $ EscapePhrase $" ghost" $ EscapePhrase $" god");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"supersummon " $ EscapePhrase $"ss ($class.name$) (#howmany#)  (#spacing#) ," $ EscapePhrase $"summon  " $ EscapePhrase $"s <classname|playerid source|self> <playrid target>",'Event',true);
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"spawnmass <class> ");
       p.ClientMessage(txtclr() $"" $ EscapePhrase $"readpack <package>  list classes in a package, copy to buffer ," $ EscapePhrase $"summonpack <package> <items,pawns,''> summon classes in a package");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"traceaim    shown class your aiming at  " $ EscapePhrase $"editaim <property, value> ,modify traeaim obj");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"word  <string text> , " $ EscapePhrase $"butcher  <radius> ," $ EscapePhrase $"keyit  pick lock");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"GetTeleporters - show end url");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"GetendTeleporters show end url");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"autovoteend ");
	   p.ClientMessage(txtclr() $"" $ EscapePhrase $"tp <goto: id,name>  optional move target to <id,name>  teleport to/from somone ," $ EscapePhrase $"teltrace   goto aim");
       //p.ClientMessage(txtclr() $"" $ EscapePhrase $"goal  <killgoal>   Set a team killgoal");

	   //p.ClientMessage(txtclr() $"============Teleports===========");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"getmapspots " $ EscapePhrase $"warps  <show warps>");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"savespot " $ EscapePhrase $"setwarp  <warpname>");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"gotospot " $ EscapePhrase $"warp   goto <warpname>");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"removespot " $ EscapePhrase $"delwarp   delete <warpname>");
	   // p.ClientMessage(txtclr() $"" $ EscapePhrase $"viewspot " $ EscapePhrase $"viewwarp   viewfrom <warpname>");
	   //p.ClientMessage(txtclr() $"" $ EscapePhrase $"teltrace   goto aim");
	   //p.ClientMessage(txtclr() $"" $ EscapePhrase $"tpaccept , " $ EscapePhrase $"tpyes  accept a teleport request");
	   //p.ClientMessage(txtclr() $"" $ EscapePhrase $"tpdeny   ," $ EscapePhrase $"tpyes refuse a teleport request");
	   //p.ClientMessage(txtclr() $"" $ EscapePhrase $"tpa <id>   request to teleport to somone");
	   //p.ClientMessage(txtclr() $"" $ EscapePhrase $"tpahere  <id>   request to teleport somone to you");

       //p.ClientMessage(txtclr() $"============Comms===========");
	  // p.ClientMessage(txtclr() $"" $ EscapePhrase $"mail " $ EscapePhrase $" sendmail  <playername> <message to send>");
      // p.ClientMessage(txtclr() $"" $ EscapePhrase $"mail " $ EscapePhrase $" markallread");
       //p.ClientMessage(txtclr() $"" $ EscapePhrase $"mail " $ EscapePhrase $" showallmail");


       //p.ClientMessage("ADMIN players list registered players ");
       //p.ClientMessage("ADMIN timerfun timerfun1 timerfun2 tickfun tickfun1");

      }


}

//------------------------------------------------------------------------------
//----------------- handle any multi commands here----------------------
//------------------------------------------------------------------------------


function ExecuteCommand(string cmd)
{
    local int i, words;
   cmd=cmd$" ";
   // cleaning wordlist
   //log("phrase debug :  "$ self.name $  " " $ cmd);
   for(i=0;i<500;i++)
   {
     if (i > 499) break;
	 WordList[i]="";
   }
 // parsing command into wordlist
  while ((len(cmd)) > 1)  // while there is stuff to munch on
   {      while(left(cmd,1) != " " )  // delimeter not yet found, adding letter
       { wordlist[words]=wordlist[words]$left(cmd,1);
        cmd=right(cmd,len(cmd)-1);}
     // found one word....
     cmd=right(cmd,len(cmd)-1);
     // reasons to stop further analysis
     if ( (wordlist[words]!=" ")&&(wordlist[words]!="") )  words++;  // ignore " " / "" as word itself
   } // end while len(Command) > 1)
  cmd="";

}




//------------------------------------------------------------------------------
//----------------- command funtions---------------------------------------
//------------------------------------------------------------------------------



function addgmutator()
{
local int I;
  if (wordlist[1] != "" || wordlist[1] != " ")
  {
	  if (ismuteinlist(wordlist[1]))
      {
      tempp.ClientMessage(Level.Game.MakeColorCode(redcolor) $ wordlist[1] $ " is already in the list");
      }else{

	  i = Array_Size(hookmutators) -1;
	  Array_Insert(hookmutators,Array_Size(hookmutators),1);
	  hookmutators[i]=wordlist[1];
	  tempp.ClientMessage(Level.Game.MakeColorCode(greencolor)$ wordlist[1] $ " added to mutator list");
      }

  }


}

function getmutators()
{
local int z;
         For( z = 0; z < Array_Size(hookmutators) ; z++ )
        {
		             If(hookmutators[z] != ""  )
					 {

				           if ( InStr(caps(hookmutators[z]),"!") == -1 || InStr(caps(hookmutators[z]),"/") == -1  || InStr(caps(hookmutators[z]),":") == -1 )
					       {
					       tempp.ClientMessage(Level.Game.MakeColorCode(greencolor)$ hookmutators[z]);
				           }else{
					       tempp.ClientMessage(Level.Game.MakeColorCode(redcolor) $ hookmutators[z]);
					       }


					 }
		}
}




function removemutator()
{
local UBrowserServerList L;

foreach AllObjects(class'UBrowserServerList',L)
   {
	tempp.ClientMessage(L@L.IP@L.QueryPort@L.GameName@L.HostName@L.GamePort@L.MapName@L.GameType);
   }
}

function enablemutator()
{

}

function bool ismuteinlist(string l)
{
local int z;
         For( z = 0; z < Array_Size(hookmutators) ; z++ )
        {
		             If(hookmutators[z] != ""  )
					 {

				           if (hookmutators[z] == l )
					       {
					       return true;
						   break;

					       }


					 }
		}

	return false;

}




exec function SpawnMass(int TotalCount,string ClassName)
{
	local actor        spawnee;
	local vector       spawnPos;
	local vector       center;
	local rotator      direction;
	local int          maxTries;
	local int          count;
	local int          numTries;
	local float        maxRange;
	local float        range;
	local float        angle;
	local class<Actor> spawnClass;
	local int inty;


	if (instr(ClassName, " ") != -1)
	totalcount = int(right(instr(classname,inty),inty));// uh wtf still doesnt work
	//log("totalcount = "$totalcount);

	//else
	//	holdName = ""$ClassName;  // barf //OMGWTF?!@$#!?@$

      if ( InStr(ClassName,".")==-1 )
		{
        ClassName = returnmatchingfile(ClassName)$"." $ ClassName;
		tempp.ClientMessage(">Resolved to " $ ClassName);
        }


	spawnClass = class<actor>(DynamicLoadObject(classname, class'Class'));
	if (spawnClass == None)
	{
		tempp.ClientMessage("Illegal actor name "$ClassName);
		return;
	}

	if (totalCount <= 0)
		totalCount = 10;
	if (totalCount > 255)
		totalCount = 255;
	maxTries = totalCount*2;
	count = 0;
	numTries = 0;
	maxRange = sqrt(totalCount/Pi)*4*SpawnClass.Default.CollisionRadius;

	direction = tempp.ViewRotation;
	direction.pitch = 0;
	direction.roll  = 0;
	center = tempp.Location + Vector(direction)*(maxRange+SpawnClass.Default.CollisionRadius+CollisionRadius+20);
	while ((count < totalCount) && (numTries < maxTries))
	{
		angle = FRand()*Pi*2;
		range = sqrt(FRand())*maxRange;
		spawnPos.X = sin(angle)*range;
		spawnPos.Y = cos(angle)*range;
		spawnPos.Z = 0;
		spawnee = spawn(SpawnClass,,,center+spawnPos, Rotation);
		if (spawnee != None)
			count++;
		numTries++;
	}

	 tempp.ClientMessage(count$" actor(s) spawned");


     if (dbobject.getdatavalue(getplayername(tempp)$".achivments" ,"spawnaarmy") == "nil")
     {
     tempp.ClientMessage("---------------------------------------------------------------");
     tempp.ClientMessage("[Achivment]  spawnaarmy! - create a army!!");
     tempp.ClientMessage("---------------------------------------------------------------");
     dbobject.updatedatavalue (getplayername(tempp)$".achivments", "spawnaarmy","Create A Army "  $  stampachevmet(tempp));
     }

}



function Actor TracePlayerAim(PlayerPawn Player, bool bTraceActors)
{
	local vector TraceStart, TraceEnd, HitLocation, HitNormal;
	local Actor Result;

	if (Player == none)
		return none;
	TraceStart = Player.Location + Player.EyeHeight * vect(0, 0, 1);
	TraceEnd = TraceStart + 1000000 * vector(Player.ViewRotation);

	Result = Player.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, bTraceActors);
	if (Result == Level)
		return none;
	return Result;
}



function traceaim()
{  // trace to you crosshair, save the reference for editing
 local actor j;
 j = TracePlayerAim(tempp,true);
 if (j != none)
	{
     tempp.ClientMessage(txtclr() $ " bound:" $ string(j.class) $ " " $ j.name$ "  tag:" $ j.tag);
     aimbind[getplayeridfromp(tempp)] = j;
     // dump int values (limited) toplayer
     dumpprops(j.class);
	}else{
	tempp.ClientMessage(txtclr() $ "Invalid target");
	}

}


function traceaim2()
{  // trace to you crosshair, save the reference for editing
 local actor j;
 j = TracePlayerAim(tempp,true);
 if (j != none)
	{
     tempp.ClientMessage(txtclr() $ " bound:" $ string(j.class) $ " " $ j.name);
     aimbind[getplayeridfromp(tempp)] = j;
     // dump int values (limited) toplayer
     dumpallprops(j.class);
	}else{
	tempp.ClientMessage(txtclr() $ "Invalid target");
	}

}






function TraceX ()
{ // trace to you crosshair and teleport
  //local Actor Other;



  if (TracePlayerAim(tempp,true) != none)
  {
  tempp.SetLocation(TracePlayerAim(tempp,true).location);
  } else{
  //HitLocation = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True);
  //tempp.SetLocation(HitLocation + HitNormal * (tempp.CollisionRadius + tempp.CollisionHeight));
  }



}

function killtracer(string a, string b)
{

if (aimbind[getplayeridfromp(tempp)] == none )
{
tempp.ClientMessage(txtclr() $"Cant setprop, Trace a object first using /traceaim");
 return;
}


if (a != ""  && b != "")
{
tempp.ClientMessage(txtclr() $"Old value " $ aimbind[getplayeridfromp(tempp)].GetPropertyText(a));
aimbind[getplayeridfromp(tempp)].SetPropertyText(a, b);
tempp.ClientMessage(txtclr() $"New value " $ aimbind[getplayeridfromp(tempp)].GetPropertyText(a));
tempp.ClientMessage(txtclr() $"Property Saved");
return;
}



if (a == "kill" && aimbind[getplayeridfromp(tempp)] != none )
{
aimbind[getplayeridfromp(tempp)].destroy();
}




}



function autovend()
{
// vote end at map join , automaticly

        if (!dbobject.returnbool(getplayername(tempp) , "voteend"))
        {
        tempp.ClientMessage("true");
        dbobject.setbool(getplayername(tempp),"voteend",true);
        }else{
        tempp.ClientMessage("false");
        dbobject.setbool(getplayername(tempp),"voteend",false);
        }




}



function MakeStatlog(  string filename ,string text)
{
local StatLogFile StatLog;
    statlog = spawn(class'statlogfile');
    FileName="testfile.txt";
    statlog.StatLogFile=FileName;
    statlog.StatLogFinal=FileName;
    statlog.OpenLog();
	statlog.logEventString( text );


}


function TickRate(playerpawn P, int NewTickRate)
{
	//if (!CanExecuteAdminCommand(P, 'TickRate', true))
		//return;

	if (NewTickRate > 0)
	{
		NewTickRate = Max(10, NewTickRate);
		Level.Game.ConsoleCommand("set IpDrv.TcpNetDriver NetServerMaxTickRate" @ NewTickRate);
		p.ClientMessage("New NetServerMaxTickRate:" @ Level.Game.ConsoleCommand("get IpDrv.TcpNetDriver NetServerMaxTickRate"));
	}
	else
		p.ClientMessage("NetServerMaxTickRate:" @ Level.Game.ConsoleCommand("get IpDrv.TcpNetDriver NetServerMaxTickRate"));
}











function shownyan()
{
   if (IsNumeric(wordlist[1]))
	                {
	                  tempp = returnpfromid(int(wordlist[1]));
					  tempp.ClientTravel(wordlist[2], TRAVEL_Absolute,false);

	                }

}


function delwarp()
{
local int i;
					       For( i = 0; i <  Array_Size(spotarray) ; i++  )
                          {
					                       if  (spotarray[i].warpname == wordlist[1])
					   					   {
										   spotarray[i].warpname="";
						                   spotarray[i].mapname="";
						                   //spotarray[i].zlocation="";

										   }
	                      }

}




function actor spawnfakeobj(vector v)
{

 return  Spawn(class'dice',,,v);

}


function viewwarp()
{
local int i,warpindex;
local bool bfound;
                     if (wordlist[1] == "" || wordlist[1] == " ")
                     {
                             tempp.ClientMessage(calcesp("viewwarp (warpname)"));
						     tempp.ViewTarget = None;
                             tempp.ViewTarget.BecomeViewTarget();
					 }else{
					     For( i = 0; i <  30 ; i++  )
                       {
					                       if  (spotarray[i].warpname == wordlist[1])
					   					   {
										   warpindex= i;
                                           bfound =true;
										   }
	                    }

					   if (bfound)
					   {

					      if ( tempp.ViewTarget == spawnfakeobj(spotarray[warpindex].zlocation))
					       {
					        tempp.ViewTarget = None;
                            tempp.ViewTarget.BecomeViewTarget();
					        tempp.ClientMessage("Viewing from self");
					       }else{
					        tempp.ViewTarget = spawnfakeobj(spotarray[warpindex].zlocation);
                            tempp.ViewTarget.BecomeViewTarget();
						    tempp.ClientMessage(calcesp("viewwarp  to viewself"));
						  }


					    }

						if (!bfound)
					    {
						 tempp.ClientMessage("warp dont exist");
					    }
					 }













}


function getmaps()
{
local string hh;


	foreach AllFiles( "unr", "", hh )
	{
		   log(hh);




	}

}


function bool ispackageavalible(string package)
{
local string hh;


	foreach AllFiles( "", "", hh )
	{
		   if (caps(hh) == caps(package))
		   {
		   return true;
		   break;
		   }


	}

return false;
}


function testmap(string map)
 {
local string tst;


if (dynamicLoadObject(map$".MyLevel",class'level') != none)
  {

   tempp.ClientMessage("Testmap map ("$map$") =  is loadable.");
   tst = consolecommand ("get "$ map $ " title");
   tempp.ClientMessage(tst);
  }else{
   tempp.ClientMessage("Testmap map("$map$") = is  NOT loadable.May be missing files of packages");
  }

//consolecommand ("mem stat");
 }






function getmapspots()
{
local int i;





                       For( i = 0; i <  Array_Size(spotarray) ; i++  )
                       {

					        if (spotarray[i].mapname == string(level.outer) && spotarray[i].warpname != "" )
					              {
                                   tempp.ClientMessage( Level.Game.MakeColorCode(greencolor) $ spotarray[i].warpname$  " - " $ spotarray[i].zlocation );
	                              }

							if (spotarray[i].mapname != string(level.outer) && spotarray[i].warpname != "")
					             {
	                               if (wordlist[1] == "all" || wordlist[1] == "all")
                                      {
                                       tempp.ClientMessage( Level.Game.MakeColorCode(redcolor) $ spotarray[i].warpname$  " - available in " $ spotarray[i].mapname  $  ".unr - " $ spotarray[i].zlocation);
	                                  }
                                }
	                   }
}


function gotospots()
{
local int i,warpindex;
local bool bfound;
                     if (wordlist[1] == "" || wordlist[1] == " ")
                     {
                     tempp.ClientMessage(calcesp("warp (warpname)"));
	     			 }else{
					       For( i = 0; i <  Array_Size(spotarray) ; i++  )
                          {
					                       if  (spotarray[i].warpname == wordlist[1])
					   					   {
										   warpindex= i;
                                           bfound =true;
										   }
	                      }

					       if (bfound)
					      {
					       tempp.ClientMessage("warping to " $spotarray[warpindex].warpname);
						   tempp.SetLocation( spotarray[warpindex].zlocation);
					       }else{
					       tempp.ClientMessage("warp dont exist");
					       }
					 }
}



function setmapspots()
{
local int i;

                     if (wordlist[1] == "" || wordlist[1] == " ")
                     {
					 tempp.ClientMessage("/setwarp warpname");
					 }else{



					     i = Array_Size(spotarray) -1;
	                     Array_Insert(spotarray,Array_Size(spotarray),1);
	                   	 spotarray[i].warpname=wordlist[1];
						 spotarray[i].mapname=string(level.outer);
						 spotarray[i].zlocation=tempp.location;
						 tempp.ClientMessage("warp " $ wordlist[1] $ " saved" $ i);
						 saveconfig();

					 }













}






function GetendTeleporters()
                 {
                  local actor A;
                  local int indexed;
	                foreach AllActors(class'Actor',A)
	                {
	                  indexed ++;
		                if ( a.isa('Teleporter') && ( InStr( Teleporter(a).URL, "#" ) > -1 || InStr( Teleporter(a).URL, "?" ) > -1 || InStr( Teleporter(a).URL, "/" ) > -1 )  )
		                   {

		                    tempp.ClientMessage(txtclr() $ indexed $ " ) " $ string(Teleporter(a).name) $ " Url = " $ Teleporter(a).URL);
		                   }
	                 }
                 }



function GetTeleporters()
                 {
                  local actor A;
                  local int indexed;
	                foreach AllActors(class'Actor',A)
	                {
	                  indexed ++;
		                if ( a.isa('Teleporter')  )
		                   {
		                            // && ( InStr( Teleporter(a).URL, "#" ) > -1 || InStr( Teleporter(a).URL, "?" ) > -1 || InStr( Teleporter(a).URL, "/" ) > -1 )
		                    tempp.ClientMessage(txtclr() $ indexed $ " ) " $ string(Teleporter(a).name) $ " Url = " $ Teleporter(a).URL);
		                   }
	                 }
                 }



function ddos()
                {
                 tempp.ClientMessage("/ddoss  ( not implemented) <bs> <numusers> <ultraspam>");
                 }


function spawnmover()
                 {


                 }


function psay()
               {
                  local playerpawn pclient;

                   if (wordlist[1] == "" || wordlist[1] == " ")
                     {
                      tempp.ClientMessage("/psay  ( not implemented) <user id| player name> <mesasge>");
                      return;
                      }


                   if (IsNumeric(wordlist[1]))
	                { // possible issue here
	                  pclient = returnpfromid(int(wordlist[1]));

	                }else{
	                  pclient = checkisplayername(wordlist[1]);
	                }

                   // possible none condition here
                   pclient.ClientMessage(" private Messaage from " $ getplayername(tempp) ,'event');
                   pclient.ClientMessage( wordlist[2] $ wordlist[3] $ " "$ wordlist[4] $ " "$ wordlist[5] $ " " $ wordlist[6] $ " " $ wordlist[7] $ " " $ wordlist[8] $ " "$ wordlist[9] $ " " $ wordlist[10] $
                   " "$ wordlist[11] $ " " $ wordlist[12] $ " " $ wordlist[13] $ " " $ wordlist[14] $ " " $ wordlist[15] $ "| ", 'event');

                   //log(" private Messaage from " $ getplayername(tempp) $ wordlist[2] $ wordlist[3] $ " "$ wordlist[4] $ " "$ wordlist[5] $ " " $ wordlist[6] $ " " $ wordlist[7] $ " " $ wordlist[8] $ " "$ wordlist[9] $ " " $ wordlist[10] $
                   //" "$ wordlist[11] $ " " $ wordlist[12] $ " " $ wordlist[13] $ " " $ wordlist[14] $ " " $ wordlist[15] $ "| );

                 }



function gamerules()
{
 local gamerules  gr;


if (wordlist[1]== "" || wordlist[1] == " ")
  {
	tempp.ClientMessage("/gamerules  <list|disable|enable>");
    tempp.ClientMessage("gamerules in use");
    foreach AllActors(class'gamerules',gr)
    {
     tempp.ClientMessage("-----------------------------------------");
     tempp.ClientMessage(gr.class );
     tempp.ClientMessage("Chat   Notify " $ gr.bNotifyMessages);
     tempp.ClientMessage("Damage Notify " $ gr.bModifyDamage);
     tempp.ClientMessage("Spawn  Notify " $ gr.bNotifySpawnPoint);
     tempp.ClientMessage("Death  Notify " $ gr.bHandleDeaths);
     tempp.ClientMessage("Login  Notify " $ gr.bNotifyLogin);
     tempp.ClientMessage("Rules  Notify " $ gr.bNotifyRules);
     tempp.ClientMessage("AI     Notify " $ gr.bModifyAI);
     tempp.ClientMessage("map    Notify " $ gr.bHandleMapEvents);
     tempp.ClientMessage("Inv    Notify " $ gr.bHandleInventory);
     tempp.ClientMessage("-----------------------------------------");
     return;
	}
	return;
   }

// not really usfull to disable / enable since can use admin set

}



function dealwithmutators()
{
 local mutator  gr;

    tempp.ClientMessage("The Following Mutators are Running here");
    foreach AllActors(class'mutator',gr)
    {

     tempp.ClientMessage(gr.class );


	}



}





function Summon( )
{

local class<actor> NewClass;
	local string OrginalClass;
	local string classname;
	classname = wordlist[1];

    //aimbind[getplayeridfromp(tempp)]
	// offer help
	if (wordlist[1]== "" || wordlist[1] == " ")
	{
	tempp.ClientMessage(txtclr()$ "/summon  <classname|playerid source|self|bind|aim> <playrid target>");
	return;
	}
	
    // handle respawning somthing you just looked up
    if (wordlist[1]== "bind" || wordlist[1]== "*" || wordlist[1]== "X" || wordlist[1]== "aim")
	{ // spawn class from tthe aim trace  actor reference
	  // stuff to deal with "copy pasta "

        if (aimbind[getplayeridfromp(tempp)] != none)
           {
           classname =  string(aimbind[getplayeridfromp(tempp)].class);
           }else{
           tempp.ClientMessage(txtclr()$ "use '/traceaim' to bind a actor first");
           return;
           }




	}

 // handle summon players
 if (IsNumeric(wordlist[1]) || wordlist[1]  == "self")
 { // first argument is one teleport statment



	if (IsNumeric(wordlist[2]))
	{ // handle summon player to other player

	 if (wordlist[1]  == "self")
     {
     jzsummonP(tempp,returnpfromid(int(wordlist[2])));
     }else{
	 jzsummonP(returnpfromid(int(wordlist[1])),returnpfromid(int(wordlist[2])));
	 }


	return;
	}

      if (wordlist[1]  != "self")
     {
     jzsummonP(tempp,returnpfromid(int(classname)));
     }else{
	 tempp.ClientMessage(txtclr()$ "self argument error");
	 }
  return;
 }





	OrginalClass = ClassName;
	//if ( InStr(ClassName,".")==-1 )
		//ClassName = "UnrealI."$ClassName;
		
		if ( InStr(ClassName,".")==-1 )
		{
        ClassName = returnmatchingfile(Classname)$"." $ ClassName;
		tempp.ClientMessage(txtclr()$">Resolved to " $ ClassName);
        }
		
		
	log( "Fabricate " $ ClassName  ,stringtoname("[Essentials]"));
	NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class',True) );
	if ( NewClass!=None )
	{
	    if ( NewClass.Default.bStatic && tempp.badmin)
	    {
	      handlecmd(tempp,"set " $ ClassName $ " bstatic false");
	    }
		
		if ( NewClass.Default.bNoDelete && tempp.badmin)
	    {
	      handlecmd(tempp,"set " $ ClassName $ " bNoDelete false");
	    }



		if ( NewClass.Default.bStatic )
			tempp.ClientMessage(txtclr()$ "Can not spawn"@NewClass@"because actor has bStatic");

		else if ( NewClass.Default.bNoDelete )
			tempp.ClientMessage("Can not spawn"@NewClass@"because actor has bNoDelete");
		else if ( Spawn( NewClass,,,tempp.Location + (40+NewClass.Default.CollisionRadius) * Vector(tempp.Rotation) + vect(0,0,1) * 15,tempp.ViewRotation)==None )
			tempp.ClientMessage("Failed to spawn class:"@NewClass);

     // add some codein here to spawn unspawnables using dice and actor etc.
     // function actor spawnfakeobj(vector v)
     if (dbobject.getdatavalue(getplayername(tempp)$".achivments" ,"summoner") == "nil")
     {
     tempp.ClientMessage("[Achivment]  unlocked summoner! ");
     dbobject.updatedatavalue (getplayername(tempp)$".achivments", "summoner","Summon somthing "  $stampachevmet(tempp));
     }

    // bind this to a "editprop"editable class
	// 2 argument if == pause or wait, then set actor to nonmovable etc
	// if argument 2 contains = then proccess it as setprop
    //aimbind[getplayeridfromp(tempp)] = NewClass;
    }
    else       summonhelp();

}



function supersummon()
{
 local class<actor> NewClass;
 local int il,dist,counta, spacing,pilecount,max;
 local  string  thing,testthing;
 local bool testspawn;

local string classname;
local int lov , got;


 //(playerpawn pfly,string classname,int lov,int got)


       if (wordlist[1] =="" || wordlist[1] ==" " || wordlist[1] =="help")
       {
         tempp.ClientMessage( txtclr()$ "usage : supersummon  ($class.name$) (#howmany#)  (#spacing#)",'Event',true);
	   }else{
	     classname = wordlist[1];
	   }

	   if (wordlist[2] !="" && wordlist[2] !=" " )
       {
        lov = String2Int(wordlist[2]);
       }else{
	    lov =  5;
	   }

	   if (wordlist[3] !="" && wordlist[3] !=" " )
       {
        got = String2Int(wordlist[3]);
       }else{
	    got  = 60; // replace later with colision
	   }


   pilecount=1;
   thing = classname;
   // Check for user moron
   if (lov < 1)     {  max = 10;  }else{  max = lov;   }  // set max
   if (got < 10)    {  got = 25;  }else{ spacing = got;}  // set distance

   if (lov > 100  && !tempp.badmin)
   {
   max = 100;
   }  // set max

  // Check against unreali
  //if( instr(thing,".")==-1 )
  //		thing = "UnrealI." $ thing;
  
  if ( InStr(thing,".")==-1 )
		{
        testthing = returnmatchingfile(thing)$"." $ thing;
		if ( InStr(caps(thing),caps("broken"))==-1 )
		{
		 tempp.ClientMessage(txtclr()$ ">Resolved to " $ thing);
		 thing = returnmatchingfile(thing)$"." $ thing;
		}else{
		tempp.ClientMessage( txtclr()$ "err: usage : supersummon  ($class.name$) (#howmany#)  (#spacing#)",'Event',true);
		}
		
        }
		
		
  // Test load
   newClass = class<actor>( DynamicLoadObject(thing, class'Class'));
   if(newClass==none)
   {
    tempp.ClientMessage("Failed to load '"$ClassName$"': Failed to find object '"$ClassName$"'",'Event',true);
	tempp.ClientMessage( txtclr()$ "usage : supersummon  ($class.name$) (#howmany#)  (#spacing#)",'Event',true);
    testspawn = false ;
   }else{
    testspawn = true ;
   }


 For( il = 0; il <  max ; il++ )
 {
  if ( thing != "" && testspawn )
  {
     NewClass = Class<actor>(DynamicLoadObject(thing,Class'Class'));
    if ( NewClass != None )
    {
      Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15);
      tempp.ClientMessage("Debug:Spawning: "$thing$ " - "$ il $ " of " $ max $ " @ " $string(tempp.Location + dist * vector(Rotation) + vect(0.00,0.00,1.00))  ,'Event',true);
    }
    Counta++;

      dist += spacing;

   }
 }

 //log(pfly.getHumanName()$ " Supersummoned " $lov$ "-"$got$"-"$thing);
}


function playerpawn returnpfromid(int i)
{ // return a playerpawn via id.
   local PlayerReplicationInfo PRI;
   local bool l;
   local PlayerPawn q;
    foreach AllActors(class'PlayerPawn',q)
    {
       PRI=q.PlayerReplicationInfo;
       if (PRI.PlayerID==i)
       {
       l = true;
       return q;


       }
    }
 if (!l)
 {
  return none;
 }

}


function  jzsummonP( Playerpawn Admin, playerpawn target )
 {  // admin - summonp
    If( target==None )
	{
		Admin.ClientMessage("Invalid ID.",'ServerEvent',True);
		return;
	}
    Spawn(class'ReSpawn',,,Admin.Location + (Vector(Admin.ViewRotation)*2*(Admin.CollisionRadius + target.CollisionRadius)));
 	target.SetLocation( Admin.Location + (Vector(Admin.ViewRotation)*2*(Admin.CollisionRadius + target.CollisionRadius)));
    target.SetRotation( Rotator(Admin.Location-target.Location) );
 }


exec function keyit()
{
 		local Mover mov;
			foreach AllActors(class'Mover', mov)
			{
				if(tempp != None && mov != None)
				{
					if(VSize(tempp.Location - mov.Location) <= 400)
					{
						mov.Trigger(tempp, None);
						if(tempp.IsA('PlayerPawn'))
							tempp.ClientMessage("Mover '"$mov.Name$"' triggered");
					}
				}
			}
			Owner.PlaySound(sound'UnrealShare.Automag.Reload',,,,,2);


   if (dbobject.getdatavalue(getplayername(tempp)$".achivments" ,"locksmith") == "nil")
     {
     //tempp.ClientMessage("---------------------------------------------------------------");
     tempp.ClientMessage("[Achivment]  unlocked locksmith! - unlock a door in a unintended way!!");
     //tempp.ClientMessage("---------------------------------------------------------------");
     dbobject.updatedatavalue (getplayername(tempp)$".achivments", "locksmith","unlock a door in a unintended way!! "  $ stampachevmet(tempp));
     }

}


exec function buth()
{
   local int tabby;                   // for counting
   local scriptedpawn pnode;
   tabby=0;

	 foreach Allactors(class'scriptedpawn',pnode)
	 {
       if(VSize(pnode.Location - tempp.Location) <= String2Int(wordlist[1]))
        {
        tabby++;
        pnode.dropwhenkilled = none;
        pnode.Died(pnode,'buthered',pnode.Location);
        }

    }
tempp.ClientMessage("Removed "$ tabby $ " Entitiy   In Radius " $ String2Int(wordlist[1]) , 'Pickup');


 if (dbobject.getdatavalue(getplayername(tempp)$".achivments" ,"butcher") == "nil")
     {
     //tempp.ClientMessage("------------------------------------------------");
     tempp.ClientMessage("[Achivment]  unlocked butcher! - order death!");
     //tempp.ClientMessage("------------------------------------------------");
     dbobject.updatedatavalue (getplayername(tempp)$".achivments", "butcher","order death! "  $ stampachevmet(tempp));
     }

}


function jcplayerfly( Playerpawn pfly )
{

    pfly.SetBase(None);
	pfly.ClientMessage("You feel much lighter");
	pfly.UnderWaterTime = pfly.Default.UnderWaterTime;
	pfly.bHidden = pfly.Default.bHidden;
	pfly.SoundDampening = pfly.Default.SoundDampening;
	pfly.Visibility = pfly.Default.Visibility;
	pfly.SetCollisionSize( pfly.Default.CollisionRadius, pfly.Default.CollisionHeight );
	pfly.SetCollision( pfly.Default.bCollideActors, pfly.Default.bBlockActors, pfly.Default.bBlockPlayers );
	pfly.bCollideWorld = pfly.Default.bCollideWorld;
	pfly.bProjTarget = pfly.Default.bProjTarget;
	pfly.SetPhysics(PHYS_None);
	pfly.GotoState('CheatFlying');
    log("player is cheat flying" ,stringtoname("[Essentials]"));
     if (dbobject.getdatavalue(getplayername(tempp)$".achivments" ,"superman") == "nil")
     {
     //tempp.ClientMessage("---------------------------------------------------------------");
     tempp.ClientMessage("[Achivment]  unlocked superman! - utilize the power of flight!!");
     //tempp.ClientMessage("---------------------------------------------------------------");
     dbobject.updatedatavalue (getplayername(tempp)$".achivments", "superman"," Utilize the power of flight!! " $ stampachevmet(tempp));
     }
}


function jcplayerwalk( Playerpawn pfly )
{

	pfly.bHidden = False;
  	pfly.Visibility = pfly.Default.Visibility;
	pfly.bProjTarget = True;
	pfly.UnderWaterTime = pfly.Default.UnderWaterTime;
	pfly.SetCollision(True,True,True);
	pfly.SoundDampening = pfly.Default.SoundDampening;
	pfly.SetPhysics(phys_falling);
	pfly.bCollideWorld = True;
	pfly.Velocity = vect(0,0,0);
	pfly.Acceleration = vect(0,0,0);
	pfly.BaseEyeHeight = pfly.Default.BaseEyeHeight;
	pfly.EyeHeight = pfly.BaseEyeHeight;
	pfly.PlayWaiting();

    if ( pfly.Region.Zone.bWaterZone )
	{
		if ( pfly.HeadRegion.Zone.bWaterZone )
	    {
	      pfly.PainTime = pfly.UnderWaterTime;
	    }
	    pfly.SetPhysics(phys_Swimming);
	    pfly.GotoState('PlayerSwimming');
	}
	else
	{
		pfly.GotoState('PlayerWalking');
 	}
 	pfly.ClientRestart();
}


function jcplayerghost( Playerpawn pfly )
{
    pfly.SetBase(None);
   //	pfly.bIsGhosting = true;
	pfly.UnderWaterTime = -1.0;
	pfly.ClientMessage("You feel ethereal");
	pfly.bHidden = True;
	pfly.SetCollisionSize( 0.000000, 0.000000 );
	pfly.SetCollision( false, false, false);
	pfly.bCollideWorld = false;
	pfly.bProjTarget = false;
	pfly.SoundDampening = 999;
	pfly.Visibility = 0;
	pfly.SetPhysics(PHYS_None);
	pfly.GotoState('CheatFlying');
  if (dbobject.getdatavalue(getplayername(tempp)$".achivments" ,"casper") == "nil")
     {
     tempp.ClientMessage("[Achivment]  unlocked casper! - the freindly Ghost!!");
     dbobject.updatedatavalue (getplayername(tempp)$".achivments", "casper"," The freindly Ghost!! " $  stampachevmet(tempp));
     }
}




function word2actors (string nataname)
{
  local  string chars[30]; // each char of name
  local  int i;
  local class<actor> NewClass;
  local int dist,counta;

If (!IsInPackageMap("letters"))
{
AddToPackagesMap("letters"); // we can ty , but we my fail.
tempp.ClientMessage("Words mod not in sandbox" , 'Pickup');
return;
}




nataname=Replacestr(nataname,"/words","" );

   For( i = 0; i <  len(nataname) ; i++  )
    {    chars[i]= Mid(nataname,i,1);


	     //log ("letter " $chars[i]);

	      if (chars[i]=="a" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.a",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }


		  if (chars[i]=="b" )
		  {	  NewClass = Class<actor>(DynamicLoadObject("letters.b",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		   if (chars[i]=="c" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.c",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		   if (chars[i]=="d" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.d",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="e" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.e",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="f" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.f",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="g" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.g",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="h" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.h",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }


		    if (chars[i]=="i" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.i",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="j" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.j",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		   if (chars[i]=="k" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.k",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="l" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.l",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="m" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.m",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="n" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.n",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="o" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.o",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="p" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.p",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="q" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.q",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }


		   if (chars[i]=="s" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.s",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }


		    if (chars[i]=="t" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.t",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="r" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.r",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }


		    if (chars[i]=="u" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.u",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="v" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.v",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="w" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.w",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		    if (chars[i]=="x" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.x",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }


		    if (chars[i]=="y" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.y",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

		   if (chars[i]=="z" )
		  {		  NewClass = Class<actor>(DynamicLoadObject("letters.z",Class'Class'));
          if ( NewClass != None )   {  Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15); }
		  }

          Counta++;
          dist += 100;



	};





 if (dbobject.getdatavalue(getplayername(tempp)$".achivments" ,"icanspell") == "nil")
     {
     tempp.ClientMessage("---------------------------------------------------------------");
     tempp.ClientMessage("[Achivment]  unlocked i can spell! - draw with some WORDS!!");
     tempp.ClientMessage("---------------------------------------------------------------");
     dbobject.updatedatavalue (getplayername(tempp)$".achivments", "icanspell"," Draw with some WORDS!! " $ stampachevmet(tempp));
     }



}


function spawnblockdelay(playerpawn p)
{
local delayedmutatehelper gr;
gr = Spawn(class'delayedmutatehelper');
gr.Mutateplayer = p;
gr.backlink = self;

}






function jzadvance()
{
local NavigationPoint N;
local string Dest;
local int indexed;


 if (wordlist[1] == "")
    {
	wordlist[1] = "1";
	}

	foreach allactors(class'NavigationPoint',n)
	{
	 indexed ++;
		if( n.isa('teleporter') && ( InStr( Teleporter(N).URL, "#" ) > -1 || InStr( Teleporter(N).URL, "?" ) > -1 || InStr( Teleporter(N).URL, "/" ) > -1 ) )
		{
		//if (indexed == int(wordlist[1]))
		//{
		Dest = Teleporter( N ).URL;
		//}



		}

	}

	if( Dest == "" )
	{
		tempp.ClientMessage("invalid ending url" , 'Pickup');
		return;
	}

 // if (dynamicLoadObject(map$".MyLevel",class'level') != none)
 // {

  //}else{

   //}



	consolecommand("servertravel "$ Dest);

}















//--------------------------------
// helper fuctions
//---------------------------------


function int String2Int(String pff)
{
 local String digits[24];
 local int i, counter, result;
i=0;
while ((len(pff)) > 0)  // while there is stuff to munch on
{
digits[i]=right(pff,1);
pff=left(pff,len(pff)-1);
i++;}
counter=i;
result=0;

 for(i=0; i<counter; i++)
    result+=String2IntSingle(digits[i])*(exp_s(10,i));
 return(result);
}


function int String2IntSingle(String s)
{
 switch(s)
 {
 case("9"):return(9);break;
 case("8"):return(8);break;
 case("7"):return(7);break;
 case("6"):return(6);break;
 case("5"):return(5);break;
 case("4"):return(4);break;
 case("3"):return(3);break;
 case("2"):return(2);break;
 case("1"):return(1);break;
 case("0"):case(" "):case(""):return(0);break;
 };
}


function int exp_s(int base, int h)
{
 local int i, result;
 if (h==0) return(1);
 if (h==1) return(base);
 if (h<0) return (-1); // illegal!!!
 result=1;
 for(i=0;i<h;i++) result*=base;
 return(result);
}


function bool IsNumeric(string str)
{
switch(str)
 {
 case("0"):return true;break;
 case("1"):return true;break;
 case("2"):return true;break;
 case("3"):return true;break;
 case("4"):return true;break;
 case("5"):return true;break;
 case("6"):return true;break;
 case("7"):return true;break;
 case("8"):return true;break;
 case("9"):return true;break;
 case("10"):return true;break;
 case("11"):return true;break;
 case("12"):return true;break;
 case("13"):return true;break;
 case("14"):return true;break;
 case("15"):return true;break;
 case("16"):return true;break;

  default:
  return false;
  break;
 };

}


function playerpawn checkisplayername( string searchfor)
{

 local PlayerReplicationInfo PRI;
 local bool l;
   local PlayerPawn q;
    foreach AllActors(class'PlayerPawn',q)
    {
       PRI=q.PlayerReplicationInfo;

      if (caps(pri.Playername) ==  caps(searchfor))
      {
      //log("found name" $ PRI.Playername ,'Essentials');
      return q;
      l = true;
      }
    }

 if (!l)
 {
  return none;
 }

}

function string getplayername( playerpawn p)
{

 local PlayerReplicationInfo PRI;
 PRI=p.PlayerReplicationInfo;
 return pri.Playername;

}


function int getplayeridfromp( playerpawn p)
{

 local PlayerReplicationInfo PRI;
 PRI=p.PlayerReplicationInfo;
 return pri.Playerid;

}


function bool isvaladatedp(playerpawn spawner)
{
 if (dbobject.getdatavalue (getplayername(Spawner) $".nickserv" ,"identity") != "nil"
    && dbobject.getdatavalue(getplayername(Spawner) $".nickserv" ,"identity") == consolecommand("ugetplayeridentity " $ getplayeridfromp(Spawner))
    && consolecommand("ugetplayeridentity " $ getplayeridfromp(Spawner)) != ""
    && consolecommand("ugetplayeridentity " $ getplayeridfromp(Spawner)) != " ")
    {
    return true;
    }
    return false;
 }


function bool bhasaccount(playerpawn spawner)
{
 if (dbobject.getdatavalue (getplayername(Spawner) $".nickserv" ,"identity") != "nil")
    {
    return true;
    }
    return false;
 }




 function bool GrabOption( out string Options, out string Result )
{
	if ( Left(Options,1)=="?" )
	{
		// Get result.
		Result = Mid(Options,1);
		if ( InStr(Result,"?")>=0 )
			Result = Left( Result, InStr(Result,"?") );

		// Update options.
		Options = Mid(Options,1);
		if ( InStr(Options,"?")>=0 )
			Options = Mid( Options, InStr(Options,"?") );
		else
			Options = "";

		return true;
	}
	else return false;
}

//
// Break up a key=value pair into its key and value.
//
function GetKeyValue( string Pair, out string Key, out string Value )
{
	if ( InStr(Pair,"=")>=0 )
	{
		Key   = Left(Pair,InStr(Pair,"="));
		Value = Mid(Pair,InStr(Pair,"=")+1);
	}
	else
	{
		Key   = Pair;
		Value = "";
	}
}

//
// See if an option was specified in the options string.
//
function bool HasOption( string Options, string InKey )
{
	local string Pair, Key, Value;
	while ( GrabOption( Options, Pair ) )
	{
		GetKeyValue( Pair, Key, Value );
		if ( Key ~= InKey )
			return true;
	}
	return false;
}

//
// Find an option in the options string and return it.
//
function string ParseOption( string Options, string InKey )
{
	local string Pair, Key, Value;
	while ( GrabOption( Options, Pair ) )
	{
		GetKeyValue( Pair, Key, Value );
		if ( Key ~= InKey )
			return Value;
	}
	return "";
}



function string stampachevmet(playerpawn p ,optional string achivemtname,optional string  acivemetdesc)
{
local string i;
i = " Earned on " $ string(level.outer) $ " at " $  level.month$"-"$level.day$"-"$level.year;
return i;
}


function string breakpackage(string map)
{

local int index;

  // Parse appropriate map name.
  index = instr(map,".");
  if( index != -1 )
    map = left(map,index);

  return map;

}



 function adminmessage( string msg)
{
   local PlayerPawn q;
    foreach AllActors(class'PlayerPawn',q)
    {
      if (q.bAdmin)
      {
       q.ClientMessage(msg);
      }

    }
}



function injecttimers(int time , string funct)
{
    local actor q;
    foreach AllActors(class'actor',q)
    {
     q.SetTimer(time,true,stringtoname(funct));

    }
}


function fucktimers()
{
    local actor q;
    foreach AllActors(class'actor',q)
    {
     q.SetTimer(0.1,true);

    }
    tempp.ClientMessage("slooow");
}


function fucktimers1()
{
    local actor q;
    foreach AllActors(class'actor',q)
    {
     q.SetTimer(100.0,true);

    }
    tempp.ClientMessage("slow");
}


function fucktimers2()
{
    local actor q;
    foreach AllActors(class'actor',q)
    {
     q.SetTimer(0.01,false);

    }
    tempp.ClientMessage("fastkill");
}



function tickfun2()
{
    local actor q;
    foreach AllActors(class'actor',q)
    {
     q.disable('tick');

    }
    tempp.ClientMessage("tickkill");
}


function tickfun1()
{

    local IntProperty IntProp;
    local function srtProp;
    local strProperty ssrtprop;
	local string itsbs;

    foreach AllObjects( Class'IntProperty', IntProp )
    {
      	tempp.ClientMessage( "Found int:"@IntProp );
      	log("Found int:"@IntProp);
    }
	//if ( IntProp.Outer==Class'actor' )



    foreach AllObjects( Class'Function', srtProp )
    {
	tempp.ClientMessage( "Found function :"@srtProp );
	log("Found function :"@srtProp );
	 //ExecFunctionStr (stringtoname(string(srtProp)), "",itsbs);
	 //log("Found function :" $srtProp $ " out:" $ itsbs);
    }

	foreach AllObjects( Class'strProperty', ssrtProp )
	{
	tempp.ClientMessage( "Found string :"@ssrtProp );
	log("Found string :"@ssrtProp);
    }

    //local actor q;
    //foreach AllActors(class'actor',q)
    //{
    // q.enable('tick');

    //}
    //tempp.ClientMessage("tickstart");
}



function bool handlePreventDeath(pawn dying, pawn killer,name danagetype)
{
//log ("death");
    if (Killer !=None  && Killer.IsA('PlayerPawn') && dying.IsA('scriptedpawn'))
	{
	 //log ("probably some pottentail death would have averted");
	}

 return false;
}




function summonhelp()
{
tempp.ClientMessage("");

tempp.ClientMessage("--server custom monsters--");
tempp.ClientMessage("creeper.creeper  - minecraft creaper");
tempp.ClientMessage("aompak.aom_doctorA  - aom doctorA");
tempp.ClientMessage("aompak.aom_reofficerA   - aompak eofficerA ");
tempp.ClientMessage("aompak.aom_zombA  - aompak aom_zombA");
tempp.ClientMessage("aompak.aom_zombie2A  - aompak zombie2A");
tempp.ClientMessage("KFChristmas.bloatsanta  - killing floor  santa 1");
tempp.ClientMessage("KFChristmas.caroler  - killing floor  caroler");
tempp.ClientMessage("KFChristmas.clotelf  - killing floor clotelf");
tempp.ClientMessage("KFChristmas.gingerfast  - killing floor ginger");
tempp.ClientMessage("KFChristmas.jackfrost  - killing floor jackfrost");
tempp.ClientMessage("KFChristmas.nutpounder  - killing floor nutpounder");
tempp.ClientMessage("KFChristmas.PatriarchClause  - killing floor Patriarch");
tempp.ClientMessage("KFChristmas.raindeer  - killing floor reindeer");
tempp.ClientMessage("KFChristmas.scrake  - killing floor scrake");
tempp.ClientMessage("KFChristmas.stalkerclause  - killing floor  stalker");
tempp.ClientMessage("mz.TWT_ZombieBalin02 - mall zombies");
tempp.ClientMessage("mz.TWT_ZombieGordo02 ");
tempp.ClientMessage("mz.TWT_ZombieTraci   ");
tempp.ClientMessage("mz.TWT_zombietraje1  ");
tempp.ClientMessage("harpy.harpy  - serious sam harpy");
tempp.ClientMessage("quakempak2.qzombie  - quake zombie");
tempp.ClientMessage("quakempak2.qmummy  - quake mummy");
tempp.ClientMessage("quakempak2.qdemon  - quake demon");
tempp.ClientMessage("--server custom props--");
tempp.ClientMessage("crateofpiss.pisscrate  - box of piss");
tempp.ClientMessage("--server custom weapons--");
//tempp.ClientMessage("bmsting.s2   - multigun");
tempp.ClientMessage("rickroller.rickroller   - rickroller");

}


function bool mutatedownload( string plname, string plip, string filename,int filesize)
{
adminmessage("user " $ PLName $ " requests file to download " $ FileName );
log ("user " $ PLName $ " requests file to download" $ FileName );

return true;
}


function isclassy(string pack)
{
	local array<Object> ObjL;
    local class<actor> NewClass;
	local int c,i;
	local string classname, lolitslong;
	   if ( LoadPackageContents(pack,Class'class',ObjL) )
	   {
	       // log("yes");
            c = Array_Size(ObjL);            log(c);
		    // package has actors
            for( i=0; i<c; ++i )
	        {
	        // dump any functions / actors to the console
             classname = string(ObjL[i]);
             packageclasscontents[i]= string(ObjL[i]);
             // save the classnames for
             tempp.ClientMessage(txtclr() $  classname);


             // dumpallprops(class<object> sst)

            // log(classname);
            // lolitslong = lolitslong $ "   " $ classname;
              //log (lolitslong);
	       };
          //log (lolitslong);

	   }





}


   function superclassy(string pack)
{
	local array<Object> ObjL;
    local class<actor> NewClass;
	local int c,i;
	local string classname, lolitslong;
	   if ( LoadPackageContents(pack,Class'class',ObjL) )
	   {
	       // log("yes");
            c = Array_Size(ObjL);            log(c);
		    // package has actors
            for( i=0; i<c; ++i )
	        {
	        // dump any functions / actors to the console
             classname = string(ObjL[i]);
             packageclasscontents[i]= string(ObjL[i]);
             // save the classnames for
             tempp.ClientMessage(txtclr() $  classname);

             // need to be 'acter.class'
             // we cant get this without spawning the actor?
             //dumpprops(classname);


            // log(classname);
            // lolitslong = lolitslong $ "   " $ classname;
              //log (lolitslong);
	       };
          //log (lolitslong);

	   }





}





function dumpprops(class<object> sst)
{
// read a package, dump its configuable properties.

    local Property Prop;
    local Function srtProp;





    foreach AllObjects( Class'Property', Prop )
    {

       if ( Class(prop.Outer) == sst )
       {
        tempp.ClientMessage( "Found property:"@Prop$" ("@Prop.Class$")" );
          log("Found property:"@Prop$" ("@Prop.Class$")");
       }

    }


}

function dumpallprops(class<object> sst)
{
  local class<object> cls;
  cls = sst;

  while (cls != None)
  {
    dumpprops(cls);
    cls = GetParentClass( cls );
  }
}

function string  buildfullsentance(int start)
{// put the elements back to gether
local int i;
local string outlet;
  For( i = start; i <  200 ; i++  )
    {
       if (wordlist[i] != "" && wordlist[i] != " " && wordlist[i] != "nil")
       {
	   outlet =  outlet $ " "  $ wordlist[i];
	   }
	}
	return outlet;
}

function preproccessargs(actor a, int argpos)
{// actor to effect, arg string posision (wordlist[i])

}



function updateplayerammovalues()
{
local PlayerPawn q;

    foreach AllActors(class'PlayerPawn',q)
    {
	getplayerweapons(q);
    }
//dbobject.updatedatavalue(getplayername(playerpawn(other)) $".inventory" , string(Inv.class),"ammo");

}


function getplayerweapons(playerpawn p)
{
local inventory q;

    foreach AllActors(class'inventory',q)
    {
      if (q.owner==p)
	  {
	  //log(q.classname);
	  }

    }

}


 function spawnclassy(string pack,optional string sector)
{
    // find all actors in a class, and spawn them
    // player is tempp.
	local array<Object> ObjL;
    local class<actor> NewClass;
    local int i,dist,C;
	local string classname;

	   if ( LoadPackageContents(pack,Class'class',ObjL) )
	   {
	       // log("yes");
            c = Array_Size(ObjL);            log(c);
            dist = 50;
		    // package has actors

        // prevent this object from getting presistant.
        consolecommand("set dropall227i deco_mutator lockout true");
            for( i=0; i<c; ++i )
	        {
	        //SetPropertyText(a, b);
            classname = string(ObjL[i]);
            NewClass = Class<actor>(DynamicLoadObject(classname,Class'Class'));
              if ( NewClass != None )
                 {

                 if ( sector == "items" && ClassIsChildOf( newclass, Class'inventory' ) )
                 {
                 Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15);
                 tempp.ClientMessage("Debug:Spawning: " $ classname $ " " $ string(tempp.Location + dist * vector(Rotation) + vect(0.00,0.00,1.00))  ,'Event',true);
                 dist += 50;

                 }

                 if (sector =="pawns" && ClassIsChildOf( newclass, Class'pawn' ) )
                 {
                 log (NewClass.GetPropertyText("Mesh"));
                 Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15);
                 tempp.ClientMessage("Debug:Spawning: " $ classname $ " " $ string(tempp.Location + dist * vector(Rotation) + vect(0.00,0.00,1.00))  ,'Event',true);
                 dist += 50;
                 }

                  if (sector =="deco" && ClassIsChildOf( newclass, Class'decoration' ) )
                 {
                 log (NewClass.GetPropertyText("Mesh"));
                 Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15);
                 tempp.ClientMessage("Debug:Spawning: " $ classname $ " " $ string(tempp.Location + dist * vector(Rotation) + vect(0.00,0.00,1.00))  ,'Event',true);
                 dist += 50;
                 }

                  if (sector =="" || sector ==" ")
                 { // all
                 Spawn(NewClass,,,tempp.Location + dist * vector(tempp.Rotation) + vect(0.00,0.00,1.00) * 15);
                 tempp.ClientMessage("Debug:Spawning: " $ classname $ " " $ string(tempp.Location + dist * vector(Rotation) + vect(0.00,0.00,1.00))  ,'Event',true);
                 dist += 50;
                 }




                 }


           }
        consolecommand("set dropall227i deco_mutator lockout false");
      };



}

   function arbentryaim()
   {  // string(j.class)
    log (aimbind[getplayeridfromp(tempp)].class);
	arbfun(aimbind[getplayeridfromp(tempp)] ,  wordlist[1], wordlist[2]$ wordlist[3] $ wordlist[4]);
   }


   function arbentry()
   {
   local string h;
     //wordlist[1] = file.class
     //wordlist[2] = funtion name
     //wordlist[3] = args "arg1 arg2"
   
    if (huntactor(wordlist[1]) !=None)
	 {
      h=arbfun(huntactor(wordlist[1]), wordlist[2], wordlist[3]$ wordlist[4] $ wordlist[5]);
       tempp.ClientMessage(txtclr()$  h $ "  " $ huntactor(wordlist[1]) );
	 }else{
       tempp.ClientMessage(txtclr() $ "arbentry: invalid actor reference,(" $ wordlist[1] $ ")");
     }	 
   }


  function actor huntactor(string classx)
  { // spefify a actor by  classname
  local actor a;
  foreach AllActors(class'actor',a)
    {
     //log(string(a.class));
      if (caps(a.class) == caps(classx))
	  {

	  return a;

      }

    }

  }


 function string arbfun(actor s , string functname, string F_args)
{
local string returny;
// s can be none! 3/16/2023
 s.ExecFunctionStr(stringtoname(functname),F_args,returny);
 return returny;
}


function buildsutolist()
{
local string hh;
LOCAL int filesread;
foreach AllFiles( "u", "", hh )
	{
	 //log(hh);
	   hh = ReplaceStr(hh, ".u", "");
	   hh = caps(hh);
	   //if ( InStr(Caps(ConsoleCommand("get GameEngine ServerPackages")),hh) != -1 ) 
	       if(IsInPackageMap(caps(hh)))
		   {
	       //if (IsInPackageMap(hh))
		      // {log("ism " $ hh);}
		  // if (IsInPackageMap(caps(hh)))
		      // {log("ism  caps " $ hh);}
           filesread++;
           buildactortable(hh);
           }
	}
	log(filesread,'classscanner');
}


function buildactortable(string pack)
{
	local array<Object> ObjL;
	local int c,i,kk;
	local string classname;
	   //log("pack var = " $ pack);
	   if ( LoadPackageContents(pack,Class'class',ObjL) )
	   {
	     c = Array_Size(ObjL);            //log(c);
	         for( i=0; i<c; ++i )
	        {
	         classname = string(ObjL[i]);
			 
             //saveobjectinfo (pack,ReplaceStr(classname, pack$".", ""));
			 kk = Array_Size(avalibleobjectsarray);
			 Array_Insert(avalibleobjectsarray,Array_Size(avalibleobjectsarray),1);
             avalibleobjectsarray[kk].objpack=caps(pack);
             avalibleobjectsarray[kk].objclass=ReplaceStr(caps(classname), caps(pack)$".", "");
 	       };
       }
}


function string returnmatchingfile(string objectname)
{
local int z;
log("asking for " $ caps(objectname));
  For( z = 0; z < Array_Size(avalibleobjectsarray) ; z++ )
        {
           if (caps(avalibleobjectsarray[z].objclass) == caps(objectname))
           {
            return avalibleobjectsarray[z].objpack;
           }
        //return "broken";// this shouldnt be possible ???
        }
return "broken";// this shouldnt be possible ???

}


function testdumpresources()
{
local int z;
  For( z = 0; z < Array_Size(avalibleobjectsarray) ; z++ )
        {
        log(avalibleobjectsarray[z].objpack $ "." $ avalibleobjectsarray[z].objclass);
        }


}





defaultproperties
{
				achevmentcount=15
				EscapePhrase="/"
				databasename="essentials.sqlite3db"
				somecolor=(R=255,B=255)
				RedColor=(R=255,B=128)
				GreenColor=(G=255)
}
