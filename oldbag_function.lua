--/run mEcho(GetExtraActionInfo(1));
-- set3

WAITING_TIME_AFTER_CAST = 200;
SKILL_CD_TSH_START = 0.3;
SKILL_CD_TSH_END = 2;
SKILL_PREFIX = "interface/icons/skill_";
A_BOAT_IN_THE_OCEAN = SKILL_PREFIX.."run72-1.dds";

SET0_BUFF = "Specialized Area";
SET0_BASIC_INVISIBILITY = SKILL_PREFIX.."thi12-2.dds"; 
SET0_INTERFERENCE_CIRCLE = SKILL_PREFIX.."ran54-1.dds";
SET0_MAGIC_CHARGE = SKILL_PREFIX.."aug6-1.dds";

SET1_BUFF = "Inappropriate Discipline";
SET1_TASK = SKILL_PREFIX.."thi27-2.dds";
SET1_EXCUSE = SKILL_PREFIX.."war_berserk.dds";

SET2_BUFF = "Find out the Master Plan";
SET2_PROBE = SKILL_PREFIX.."mag24-2.dds";
SET2_HINT = SKILL_PREFIX.."dru9-2.dds";

SET3_BUFF = "Well-Intentioned Lie";
SET3_TELL = "interface/icons/story_11.dds";
SET3_EMBELLISH = SKILL_PREFIX.."war39-2.dds";
SET3_PRETEND = SKILL_PREFIX.."thi3-2.dds";

SET4_BUFF = "The Last Resort";
SET4_BLOW = "interface/icons/wp_club06_060_003.dds";
SET4_NERVER = SKILL_PREFIX.."ran72-1.dds";

SET5_BUFF = "Deliberate Troublemaking";
SET5_LOOK = SKILL_PREFIX.."mag9-2.dds";
SET5_FAR = SKILL_PREFIX.."thi54-1.dds";
SET5_HOWL = SKILL_PREFIX.."kni9-1.dds";

SET6_BUFF = "Living Experiment";
SET6_COVERT = SKILL_PREFIX.."thi12-1.dds";
SET6_CONFIDENT = SKILL_PREFIX.."kni72-1.dds";
SET6_CATCH = SKILL_PREFIX.."buff05.dds";

SET7_BUFF = "Like Chopping Wood";
SET7_BLIND = SKILL_PREFIX.."thi9-1.dds";
SET7_VANISH = SKILL_PREFIX.."war15-2.dds";


BUFF_LIST = {};
BUFF_LIST_SIZE = 8;
BUFF_LIST[0] = SET0_BUFF;
BUFF_LIST[1] = SET1_BUFF;
BUFF_LIST[2] = SET2_BUFF;
BUFF_LIST[3] = SET3_BUFF;
BUFF_LIST[4] = SET4_BUFF;
BUFF_LIST[5] = SET5_BUFF;
BUFF_LIST[6] = SET6_BUFF;
BUFF_LIST[7] = SET7_BUFF;
-- done --
function getQuestState()
  local queststate = getQuestStatus("Strongholds, Morale and Rumors");
	return queststate;
end
-- done --
function getQuestSetNumber()
	local buffnum=1;
	local buff=RoMScript("UnitBuff('player',"..buffnum..")");
	while buff ~= nil do
        for i = 0, BUFF_LIST_SIZE, 1 do
			if buff == BUFF_LIST[i] then
				cprintf(cli.yellow,"Now we're doing "..BUFF_LIST[i].." quest \n");
				return i;
			end
		end			
		
        buffnum=buffnum+1
        buff=RoMScript("UnitBuff('player',"..buffnum..")");
    end
	return -1;
end
-- done --
function castExtraSpell(info)
	for i = 1, 10, 1 do
		local cinfo = RoMScript("GetExtraActionInfo("..i..");");
		if cinfo == info then
			sendMacro("UseExtraAction("..i..")");
			break;
		end
	end			
end
-- done --
function getExtraSpellCooldown(info)
	for i = 1, 10, 1 do
		local cinfo = RoMScript("GetExtraActionInfo("..i..");");
		if cinfo == info then
			local cduration, cremain = RoMScript("GetExtraActionCooldown("..i..");");
			return cremain;
		end
	end	
	return -1;
