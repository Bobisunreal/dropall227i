class mcoopGR expands GameRules;

var mcoop MutatorPtr;





function ModifyPlayerSpawnClass( string Options, out Class<PlayerPawn> AClass )
{
local string usedname;
 if(instr(options,"Name=gasbag?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.GasbagPL", class'Class'));
	usedname = "gasbag";
	}
	
	if(instr(options,"name=warlord?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.WarlordPL", class'Class'));
	usedname = "warlord";
	}
	
	if(instr(options,"name=bloblet?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.BlobletPL", class'Class'));
	usedname = "bloblet";
	}
	
	if(instr(options,"name=giantgasbag?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.GiantGasbagPL", class'Class'));
	usedname = "gaintgasbag";
	}
	
	if(instr(options,"name=Iceskaarj?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.IceSkaarjPL", class'Class'));
	usedname = "iceskaarj";
	}
	
	if(instr(options,"name=krallelite?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.KrallElitePL", class'Class'));
	usedname = "krallelite";
	}
	
	if(instr(options,"name=queen?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.QueenPL", class'Class'));
	usedname = "queen";
	}
	
	if(instr(options,"name=stonetitan?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.StoneTitanPL", class'Class'));
	usedname = "stonetitan";
	}
	
	if(instr(options,"name=titan?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.TitanPL", class'Class'));
    usedname = "titan";
	}
	
	if(instr(options,"name=warlord?")!=-1)	
	{
	AClass =  class<playerpawn>(DynamicLoadObject("jmdm.WarlordPL", class'Class'));
	usedname = "warlord";
	}
	
	
	// if usedname  = names in use  then options.name = usedname $ #++;
	// do some stuff here to allow for the fact that multiple players may use the same "name"
	
	
	
}

function bool AllowChat( PlayerPawn Chatting, out string Msg )
{
if (msg == "/help")
   {
   chatting.ClientMessage("[mcoop_mutator]  mplayers based on jmdm 2022.8.3 '/mcoop help' for more");
   // added help
   return true;
   }   

if (msg == "/mcoop help")
   {
   chatting.ClientMessage("[mcoop_mutator] join with  monster name,warlord,titan,stonetitan,queen,krallelite,gasbag,Iceskaarj,pupae to play as monster.");
   return false;
   }
return true;
}









defaultproperties
{
bNotifyLogin=True
bNotifyMessages=True
}






     
  
     
