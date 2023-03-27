class deco_mutator expands Mutator
 Config(dropall227);

var() config bool blogin,blogout;

 // so we listen for spawns,save them
 // then we listen for prevent dearh
 // 2/14 tested pause code

 struct sn_note  {//
    var() config actor            aref;        // actor ref
	var() config string           classi;      // spawnclass
    var() config name             name;        // absolute name
	var() config float            ds;
	var() config mesh             meshy;
	var() config float            radi,loli;
	var() config bool             gone;        // deleted / none
	var() config vector           loc;         // spawn location
	var() config rotator          rot;         // rotation
	var() config int              leveltime;   // spawn time
	var() config bool             respawnedpawn ;
	var() config string           levelname;

                   };
// save roation, location , class name to respawn later.
// save leveltime(seconds) to respawn  everyting in x time frame (ie 3 minutes ago to now , dead)
// also save  death time to do spam calulations for spawns

var()config array<sn_note>  sn_list;   // the array
var bool lockout,                      // disable the listener from cacthing respawned objects
         speedygoat;                   // switch to a faster tickrate if we are passing tho irrelevent objects
var int arraysizeholder,momentholder,  // stepping
        reallicker;                    // total objects for this level spawned
var playerpawn pp,pr;                     // chatter reference for commands
var actor aawait;                      // special holder for instanthouse decorations

var bool godoit,                       // supertick speeder bool
         pauserecall,                  // pause state
		 spewdebug;                    // spit to player
var int threads;
var bool wetoldeveryone;


var actor aimbind[32];


function BeginPlay()
{
	SetTimer(10.0,false,'waitforit');	// let other things spawn in first 10 seconds of level.
    pauserecall = false;	            // set async pause stat

}

// wait for any odd mutators to finish there stuff ( treemut spawning trees etc)
function waitforit()
{
AddGameRules(); // spawn rule listener
Addtracker();   // spawn notify listener
setup_async();  // init the async vars
log( "persatant deco controller  betav1.1" ,stringtoname("[deco_mutator]"));
}





function Tick (float DeltaTime)
{

    // fast search to speed past non spawns
    if(godoit)
	{
	async_resurect();// doin it twice to get 2 executions per tick
	async_resurect();
        // threads ++;
	}
}


// clear any saved data relating to this level.
// idealy , there would be arguments for date/object
// dates , classes or both
function clearsession()
{
if ( sn_list[momentholder].levelname == string(level.outer) )
						  {
						  // Array_Remove(sn_list,momentholder);
						  // momentholder --;
						  }
}



// basicly just setup the scene variables.
function setup_async()
{
//lockout = true;
arraysizeholder = Array_Size(sn_list);// todo: what if the array size changed while we are looping?
momentholder = 0;
SetTimer(0.05,false,'async_resurect'); //this is a one shot to start the loop
log( "------------------" ,stringtoname("[Async loading]"));
wetoldeveryone = false;
}


// this is steping tho the loop, while not being a loop.