end
-- done --
function isExistedNPC(npcname,range)
	if(range==nil) then
		range = 50;
	end
	local objectList = CObjectList();
	objectList:update();
	for i = 0,objectList:size() do
		local obj = objectList:getObject(i);
		if obj.Name == npcname and range >= distance(player.X,player.Z,player.Y,obj.X,obj.Z,obj.Y) then
			return true;
		end
	end
	return false;
end
-- done --
function getPlayerRemainingCastingTime()
	local name, maxValue, currValue = RoMScript("UnitCastingTime(\"player\");");
	return currValue;
end

function Six_selectNoneBuffVillager()
	local range = 50;
	local npcname = "Villager"
	local objectList = CObjectList();
	objectList:update();
	for i = 0,objectList:size() do
		local obj = objectList:getObject(i);
		if obj.Name == npcname and range >= distance(player.X,player.Z,player.Y,obj.X,obj.Z,obj.Y) then
			--cprintf(cli.yellow,"Obj Address = "..obj.Address.." \n");
			local vil = CPawn(obj.Address);
			local bool = vil:hasBuff("Transportation Mark");
			
			if not bool then
				return vil;
			end
			
			
			--[[
			if(not vil.hasBuff("Transportation Mark")) then
				return vil;
			end
			--]]
		end
	end
	return nil;
end

function DoSetZero()	
	cprintf(cli.yellow,"Start doing "..BUFF_LIST[0].." quest.\n");
	local cd_invis = 0;
	local cd_curcle = 0;
	local cd_charge = 0;
	local state = 2;
	local comboDone = true;
	player:clearTarget();
	while(true) do
		cd_invis = getExtraSpellCooldown(SET0_BASIC_INVISIBILITY);
		cd_curcle = getExtraSpellCooldown(SET0_INTERFERENCE_CIRCLE);
		cd_charge = getExtraSpellCooldown(SET0_MAGIC_CHARGE);	
		local targetAdventurer =  player:findNearestNameOrId("Adventurer");
		local targetpawn = CPawn(targetAdventurer.Address);
		local currValue = getPlayerRemainingCastingTime();
		if (isExistedNPC("Adventurer",50)) then
			-- find state
			player:update();
			if(comboDone) then
				while(cd_invis>=1 or currValue>=1) do
					yrest(50);
					cd_invis = getExtraSpellCooldown(SET0_BASIC_INVISIBILITY);
					currValue = getPlayerRemainingCastingTime();
				end
				state = 0;	
			elseif(player:hasBuff("Basic Invisibility") and not comboDone) then
				state = -1
				while(cd_charge>=1 and cd_curcle>=1 ) do
					yrest(50);
					cd_curcle = getExtraSpellCooldown(SET0_INTERFERENCE_CIRCLE);
					cd_charge = getExtraSpellCooldown(SET0_MAGIC_CHARGE);	
				end
				if(cd_charge<1) then
					state = 1;
				elseif(cd_curcle<1) then
					state = 2;
				end
			else
				comboDone = true;
				state = 0;		
			end
			
			-- process state
			if (state==0) then
				cprintf(cli.yellow,"Casting invisible.\n");
				player:target(targetpawn);		
				castExtraSpell(SET0_BASIC_INVISIBILITY);	
				comboDone = false;			
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state==1) then			
				cprintf(cli.yellow,"Casting charge.\n");
				player:target(targetpawn);				
				castExtraSpell(SET0_MAGIC_CHARGE);	
				comboDone = false;	
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state==2) then
				cprintf(cli.yellow,"Casting curcle.\n");
				player:target(targetpawn);
				castExtraSpell(SET0_INTERFERENCE_CIRCLE);
				comboDone = true;
				yrest(WAITING_TIME_AFTER_CAST);
			else
				yrest(100);
				cprintf(cli.yellow,"Waiting for cooldown.\n");
			end
			
			
			
		else
			cprintf(cli.yellow,"Waiting for Adventurer. \n");
			yrest(500);
		end	
		
		if(getQuestState()=="complete") then
			break;
		end
	end
	yrest(500);
end

