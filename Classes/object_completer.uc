class object_completer expands actor;
 
 
 // ----------------------------------------------------
 // usage - spawn this somhow and link it.
 // call function string returnmatchingfile(string objectname) to return the file a object is from.
 //
 // or
 // this.ExecFunctionStr(stringtoname("returnmatchingfileblind"),"objecttofind");
 // then read  
 // this.output_file or this.GetPropertyText("output_file"));

 
Struct actor_list{var() string objpack, objclass;};
var () array<actor_list> avalibleobjectsarray;
var () array<string> files_array;
var int current_block,total_block,files_total,classes_total;
var string output_file; // you can use getproperty/class.output_file to read this, without linking it.




function PostBeginPlay()
{
log("start obj");
buildsutolist();
}



function buildsutolist()   // build the files to a array.
{
local string hh;
LOCAL int filesread,tempkk;
foreach AllFiles( "u", "", hh )
	{
	    hh = ReplaceStr(hh, ".u", "");  hh = caps(hh);
	    
		if(IsInPackageMap(caps(hh)))
	    {
		     tempkk = Array_Size(files_array);
		     Array_Insert(files_array,Array_Size(files_array),1);
             files_array[tempkk]=caps(hh);
    		 filesread++;
        }
	}
    // the total packages avalible
	// log(filesread,'classscanner');
	
proccess_packages();	
}


function proccess_packages()
{
total_block = Array_Size(files_array);
current_block = 0;
SetTimer(0.1,false,'proccess_one_package');

}


function proccess_one_package()
{
  if (current_block < total_block ) // keep going
  {
    buildactortable(files_array[current_block]);
	//log("prosseccing " $ files_array[current_block]);
	current_block++;
    SetTimer(0.05,false,'proccess_one_package');
	
  }else{
    log("List build done " $ total_block $ " packages " $ Array_Size(avalibleobjectsarray) $ " classes",'completer');
	
  }

}



function buildactortable(string pack)
{
	local array<Object> ObjL;
	local int c,i,kk;
	local string classname;
	   if ( LoadPackageContents(pack,Class'class',ObjL) )
	   {
	     c = Array_Size(ObjL); 
	        for( i=0; i<c; ++i )
	        {
	         classname = string(ObjL[i]);
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
		    output_file =  avalibleobjectsarray[z].objpack;
            return avalibleobjectsarray[z].objpack;
           }
        
        }
// nothing matches anything we know.
output_file = "broken";
return "broken";// this shouldnt be possible ???

}


//blind return, from exectu function string
function  returnmatchingfileblind(string objectname)
{
local int z;
log("asking for " $ caps(objectname));
  For( z = 0; z < Array_Size(avalibleobjectsarray) ; z++ )
        {
           if (caps(avalibleobjectsarray[z].objclass) == caps(objectname))
           {
            output_file =  avalibleobjectsarray[z].objpack;
			return;
           }
        
        }
// nothing matches anything we know.
output_file = "broken";// this shouldnt be possible ???
return;

}