function async_resurect()
{
local Actor A;
local mesh mm;
local class<Actor> aClass;
local class<mesh> amesh;

// every second we spawn another object
// incriment the array
 if ( sn_list[momentholder].levelname == string(level.outer) &&   sn_list[momentholder].levelname != "" &&  sn_list[momentholder].classi != "" && momentholder <  arraysizeholder)
						  {
						  // the array is relevent, and the next one is probably level relevent too.
						  speedygoat = false;       // slow search
						  godoit = false;           // super ticker disable
						  //log(TimeSeconds*1000);  // for performance debuging
						  reallicker ++;            // +1 found object

						   // Load it
						   aClass = class<Actor>(DynamicLoadObject(sn_list[momentholder].classi, class'Class'));
	                        //log("async reserect: " $ sn_list[momentholder].classi $  momentholder $ " of " $ arraysizeholder);
							if (spewdebug)
							{  if (pr != none )
							   {
							   pr.ClientMessage("async reserect: " $ sn_list[momentholder].classi $  momentholder $ " of " $ arraysizeholder);
							   }
							}

                             if (aClass.Default.bStatic )
	                         { // fake out that deco!
	                         //aClass.SetPropertyText("bstatic", "false");
	                         log("overiding static");
	                         consolecommand("set " $ sn_list[momentholder].classi $ " bstatic false");
	                         aClass = class<Actor>(DynamicLoadObject(sn_list[momentholder].classi, class'Class'));
                              //aClass = class<Actor>(DynamicLoadObject("unreali.dice", class'Class'));
                              // log("using fake deco acter");
                             }


                            if ( aClass != None )
		                    lockout = true;  // ignore notify



                            A = Spawn(aClass,none,'yey',sn_list[momentholder].loc, sn_list[momentholder].rot);
							if (a != none)
							{
                              a.SetRotation(sn_list[momentholder].rot);
							  a.SetLocation(sn_list[momentholder].loc);
							  sn_list[momentholder].aref= a;    // so we can update location

                              sn_list[momentholder].aref.SetRotation(sn_list[momentholder].rot);
							  sn_list[momentholder].aref.SetLocation(sn_list[momentholder].loc);

                             //handle instanthouse objects special.

                            //  if(a.IsA('dice'))
	                        //  {
	                       //  mm = DynamicLoadObject(string(sn_list[momentholder].meshy),class'mesh');
                             //class<mesh>(DynamicLoadObject(sn_list[momentholder].meshy, mesh'Mesh'));
                           // mm = mesh<mesh>(DynamicLoadObject(string(sn_list[momentholder].meshy), class'mesh'));
	                        //  log("dice reserect: with mesh : " $ string(sn_list[momentholder].meshy));
	                        //  a.mesh = sn_list[momentholder].meshy;
	                         // a.drawscale = sn_list[momentholder].ds;
	                         // a.SetRotation(sn_list[momentholder].rot);
							 // a.SetLocation(sn_list[momentholder].loc);
							  //a.SetCollisionSize(sn_list[momentholder].radi,sn_list[momentholder].loli);
	                        // }


                             if(a.IsA('HouseGenericDeco'))
	                         {

							  if (sn_list[momentholder].meshy != None)
							  {
							  a.mesh = sn_list[momentholder].meshy;
	                          a.drawscale = sn_list[momentholder].ds;
	                          a.SetCollisionSize(sn_list[momentholder].radi,sn_list[momentholder].loli);
							  log("async reserect: with mesh : " $ string(sn_list[momentholder].meshy));
							  }else{

							  // legacy remains.
							  Array_Remove(sn_list,momentholder);
						      momentholder --;
							  log("deleted legacy instanthouse entry." $ momentholder);

							  }

							  if (spewdebug)
							{  if (pr != None)
							   {
							   pr.ClientMessage("instantdeco with mesh : " $ string(sn_list[momentholder].meshy));
							   }
							}
	                          }


							a.bmovable= false;                     // for most objects.
							if (a.isa('book')){a.bmovable= true;}; // but not books.

							// mark the objects for cleanup later.
						    }   // none

                            if (a != none)
						    {
						     a.tag = 'yey';
						    }

							// start listing for new objects again.
							lockout = false;



						  }else{
						  // no match ...breakout.
						  // the array is NOT relevent. we arnt spawning , just searching tho.
						  speedygoat = true;// fast timer
						  godoit = true;    // dumb shit fast double ticker.
						  // long gaint arrays or 6000+ lines are probably in order on the level played.
						  // if your in a cluster of non matches , you cant look as fast as possible
						  // if you arent spawning objects.

						  }


    if (momentholder <  arraysizeholder)
       {
       momentholder ++;
	   // if we arnt spawning ,move thu the array much, much faster.

	   if (speedygoat)
	   {
	   //SetTimer(0.00000001,false,'async_resurect'); // not fast enought anymore
	   godoit = true;      //enable tick chaser
	   //async_resurect(); // called by tick

	  	// 2/15/22 bugfix  ?
	   if (pauserecall)
	       {
		   log ("async on hold.(goat)");
		   pp.ClientMessage(" paused at " $ sn_list[momentholder].classi $  momentholder $ " of " $ arraysizeholder);
		   lockout = false;
		   godoit = false;
		   return;

	       }else{
	       SetTimer(0.04,false,'async_resurect');
		   }



	   }else{

	       if (pauserecall)
	       {
		   log ("async on hold.(not goat)");
		   pp.ClientMessage(" paused at " $ sn_list[momentholder].classi $  momentholder $ " of " $ arraysizeholder);
		   lockout = false;
		   godoit = false;
		   return;

	       }else{
	       SetTimer(0.04,false,'async_resurect');
		   }
	   }

	   lockout = false;
       }else{
	   godoit = false;

       // this gets spamed up to 3 times if each "thread" is done!
       // need some clever work around.

       if (!wetoldeveryone)
       {
       log ("async reload done respawned " $  reallicker $ " objects" );
       log( "------------------" ,stringtoname("[Async loading]"));
       wetoldeveryone = true;
       }

       }
	lockout = false;
}



