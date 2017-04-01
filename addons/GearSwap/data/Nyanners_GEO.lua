-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[	Custom Features:
		
		Magic Burst			Toggle Magic Burst Mode  [Alt-`]
		Capacity Pts. Mode	Capacity Points Mode Toggle [WinKey-C]
		Auto. Lockstyle		Automatically locks desired equipset on file load
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
	indi_timer = ''
	indi_duration = 230

	state.CP = M(false, "Capacity Points Mode")

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'Acc')
	state.CastingMode:options('Normal', 'Seidr', 'Resistant')
	state.IdleMode:options('Normal', 'DT')

	state.WeaponLock = M(false, 'Weapon Lock')	
	state.MagicBurst = M(false, 'Magic Burst')

	-- Additional local binds
--	send_command('bind !` gs c toggle MagicBurst')

	send_command('bind @c gs c toggle CP')
	send_command('bind @w gs c toggle WeaponLock')
	
	send_command('unbind ^`')
	send_command('bind !backspace Erase')
	send_command('bind !delete EclipticAttrition')
	send_command('bind !end LastingEmanation')
	send_command('bind !insert BlazeOfGlory')
	send_command('bind !home Dematerialize')
	send_command('bind ^delete CollimatedFervor')
	send_command('bind @[ gs c minustier')
	send_command('bind @] gs c plustier')

	send_command('bind ^insert gs equip idle.Town;input /echo ===== Idle Set =====')
	send_command('bind ^home gs equip engaged;input /echo ===== TP Set =====')

	send_command('exec dualgeo.txt;send Aisaka exec dualgeo.txt')

	select_default_macro_book()
end

function user_unload()
end


-- Define sets and vars used by this job file.
function init_gear_sets()

	------------------------------------------------------------------------------------------------
	----------------------------------------- Precast Sets -----------------------------------------
	------------------------------------------------------------------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA.Bolster = {
		body="Bagua Tunic"
	}
	sets.precast.JA['Life Cycle'] = {body="Geo. Tunic +1", back="Nantosuelta's Cape"}
	sets.precast.JA['Full Circle'] = {head="Azimuth Hood"}
	sets.precast.JA['Radial Arcana'] = {head="Bagua Sandals"}

	-- Fast cast sets for spells

	sets.precast.FC = {
		ammo="Impatiens", --2 Quick Magic
        neck="Jeweled Collar", --2 FC
		ear2="Loquacious Earring", --2 FC
        back="Lifestream Cape", --7 FC
		legs="Geomancy Pants", --10 FC
		}

	sets.precast.FC.Geomancy = set_combine(sets.precast.FC, {ammo="",ranged="Dunna"})

	sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
		waist="Siegel Sash",
		})

	sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
		head="Mallquis Chapeau", --3 Elemental Casting Time
		neck="Stoicheion Medal", --3 ECT
		body="Mallquis Saio", --5 ECT
		hands="Bagua Mitaines +1", --12 ECT
		feet="Mallquis Clogs +1", --5 ECT
		})

	sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		main="Tamaxchi", --Just Because
		sub="Genbu's Shield", --8 Cure Casting Time
		back="Pahtli Cape", --8 Cure Casting Time
		})

	sets.precast.FC.Curaga = sets.precast.FC.Cure
	sets.precast.FC.Impact = {head=empty, body="Twilight Cloak"}


	-- Weaponskill sets
	-- Default set for any weaponskill that isn't any more specifically defined
