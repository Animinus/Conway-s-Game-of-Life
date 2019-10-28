Cell = {}

function love.load()
	white = {255, 255, 255, 250}
	black = {0, 0, 0, 250}
	started = false
	
	
	universeSize = love.graphics.getHeight()-20
	cellGridSize = math.floor(universeSize/5)
	
	
	cells = initGrid()
	oldCells = clone(cells)
end

function love.update(dt)
end

function love.draw(dt)
	if started then
		calcNew()
		drawWorld(cells)
	else
		drawWorld(cells)
		started = true
	end
end

function Cell.new(x, y, isAlive)
	local i 	= {}
	i.x 	 	= x
	i.y 		= y
	i.isAlive 	= isAlive
	setmetatable(i, {__index = Cell})
	
	return i
end

function initGrid()
	cells = {}
	
	for i = 0, cellGridSize do
		cells[i] = {}
		for j = 0, cellGridSize do
			local cell = Cell.new(
				12 + i*5,
				12 + j*5,
				math.random(0, 10) == 1 and true or false)
			cells[i][j] = cell
		end
	end
	
	return cells
end

function drawWorld(cells)
	for i = 0, #cells do
		for j = 0, #cells do
			if cells[i][j].isAlive then
				love.graphics.setColor(white)
			else
				love.graphics.setColor(black)
			end
			
			love.graphics.rectangle("fill", cells[i][j].x, cells[i][j].y, 4, 4)
		end
	end
end

-- Here's where I start to want to end my life

function getLeft(i, j)
	if i > 0 then
		return oldCells[i-1][j]
	else
		return nil
	end
end

function getRight(i, j)
	if i < #oldCells then
		return oldCells[i+1][j]
	else
		return nil
	end
end

function getUpper(i, j)
	if j > 0 then
		return oldCells[i][j-1]
	else
		return nil
	end
end

function getBottom(i, j)
	if j < #oldCells then
		return oldCells[i][j+1]
	else
		return nil
	end
end

function getUpperLeft(i, j)
	if i > 0 and j > 0 then
		return oldCells[i-1][j-1]
	else
		return nil
	end
end

function getUpperRight(i, j)
	if i > 0 and j < #oldCells then
		return oldCells[i-1][j+1]
	else
		return nil
	end
end

function getBottomLeft(i, j)
	if i > 0 and j < #oldCells then
		return oldCells[i-1][j+1]
	else
		return nil
	end
end

function getBottomRight(i, j)
	if i < #oldCells and j < #oldCells then
		return oldCells[i+1][j+1]
	else
		return nil
	end
end

function calcNew()
	oldCells = clone(cells)
	cells 	 = {}
	
	for i = 0, #oldCells do
		cells[i] = {}
		for j = 0, #oldCells do
			local oldCell = oldCells[i][j]
			
			--Get all neighbours and store in table
			local neighbours = {}
			local tempCell   = nill
			
			tempCell = getUpperLeft(i, j)
			if tempCell ~= nil then
				table.insert(neighbours, tempCell)
			end
			
			tempCell = getUpper(i, j)
			if tempCell ~= nil then
				table.insert(neighbours, tempCell)
			end
			
			tempCell = getUpperRight(i, j)
			if tempCell ~= nil then
				table.insert(neighbours, tempCell)
			end
			
			tempCell = getLeft(i, j)
			if tempCell ~= nil then
				table.insert(neighbours, tempCell)
			end
			
			tempCell = getRight(i, j)
			if tempCell ~= nil then
				table.insert(neighbours, tempCell)
			end			
			
			tempCell = getBottomLeft(i, j)
			if tempCell ~= nil then
				table.insert(neighbours, tempCell)
			end
			
			tempCell = getBottom(i, j)
			if tempCell ~= nil then
				table.insert(neighbours, tempCell)
			end
			
			tempCell = getBottomRight(i, j)
			if tempCell ~= nil then
				table.insert(neighbours, tempCell)
			end

			--do calculations on neighbours we got
			local lifeCount  = 0
			for i = 1, #neighbours do
				if neighbours[i].isAlive then
					lifeCount = lifeCount + 1
				end
			end
			
			local newCell = clone(oldCell)
			if oldCell.isAlive and (lifeCount < 2 or lifeCount > 3) then
				newCell.isAlive = false
			end
			
			if not oldCell.isAlive and lifeCount == 3 then
				newCell.isAlive = true
			end
			
			cells[i][j] = newCell
		end
	end
end

function clone(t)
	if type(t) ~= "table" then return t end
	
	local meta = getmetatable(t)
	local target = {}
	
	for i, v in pairs(t) do
		if type(v) == "table" then
			target[i] = clone(v)
		else
			target[i] = v
		end
	end
	
	setmetatable(target, meta)
	return target
end