function AddGameRules()
{
	local deco_tracker_GR gr;

	gr = Spawn(class'deco_tracker_GR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}

function Addtracker()
{
	local deco_tracker gr;

	gr = Spawn(class'deco_tracker');
	gr.MutatorPtr = self;


}

function scorepawnKill( Pawn Killer, Pawn Other )
{
// dont care
}


function bool handleChat( PlayerPawn Chatting, out string Msg )
{

   if (msg == "/help")
   {
   chatting.ClientMessage("[deco_mutator]  Persistant decoration  build 2022.8.3 '/decosaver help'");
   return true;
   }

   if (msg == "/decosaver help")
   {
      if(chatting.badmin)
      {
      chatting.ClientMessage("[deco_mutator]  'hagain' - trigger async, 'decorecallstatus' deco state, 'decorecallpause' ,'updatedeco' - test force update loc , 'ownalldeco' - become the debugger");
      return false;
      }else{
      chatting.ClientMessage("[deco_mutator]  'decorecallstatus' - list deco loading info");
      return false;
      }


   }


   if (msg == "/hagain")
   {
   pp = chatting;
   setup_async();


   }

   if (msg == "/decoaim")
   {
    pp = chatting;
   traceaim();
   // set a array index to start at.
   // fe at map start for performance or to ast spawn clusters of idexed objects.
   }

   if (msg == "/decosetend")
   {
   // set a array index to end at.
   // fe at map start for performance or to ast spawn clusters of idexed objects.
   }



   if (msg == "/decorecallstatus")
   {
   pp = chatting;
   pp.ClientMessage("fast seeking =" $ speedygoat);

   //if (momentholder <  arraysizeholder)

   if (pauserecall)
         {
         // already paused
          pp.ClientMessage(" paused at" $ sn_list[momentholder].classi $  momentholder $ " of " $ arraysizeholder);

         }else{
		 pp.ClientMessage("current:" $ sn_list[momentholder].classi $  momentholder $ " of " $ arraysizeholder);

		}
   }

   if (msg == "/decorecallpause")
   {
   pp = chatting;
   //  set a pause bool to hold off respawning
      if (pauserecall)
         {
         // already paused
          pp.ClientMessage(" resuming recall from" $ sn_list[momentholder].classi $  momentholder $ " of " $ arraysizeholder);
		  SetTimer(0.04,false,'async_resurect');
		  pauserecall = false;
		  return true; // break out the iff before we shift again
         }else{
		 // notpause yet.
		 pauserecall = true;
		 pp.ClientMessage(" pausing recall");
		 godoit = false; // pasue tick calling increment. // 2/15/22
		 return true; // break out the iff before we shift again

		}


   }


   if (msg == "/decorecallstep")
   {
   // step tho one object
   }


   if (msg == "/updatedeco")
   {
   pp = chatting;
   inserect();


   }

   if (msg == "/ownalldeco")
   {
   pr = chatting;
   spewdebug = true;
   }

   if (msg == "/deletesession")
   {
   // wipe out setting for this map
   // delte anything wit yey


   }


return true;// pass it on
}


function waitingclass()
{
//aawait
log(aawait.mesh);
addpawn(string(aawait.class),aawait,aawait.name);

}



function receivenotify( actor A )
{

                // instanhousr stuff
                // A.DrawScale = GenericDecoClass.Default.DrawScale;
				// A.Mesh = GenericDecoClass.Default.Mesh;
				// A.SetCollisionSize(GenericDecoClass.Default.CollisionRadius,GenericDecoClass.Default.CollisionHeight);
				// HouseGenericDeco(A).GenericParentClass = GenericDecoClass;

if (lockout)
	{

        // log( A.name $ " was disgarded in lockout state." ,stringtoname("[deco_mutator]"));
	return;
	}

if(a.IsA('Drip'))
{
// wtf3 , + no reason for saving
return;
}


if(a.IsA('HouseGenericDeco'))
	{
	//log(" with deco mesh: " $ a.GetPropertyText("genericdecoclass mesh"));
	//log(a.mesh);
	aawait = a;
	SetTimer(0.01,false,'waitingclass');


	}


if(a.IsA('HouseGenericDeco'))
{
// break here
// handle it elsewhere!
return;
}


//log( A.name ,stringtoname("[deco_mutator]"));
if(a.IsA('decoration'))
	{
	if (a.tag == 'yey')
	{
	return;
	}


	if(a.IsA('CreatureCarcass') || a.IsA('DoomCarcass') || a.IsA('snakecarcass'))
	{
	return;
	}





	//log("notify " $ a.class);
    //addpawn(string(a.class),a,a.name);
	 	aawait = a;
	SetTimer(0.01,false,'waitingclass');
    }


}


function addpawn(string class,actor a,name cmdstr)
{
    local int I;

	// dont re-add shit we already added.
	if (a.tag == 'yey')
	{
	return;
	}

	if (a.isa('CreatureChunks'))
	{
	return;
	}

	if (a == none)
	{
	return;
	}


	// we should check raduis for closest player.
	// they would be the owner




	i = Array_Size(sn_list);
	Array_Insert(sn_list,Array_Size(sn_list),1);
	sn_list[i].classi=class;
    sn_list[i].name=a.name;
	sn_list[i].rot = a.rotation;
	sn_list[i].loc = a.location;
	sn_list[i].levelname = string(level.outer);
	sn_list[i].ds = a.drawscale;
	sn_list[i].radi = a.CollisionRadius;
	sn_list[i].loli = a.CollisionHeight;
    sn_list[i].aref = a;
    sn_list[i].meshy = a.mesh;

	if(a.IsA('HouseGenericDeco'))
	{
	sn_list[i].meshy = a.mesh;
	sn_list[i].ds = a.drawscale;
	sn_list[i].radi = a.CollisionRadius;
	sn_list[i].loli = a.CollisionHeight;
	}



	//log("add " $class $ " slot" $ i );

	// flag  respawned pawns
	if (a.tag == 'yey')
		{
		 //log("yey "$ " slot" $ i );
		 sn_list[i].respawnedpawn = true;
        }

		if (a.isa('decoration') && !a.isa('CreatureChunk'))
		{
		sn_list[i].gone = true;
        //log("flagged gone " $class $ " slot" $ i );
		}

saveconfig();
}




function reserect ()
{
local int i,io;
local Actor A;
local class<Actor> aClass;
io = 0;
lockout = true;
//log(" size " $ Array_Size(sn_list));
 For( i = 0; i <  Array_Size(sn_list) ; i++  )
    {
	//log("outer" $ sn_list[i].classi);
	                      if (sn_list[i].levelname == string(level.outer) &&  sn_list[i].levelname != "" && sn_list[i].classi != "")
						  {
						    aClass = class<Actor>(DynamicLoadObject(sn_list[i].classi, class'Class'));

						    if ( aClass != None )
	    log("reserect: " $ sn_list[i].classi);
        if (aClass.Default.bStatic )
	    {
	     aClass = class<Actor>(DynamicLoadObject("unrealshare.dice", class'Class'));
	    }
		                    A = Spawn(aClass,none,'yey',sn_list[i].loc, sn_list[i].rot);
							a.mesh = sn_list[i].meshy;
                            a.SetRotation(sn_list[i].rot);
							a.SetLocation(sn_list[i].loc);
							a.drawscale =  sn_list[i].ds;
							a.bmovable= false;
						    if (a != none)
						    {

							 if(a.IsA('HouseGenericDeco'))
	                          {
	                          a.mesh = sn_list[i].meshy;
	                          a.drawscale =  sn_list[i].ds;
							  sn_list[i].radi = a.CollisionRadius;
	                          sn_list[i].loli = a.CollisionHeight;
	                          }



							 a.tag = 'yey';
						     io ++;

						  }
						  // remebmer respawned actors , outside of the saved listen
						  // otherwise it will double each time

						  // we check at notify but whoknows

						  sn_list[i].respawnedpawn=  true;


						  }







    }

log(" ye ye ");
lockout = false;
}





// update any decoration locations
function INserect ()
{
local int i,io;
local Actor A;
local class<Actor> aClass;
io = 0;
 //log("attempt" $ sn_list[i].aref.name );

 For( i = 0; i <  Array_Size(sn_list) ; i++  )
    {

                       if(sn_list[i].levelname == string(level.outer) &&  sn_list[i].levelname != "")
                       {
                         // if in this level
                         //log(" inlevel");
                          if (sn_list[i].aref != none )
						  {
						  // log(" inlevel , aref ok");
						    // log("checking vector" $ sn_list[i].aref.name );

                            // basicly just check vector compare
                            if (sn_list[i].rot != sn_list[i].aref.rotation || sn_list[i].loc != sn_list[i].aref.location)
							{
							 // copy from aref  to config array.
						     sn_list[i].rot =   sn_list[i].aref.rotation;
	                         sn_list[i].loc =   sn_list[i].aref.location;
	                         sn_list[i].meshy = sn_list[i].aref.mesh; // this was swapped , and probablyunneccary anyway.
	                         sn_list[i].ds =    sn_list[i].aref.drawscale;
							 sn_list[i].radi =  sn_list[i].aref.CollisionRadius;
	                         sn_list[i].loli =  sn_list[i].aref.CollisionHeight;

	                         // mesh may not be super relevent to log but w/e
							 log("Updated decoration data of " $ sn_list[i].aref.name $ " With  mesh " $ string(Sn_list[i].meshy));

							 // We Will log to a single player if they want to hear it.
                             if (spewdebug)
							 {
                               if (pr != none )
							   {
							   pr.ClientMessage("Updated decoration data of " $ sn_list[i].aref.name);
							   }
							 }
							}
                           log("item but no changed location" $ sn_list[i].aref.location);
						  } else{

						  // its in this level, but itis none?
						  log(" already destroyed ?");

						  }
                        }
    }

}



function  gofuckyourwife ()
{
log( "Game ended , updating decorations" ,stringtoname("[deco_mutator]"));
saveconfig();
INserect();
}



 function traceaim()
{  // trace to you crosshair, save the reference for editing
 local actor j;
 j = TracePlayerAim(pp,true);
 if (j != none)
	{
     pp.ClientMessage("deco bound:" $ string(j.class) $ " " $ j.name$ "  tag:" $ j.tag);
     matchactor(j);
     // dump int values (limited) toplayer
    // dumpprops(j.class);
	}else{
	pp.ClientMessage("Invalid target");
	}

}


function int getplayeridfromp( playerpawn p)
{

 local PlayerReplicationInfo PRI;
 PRI=p.PlayerReplicationInfo;
 return pri.Playerid;

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


function  matchactor( actor aa)
{
local int i;
 For( i = 0; i <  Array_Size(sn_list) ; i++  )
    {

                       if(sn_list[i].levelname == string(level.outer) &&  sn_list[i].levelname != "")
                       {
                         // if in this level
                         //log(" inlevel");
                          if (aa != none )
						  {

                            if (sn_list[i].rot == aa.rotation && sn_list[i].loc == aa.location)
							{
							log( " some match ");
							sn_list[i].aref.destroy();
							Array_Remove(sn_list,i);
							aa.destroy();
							}
						  }
					}
     }
}

defaultproperties
{

}