--	sets.precast.WS = {}


	------------------------------------------------------------------------
	----------------------------- Midcast Sets -----------------------------
	------------------------------------------------------------------------

	-- Base fast recast for spells
	sets.midcast.FastRecast = {
        head="Wayfarer Circlet", --6 Haste
		neck="Jeweled Collar", --2 FC
		ear1="Gifted Earring", --3 Conserve MP
		ear2="Loquacious Earring", --2 FC

        body="Wayfarer Robe", --3 Haste
		hands="Mallquis Cuffs +1", --4 Haste

        back="Lifestream Cape", --7 FC
		waist="Swift Belt", --4 Haste
		legs="Geomancy Pants", --10 FC. 4 Haste, 20 Spell Interrupt
		feet="Geomancy Sandals +1", --3 Haste
		}
		
	sets.midcast.Geomancy = {
		ranged="Dunna", --5 Geomancy
		head="Azimuth Hood", --10 Skill
		body="Bagua Tunic", --10 Skill
		hands="Geomancy Mitaines", --15 Skill
		back="Lifestream Cape", --5 Skill
		}

	sets.midcast.Geomancy.Indi = {
		ranged="Dunna",
		head="Azimuth Hood", --10 Skill
		body="Bagua Tunic", --10 Skill
		hands="Geomancy Mitaines", --15 Skill
		back="Lifestream Cape", --5 Skill
		legs="Bagua Pants", --12 Duration
		feet="Azimuth Gaiters", --15 Duration
		}

	sets.midcast.Cure = {
		main="Tamaxchi", --22 Potency
		sub="Genbu's Shield", --3 Potency
        hands="Telchine Gloves", --10 Potency
		ring1="Solemn Ring", --5 MND
		ring2="Aquasoul Ring", --7 MND
		}

	sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
		})

	sets.midcast.Cursna = {ring2="Haoma's Ring"}

	sets.midcast['Enhancing Magic'] = {}

	sets.midcast.EnhancingDuration = {}

	sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
		})

	sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
		})

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
		waist="Siegel Sash",
		})

	sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
		})

	sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
		ring1="Sheltered Ring",
		})
	sets.midcast.Protectra = sets.midcast.Protect
	sets.midcast.Shell = sets.midcast.Protect
	sets.midcast.Shellra = sets.midcast.Protect

	sets.midcast.MndEnfeebles = {
		main="Marin Staff", --15 MAcc, 228 MAcc Skill
		sub="Reign Grip", --3 MND
		head="Mallquis Chapeau", --26 MAcc, 23 MND
		neck="Stoicheion Medal", --2 MAcc
		body="Mallquis Saio", --28 MAcc, 33 MND
		hands="Mallquis Cuffs +1", --37 MAcc, 37 MND
		ring1="Balrahn's Ring", --4 MAcc
		ring2="Aquasoul Ring", --7 MND
		back="Pahtli Cape", --8 MND
		legs="Mallquis Trews", --27 MAcc, 28 MND
		feet="Mallquis Clogs +1", --36 MAcc, 23 MND
		} -- MND/Magic Accuracy, Enfeebling Magic Skill

	sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
		main="Marin Staff", --15 MAcc, 228 MAcc Skill
		sub="Wizzan Grip", --3 INT, 1 Conserve MP
		head="Mallquis Chapeau", --26 MAcc, 29 INT
		neck="Stoicheion Medal", --2 MAcc
		body="Mallquis Saio", --28 MAcc, 43 INT
		hands="Mallquis Cuffs +1", --37 MAcc, 36 INT
		ring1="Balrahn's Ring", --4 MAcc
		ring2="Icesoul Ring", --7 INT
		back="Lifestream Cape", --10 Skill
		legs="Mallquis Trews", --27 MAcc, 46 INT
		feet="Mallquis Clogs +1", --36 MAcc, 33 INT
		}) -- INT/Magic Accuracy, Enfeebling Magic Skill

	sets.midcast['Dark Magic'] = {
		main="Marin Staff", --15 MAcc, 228 MAcc Skill
		sub="Wizzan Grip", --1 Conserve MP
		head="Mallquis Chapeau", --26 MAcc
		neck="Stoicheion Medal", --2 MAcc
		body="Mallquis Saio", --28 MAcc
		hands="Mallquis Cuffs +1", --37 MAcc
		ring1="Balrahn's Ring", --4 MAcc
		legs="Mallquis Trews", --27 MAcc
		feet="Mallquis Clogs +1", --36 MAcc
		} --Magic Accuracy, Dark Skill

	sets.midcast.Drain = set_combine(sets.midcast['Dark Magic'], {
		head="Bagua Galero", --20 Drain/Aspir Potency
		ring2="Excelsis Ring", --5 Drain/Aspir Potency
		})

	sets.midcast.Aspir = sets.midcast.Drain

	sets.midcast.Stun = set_combine(sets.midcast['Dark Magic'], {
		})

	-- Elemental Magic sets

	sets.midcast['Elemental Magic'] = {
		main="Marin Staff", --12 INT, 15 MAcc, 28 MAB, 217 Magic Damage, 228 MAcc Skill, 2 FC
		sub="Wizzan Grip", --3 INT, 1 Conserve MP
		ammo="Dosis Tathlum", --13 Magic Damage

		head="Mallquis Chapeau", --29 INT, 26 MAcc, 52 Magic Damage
		neck="Stoicheion Medal", --2 MAcc, 8 MAB
		ear1="Novio Earring", --7 MAB
		ear2="Hecate's Earring", --6 MAB, 3 MCrit
		
		body="Mallquis Saio", --43 INT, 28 MAcc, 58 Magic Damage
		hands="Mallquis Cuffs +1", --36 INT, 37 MAcc, 49 Magic Damage, 12 MAB
		ring1="Acumen Ring", --2 INT, 4 MAB
		ring2="Icesoul Ring", --7 INT

		back="Nantosuelta's Cape", --7 FC
		waist="Swift Belt", --4 Haste
		legs="Hagondes Pants +1", --32 INT, 37 MAB, 10 Magic Damage
		feet="Mallquis Clogs +1", --33 INT, 36 MAcc, 46 Magic Damage, 12 MAB
		}

	sets.midcast['Elemental Magic'].Resistant = set_combine(sets.midcast['Elemental Magic'], {
		})

	sets.midcast.GeoElem = set_combine(sets.midcast['Elemental Magic'], {
		})

	sets.midcast['Elemental Magic'].Seidr = set_combine(sets.midcast['Elemental Magic'], {
		})

	sets.midcast.GeoElem.Seidr = set_combine(sets.midcast['Elemental Magic'].Seidr, {
		})

	sets.midcast.Impact = set_combine(sets.midcast['Elemental Magic'], {
		--head=empty,
		--body="Twilight Cloak",
		})

	------------------------------------------------------------------------------------------------
	------------------------------------------ Idle Sets -------------------------------------------
	------------------------------------------------------------------------------------------------

	sets.idle = {
		main="Earth Staff", --20 PDT
		sub="Reign Grip",
		ranged="Dunna",

        head="Mallquis Chapeau", --33 Eva, 53 MEva, 6 MDB
		neck="Twilight Torque", --5 DT
		ear1="Moonshade Earring", --1 Refresh
		ear2="Ethereal Earring", --5 Eva, 3 Damage > MP

        body="Geomancy Tunic +1", --41 Eva, 80 MEva, 6 MDB, 2 Refresh
		hands="Bagua Mitaines +1", --22 Eva, 37 MEva, 3 MDB, 1 Refresh
		ring1="Warp Ring", --Warp
		ring2="Dark Ring", --6 PDT, 3 MDT

        back="Lifestream Cape", --2 Pet DT
		waist="Slipor Sash", --3 MDB, 3 MDT
		legs="Assiduity Pants", --27 Eva, 107 MEva, 6 MDB, 1 Refresh
		feet="Geomancy Sandals +1", --55 Eva, 107 MEva, 5 MDB, 12 Move Speed
		}

	sets.resting = set_combine(sets.idle, {
		main="Chatoyant Staff", --10 HMP
		})

	sets.idle.DT = set_combine(sets.idle, {
		})

	sets.idle.Weak = sets.idle.DT

	-- .Pet sets are for when Luopan is present.
	sets.idle.Pet = set_combine(sets.idle, {
		main="Earth Staff", --20 PDT
		sub="Reign Grip",
		ranged="Dunna",

        head="Mallquis Chapeau", --33 Eva, 53 MEva, 6 MDB
		neck="Twilight Torque", --5 DT
		ear1="Moonshade Earring", --1 Refresh
		ear2="Ethereal Earring", --5 Eva, 3 Damage > MP

        body="Geomancy Tunic +1", --41 Eva, 80 MEva, 6 MDB, 2 Refresh
		hands="Bagua Mitaines +1", --22 Eva, 37 MEva, 3 MDB, 1 Refresh
		ring1="Merman's Ring", --4 MDT
		ring2="Dark Ring", --6 PDT, 3 MDT

        back="Nantosuelta's Cape", --4 Pet Regen
		waist="Slipor Sash", --3 MDB, 3 MDT
		legs="Assiduity Pants", --27 Eva, 107 MEva, 6 MDB, 1 Refresh
		feet="Bagua Sandals", --25 Eva, 73 MEva, 2 MDB, 2 Pet Regen
		})

	sets.idle.DT.Pet = set_combine(sets.idle.Pet, {
		})

	-- .Indi sets are for when an Indi-spell is active.