function DoSetOne()
	cprintf(cli.yellow,"Start doing "..BUFF_LIST[1].." quest.\n");
	local cd_task = 0;
	local cd_excuse = 0;
	local state = 0;
	player:clearTarget();
	while(true) do
		cd_task = getExtraSpellCooldown(SET1_TASK);
		cd_excuse = getExtraSpellCooldown(SET1_EXCUSE);	
		
		if (isExistedNPC("Adventurer")) then
			local targetAdventurer =  player:findNearestNameOrId("Adventurer");
			local targetpawn = CPawn(targetAdventurer.Address);
			while(cd_task>=1 or cd_excuse>=1) do
				yrest(50);
				cd_task = getExtraSpellCooldown(SET1_TASK);
				cd_excuse = getExtraSpellCooldown(SET1_EXCUSE);
			end
			if (cd_task<1 and cd_excuse<1) then
				if(targetpawn:hasBuff("Disregard Orders")) then
					cprintf(cli.yellow,"Buff #Disregard Orders# does exist,, cast excuse \n");
					player:target(targetpawn);
					castExtraSpell(SET1_EXCUSE);
					yrest(WAITING_TIME_AFTER_CAST);
				else
					cprintf(cli.yellow,"Buff #Disregard Orders# does not exist,, cast task \n");
					player:target(targetpawn);
					castExtraSpell(SET1_TASK);
					yrest(WAITING_TIME_AFTER_CAST);
				end
			else
				cprintf(cli.yellow,"Waiting for skill cooldown. \n");
				yrest(100);
			end
			
		else
			cprintf(cli.yellow,"Waiting for Adventurer. \n");
			yrest(2000);
		end	
		
		if(getQuestState()=="complete") then
			break;
		end
	end
	yrest(500);
end

function DoSetTwo()
	cprintf(cli.yellow,"Start doing "..BUFF_LIST[2].." quest.\n");
	local cd_one = 0;
	local cd_two = 0;
	local state = 0;
	player:clearTarget();
	while(true) do
		cd_one = getExtraSpellCooldown(SET2_PROBE);
		cd_two = getExtraSpellCooldown(SET2_HINT);	
		
		if (isExistedNPC("Villager")) then
			local targetAdventurer =  player:findNearestNameOrId("Villager");
			local targetpawn = CPawn(targetAdventurer.Address);
			local curr = getPlayerRemainingCastingTime();
			while((cd_one>=1 and cd_two>=1) or curr>=1) do
				yrest(50);
				cd_one = getExtraSpellCooldown(SET2_PROBE);
				cd_two = getExtraSpellCooldown(SET2_HINT);	
				curr = getPlayerRemainingCastingTime();
			end
			if (cd_one<1 or cd_two<1) then
				if(cd_one<1) then
					cprintf(cli.yellow,"Cast probe \n");
					player:target(targetpawn);
					castExtraSpell(SET2_PROBE);
					yrest(WAITING_TIME_AFTER_CAST);
				elseif(cd_two<1) then
					cprintf(cli.yellow,"Cast hint \n");
					player:target(targetpawn);
					castExtraSpell(SET2_HINT);
					yrest(WAITING_TIME_AFTER_CAST);
				end
			else
				cprintf(cli.yellow,"Waiting for skill cooldown. \n");
				yrest(500);
			end
			
		else
			cprintf(cli.yellow,"Waiting for Villager. \n");
			yrest(2000);
		end	
		
		if(getQuestState()=="complete") then
			break;
		end
	end
	yrest(500);
end

