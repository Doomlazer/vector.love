require "mode"
require "objects"
require "256colors"
require "draw"
require "controls"

function loadShit()
love.window.setTitle("vector.love")
love.window.updateMode(800, 600, {resizable=true, vsync=-1, minwidth=560, minheight=420})
screen_width, screen_height = love.graphics.getDimensions()

arialFont=love.graphics.setNewFont("fonts/Arial.TTF", 12)

--rot=0
--local transform = love.math.newTransform()
--transform:rotate(rot)

myColorTable=load256table()

menu=false
typingAttrib=0
typing=false
tblink=true


objects={}
objNum=1
settingPoint=false
hidePoints=false

rulerspacing=10
rPointArray={}

cpx=screen_width/2
cpy=screen_height/2
prevX=cpx
prevY=cpy
modes={"Add Lines","Move","Add Rect","Add Text","PointBrush"}
types={"Line","Rectangle","Triangle","PointArray"}
mode=1
rFlip=false
currentObject={}
showRuler=true
rulerModePoints=true
rc={0.5,0.5,0.5,1} --ruler color

--default color for new objs
defr=1
defg=1
defb=1
defa=1
deflw=1
deffs=15
defps=8
deffill=true

--mode rgba
mr=0
mg=0
mb=0
ma=0

fontList=love.filesystem.getDirectoryItems("fonts")
local remove=0
for k,f in pairs(fontList) do
  if (f==".DS_Store") then
    remove=k
  end
end
if (remove>0) then
  table.remove(fontList, remove)
end
if (#fontList>0) then
  love.graphics.setNewFont("fonts/"..fontList[1], 12)
end

--menu item width offset
menuSpaceL=10
menuSpaceR=500

end
function love.load()
  t=0
  loadShit()
  rspeed=1
  recalcRPointArry()
  createObject(objNum,1,defr,defg,defb,defa,deflw)
  multiVectorAdd=false
end
function love.update(dt)
  --rot=rot+0.0001*dt
  --transform:rotate(rot)
  menuSpaceR=screen_width-250
  --for sliders
  screen_width, screen_height = love.graphics.getDimensions()
  lStart,lEnd=screen_width/2-75,screen_width/2+125
  if (menuSpaceR<350) then menuSpaceR=350 end
  t=t+1
  if (t>360000) then t=0 end
  if (t%200==0) then
    local state=not tblink
    tblink=state
  end
  mx,my = love.mouse.getPosition()
  if not (menu or mode==5) then
    setClosestPoint()
  end
  --change color on mode
  if (mode==1) then
    mr,mg,mb,ma=1,0.5,0,1
  elseif (mode==2) then
    mr,mg,mb,ma=1,1,0.5,1
  elseif (mode==3) then
    mr,mg,mb,ma=0.5,1,1,1
  elseif (mode==4) then
    mr,mg,mb,ma=0,0.5,1,1
  elseif (mode==5) then
    mr,mg,mb,ma=0,0.75,0,1
  end
  
  controlInputs()

end
function setClosestPoint()
  local count=0
  --local hy=math.floor(my/rulerspacing)-rulerspacing
  --local wx=math.floor(mx/rulerspacing)-rulerspacing
  
  --print(wx)
  --print(hy)
  
  --for h=hy,hy+(rulerspacing*2),rulerspacing do
  --  for w=wx,wx+(rulerspacing*2),rulerspacing do
  for h=0,screen_height/rulerspacing,1 do 
    for w=0,screen_width/rulerspacing,1 do
      count=count+1
      local px,py=w*rulerspacing,h*rulerspacing
      local tt=rulerspacing/2
      if (mx>px-tt) and (mx<px+tt) then
        if (my>py-tt) and (my<py+tt) then
          cpx,cpy=px,py
        end
      end
    end
  end
 
 
  --print("count")
  --print(count)
  
  
end
function love.draw()
  if showRuler then
    drawRuler()
  end

  --draw unselected objects
  if (#objects>0) then 
    for i=1,#objects,1 do
      drawObject(objects[i])
    end
  end
  
  drawPoints()
  drawInfo()
  
    --draw cursor  
  if (mode==5) then
    --pointbrush brush
    love.graphics.setColor(0,0.75,0,1)
    love.graphics.setLineWidth(1)
    love.graphics.circle("line",mx,my,currentObject.range, currentObject.range)
  else
    love.graphics.setColor(1,0,0,1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line",0+cpx-5,0+cpy-5,10,10)
  end
  
  if colorPicker then
    draw256window()
  end
  if menu then
    drawMenu()
  end

  --drawTestCode()
end
