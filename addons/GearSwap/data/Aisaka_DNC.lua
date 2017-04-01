-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[	Custom Features:

		Step Selector		Cycle through available primary and secondary step types,
							and trigger with a single macro
		Haste Detection		Detects current magic haste level and equips corresponding engaged set to
							optimize delay reduction (automatic)
		Haste Mode			Toggles between Haste II and Haste I recieved, used by Haste Detection [WinKey-H]
		Capacity Pts. Mode	Capacity Points Mode Toggle [WinKey-C]
		Reive Detection		Automatically equips Reive bonus gear
		Auto. Lockstyle		Automatically locks specified equipset on file load
--]]


-------------------------------------------------------------------------------------------------------------------

--[[
	Custom step commands:
	
	gs c step
		Uses the currently configured step on the target, with either <t> or <stnpc> depending on setting.

	gs c step t
		Uses the currently configured step on the target, but forces use of <t>.
	
	
	Configuration commands:
	
	gs c cycle mainstep
		Cycles through the available steps to use as the primary step when using one of the above commands.
		
	gs c cycle altstep
		Cycles through the available steps to use for alternating with the configured main step.
		
	gs c toggle usealtstep
		Toggles whether or not to use an alternate step.
		
	gs c toggle selectsteptarget
		Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step.
--]]


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

	state.MainStep = M{['description']='Main Step', 'Box Step', 'Feather Step', 'Quickstep', 'Stutter Step'}
	state.AltStep = M{['description']='Alt Step', 'Feather Step', 'Quickstep', 'Stutter Step', 'Box Step'}
--	state.UseAltStep = M(false, 'Use Alt Step')
--	state.SelectStepTarget = M(false, 'Select Step Target')
--	state.IgnoreTargetting = M(false, 'Ignore Targetting')

	state.ClosedPosition = M(false, 'Closed Position')

	state.HasteMode = M{['description']='Haste Mode', 'Haste I', 'Haste II'}
	
	state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}

	state.CP = M(false, "Capacity Points Mode")

	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'DT')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.IdleMode:options('Normal', 'DT')

	-- Additional local binds

	send_command('bind @h gs c cycle HasteMode')
	send_command('bind @c gs equip CP;gs c toggle CP')

	send_command('bind f9 gs c cycle OffenseMode')
	send_command('bind @[ gs c cycle MainStep')
	send_command('bind @] gs c cycle AltStep')

	send_command('bind ![ WildFlourish')
	send_command('bind !] BuildingFlourish')
	send_command('bind ^` CuringWaltzV stpc')
	send_command('bind !` ViolentFlourish')
	send_command('bind !- NoFootRise')
	send_command('bind !; ChocoboJigII')
	send_command('bind !backspace Presto')
	send_command('bind !delete SaberDance')
	send_command('bind !end FanDance')
	send_command('bind !insert cancel 410')
	send_command('bind !home cancel 411')
	send_command('bind !\' ClimacticFlourish')

	send_command('bind ^insert gs equip idle.Town;input /echo ===== Town Set =====')
	send_command('bind ^home gs equip engaged;input /echo ===== TP Set =====')
	
	select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
end


