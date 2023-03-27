class swapdropper expands Mutator
 Config(dropall227);

struct pawndwk  {// DROPWHENKILLED
    var() config string           pawnname;
    var() config int              howmany;
    var() config bool             isenabled,useoldmethod;
    var() config string           dwkthing;
    var() config string          dropcondional;
	            };

	//var() config string           spawngen; //alternate swarmhost blueprint

var  (Dwk) config  array<pawndwk>  pawndwklist;
var string wordlist[500];      // Putting full command in word pieces
var playerpawn chattinghold;



function BeginPlay()
{

	AddGameRules();
	log( "Loading Swapdroper DWK Manager v1" ,stringtoname("[Swapdropper]"));
	log( "Drop rules:" ,stringtoname("[Swapdropper]"));
	listrulez();
	SaveConfig();
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
   case("/swapdropper"):                sdpro();break;
   case("swapdropper"):                 sdpro();break;
   break;
  }
}



function sdpro()
{
local int i;
log("msgloop " $ wordlist[0]$ "," $ wordlist[1]  $ "," $ wordlist[2]);

if (wordlist[1] =="" || wordlist[1] ==" " || wordlist[1] =="help")
       { // usage situation help
       chattinghold.ClientMessage("usage : dropswapper  editdrop | editdropcount | editname ",'Event',true);
	   }



if (wordlist[1] =="list" )
       {
       listruleztochat(chattinghold);
       }





//---------------------
       if (wordlist[1] =="editname" )
       {        //   editdrop command

          if (wordlist[2] =="" || wordlist[2] ==" " || wordlist[2] =="help")
              {
                     if (!IsNumeric(wordlist[2]))
                     {
                     chattinghold.ClientMessage(" [!] Editname , missng argument 2 (numeral)",'Event',true);
                     }else{
                     chattinghold.ClientMessage(" [!] Editname , missng argument 2 ",'Event',true);
                     }
              }else{
              chattinghold.ClientMessage("  Editname existing data:" $  pawndwklist[String2Int(wordlist[2])].pawnname,'Event',true);
                    if (String2Int(wordlist[2]) > Array_Size(pawndwklist))
                    {
                    // we need to create a new row.
                    chattinghold.ClientMessage(" [!] Editname ,invalid row. " $ i,'Event',true);

                      if (wordlist[3] =="" || wordlist[3] ==" " || wordlist[3] =="help"  )
                      { // also check for a simple valid classname
                       chattinghold.ClientMessage(" [!] Editname , missing argument 3 (format as a name 'krall' etc)",'Event',true);
                      }else{
                      // we already have this row.
                       i = Array_Size(pawndwklist) -1;
	                   Array_Insert(pawndwklist,Array_Size(pawndwklist),1);
	                   pawndwklist[i].dwkthing="unreali.pupae";
                       pawndwklist[i].pawnname=wordlist[3];
                       pawndwklist[i].dropcondional="isa";
                       pawndwklist[i].howmany=1;
                       pawndwklist[i].isenabled=true;
                       chattinghold.ClientMessage("  [ok] Editname ,New row added at " $ i,'Event',true);
                       chattinghold.ClientMessage("  [ok] Editname ,Setting commited.",'Event',true);
                       saveconfig();
                       }


                   }else{ // array size

                     if (wordlist[3] =="" || wordlist[3] ==" " || wordlist[3] =="help"  )
                     { // also check for a simple valid classname
                     chattinghold.ClientMessage(" [!] Editname , Missing argument 3 (format as NAME 'krall' )",'Event',true);
                     }else{
                     pawndwklist[String2Int(wordlist[2])].pawnname = wordlist[3];
                     chattinghold.ClientMessage(" [!] Editname ,Setting commited.",'Event',true);
                     saveconfig();
                     }




                   }


              }

       }






//-----------------------
if (wordlist[1] =="editcount" )
       {        //   editdrop command

          if (wordlist[2] =="" || wordlist[2] ==" " || wordlist[2] =="help")
              {
                // unreasonable  data? !IsNumeric(wordlist[2])
                 if (!IsNumeric(wordlist[2]))
                    {
                    chattinghold.ClientMessage(" [!] Editcount , missng argument 2 (numeral)",'Event',true);
                    }else{
                    chattinghold.ClientMessage(" [!] Editcount , missng argument 2 ",'Event',true);
                    }

               }else{
                    chattinghold.ClientMessage("  Editcount existing data:" $  pawndwklist[String2Int(wordlist[2])].howmany,'Event',true);
                      if (wordlist[2] =="" || wordlist[2] ==" " || wordlist[2] =="help")
                      {
                         if (!IsNumeric(wordlist[3]))
                         {
                         chattinghold.ClientMessage(" [!] Editcount , missng argument 3 (numeral)",'Event',true);
                         }else{
                         chattinghold.ClientMessage(" [!] Editcount , missng argument 3 ",'Event',true);
                         }
                      }else{
                      pawndwklist[String2Int(wordlist[2])].howmany = String2Int(wordlist[3]);
                      chattinghold.ClientMessage("  [ok] Editcount ,Setting commited.",'Event',true);
                      }

              }

      }








//-----------------------------
       if (wordlist[1] =="editdrop" )
       {        //   editdrop command

          if (wordlist[2] =="" || wordlist[2] ==" " || wordlist[2] =="help")
              {
                // unreasonable  data? !IsNumeric(wordlist[2])
                 if (!IsNumeric(wordlist[2]))
                    {
                    chattinghold.ClientMessage(" [!] Editdrop , missng argument 2 (numeral)",'Event',true);
                    }else{
                    chattinghold.ClientMessage(" [!] Editdrop , missng argument 2 ",'Event',true);
                    }
                    }else{
                // reasonable date?
                chattinghold.ClientMessage("  Editdrop existing data:" $  pawndwklist[String2Int(wordlist[2])].dwkthing,'Event',true);

                   if (String2Int(wordlist[2]) > Array_Size(pawndwklist))
                   {
                   // we need to create a new row.
                    chattinghold.ClientMessage(" [!] Editdrop ,invalid row. " $ i,'Event',true);

                      if (wordlist[3] =="" || wordlist[3] ==" " || wordlist[3] =="help" || InStr(wordlist[3],".")==-1 )
                      { // also check for a simple valid classname
                      chattinghold.ClientMessage(" [!] Editdrop , missing argument 3 (format as 'unreali.krall' etc)",'Event',true);
                      }else{
                    // we already have this row.
                       i = Array_Size(pawndwklist) -1;
	                   Array_Insert(pawndwklist,Array_Size(pawndwklist),1);
	                   pawndwklist[i].dwkthing=wordlist[3];
                       pawndwklist[i].pawnname="pupae";
                       pawndwklist[i].dropcondional="isa";
                       pawndwklist[i].howmany=1;
                       pawndwklist[i].isenabled=true;
                       chattinghold.ClientMessage("  [ok] Editdrop ,New row added at " $ i,'Event',true);
                       chattinghold.ClientMessage("  [ok] Editdrop ,Setting commited.",'Event',true);
                       saveconfig();
                       }





                   }else{

                     if (wordlist[3] =="" || wordlist[3] ==" " || wordlist[3] =="help" || InStr(wordlist[3],".")==-1 )
                     { // also check for a simple valid classname
                     chattinghold.ClientMessage(" [!] Editdrop , Missing argument 3 (format as 'unreali.krall' etc)",'Event',true);
                     }else{
                     pawndwklist[String2Int(wordlist[2])].dwkthing = wordlist[3];
                     chattinghold.ClientMessage(" [!] Editdrop ,Setting commited.",'Event',true);
                     saveconfig();
                     }



                }




              }
	   }


       if (wordlist[1] =="editdropcount" )
       {
       chattinghold.ClientMessage("editdropcount # , new actor",'Event',true);
	   }

       if (wordlist[1] =="editcount" )
       {
       chattinghold.ClientMessage("editdropcount # , new actor",'Event',true);
	   }




//listruleztochat(Chattinghold);
}


