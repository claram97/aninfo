local M = {}

-- Function to save the snake state to a text file
function M.saveSnakeState(snake, score, mode)
    -- format the savegame filename
    local filename = "snake_state_" .. mode .. ".txt"

    local file = io.open(filename, "w") -- Open the file in write mode
    if file then
        -- Write the snake's x and y positions
        for i, segment in ipairs(snake) do
            file:write(segment.x .. "," .. segment.y .. "\n")
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
    local file = io.open(filename, "r") -- Open the file in read mode
    if file then
        local snake = {} -- Create a new snake object
        -- Read the snake's x and y positions
        for line in file:lines() do
            local x, y = line:match("(%d+),(%d+)")
            if x and y then
                local segment = {x = tonumber(x), y = tonumber(y)}
                table.insert(snake, segment)
            end
        end
        file:close() -- Close the file
        print("Snake state loaded successfully!")
        return snake
    else
        print("Failed to open file for reading.")
        return nil
    end
end

return M