function DoSetThree()
	cprintf(cli.yellow,"Start doing "..BUFF_LIST[3].." quest.\n");
	local cd_one = 0;
	local cd_two = 0;
	local cd_three = 0;
	local state = 0;
	--Suspicious
	--Don't Trust
	player:clearTarget();
	while(true) do
		cd_one = getExtraSpellCooldown(SET3_TELL);
		cd_two = getExtraSpellCooldown(SET3_EMBELLISH);	
		cd_three = getExtraSpellCooldown(SET3_PRETEND);
		
		if (isExistedNPC("Adventurer")) then
			local targetAdventurer =  player:findNearestNameOrId("Adventurer");
			local targetpawn = CPawn(targetAdventurer.Address);
			
			---find state
			if(targetpawn:hasBuff("Don't Trust")) then
				state = 2;
				while(cd_three>=1) do
					yrest(50);
					cd_three = getExtraSpellCooldown(SET3_PRETEND);
				end
			elseif(targetpawn:hasBuff("Grow Suspicious")) then
				state = 1;
				while(cd_two>=1) do
					yrest(50);
					cd_two = getExtraSpellCooldown(SET3_EMBELLISH);
				end
			else
				state = 0;
				while(cd_one>=1) do
					yrest(50);
					cd_one = getExtraSpellCooldown(SET3_TELL);
				end
			end
			
			--process state
			if(state == 0) then
				cprintf(cli.yellow,"No Buff,, cast tell \n");
				player:target(targetpawn);
				castExtraSpell(SET3_TELL);
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state == 1) then
				cprintf(cli.yellow,"Suspicious Buff,, cast embellish \n");
				player:target(targetpawn);
				castExtraSpell(SET3_EMBELLISH);
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state == 2) then
				cprintf(cli.yellow,"Don't tell Buff,, cast pretend \n");
				player:target(targetpawn);
				castExtraSpell(SET3_PRETEND);
				yrest(WAITING_TIME_AFTER_CAST);
			else
				cprintf(cli.yellow,"Waiting for skill cooldown. \n");
				yrest(100);
			end
		else
			cprintf(cli.yellow,"Waiting for Adventurer. \n");
			yrest(2000);
		end	
		
		if(getQuestState()=="complete") then
			break;
		end
	end
	yrest(500);
end

function DoSetFour()
	cprintf(cli.yellow,"Start doing "..BUFF_LIST[4].." quest.\n");
	local cd_one = 0;
	local cd_two = 0;
	local cd_three = 0;
	local state = 0;
	--Staggering Blow
	player:clearTarget();
	while(true) do
		cd_one = getExtraSpellCooldown(SET4_BLOW);
		cd_two = getExtraSpellCooldown(SET4_NERVER);
		
		if (isExistedNPC("Adventurer",150)) then
			local targetAdventurer =  player:findNearestNameOrId("Adventurer");
			local targetpawn = CPawn(targetAdventurer.Address);
			
			---find state
			if(targetpawn:hasBuff("Staggering Blow")) then
				state = 1;
			else
				state = 0;
			end
			
			-- prepare state processing
			if(state==0) then
				if(cd_one >= SKILL_CD_TSH_START) then
					state = -1;
				end
				while (cd_one >= SKILL_CD_TSH_START and cd_one <= SKILL_CD_TSH_END) do
					state = 0;
					yrest(50);
					cd_one = getExtraSpellCooldown(SET4_BLOW);
				end
			elseif(state==1) then
				if(cd_two >= SKILL_CD_TSH_START) then
					state = -1;
				end
				while (cd_two >= SKILL_CD_TSH_START and cd_two <= SKILL_CD_TSH_END) do
					state = 1;
					yrest(50);
					cd_one = getExtraSpellCooldown(SET4_BLOW);
				end					
			end
			
			--process state
			if(state == 0) then
				cprintf(cli.yellow,"No Buff,, cast Blow \n");
				player:target(targetpawn);
				castExtraSpell(SET4_BLOW);
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state == 1) then
				cprintf(cli.yellow,"Staggering Buff,, cast never giveup \n");
				player:target(targetpawn);
				castExtraSpell(SET4_NERVER);
				yrest(4000);
			else
				cprintf(cli.yellow,"Waiting for skill cooldown. \n");
				yrest(100);
			end
		else
			cprintf(cli.yellow,"Waiting for Adventurer. \n");
			yrest(200);
		end	
		
		if(getQuestState()=="complete") then
			break;
		end
	end
	yrest(500);
end

function FiveMoveToRightPosition()
	local index = __WPL:findWaypointTag("right");
	local waypoint = __WPL.Waypoints[index];
	local dist = distance(waypoint.X, waypoint.Z, waypoint.Y, player.X, player.Z, player.Y);
	if(dist>5) then
		player:moveTo(waypoint);
	end
