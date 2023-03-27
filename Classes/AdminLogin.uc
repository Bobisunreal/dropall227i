class adminlogin expands Mutator config(dropall227);

  // updated     8/11 2022 for dynamic arrays
  // updated     8/9 2022 for ddatabase access
                           //xccoop support , except we wont get a callbackin stock xcoop.


struct PlayerData
{
	var() config string PlayerName;
	var() config string PlayerIp, uid ;
	var() config bool enabled;
    var() config int A_level;
    var() config string memo;

};

var() config  array<PlayerData>  Admins;
var() globalconfig PlayerData	ipgrid[20];
var () config color somecolor;
var() playerpawn ww;
var string wordlist[500];      // Putting full command in word pieces
//var databaseinterationclass dbobject, dbtarget;
var actor testobj,dbtarget;
var string returny;
var bool icant;

function BeginPlay()
{
   log ("Loading Adminlogin V1.5 ---------------",stringtoname("[AdminLogin]"));
    listadmins();
	AddGameRules();
	SaveConfig();

	//grab a reference to the backround db,ifits avalible
    foreach AllActors(Class'actor',testobj)
   	 {
   	  if(testobj.isa('databaseinterationclass'))
   	  {
   	    dbtarget = testobj;
   	    log("Found playerDB Running",stringtoname("[AdminLogin]"));
   	  }
     }

        if (level.game.isa('xcoop'))
        {
         Log("Detected gamtype as Xcoop ", stringtoname("[AdminLogin]"));
        }
		
		 if (level.game.isa('wolfcoop'))
        {
         Log("Detected gamtype as wolfcoop ", stringtoname("[AdminLogin]"));
        }
}

function listadmins()
{
local int bz;
For( bz = 0; bz <  Array_Size(Admins) ; bz++ )
           {
               if( Admins[bz].playername!=""  && Admins[bz].playername!=" ")
              {
                log ("AdminList Init [" $  Admins[bz].playername $ " - " $ Admins[bz].playerip $ " ]",stringtoname("[AdminLogin]"));

              }

            }

}


function AddGameRules()
{
	local adminlogin_GR gr;

	//local string ff;
	gr = Spawn(class'adminlogin_GR');
	gr.MutatorPtr = self;
	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}




function bool handlecast(Actor Broadcasting, string Msg)
{
 // intercept console here.
 // anybody could probably call this using admin say, etc
 // notible with code, as a admin would already be able to...
 // ScriptLog: jCoopZGame Console: /test y
 log(Broadcasting.name $ " " $ msg);
 return true;
}

function bool handleChat( PlayerPawn Chatting, out string Msg )
{
  local int i;
  local string rretur;
          if (msg == "/help")
          {
          Chatting.ClientMessage("[Adminlogin]: Admin account managment Build 2022.8.11 xcoopsupport", 'event');
          return true;
          }

         // this gets extra messy when executed from condole.
          if(instr(msg,"/op")!=-1  && chatting != None)
          {
           ExecuteCommand(msg);

            if (dbtarget == None)
            {
            Chatting.ClientMessage("functionality requires datbase.");
            return false;
            }

            if  (wordlist[1] != "" && (Chatting.badmin) && (dbtarget != None))
            {



             // by playername ideally.
             // but if they are not present , we need  to look up there ip in the database.

             // how to we hanfle this?
               returny = "";
   	           //log("blank: "$ returny);
               dbtarget.ExecFunctionStr('getdatavalue',"loggedplayer" $ " " $ wordlist[1],returny);
               dbtarget.ExecFunctionStr('getdatavalue',wordlist[i] $ ".nickserv" $ " " $ "identity",rretur);
               if (returny != "nil")
               {
               Chatting.ClientMessage(" found IP");
                i = Array_Size(Admins) -1;
                Array_Insert(Admins,Array_Size(Admins),1);
	                   	 Admins[i].PlayerName=wordlist[1];
						 Admins[i].PlayerIp=returny;
						 Admins[i].uid=rretur;
						 Admins[i].memo="opped by:" $ chatting.PlayerReplicationInfo.Playername;
						 Chatting.ClientMessage(Level.Game.MakeColorCode(somecolor) $"[Adminlogin]: OP:  added at line " $ i);
               }else{
                Chatting.ClientMessage(Level.Game.MakeColorCode(somecolor) $"[Adminlogin]: OP:  Player was never present on server.");
               }
               //  dbtarget.ExecFunctionStr('wordlist[i]$".nickserv',"identity" $ " " $ ff,rretur);

            Chatting.ClientMessage("debug: *=" $ wordlist[1] $ " ?=" $ wordlist[2] $ " !=" $ wordlist[3] $ " dag:" $ returny);
            }
          Chatting.ClientMessage("[Adminlogin]: not implemented", 'event');
          return true;
          }
return  true;
}

function MutateRespawningPlayer( Pawn Spawner )
{
 if (spawner.IsA('playerpawn') )
 {
 ww=playerpawn(spawner);
 settimer (1,false,'loginusera');
 //loginuser(playerpawn(spawner));
 }
}

function loginusera()
{
loginuser(ww);
}

function int getplayerid( playerpawn p)
{

 local PlayerReplicationInfo PRI;
 PRI=p.PlayerReplicationInfo;
 return pri.Playerid;

}