-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Start defining the sets
	--------------------------------------
	
	-- PRECAST SETS
	
	-- Enmity set
	sets.Enmity = {
		}

	-- Job Ability Sets

	sets.precast.JA['Provoke'] = sets.Enmity
	sets.precast.JA['No Foot Rise'] = {body="Horos Casaque"}
	--sets.precast.JA['Trance'] = {head="Horos Tiara +1"}
	  
	sets.precast.Waltz = {
		ammo="Light Sachet",
		
		head="Anwig Salade", --Delay -2
		ear1="Roundel Earring", --5
		
		body="Maxixi Casaque +1", --15 (Received 6)
		hands="Mummu Wrists +1",
		ring1="Valseur's Ring", --3
		
		back="Toetapper Mantle", --5
		legs="Espial Hose",
		feet="Maxixi Shoes", --10
		} -- Waltz Potency
		
	sets.precast.Waltz['Healing Waltz'] = {head="Anwig Salade"}
	sets.precast.Samba = {head="Maxixi Tiara +1", back="Senuna's Mantle"}
	sets.precast.Jig = {legs="Horos Tights", feet="Maxixi Shoes"}

	sets.precast.Step = {
		head="Mummu Bonnet",
		ear1="Ghillie Earring +1",
		
		body="Mummu Jacket",
		hands="Mummu Wrists +1",
		ring1="Valseur's Ring",
		ring2="Rajas Ring",

		back="Toetapper Mantle",
		waist="Anguinus Belt",
		legs="Mummu Kecks",
		feet="Horos Toe Shoes +1",
		}

	sets.precast.Step['Feather Step'] = set_combine(sets.precast.Step, {feet="Charis Shoes +2"})
	sets.precast.Flourish1 = {}
	sets.precast.Flourish1['Animated Flourish'] = sets.Enmity

	sets.precast.Flourish1['Violent Flourish'] = {
		neck="Atzintli Necklace",

		body="Horos Casaque",
		hands="Taeon Gloves",
		ring1="Fenrir Ring",
		ring2="Fenrir Ring",
		} -- Magic Accuracy
		
	sets.precast.Flourish1['Desperate Flourish'] = {
		head="Mummu Bonnet",
		ear1="Ghillie Earring +1",
		
		body="Mummu Jacket",
		ring1="Valseur's Ring",
		ring2="Rajas Ring",

		back="Toetapper Mantle",
		waist="Anguinus Belt",
		legs="Mummu Kecks",
		feet="Horos Toe Shoes +1",
		} -- Accuracy

	sets.precast.Flourish2 = {}
	sets.precast.Flourish2['Reverse Flourish'] = {hands="Charis Bangles +2", back="Toetapper Mantle"}
	sets.precast.Flourish3 = {}
	sets.precast.Flourish3['Striking Flourish'] = {body="Maculele Casaque"}
	sets.precast.Flourish3['Climactic Flourish'] = {head="Charis Tiara +2",}
	
	sets.precast.FC = {
		}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		neck="Magoraga Beads",
		})
	   
	-- Weapon Skill Sets
	
	sets.precast.WS = {
		ammo="Potestas Bomblet",

		head="Mummu Bonnet",
		neck="Justiciar's Torque",
		ear1="Ghillie Earring +1",
		ear2="Moonshade Earring",

		body="Mummu Jacket",
		hands="Mummu Wrists +1",
		ring1="Epona's Ring",
		ring2="Rajas Ring",

		back="Senuna's Mantle",
		waist="Fotia Belt",
		legs="Mummu Kecks",
		feet="Maxixi Shoes",
		}
		
	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		})
	
	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
		ammo="Potestas Bomblet",

		head="Maxixi Tiara +1",
		neck="Justiciar's Torque",
		ear1="Ghillie Earring +1",
		ear2="Moonshade Earring",

		body="Mummu Jacket",
		hands="Maxixi Bangles +1",
		ring1="Epona's Ring",
		ring2="Stormsoul Ring",

		back="Senuna's Mantle",
		waist="Fotia Belt",
		legs="Mummu Kecks",
		feet="Mummu Gamashes +1",
		})
		
	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {
		})

	sets.precast.WS['Pyrrhic Kleos'] = set_combine(sets.precast.WS, {
		ammo="Charis Feather",

		head="Mummu Bonnet",
		neck="Justiciar's Torque",
		ear1="Ghillie Earring +1",
		ear2="Brutal Earring",

		body="Mummu Jacket",
		hands="Mummu Wrists +1",
		ring1="Epona's Ring",
		ring2="Rajas Ring",

		back="Senuna's Mantle",
		waist="Fotia Belt",
		legs="Mummu Kecks",
		feet="Mummu Gamashes +1",
		})
		
	sets.precast.WS['Pyrrhic Kleos'].Acc = set_combine(sets.precast.WS['Pyrrhic Kleos'], {
		})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
		ammo="Charis Feather",

		head="Mummu Bonnet",
		neck="Rancor Collar",
		ear1="Ghillie Earring +1",
		ear2="Moonshade Earring",

		body="Mummu Jacket",
		hands="Mummu Wrists +1",
		ring1="Epona's Ring",
		ring2="Rajas Ring",

		back="Senuna's Mantle",
		waist="Fotia Belt",
		legs="Mummu Kecks", 
		feet="Mummu Gamashes +1",
		})

	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
		})

	sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {
		ammo="Charis Feather",

		head="Mummu Bonnet",
		neck="Justiciar's Torque",
		ear1="Ghillie Earring +1",
		ear2="Moonshade Earring",

		body="Mummu Jacket",
		hands="Mummu Wrists +1",
		ring1="Epona's Ring",
		ring2="Rajas Ring",

		back="Senuna's Mantle",
		waist="Anguinus Belt",
		legs="Mummu Kecks", 
		feet="Mummu Gamashes +1",
		})

	sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {
		})

	sets.precast.WS['Aeolian Edge'] = {
		head="Chimera Hairpin",
		neck="Atzintli Necklace",
		ear1="Hecate's Earring",
		ear2="Moonshade Earring",

		body="Mummu Jacket",
		hands="Taeon Gloves",
		ring1="Acumen Ring",
		ring2="Fenrir Ring",

		back="Senuna's Mantle",
		waist="Cuchulain's Belt",
		legs="Taeon Tights",
		}
	
	-- MIDCAST SETS
	
	sets.midcast.FastRecast = sets.precast.FC

	sets.midcast.SpellInterrupt = {
		}
		
	-- Specific spells
	sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

	-- Resting sets
	sets.resting = {}
	

	-- Idle sets

	sets.idle = {
		ammo="Potestas Bomblet",

		head="Mummu Bonnet",
		neck="Charis Necklace",
		ear1="Suppanomimi",
		ear2="Brutal Earring",

		body="Mummu Jacket",
		hands="Mummu Wrists +1",
		ring1="Warp Ring",
		ring2="Rajas Ring",

		back="Mecisto. Mantle",
		waist="Patentia Sash",
		legs="Mummu Kecks", 
		feet="Skd. Jambeaux +1",
		}

	sets.idle.DT = set_combine (sets.idle, {
		})

	sets.idle.Town = set_combine (sets.idle, {
		main="Terpsichore",
		sub="Atoyac",
		ring1="Warp Ring",
		ring2="Dim. Ring (Dem)",
		})
	
	sets.idle.Weak = sets.idle.DT

	-- Defense sets

	sets.defense.PDT = sets.idle.DT
	sets.defense.MDT = sets.idle.DT

	sets.Kiting = {
		feet="Skd. Jambeaux +1",
		}

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- * DNC Native DW Trait: 30% DW
	-- * DNC Job Points DW Gift: 5% DW
	
	-- No Magic Haste (74% DW to cap)
	sets.engaged = {
		ammo="Potestas Bomblet",

		head="Mummu Bonnet", --8 Haste
		neck="Charis Necklace", --5 DW
		ear1="Suppanomimi", --5 DW
		ear2="Brutal Earring",
		
		body="Maculele Casaque", --4 Haste, 10 DW
		hands="Mummu Wrists +1", --5 Haste
		ring1="Epona's Ring",
		ring2="Rajas Ring",
		
		back="Atheling Mantle",
		waist="Patentia Sash", --5 DW
		legs="Mummu Kecks", --6 Haste
		feet="Mummu Gamashes +1", --4 Haste
		} --27 Haste, 25 DW

	sets.engaged.DT = set_combine(sets.engaged, {
		})

	-- 15% Magic Haste (67% DW to cap)
	sets.engaged.LowHaste = {
		ammo="Potestas Bomblet",

		head="Mummu Bonnet", --8 Haste
		neck="Charis Necklace", --5 DW
		ear1="Suppanomimi", --5 DW
		ear2="Brutal Earring",
		
		body="Maculele Casaque", --4 Haste, 10 DW
		hands="Mummu Wrists +1", --5 Haste
		ring1="Epona's Ring",
		ring2="Rajas Ring",
		
		back="Atheling Mantle",
		waist="Patentia Sash", --5 DW
		legs="Mummu Kecks", --6 Haste
		feet="Mummu Gamashes +1", --4 Haste
		} --27 Haste, 25 DW

	sets.engaged.DT.LowHaste = set_combine(sets.engaged.LowHaste, {
		})

	-- 30% Magic Haste (56% DW to cap)
	sets.engaged.MidHaste = {
		ammo="Potestas Bomblet",

		head="Mummu Bonnet", --8 Haste
		neck="Charis Necklace", --5 DW
		ear1="Suppanomimi", --5 DW
		ear2="Brutal Earring",
		
		body="Maculele Casaque", --4 Haste, 10 DW
		hands="Mummu Wrists +1", --5 Haste
		ring1="Epona's Ring",
		ring2="Rajas Ring",
		
		back="Atheling Mantle",
		waist="Patentia Sash", --5 DW
		legs="Mummu Kecks", --6 Haste
		feet="Mummu Gamashes +1", --4 Haste
		} --27 Haste, 25 DW

	sets.engaged.DT.MidHaste = set_combine(sets.engaged.MidHaste, {
		})

	-- 35% Magic Haste (51% DW to cap)
	sets.engaged.HighHaste = {
		ammo="Potestas Bomblet",

		head="Mummu Bonnet", --8 Haste
		neck="Charis Necklace", --5 DW
		ear1="Suppanomimi", --5 DW
		ear2="Brutal Earring",
		
		body="Maculele Casaque", --4 Haste, 10 DW
		hands="Mummu Wrists +1", --5 Haste
		ring1="Epona's Ring",
		ring2="Rajas Ring",
		
		back="Atheling Mantle",
		waist="Windbuffet Belt",
		legs="Mummu Kecks", --6 Haste
		feet="Mummu Gamashes +1", --4 Haste
		} --27 Haste, 20 DW

	sets.engaged.DT.HighHaste = set_combine(sets.engaged.HighHaste, {
		})

	-- 47% Magic Haste (36% DW to cap)
	sets.engaged.MaxHaste = {
		ammo="Potestas Bomblet",

		head="Mummu Bonnet", --8 Haste
		neck="Charis Necklace", --5 DW
		ear1="Ghillie Earring +1",
		ear2="Brutal Earring",
		
		body="Mummu Jacket", --4 Haste
		hands="Mummu Wrists +1", --5 	
		ring1="Epona's Ring",
		ring2="Rajas Ring",
		
		back="Atheling Mantle",
		waist="Windbuffet Belt",
		legs="Mummu Kecks", --6 Haste
		feet="Mummu Gamashes +1", --4 Haste
		} --

	sets.engaged.DT.MaxHaste = set_combine(sets.engaged.MaxHaste, {
		})

	-- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