end
function DoSetFive()
	cprintf(cli.yellow,"Start doing "..BUFF_LIST[5].." quest.\n");
	local cd_one = 0;
	local cd_two = 0;
	local cd_three = 0;
	local state = 0;
	local count = 0;
	--Staggering Blow
	player:clearTarget();
	while(true) do
		FiveMoveToRightPosition();
		cd_one = getExtraSpellCooldown(SET5_LOOK);
		cd_two = getExtraSpellCooldown(SET5_FAR);
		cd_three = getExtraSpellCooldown(SET5_HOWL);
		if (isExistedNPC("Villager")) then
			local targetAdventurer =  player:findNearestNameOrId("Villager");
			local targetpawn = CPawn(targetAdventurer.Address);
			
			---find state
			if(player:hasBuff("Excessive")) then
				--Pondering Substitute
				local buff = targetpawn:getBuff("Pondering Substitute");
				if buff then
					if(buff.Level>=2) then
						state = 2;
					else
						state = 1;
					end
				else
					state = 1
				end				
			else
				state = 0;
			end
			
			-- prepare state processing
			if(state==0) then				
				if(cd_one>=SKILL_CD_TSH_START) then
					state = -1;
				end
				while(cd_one>=SKILL_CD_TSH_START and cd_one<= SKILL_CD_TSH_END) do
					state = 0;
					yrest(50);
					cd_one = getExtraSpellCooldown(SET5_LOOK);
				end
			elseif(state==1) then
				if(cd_two>=SKILL_CD_TSH_START) then
					state = -1;
				end
				while(cd_two>=SKILL_CD_TSH_START and cd_two<= SKILL_CD_TSH_END) do
					state = 1;
					yrest(50);
					cd_two = getExtraSpellCooldown(SET5_FAR);
				end
			elseif(state==2) then
				if(cd_three>=SKILL_CD_TSH_START) then
					state = -1;
				end
				while(cd_three>=SKILL_CD_TSH_START and cd_three<= SKILL_CD_TSH_END) do
					state = 2;
					yrest(50);
					cd_three = getExtraSpellCooldown(SET5_HOWL);
				end
			end
			
			--process state
			if(state == 0) then
				cprintf(cli.yellow,"No Buff,, cast Look \n");
				player:target(targetpawn);
				castExtraSpell(SET5_LOOK);
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state == 1) then
				cprintf(cli.yellow,"Not enough target buff, cast Far \n");
				player:target(targetpawn);
				--targetpawn:updateBuffs();
				--table.print(targetpawn.Buffs);
				castExtraSpell(SET5_FAR);
				local wx, wy, ww, wh = windowRect(getWin());
				detach();
				yrest(250);				
				mouseSet((wx+ww)/2, (wy+wh)*6/10);			
				attach(getWin()); 	
				yrest(1);
				sendMacro("SpellTargetUnit(\"player\");");	
				count = count+1;
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state == 2) then
				cprintf(cli.yellow,"Enough target buff, cast howl \n");
				player:target(targetpawn);
				castExtraSpell(SET5_HOWL);
				count = 0;
				yrest(WAITING_TIME_AFTER_CAST);
			else
				cprintf(cli.yellow,"Waiting for skill cooldown. \n");
				yrest(100);
			end
		else
			cprintf(cli.yellow,"Waiting for Villager. \n");
			yrest(500);
		end	
		
		if(getQuestState()=="complete") then
			break;
		end
	end
	yrest(500);
end

