
function createObject(n,t,r,g,b,a,lw)
  local object={}
  object.points={}
  if (t==1) then
    object.name="object #"..n.." LINE"
  elseif (t==2) then
    object.name="object #"..n.." RECT"
  elseif (t==3) then 
    object.name="object #"..n.." TEXT"
  elseif (t==4) then
    object.name="object #"..n.." PointBrush"
  end
  object.num=n
  object.type=t
  object.r=r
  object.g=g
  object.b=b
  object.a=a
  object.lineWidth=lw
  object.fill=deffill
  object.text="Aa"
  object.fontNum=1
  object.font=love.graphics.setNewFont("fonts/"..fontList[object.fontNum], deffs)
  object.fontSize=deffs
  object.pointSize=defps
  object.range=20
  object.sampleRate=4
  
  currentObject=object
  
  table.insert(objects, currentObject)
end
function duplicateObject(n,t,r,g,b,a,lw,points,text,name,font,fontSize,fill,range,sampleRate,fontNum,pointSize)
  local object={}
  object.points={}
  for i=1,#points,1 do
    local p=points[i]
   table.insert(object.points,p)
  end
  if (t==1) then
    object.name="object #"..n.." LINE"
  elseif (t==2) then
    object.name="object #"..n.." RECT"
  elseif (t==3) then 
    object.name="object #"..n.." TEXT"
  elseif (t==4) then
    object.name="object #"..n.." PointBrush"
  end
  object.num=n
  object.type=t
  object.r=r
  object.g=g
  object.b=b
  object.a=a
  object.lineWidth=lw
  object.fill=fill
  object.text=text
  object.fontNum=fontNum
  object.font=font
  object.fontSize=fontSize
  object.pointSize=pointSize
  object.range=range
  object.sampleRate=sampleRate
  
  
  for i=1,#object.points,1 do
    --offset
    object.points[i]=object.points[i]+30
  end
  
  currentObject=object
  
  table.insert(objects, currentObject)
end