class sn_mutator expands Mutator
 Config(dropall227);
 
var() config bool blogin,blogout;
 
 // so we listen for spawns,save them
 // then we listen for prevent dearh
 
 
 struct sn_note  {// 
    var() config actor            aref;        // actor ref
	//var() config instagator      rootaref;    // who killed me
	var() config string           classi;      // spawnclass
    var() config name             name;        // absolute name
	var() config bool             gone;        // deleted / none
	var() config vector           loc;         // spawn location
	var() config rotator          rot;         // rotation
	var() config int              leveltime;   // spawn time
	var() config int              deathtime;   // time of removal
	var() config bool             basepawn ;   // map original / vs spawned in
	var() config bool             respawnedpawn ;

                   };        
// save roation, location , class name to respawn later.
// save leveltime(seconds) to respawn  everyting in x time frame (ie 3 minutes ago to now , dead)
// also save  death time to do spam calulations for spawns
var()config array<sn_note>  sn_list;
var  int active,dead;
 
 
 
 
 
function BeginPlay()
{
	AddGameRules();
	Addtracker();
	log( "Loading Spawn controller  betav1" ,stringtoname("[sn_mutator]"));
	
}





function AddGameRules()
{
	local sn_tracker_GR gr;

	gr = Spawn(class'sn_tracker_GR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}

function Addtracker()
{
	local sn_tracker gr;

	gr = Spawn(class'sn_tracker');
	gr.MutatorPtr = self;

	
}

function scorepawnKill( Pawn Killer, Pawn Other )
{


//log(" pawn out:" $ string(other.name));
pawnbkilled (other);
//dosnt catch destroyed ie swarmhost dosnt call notify killed
}


function bool handleChat( PlayerPawn Chatting, out string Msg )
{
   if (msg == "hagain")
   {
   reserect ();


   }
   
   if (msg == "updatedeco")
   {
   inserect ();


   }
   

return true;// pass it on
}



function receivenotify( actor A )
{

                // instanhousr stuff
                // A.DrawScale = GenericDecoClass.Default.DrawScale;
				// A.Mesh = GenericDecoClass.Default.Mesh;
				// A.SetCollisionSize(GenericDecoClass.Default.CollisionRadius,GenericDecoClass.Default.CollisionHeight);
				// HouseGenericDeco(A).GenericParentClass = GenericDecoClass;




//log( A.name ,stringtoname("[sn_mutator]"));
if(a.IsA('scriptedpawn') || a.IsA('decoration'))
	{
			 if(a.IsA('swarmhost'))
			  {
			  log("ingoreing host");
			  // try to avoid this
			  }else{
			     
			  
			  addpawn(string(a.class),a,a.name);
			  }
		   // addpawn(string(a.class),a,a.name);
			log(" pawn in:" $ string(a.name) $ "  " $ a.owner);
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
	
	if (a.isa('JCZPawnGone') || a.isa('CreatureChunks'))
	{
	return;
	}
	
	
	
	
	i = Array_Size(sn_list);
	Array_Insert(sn_list,Array_Size(sn_list),1);
	sn_list[i].classi=class;
    sn_list[i].aref=a;
    sn_list[i].name=name;
	sn_list[i].rot = a.rotation;
	sn_list[i].loc = a.location;
	//sn_list[i].leveltime = TimeSeconds;
	
	// flag  respawned pawns
	if (a.tag == 'yey')
		{
		 sn_list[i].respawnedpawn = true;
        }
	    // hack to restore decorations
		// we can also hack the detroy call
		// by using a dropwhendestroyed item,
		// then getting owner, it may work.
		
		if (a.isa('decoration') && !a.isa('CreatureChunk'))
		{
		sn_list[i].gone = true;	 
        		
		}	
	
	
   

}


function pawnbkilled (actor a)
{
local int i;
dead = 0;
active = 0;

 For( i = 0; i <  Array_Size(sn_list) ; i++  )
    {
	                      if (sn_list[i].gone)
					      {
						  dead ++;
						  }else{
						  active ++;
						  if (sn_list[i].aref ==a)
					      {
                          sn_list[i].gone = true;
						  //sn_list[i].deathtime = TimeSeconds;
						  dead ++;
						  
						  //
						  if (a.tag == 'yey')
						  {
						  sn_list[i].respawnedpawn = true;
						  }
						  
						  
						  if (a.isa('decoration'))
						  {
						  //decoration(a).EffectWhenDestroyed =  
						  
						  }
						  
						  //saveconfig();
                          //log ("pawn out  line " $ i);
                          }
						  }
	
	
                          


    }

log ("active = " $ active $ "  dead =" $ dead);
}



function reserect ()
{
local int i,io;
local Actor A;
local class<Actor> aClass;
io = 0;

 For( i = 0; i <  Array_Size(sn_list) ; i++  )
    {
	                      if (sn_list[i].gone && sn_list[i].aref == none)
						  {
						    aClass = class<Actor>(DynamicLoadObject(sn_list[i].classi, class'Class'));
	                        log(sn_list[i].classi);
						    if ( aClass != None )
		                    A = Spawn(aClass,none,'yey',sn_list[i].loc, sn_list[i].rot);
							a.SetRotation(sn_list[i].rot);
							a.SetLocation(sn_list[i].loc);
						    if (a != none)
						    {
						     a.tag = 'yey';
						     io ++;
						 						  
						  }
						  // remebmer respawned actors , outside of the saved listen
						  // otherwise it will double each time
						  
						  // we check at notify but whoknows
  						 
						  sn_list[i].respawnedpawn=  true;
						    
						  
						  }
						  
						 
						 
	
                          


    }

log(" ye ye " $ io);
}





// update any decoration locations
function INserect ()
{
local int i,io;
local Actor A;
local class<Actor> aClass;
io = 0;

 For( i = 0; i <  Array_Size(sn_list) ; i++  )
    {
	                      if (sn_list[i].aref != none && sn_list[i].aref.isa('decoration'))
						  {
						   sn_list[i].rot = a.rotation;
	                       sn_list[i].loc = a.location;
		                    
						  }

    }

}




         

defaultproperties
{

}