function DoSetSix()
	cprintf(cli.yellow,"Start doing "..BUFF_LIST[6].." quest.\n");
	local cd_one = 0;
	local cd_two = 0;
	local cd_three = 0;
	local state = 0;
	--Staggering Blow
	player:clearTarget();
	while(true) do
		cd_one = getExtraSpellCooldown(SET6_COVERT);
		cd_two = getExtraSpellCooldown(SET6_CONFIDENT);
		cd_three = getExtraSpellCooldown(SET6_CATCH);
		
		--find state
		if (isExistedNPC("Villager")) then
			--local targetAdventurer =  player:findNearestNameOrId("Villager");
			--local targetpawn = CPawn(targetAdventurer.Address);
			local targetAdventurer;
			local targetpawn;
			targetpawn = Six_selectNoneBuffVillager();
			
			if targetpawn then
				state = 0;
				while(cd_one>=0.5 and cd_one<=2) do
					yrest(50);
					cd_one = getExtraSpellCooldown(SET6_COVERT);
					--cprintf(cli.yellow,"Waiting. \n");
				end
			else
				if(isExistedNPC("Adventurer")) then
					targetAdventurer =  player:findNearestNameOrId("Adventurer");
					targetpawn = CPawn(targetAdventurer.Address);
					
					state = 1;
					while(cd_two>=0.5 and cd_two<=2) do
						yrest(50);
						cd_two = getExtraSpellCooldown(SET6_CONFIDENT);
						--cprintf(cli.yellow,"Waiting. \n");
					end
					
				else
					targetAdventurer =  player:findNearestNameOrId("Villager");
					targetpawn = CPawn(targetAdventurer.Address);
					
					if(cd_three<2) then
						state = 2;
						while(cd_three>=0.5 and cd_three<=2) do
							yrest(50);
							cd_three = getExtraSpellCooldown(SET6_CATCH);
							--cprintf(cli.yellow,"Waiting. \n");
						end
					else
						state = -1;
					end
				end
			end		
			
			--process state
			if(state == 0) then
				cprintf(cli.yellow,"Put a transport mark into villager \n");
				player:target(targetpawn);				
				castExtraSpell(SET6_COVERT);
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state == 1) then
				cprintf(cli.yellow,"Teleport all adventurer \n");
				player:target(targetpawn);				
				castExtraSpell(SET6_CONFIDENT);
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state == 2) then
				cprintf(cli.yellow,"Catch all villagers \n");
				player:target(targetpawn);
				castExtraSpell(SET6_CATCH);
				yrest(WAITING_TIME_AFTER_CAST);
			else
				cprintf(cli.yellow,"Waiting for skill cooldown. \n");
				yrest(200);
			end
		else
			cprintf(cli.yellow,"Waiting for Villager. \n");
			yrest(500);
		end	
		
		if(getQuestState()=="complete") then
			break;
		end
	end
	yrest(500);
end

function DoSetSeven()
	cprintf(cli.yellow,"Start doing "..BUFF_LIST[5].." quest.\n");
	local cd_one = 0;
	local cd_two = 0;
	local cd_three = 0;
	local state = 0;
	--Staggering Blow
	player:clearTarget();
	while(true) do
		cd_one = getExtraSpellCooldown(SET7_BLIND);
		cd_two = getExtraSpellCooldown(SET7_VANISH);
		local targetAdventurer;
		local targetpawn;
		---find state
		if (isExistedNPC("Villager")) then
			if not (isExistedNPC("Adventurer")) then
				targetAdventurer =  player:findNearestNameOrId("Villager");
				targetpawn = CPawn(targetAdventurer.Address);
				if(cd_two == 0) then
					state = 1;
				else
					state = -1;
				end
			else
				targetAdventurer =  player:findNearestNameOrId("Adventurer");
				targetpawn = CPawn(targetAdventurer.Address);	
				yrest(100);
				if(targetpawn:hasBuff("Blind")) then
					targetAdventurer =  player:findNearestNameOrId("Villager");
					targetpawn = CPawn(targetAdventurer.Address);
					
					
					if(cd_two<1) then
						state = 1;
					else	
						state = -1;
					end
					while(cd_two>=1 and cd_two<=2) do
						state = 1;
						yrest(50);
						cd_two = getExtraSpellCooldown(SET7_VANISH);
					end	
				else
					if(cd_one<1) then
						state = 0;
					else	
						state = -1;
					end
					while(cd_one>=1 and cd_one<=2) do
						state = 0;
						yrest(50);
						cd_one = getExtraSpellCooldown(SET7_BLIND);
					end	
				end
			end
		
			
			--process state
			if(state == 0) then
				cprintf(cli.yellow,"Blind the adventurer \n");
				player:target(targetpawn);
				castExtraSpell(SET7_BLIND);
				yrest(WAITING_TIME_AFTER_CAST);
			elseif(state == 1) then
				cprintf(cli.yellow,"Vanish Villager \n");
				player:target(targetpawn);
				castExtraSpell(SET7_VANISH);
				yrest(WAITING_TIME_AFTER_CAST);
			else
				cprintf(cli.yellow,"Waiting for skill cooldown. \n");
				yrest(100);
			end
		else
			cprintf(cli.yellow,"Waiting for Villager. \n");
			yrest(500);
		end	
		
		if(getQuestState()=="complete") then
			break;
		end
	end
	yrest(500);
end	
