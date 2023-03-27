class loginleaf extends logindSSFTemplate;

var databaseinterationclass dbobject;


function server_beginplay(playerpawn pp,managerclient mc_instance,string  validateduser )
{
 

}

function morph(playerpawn pp,string  morphcommand )
{

}


function createlogin(playerpawn pp,managerclient mc_instance,string  createloginstring )
{


local essentials ess;

       foreach AllActors(class'essentials',ess)
       { // let this nightmare begin!
	   ess.createaccount(pp,createloginstring);
	   }



}









function server_plogin(playerpawn p,managerclient mc_instance, string user)
{ // passed to server side functions.!
local essentials ess;

       foreach AllActors(class'essentials',ess)
       { // let this nightmare begin!
	   ess.accountlogin(p,user);
	   } 
}


function int getplayeridfromp( playerpawn p)
{

 local PlayerReplicationInfo PRI;
 PRI=p.PlayerReplicationInfo;
 return pri.Playerid;

}

defaultproperties
{
}