//






function AddGameRules()
{
	local swapdropper_GR gr;

	gr = Spawn(class'swapdropper_GR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}

function listrulez()
{
  local int z;
  local bool bfoundanythingatall;
		For( z = 0; z < Array_Size(pawndwklist) ; z++ )
        {
		     if ( pawndwklist[z].pawnname != "" )
		     {
		         log( "Rule If " $ pawndwklist[z].dropcondional $ " "$ pawndwklist[z].pawnname $ " Drop " $ pawndwklist[z].howmany $ "  "$  pawndwklist[z].dwkthing ,stringtoname("[Swapdropper]"));
		         bfoundanythingatall = true;
			 }
		}

if (!bfoundanythingatall)
{
log( "No DWK Rules found! Goto settings>Swapdropper>pandwklist and set some up!" ,stringtoname("[Swapdropper]"));
}

}




function scorepawnKill( Pawn Killer, Pawn Other )
{
  local int z;
  if (Other!=None)
	{
		For( z = 0; z < Array_Size(pawndwklist) ; z++ )
        {
		     if ( pawndwklist[z].pawnname != "" && pawndwklist[z].isenabled)
		     {
		              if (pawndwklist[z].dropcondional == "stringmatch")
                      {
				        if( pawndwklist[z].pawnname == string(other.class) )    {     analsalad(other.location, z,string(other.class));  };
					  }



					  if (pawndwklist[z].dropcondional == "partmatch")
                      {
					   if(InStr(caps(string(other.class)),caps(pawndwklist[z].pawnname)) != -1  )  {     analsalad(other.location, z,string(other.class));  };
					  }


					  if (pawndwklist[z].dropcondional == "isa")
                      {
					  if(other.IsA(StringToName(pawndwklist[z].pawnname))) {     analsalad(other.location, z, string(other.class));  };
					  }

			 }
		}
   }


   // later add requireed death acotr rules - only a certain actor killing another will trigger the drop
   // so if !playerpawn then dont drop!




}


function analsalad(vector lolwhy, int z,string analsause)
{

  local SwarmHost swarmer;

  //pawndwklist[z].spawngen

                if (pawndwklist[z].useoldmethod)
			    {
                swarmer = Spawn(Class'psidwk1',,,lolwhy + 1 * vector(Rotation) + vect(0.00,0.00,1.00) * 15);
                }else{
                swarmer = Spawn(Class'swarmhost',,,lolwhy + 1 * vector(Rotation) + vect(0.00,0.00,1.00) * 15);
                }
				  if (swarmer != None )
                 {
				  // log ( analsause $ " default " $  swarmer.SpawnNumber,'dropswap');
                   swarmer.PawnToSpawn = pawndwklist[z].dwkthing;
                   swarmer.SpawnNumber = pawndwklist[z].howmany;
                   swarmer.giveuptimes = pawndwklist[z].howmany + 5;
                   swarmer.Spawnspace = 256;
                   swarmer.logspawns = true;
                  // log ( analsause $ " Dropped " $  pawndwklist[z].dwkthing,'dropswap');
				   //log ( analsause $ " after set requested " $  swarmer.SpawnNumber ,'dropswap');
				   //log ( analsause $ " requested " $  pawndwklist[z].howmany,'dropswap');
                  // success
                 }






}


function bool handleChat( PlayerPawn Chatting, out string Msg )
{
local int i;
          chattinghold = chatting;
	 	  if (msg == "/help")
          {
          Chatting.ClientMessage("[Swapdropper]: The dead will have its revenge! Build 2019.8.20", 'event');
          return true;
          }

          if(InStr(msg,"swapdropper")!=-1)   {	 ExecuteCommand(msg); return false; }
return true;// pass it on
}



function listruleztochat(playerpawn him)
{
  local int z;
  local bool bfoundanythingatall;
		For( z = 0; z < Array_Size(pawndwklist) ; z++ )
        {
		     if ( pawndwklist[z].pawnname != "" )
		     {
 him.ClientMessage("    > Rule " $ z $ " : If (" $ pawndwklist[z].dropcondional $ " " $ pawndwklist[z].pawnname $ ") Dies , Spawn  " $ pawndwklist[z].howmany $ "  of class  "$  pawndwklist[z].dwkthing, 'event');
		      bfoundanythingatall = true;
			 }
		}

if (!bfoundanythingatall)
{
him.ClientMessage("[Swapdropper]: the sderver has no configure drop rules", 'event');
}

}

defaultproperties
{
				pawndwklist(1)=(pawnname="brute",howmany=3,isenabled=True,dwkthing="unreali.krall",dropcondional="isa")
				pawndwklist(2)=(pawnname="krall",howmany=3,isenabled=True,dwkthing="unreali.leglesskrall",dropcondional="fff")
				pawndwklist(3)=(pawnname="Kamikaze",howmany=2,isenabled=True,dwkthing="doompawns.imp",dropcondional="isa")
				pawndwklist(4)=(pawnname="imp",howmany=4,dwkthing="unreali.pupae",dropcondional="isa")
				pawndwklist(5)=(pawnname="titan",howmany=1,dwkthing="unreali.titan")
				pawndwklist(6)=(pawnname="pupae",howmany=2,dwkthing="d",dropcondional="d")
				pawndwklist(7)=(pawnname="cow",howmany=1,dwkthing="unreali.cow",dropcondional="isa")
				pawndwklist(8)=(pawnname="gasbag",howmany=3,isenabled=True,dwkthing="unreali.manta",dropcondional="isa")
				pawndwklist(9)=(pawnname="gasbagx",howmany=1,dwkthing="unreali.gasbagz",dropcondional="isa")
				pawndwklist(10)=(pawnname="unreali.manta",howmany=3,isenabled=True,dwkthing="gasbag",dropcondional="isa")
				pawndwklist(11)=(pawnname="Skaarj",howmany=1,dwkthing="unreali.SkaarjOfficer",dropcondional="d")
				pawndwklist(12)=(pawnname="z",howmany=1,dwkthing="z",dropcondional="isa")
				pawndwklist(13)=(pawnname="tentacle",howmany=1,isenabled=True,dwkthing="unreali.skaarjassassin",dropcondional="isa")
}