function loginuser(playerpawn spa)
{
local int kiddo,bz;
local string tt,ff,gg;
local PlayerReplicationInfo qp;



kiddo =  spa.PlayerReplicationInfo.Playerid;

  tt=consolecommand("ugetplayerip " $ kiddo);
  gg=consolecommand("ugetplayeridentity " $ kiddo);
  ff =  spa.PlayerReplicationInfo.Playername;
  if (tt == "" || tt ==" ")
    {// we cant trust ugetip when downloaders are present.
    tt = RetrieveIP(String(spa.Name));
    log(" ugetip = " $ consolecommand("ugetplayerip " $ kiddo) ,stringtoname("[Adminlogin]"));
    log("Downloaders " $ level.HasDownloaders(),stringtoname("[Adminlogin]"));
    log("Got ip using sockets" $ tt ,stringtoname("[Adminlogin]"));
    }


 For( bz = 0; bz <  Array_Size(Admins) ; bz++ )
         {
             if(tt==Admins[bz].playerip && tt!=""  && tt!=" ")
            {
                if (! spa.badmin)
                {

                  if(tt=="" || tt==" ")
                  {
                  Admins[bz].playerip = "nullnullnullnullnull";

                  }

                 // player becomes administrator.
                 spa.badmin = true;

                 // extra gametype specific flags.
                 if (level.game.isa('xcoop'))
                 {
                     // we can "login password"
                     // or we can do some weird stuff.
                     foreach AllActors(class'PlayerReplicationInfo',qp)
                     {
                        if (qp.owner==spa && qp.isa('XPRI'))
	                    {
                          if(dbtarget != None)
   	                      {  // the future goal here is to pull "player.nicksrv admingroup "
   	                       ff =  spa.PlayerReplicationInfo.Playername;
   	                       //dbtarget.ExecFunctionStr('getdatavalue',ff $ " " $ "num_of_respawns",returny);
   	                       dbtarget.ExecFunctionStr('getdatavalue',ff $ " " $ "num_of_respawns",returny);
   	                       //dbtarget.ExecFunctionStr('updatedatavalue ',ff $ " " $ "Last_admin_login",returny);
                           //log("terst reurn " $  returny $ "   " $ icant );
   	                       }
   	                         if(Admins[bz].A_level > 0)
   	                         {
                             qp.SetPropertyText("adminlevel", string(Admins[bz].A_level));
                             log(string(Admins[bz].A_level));
                              }
                        //spa.ClientMessage(Level.Game.MakeColorCode(somecolor) $ "[Adminlogin] xcoop alevel assigned",'pickup');
                        }

                      }
                  }
				  
				  if (level.game.isa('WolfCoopGame'))
                 {
                     foreach AllActors(class'PlayerReplicationInfo',qp)
                     {
                        if (qp.owner==spa && qp.isa('wPRI'))
	                    {
                          if(dbtarget != None)
   	                      { 
   	                       ff =  spa.PlayerReplicationInfo.Playername;
                           //log("terst reurn " $  returny $ "   " $ icant );
   	                      }
   	                         if(Admins[bz].A_level > 0)
   	                         {
                             qp.SetPropertyText("adminlevel", string(Admins[bz].A_level));
                             log(string(Admins[bz].A_level));
                              }
                        spa.ClientMessage(Level.Game.MakeColorCode(somecolor) $ "[Adminlogin] wolfcoop alevel assigned("$ Admins[bz].A_level$")",'pickup');
                        }

                      }
                  }

                 //loelseg("some match " $tt);
				 ff =  spa.PlayerReplicationInfo.Playername;
				 gg=consolecommand("ugetplayeridentity " $ kiddo);
				 spa.ClientMessage(Level.Game.MakeColorCode(somecolor) $ "[Adminlogin]  Account detected, Logging in...",'pickup');
				 log(ff $"'s" $ " Admin account detected, logged in successfully",stringtoname("[Adminlogin]"));
				 log(ff $"'s" $ " Represents as " $ gg $ " using " $ tt,stringtoname("[Adminlogin]"));

                 // add uid cvhecking here




               }

            }
          }




ww = none; // protect the pin?
}


Function String RetrieveIP(String Find)
{
Local String TempIP, First, Second, Section, Orig, CurSock;
Local Int I, CSpot, CS;

CurSock = ConsoleCommand("sockets");

Orig = CurSock;

50:
CSpot = Instr(Orig, Find);

if(CSpot != -1)
{
First = Left(Orig, CSpot);
Second = Right(First, 140);
CS = Instr(Second, "Client");
If(CS != -1)
{
CS += 7;
Section = Right(Second, Len(Second) - CS);
}
Else
{
Orig = Right(Orig, Len(Orig) - (CSpot + Len(Find)));
Goto 50;
}

For(I=0;I<Len(Section);I++)
{

If(Mid(Section, I, 1) != " ")
	TempIP = TempIP$Mid(Section, I, 1);
Else
{
CurSock = "";
Return TempIP;
}
}
}
Else
{
	CurSock = "";
	Return "Non-Existent";
}

}


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
 case("17"):return true;break;
case("18"):return true;break;
case("19"):return true;break;
case("20"):return true;break;
case("21"):return true;break;
case("22"):return true;break;
case("23"):return true;break;
case("24"):return true;break;
  default:
  return false;
  break;
 };

}


function ExecuteCommand(string cmd)
{
    local int i, words;
   cmd=cmd$" ";
   // cleaning wordlist
   log("msg " $ cmd);
   log("msgx " $ wordlist[0]$ "," $ wordlist[1]  $ "," $ wordlist[2]);
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
  // executing commands
  log("msgx1 " $ wordlist[0]$ "," $ wordlist[1]  $ "," $ wordlist[2]);

   switch(wordlist[0])
  {// internal parse calls, do NOT do ANYTHING, ONLY WANTED A WORDLIST
   //case("/swapdropper"):                sdpro();break;
   case("ololololol"):
   break;
   break;
  }
}









defaultproperties
{
}
