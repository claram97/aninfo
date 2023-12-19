local M = {}

-- Function to save the snake state to a text file
function M.saveSnakeState(snake, obstacles, score, mode)
    -- format the savegame filename
    local filename = "snake_state_" .. mode .. ".txt"

    local file = io.open(filename, "w") -- Open the file in write mode
    if file then
        -- Write the snake's x and y positions
        file:write("Snake:\n")
        for i, segment in ipairs(snake) do
            file:write(segment.x .. "," .. segment.y .. "\n")
        end
        file:write("\nObstacles:\n")
        for i, obstacle in ipairs(obstacles) do
            file:write(obstacle.x .. "," .. obstacle.y .. "\n")
        end

        -- Write the score
        file:write("Score: " .. score .. "\n")
        file:close() -- Close the file
        print("Snake state saved successfully!")
    else
        print("Failed to open file for writing.")
    end
end

-- Function to load the snake state from a text file
function M.loadSnakeState(mode)
    local filename = "snake_state_" .. mode .. ".txt"
    local loadedData = {
        snake = {},
        obstacles = {},
        score = 0
    }

    local file = io.open(filename, "r") -- Open the file in read mode
    if file then
        local currentSection = nil

        for line in file:lines() do
            if line == "Snake:" then
                currentSection = "Snake"
            elseif line == "Obstacles:" then
                currentSection = "Obstacles"
            elseif line:match("^Score:") then
                -- Extract the score from the line
                loadedData.score = tonumber(line:match("Score: (%d+)"))
            else
                -- Parse x and y coordinates for Snake and Obstacles sections
                local x, y = line:match("([%d%.]+),([%d%.]+)")
                if x and y then
                    local element = { x = tonumber(x), y = tonumber(y) }
                    if currentSection == "Snake" then
                        table.insert(loadedData.snake, element)
                    elseif currentSection == "Obstacles" then
                        table.insert(loadedData.obstacles, element)
                    end
                end
            end
        end

        file:close()
        print("Snake state loaded successfully!")
    else
        print("Failed to open file for reading.")
        return nil
    end
    return loadedData
end

-- Function to remove savefiles once the game is over correctly
function M.clearSnakeState(mode)
    local filename = "snake_state_" .. mode .. ".txt"
    os.remove(filename)
end

return M