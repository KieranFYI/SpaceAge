ENT.Type 			= "anim"
ENT.Base 			= "ice_mining_laser_base"
ENT.PrintName		= "Ice Miner II"
ENT.Author			= "Zup"
ENT.Category 		= "Asteroid"

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.LaserModel		= "models/ce_miningmodels/mininglasers/laser_mk1_standard.mdl"
ENT.LaserRange		= 1200 --Radius
ENT.LaserExtract	= 1000 * 2 -- Extract per cycle m3
ENT.LaserConsume	= 5625 * 2 --Energy per cycle
ENT.LaserCycle		= 45 --Time is second to complete a cycle

ENT.IceLaserModeMin = 1

list.Set("LSEntOverlayText" , "ice_mining_laser_2", {HasOOO = true, num = 1, strings = {"ICE Mining Laser II\nEnergy: ", ""}, resnames = {"energy"}})
