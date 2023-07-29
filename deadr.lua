-- consult the oracle
-- maybe we might talk 
-- with the dead

listselect = require('listselect')

-- input history variables
local my_string = ""
history = {}
local history_index = nil
local new_line = false

days = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31'}

months = {'january','february','march','april','may','june','july','august','september','october','november','december'}

years = {1965,1966,1967,1968,1969,1970,1971,1972,1973,1974,1975,1976,1977,1978,1979,1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995}

function init()
   
   params:add_option("select_day","days",days,3)
  
   
   params:add_trigger('select_month','select month', 1)
   params:set_action('select_month', function() listselect.enter(months,callback_month) end)
  
   
   params:add_trigger('select_year', 'select year', 1)
   params:set_action('select_year', function() 
      listselect.enter(years,callback_year) end)
  
  day_list = {} 
  for i,v in ipairs(days) do 
    day_list[i] = days 
  end
  
  
  month_list = {} 
  for i,v in ipairs(months) do 
    month_list[i] = months 
  end
    
  year_list = {} 
  for i,v in ipairs(years) do 
    year_list[i] = years 
  end
    
end

function callback_day(selected_day) 
  if selected_day ~= 'cancel' then 
    fav_day = selected_day
  end
  print(selected_day)
  redraw()
end


function callback_month(selected_month) 
  if selected_month ~= 'cancel' then 
    fav_month = selected_month
  end
  print(selected_month)
  redraw()
end

function callback_year(selected_year) 
  if selected_year ~= 'cancel' then 
    fav_year = selected_year
  end
  print(selected_year)
  redraw()
end

function redraw()
  screen.clear()
  screen.level(15)

  screen.move(0,10)
  if fav_year == nil then
    screen.text('press K3 to select year')
  else
    screen.text(fav_year)
  end

  screen.move(0,20)
  if fav_month == nil then
    screen.text('press K2 to select month')
  else
    screen.text(fav_month)
  end
  
  screen.move(0,30)
  if fav_day == nil then
    screen.text('press K2+K3 to select day')
  else
    screen.text(fav_day)
  end
  
  
  screen.rect(2, 50, 125, 14)
  screen.stroke()
  screen.move(5,59)
  screen.text("> " .. my_string)
  screen.update()
end



function key(n,z)
  if n == 2 and z == 1 then
	  listselect.enter(months, callback_month)
  end
  if n == 3 and z == 1 then  
    listselect.enter(years, callback_year) 
  end
-- does not work
  if n == 2 and n == 3 and z == 1 then  
    listselect.enter(years, callback_year) 
  end
end

function keyboard.char(character)
  my_string = my_string .. character -- add characters to my string
  redraw()
end


function keyboard.code(code,value)
  if value == 1 or value == 2 then -- 1 is down, 2 is held, 0 is release
    if code == "BACKSPACE" then
      my_string = my_string:sub(1, -2) -- erase characters from my_string
    elseif code == "UP" then
      if #history > 0 then -- make sure there's a history
        if new_line then -- reset the history index after pressing enter
          history_index = #history
          new_line = false
        else
          history_index = util.clamp(history_index - 1, 1, #history) -- increment history_index
        end
        my_string = history[history_index]
      end
    elseif code == "DOWN" then
      if #history > 0 and history_index ~= nil then -- make sure there is a history, and we are accessing it
        history_index = util.clamp(history_index + 1, 1, #history) -- decrement history_index
        my_string = history[history_index]
      end
    elseif code == "ENTER" then
      table.insert(history, my_string) -- append the command to history
      my_string = "" -- clear my_string
      new_line = true
    end
    redraw()
  end
end

