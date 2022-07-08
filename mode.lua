require "objects"

--add points mode
function modeTaskOne(task,d1)
  if ((task==1) and (currentObject.type==1)) then
    --add point to object
    if checkPreviousPoint() then
      table.insert(currentObject.points,cpx)
      table.insert(currentObject.points,cpy)
    end
  elseif (task==2) then
    --create new line and add points
    createObject(d1,1,defr,defg,defb,defa,deflw)
    table.insert(currentObject.points,cpx)
    table.insert(currentObject.points,cpy)
  end
end
function checkPreviousPoint()
  --check we didn't just add that same point
  if (#currentObject.points>1) then
    local p=currentObject.points
    local ux,uy=p[#p-1],p[#p]
    if not ((ux==cpx) and (uy==cpy)) then
      return true
    else
      return false
    end
  else 
    return true
  end
end
-- move mode
function modeTaskTwo(task)
  if (task==1) then
    if not ((cpx==prevX) and (cpy==prevY)) then 
      v=currentObject.points
      for i=1,#v,1 do
        if (i%2==0) then
          if (cpy>prevY) then
            v[i]=v[i]+(cpy-prevY)
          else
            v[i]=v[i]-(prevY-cpy)
          end
        else
          if (cpx>prevX) then
            v[i]=v[i]+(cpx-prevX)
          else
            v[i]=v[i]-(prevX-cpx)
          end
        end
      end
      prevY=cpy
      prevX=cpx
    end 
  end
end
--rectangle mode
function modeTaskThree(task,d1)
  --set rectanle origin (downclick)
  if (task==1) then
      createObject(d1,2,defr,defg,defb,defa,deflw) --rect
      table.insert(currentObject.points,cpx)
      table.insert(currentObject.points,cpy)
      table.insert(currentObject.points,cpx)
      table.insert(currentObject.points,cpy)
   --extent rect to cursor 
  elseif (task==2) then
    local v=currentObject.points
    v[3]=cpx
    v[4]=cpy
  end
end
--add text
function modeTaskFour(objNum)
  createObject(objNum,3,defr,defg,defb,defa,deffs)
  table.insert(currentObject.points,cpx)
  table.insert(currentObject.points,cpy)
end
--add pointArray
function modeTaskFive(task,d1)
  if (task==2) then
    --add point to object
    if (t%currentObject.sampleRate==0) then
      if (currentObject.type==4) then
        addSuroundingPoints()
      end
    end
  elseif (task==1) then
    --create new line and add points
    createObject(d1,4,defr,defg,defb,defa,deflw)
    table.insert(currentObject.points,cpx)
    table.insert(currentObject.points,cpy)
  end
end
function addSuroundingPoints()
  local v=rPointArray
  for i=1,#v,1 do
    if not (i%2==0) then
      local xx=v[i]-mx
      local yy=v[i+1]-my
      local dist=math.sqrt((xx*xx)+(yy*yy))
      if (dist<currentObject.range) then
        checkIfInObjPointArray(v[i],v[i+1])
      end
    end
  end
end
function checkIfInObjPointArray(x,y)
  local v=currentObject
  local alreadyIn=false
  for i=1,#v.points,1 do
    if not (i%2==0) then
      if (v.points[i]==x and v.points[i+1]==y) then
        alreadyIn=true
      end
    end
  end
  if not (alreadyIn) then
    table.insert(currentObject.points,x)
    table.insert(currentObject.points,y)
  end
end