--	sets.buff['Saber Dance'] = {legs="Horos Tights +1"}
--	sets.buff['Fan Dance'] = {body="Horos Bangles +1"}
	sets.buff['Climactic Flourish'] = {head="Charis Tiara +2", back="Senuna's Mantle"}
	sets.buff['Closed Position'] = {feet="Horos Toe Shoes +1"}
--	sets.buff.Doom = {ring1="Saida Ring", ring2="Saida Ring", waist="Gishdubar Sash"}
	sets.CP = {back="Mecisto. Mantle"}
--	sets.Reive = {neck="Ygnas's Resolve +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	--auto_presto(spell)
end


function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == "WeaponSkill" then
		if state.Buff['Climactic Flourish'] then
			equip(sets.buff['Climactic Flourish'])
		end
	end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' or buff == 'Fan Dance' then
		handle_equipping_gear(player.status)
	end

--[[	if buffactive['Reive Mark'] then
		equip(sets.Reive)
		disable('neck')
	else
		enable('neck')
	end]]

--[[	if buff == "doom" then
		if gain then		   
			equip(sets.buff.Doom)
			--send_command('@input /p Doomed.')
			disable('ring1','ring2','waist')
		else
			enable('ring1','ring2','waist')
			handle_equipping_gear(player.status)
		end
	end]]

end


function job_status_change(new_status, old_status)
	if new_status == 'Engaged' then
		determine_haste_group()
	end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	determine_haste_group()
end


function customize_idle_set(idleSet)
	if player.hpp < 80 and not areas.Cities:contains(world.area) then
		idleSet = set_combine(idleSet, sets.ExtraRegen)
	end
	if state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
	end
	
	return idleSet
end

function customize_melee_set(meleeSet)
	if buffactive['Saber Dance'] then
		meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
	end
	if state.Buff['Climactic Flourish'] then
		meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
	end
	if state.ClosedPosition.value == true and state.OffenseMode.value == 'STP' then
		meleeSet = set_combine(meleeSet, sets.buff['Closed Position'])
	end
	if state.CP.current == 'on' then
		meleeSet = set_combine(meleeSet, sets.CP)
		disable('back')
	else
		enable('back')
	end
	return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
--[[	if spell.type == 'Step' then
		if state.IgnoreTargetting.value == true then
			state.IgnoreTargetting:reset()
			eventArgs.handled = true
		end
		
		eventArgs.SelectNPCTargets = state.SelectStepTarget.value
	end]]
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
	local msg = '[ Melee'
	
	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end
	
	msg = msg .. ': '
	
	msg = msg .. state.OffenseMode.value
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value
	end
	msg = msg .. ' ][ WS: ' .. state.WeaponskillMode.value .. ' ]'
	
	if state.DefenseMode.value ~= 'None' then
		msg = msg .. '[ Defense: ' .. state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ' ]'
	end

	msg = msg .. '[ ' .. state.HasteMode.value .. ' ]'
	
	if state.ClosedPosition.value then
		msg = msg .. '[ Closed Position: ON ]'
	end

	if state.Kiting.value then
		msg = msg .. '[ Kiting Mode: ON ]'
	end

	msg = msg .. '[ *'..state.MainStep.current

	if state.UseAltStep.value == true then
		msg = msg .. '/'..state.AltStep.current
	end
	
	msg = msg .. '* ]'

	add_to_chat(060, msg)

	eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
	if cmdParams[1] == 'dostep' then
		if cmdParams[2] == 'alt' then
			local doStep = ''
				doStep = state.AltStep.current
				send_command('@input /ja "'..doStep..'" <t>')
		elseif cmdParams[2] == 'main' then
			local doStep = ''
				doStep = state.MainStep.current
        		send_command('@input /ja "'..doStep..'" <t>')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()

	-- Gearswap can't detect the difference between Haste I and Haste II
	-- so use winkey-H to manually set Haste spell level.

	-- Haste (buffactive[33]) - 15%
	-- Haste II (buffactive[33]) - 30%
	-- Haste Samba - 5%/10%
	-- Victory March +0/+3/+4/+5	9.4%/14%/15.6%/17.1%
	-- Advancing March +0/+3/+4/+5  6.3%/10.9%/12.5%/14% 
	-- Embrava - 30%
	-- Mighty Guard (buffactive[604]) - 15%
	-- Geo-Haste (buffactive[580]) - 40%

	classes.CustomMeleeGroups:clear()

	if state.HasteMode.value == 'Haste II' then
		if(((buffactive[33] or buffactive[580] or buffactive.embrava) and (buffactive.march or buffactive[604])) or
			(buffactive[33] and (buffactive[580] or buffactive.embrava)) or
			(buffactive.march == 2 and buffactive[604]) or buffactive.march == 3) then
			--add_to_chat(122, 'Magic Haste Level: 43%')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif ((buffactive[33] or buffactive.march == 2 or buffactive[580]) and buffactive['haste samba']) then
			--add_to_chat(122, 'Magic Haste Level: 35%')
			classes.CustomMeleeGroups:append('HighHaste')
		elseif ((buffactive[580] or buffactive[33] or buffactive.march == 2) or
			(buffactive.march == 1 and buffactive[604])) then
			--add_to_chat(122, 'Magic Haste Level: 30%')
			classes.CustomMeleeGroups:append('MidHaste')
		elseif (buffactive.march == 1 or buffactive[604]) then
			--add_to_chat(122, 'Magic Haste Level: 15%')
			classes.CustomMeleeGroups:append('LowHaste')
		end
	else
		if (buffactive[580] and ( buffactive.march or buffactive[33] or buffactive.embrava or buffactive[604]) ) or
			(buffactive.embrava and (buffactive.march or buffactive[33] or buffactive[604])) or
			(buffactive.march == 2 and (buffactive[33] or buffactive[604])) or
			(buffactive[33] and buffactive[604] and buffactive.march ) or buffactive.march == 3 then
			--add_to_chat(122, 'Magic Haste Level: 43%')
			classes.CustomMeleeGroups:append('MaxHaste')
		elseif ((buffactive[604] or buffactive[33]) and buffactive['haste samba'] and buffactive.march == 1) or
			(buffactive.march == 2 and buffactive['haste samba']) or
			(buffactive[580] and buffactive['haste samba'] ) then
			--add_to_chat(122, 'Magic Haste Level: 35%')
			classes.CustomMeleeGroups:append('HighHaste')
		elseif (buffactive.march == 2 ) or
			((buffactive[33] or buffactive[604]) and buffactive.march == 1 ) or  -- MG or haste + 1 march
			(buffactive[580] ) or  -- geo haste
			(buffactive[33] and buffactive[604]) then
			--add_to_chat(122, 'Magic Haste Level: 30%')
			classes.CustomMeleeGroups:append('MidHaste')
		elseif buffactive[33] or buffactive[604] or buffactive.march == 1 then
			--add_to_chat(122, 'Magic Haste Level: 15%')
			classes.CustomMeleeGroups:append('LowHaste')
		end
	end
end


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function job_pretarget(spell, action, spellMap, eventArgs)
--[[	if spell.type == 'Step' then
		local allRecasts = windower.ffxi.get_ability_recasts()
		local prestoCooldown = allRecasts[236]
		local under3FMs = not buffactive['Finishing Move 3'] and not buffactive['Finishing Move 4'] and not buffactive['Finishing Move 5']
		 
		if player.main_job_level >= 77 and prestoCooldown < 1 and under3FMs then
			cast_delay(1.1)
			send_command('input /ja "Presto" <me>')
		end
	end]]
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book: (set, book)
	if player.sub_job == 'SAM' then
		set_macro_page(1, 1)
	elseif player.sub_job == 'NIN' then
		set_macro_page(2, 1)
	elseif player.sub_job == 'WAR' then
		set_macro_page(3, 1)
	elseif player.sub_job == 'THF' then
		set_macro_page(4, 1)
	elseif player.sub_job == 'RUN' then
		set_macro_page(5, 1)
	else
		set_macro_page(1, 1)
	end
end