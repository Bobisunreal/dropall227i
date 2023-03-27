class giveitems expands Mutator
	config(dropall227);

	

	
struct Items
{
var( )config string ItemClass;	var() config string Charge;
};

var config Items Item[25];

struct AdminItems
{
var() config string ItemClass;	 var() config string Charge;
};

var config AdminItems AdminItem[10];


function MutateRespawningPlayer( Pawn Spawner )
{
kpGiveItems(Spawner);
}

function PostBeginPlay()
{
	AddGameRules();
	SaveConfig();
}


function AddGameRules()
{
	
local giveitemsGR gr;	
	gr = Spawn(class'giveitemsGR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}




function kpGiveItems(pawn P)
{
	local int I;
    local class<inventory> ItemClass;
	   
	

	
	
	
	
	
	if(P == None)
		return;

	if(ArrayCount(Item) > 0)
	{
		for(I = 0; I < ArrayCount(Item); I ++)
		{
		
		
			

			if(Item[I].ItemClass == "")
				break;
				
				
	             
			
			 if ( InStr(caps(Item[I].ItemClass),caps("/"))== -1 )
                {
				
				    ItemClass = class<inventory>(DynamicLoadObject(Item[I].ItemClass, class'Class'));
	
	                    if (ItemClass == none) // error checking and script error prevention
                       {
                            // fail to load. assume broken or misspeled !
                            log("Giveitem List (givezsp) Error : Item At Slot "$i$" - "$Item[I].ItemClass$" Failed To Load , Entry Disabled");
                            Item[I].ItemClass = "/DLC_Fail/"$Item[I].ItemClass;
							 saveconfig();
		                }
				
				
				
				 bGiveItem(P, Item[I].ItemClass, Item[I].Charge);
				// log("***** " @ Item[I].ItemClass @ " *****");
				 
				}else{
				//log(Item[I].ItemClass $ "skipped - disabled class");
				
				}
                
		}
	}

	if(PlayerPawn(P) != None && PlayerPawn(P).bAdmin)
	{
		if(ArrayCount(AdminItem) > 0)
		{
			for(I = 0; I < ArrayCount(AdminItem); I ++)
			{
				

				if(AdminItem[I].ItemClass == "")
					break;
					
					
				 

				 if ( InStr(caps(AdminItem[I].ItemClass),caps("/"))== -1 )
                {	
				bGiveItem(P, AdminItem[I].ItemClass, AdminItem[I].Charge);
				//log("***** " @ AdminItem[I].ItemClass @ " *****");
				
				 ItemClass = class<inventory>(DynamicLoadObject(AdminItem[I].ItemClass, class'Class'));
	
	                    if (ItemClass == none) // error checking and script error prevention
                       {
                            // fail to load. assume broken or misspeled !
                            log("Giveitem List  Error : Item At Slot "$i$" - "$AdminItem[I].ItemClass$" Failed To Load , Entry Disabled");
                            AdminItem[I].ItemClass = "/DLC_Fail/"$AdminItem[I].ItemClass;
							 saveconfig();
		                }	
				}else{
				//log( AdminItem[I].ItemClass $ "skipped - disabled class");
				
				}
				
				
				
				
				
			}
		}
	}
	
 }
 
 


function bGiveItem(pawn P, string aClassName, string Charge)
{
	local class<inventory> ItemClass;

	local inventory NewItem;
	local Inventory Inv;

	if(P == None)
		return;

	log(aclassname $ "  " $ charge);	
	ItemClass = class<inventory>(DynamicLoadObject(aClassName, class'Class'));
	
	
	

	// Check if player already has this item.
	for(Inv = P.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		if(Inv.Class == ItemClass)
		{
			if(Inv.IsA('Weapon'))
			{
			 log("have ,isweapon");	
				if(Charge != "")
				{
					//if(Weapon(Inv).AmmoType.AmmoAmount < int(Charge))
					//	Weapon(Inv).AmmoType.AddAmmo(int(Charge));
					   log("have " $ Weapon(inv).pickupammocount);	
					Weapon(inv).pickupammocount=int(charge);
				}
			}

			else if(Inv.IsA('Pickup'))
			{
				if(Charge != "")
				{
					if(Pickup(Inv).bCanHaveMultipleCopies)
						Pickup(Inv).NumCopies = int(Charge);

					else Pickup(Inv).Charge = int(Charge);
				}

				else
				{
					if(Pickup(Inv).bCanHaveMultipleCopies)
						Pickup(Inv).NumCopies = Pickup(Inv).default.NumCopies;

					else Pickup(Inv).Charge = Pickup(Inv).default.Charge;
				}
			}

			return;
		}
	}

	log("***** Giving Player" @ aClassName @ "with charge"@ Charge @ " *****");

	NewItem = spawn(ItemClass);

	if(NewItem == None)
		return;

	NewItem.RespawnTime = 0.0;
	NewItem.AmbientGlow = 0.0;

	if(NewItem.IsA('Weapon'))
	{
		if(P.IsA('PlayerPawn'))
		{
			if(Weapon(NewItem).AmmoName != None)
			{
			log("donehave , ammo notnone");
			    Weapon(newitem).pickupammocount=int(charge);
				Weapon(NewItem).GiveAmmo(PlayerPawn(P));
				log("donehave ," $ Weapon(newitem).pickupammocount);
				
                
				if(Charge != "")
				{
					//if(Weapon(NewItem).AmmoType.AmmoAmount < int(Charge))
//					//	Weapon(NewItem).AmmoType.AddAmmo(int(Charge));
					//	Weapon(NewItem).AmmoType.AmmoAmount = int(Charge);
				}
			}


			Weapon(NewItem).GiveTo(PlayerPawn(P));
			Weapon(NewItem).bHeldItem = true;
			Weapon(NewItem).SetSwitchPriority(PlayerPawn(P));
			Weapon(NewItem).WeaponSet(P);
			Weapon(NewItem).SetHand(PlayerPawn(P).Handedness);

			PlayerPawn(P).Weapon.GotoState('DownWeapon');
			PlayerPawn(P).PendingWeapon = None;
			PlayerPawn(P).Weapon = Weapon(NewItem);
		}
	}

	else if(NewItem.IsA('Pickup'))
	{
		if(Charge != "")
		{
			if(Pickup(NewItem).bCanHaveMultipleCopies)
				Pickup(NewItem).NumCopies = int(Charge);

			else Pickup(NewItem).Charge = int(Charge);
		}

		else
		{
			if(Pickup(NewItem).bCanHaveMultipleCopies)
				Pickup(NewItem).NumCopies = Pickup(NewItem).default.NumCopies;

			else Pickup(NewItem).Charge = Pickup(NewItem).default.Charge;
		}

		NewItem.GiveTo(P);
		NewItem.bHeldItem = true;
		PlayerPawn(P).SelectedItem = NewItem;
		Pickup(NewItem).PickupFunction(P);

		if(P.IsA('ScriptedPawn'))
			NewItem.Activate();
	}

	PlayerPawn(P).Health = 199;
  }



defaultproperties
{
}