--	sets.idle.Indi = set_combine(sets.idle, {legs="Bagua Pants +1"})
--	sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {legs="Bagua Pants +1"})
--	sets.idle.DT.Indi = set_combine(sets.idle.DT, {legs="Bagua Pants +1"})
--	sets.idle.DT.Pet.Indi = set_combine(sets.idle.DT.Pet, {legs="Bagua Pants +1"})

	sets.idle.Town = set_combine(sets.idle, {
		ring1="Warp Ring",
		ring2="Dim. Ring (Dem)",
		})

	-- Defense sets

	sets.defense.PDT = sets.idle.DT
	sets.defense.MDT = sets.idle.DT

	sets.Kiting = {
		feet="Geomancy Sandals +1"
		}

	--------------------------------------
	-- Engaged sets
	--------------------------------------

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion

	-- Normal melee group
	sets.engaged = {
		}


	--------------------------------------
	-- Custom buff sets
	--------------------------------------

	sets.magic_burst = {
		}

	sets.buff.Doom = {}

	sets.Obi = {}
	sets.CP = {back="Mecisto. Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.name == 'Impact' then
		equip(sets.precast.FC.Impact)
	end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.skill == 'Elemental Magic' then 
		if state.MagicBurst.value then
			equip(sets.magic_burst)
			if spell.english == "Impact" then
				equip(sets.midcast.Impact)
			end
		end
--[[		if (spell.element == world.day_element or spell.element == world.weather_element) then
			equip(sets.Obi)
		end]]
	end
	if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
		equip(sets.midcast.EnhancingDuration)
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
	if not spell.interrupted then
		if spell.english:startswith('Indi') then
			if not classes.CustomIdleGroups:contains('Indi') then
				classes.CustomIdleGroups:append('Indi')
			end
			--send_command('@timers d "'..indi_timer..'"')
			--indi_timer = spell.english
			--send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
		elseif spell.skill == 'Elemental Magic' then
 --		   state.MagicBurst:reset()
		end
		if spell.english == "Sleep II" then
			send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
		elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
			send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
		end 
	elseif not player.indi then
		classes.CustomIdleGroups:clear()
	end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if player.indi and not classes.CustomIdleGroups:contains('Indi')then
		classes.CustomIdleGroups:append('Indi')
		handle_equipping_gear(player.status)
	elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
		classes.CustomIdleGroups:clear()
		handle_equipping_gear(player.status)
	end

--[[	if buff == "doom" then
		if gain then		   
			equip(sets.buff.Doom)
			send_command('@input /p Doomed.')
			disable('ring1','ring2','waist')
		else
			enable('ring1','ring2','waist')
			handle_equipping_gear(player.status)
		end
	end]]

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
	if state.WeaponLock.value == true then
		disable('main','sub')
	else
		enable('main','sub')
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------
function pet_change(pet,gain_or_loss)
    status_change(player.status)
    if not gain_or_loss then
        send_command('send Aisaka input /echo ===== Luopan Expired! =====')
		add_to_chat('===== Luopan Expired! =====')
    end 
end

function job_get_spell_map(spell, default_spell_map)
	if spell.action_type == 'Magic' then
		if spell.skill == 'Enfeebling Magic' then
			if spell.type == 'WhiteMagic' then
				return 'MndEnfeebles'
			else
				return 'IntEnfeebles'
			end
		elseif spell.skill == 'Geomancy' then
			if spell.english:startswith('Indi') then
				return 'Indi'
			end
		elseif spell.skill == 'Elemental Magic' then
			if spellMap == 'GeoElem' then
				return 'GeoElem'
			end
		end
	end
end

function customize_idle_set(idleSet)
	if state.CP.current == 'on' then
		equip(sets.CP)
		disable('back')
	else
		enable('back')
	end

	return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	classes.CustomIdleGroups:clear()
	if player.indi then
		classes.CustomIdleGroups:append('Indi')
	end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
	display_current_caster_state()
	eventArgs.handled = true
end

function job_self_command(cmdParams, eventArgs)
	if cmdParams[1]:lower() == 'nuke' then
		handle_nuking(cmdParams)
		eventArgs.handled = true
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	set_macro_page(1, 1)
end