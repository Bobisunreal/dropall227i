class massHost extends actor;

simulated function PostBeginPlay()
{

}

function SpawnMass(actor tempp, int TotalCount,string ClassName)
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
	
    //log ("my massorders: " $ totalcount $ "   " $  Classname); // ok
  
	if (instr(ClassName, " ") != -1)
	totalcount = int(right(instr(classname,inty),inty));// uh wtf still doesnt work
	//log("totalcount = "$totalcount); 

	//else
	//	holdName = ""$ClassName;  // barf //OMGWTF?!@$#!?@$

	spawnClass = class<actor>(DynamicLoadObject(classname, class'Class'));
	if (spawnClass == None)
	{
		//tempp.ClientMessage("Illegal actor name "$ClassName);
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

	//direction = tempp.ViewRotation;
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
		spawnee = spawn(SpawnClass,,,center+spawnPos, tempp.rotation);
		//log ("massxo: " $ "   " $ Classname);
		if (spawnee != None)
			count++;
		numTries++;
	}
	
	//log("masshost: " $ count$" actor(s) spawned");


}