function drawRuler()
  love.graphics.setColor(rc[1],rc[2],rc[3],rc[4])
  if (showRuler) then
    if (rulerModePoints) then
      love.graphics.setPointSize(1)
      love.graphics.points(rPointArray)
    else
      love.graphics.setLineWidth(1)
      for i=1,screen_height/rulerspacing,1 do 
        love.graphics.line(0,i*rulerspacing,screen_width,i*rulerspacing)
        calls=calls+1
      end
      for i=1,screen_width/rulerspacing,1 do
        love.graphics.line(i*rulerspacing,0,i*rulerspacing,screen_height)  
      end
    end
  end
end
function drawObject(obj) 
  love.graphics.setColor(obj.r,obj.g,obj.b,obj.a)
  love.graphics.setLineWidth(obj.lineWidth)
  local v=obj.points
  if (obj.type==1) then
    if (#obj.points>2) then
      love.graphics.line(obj.points)
    end
  elseif (obj.type==2) then
    if (obj.fill) then
      love.graphics.rectangle("fill",v[1],v[2],v[3]-v[1],v[4]-v[2])
    else
      love.graphics.rectangle("line",v[1],v[2],v[3]-v[1],v[4]-v[2])
    end
  elseif (obj.type==3) then
    love.graphics.setFont(obj.font)
    love.graphics.print(obj.text,v[1],v[2])
  elseif (obj.type==4) then
    drawPointBrush(obj)
  end
  if (obj==currentObject) then
    if (v[1]) then
      --love.graphics.setColor(obj.r,obj.g,obj.b,obj.a)
      love.graphics.setColor(1,1,1,0.8)
      local x
      if (obj.type==1) then
        x="LINE "
      elseif (obj.type==2) then
        x="RECT "
      elseif (obj.type==3) then
        x="TEXT "
      elseif (obj.type==4) then
        x="PointBrush "
      end
      x=x.."("..obj.name..")"
      love.graphics.setFont(arialFont)
      love.graphics.print(x,v[1]+10,v[2]-20)
    end
  end
end
function drawPoints()
  --draw points
  love.graphics.setColor(mr,mg,mb,ma)
  local dp="Points : "
  local mi
  if (#currentObject.points>40) then
    mi=40
    --mi=#currentObject.points
  else
    mi=#currentObject.points
  end
  for i=1,mi,1 do
    dp=dp..currentObject.points[i]..", "
  end
  if (mode==2) then
    local v=currentObject.points
    for i=1,#currentObject.points-1,2 do
      love.graphics.setLineWidth(2)
      love.graphics.line(v[i]-5,v[i+1],v[i]+5,v[i+1])
      love.graphics.line(v[i],v[i+1]-5,v[i],v[i+1]+5)
    end
  elseif (mode==5) then
    --Already drawn
    --drawPointBrush(currentObject)
    love.graphics.setPointSize(2)
    love.graphics.points(currentObject.points)
  else
    love.graphics.setPointSize(9)
    love.graphics.points(currentObject.points)
  end
  --print points in the info read out.
  love.graphics.setFont(arialFont)
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Points: ", 10,screen_height-35)
  love.graphics.print(dp, 50,screen_height-35)
end
function drawInfo()
  love.graphics.setFont(arialFont)
  if sswitch then
    love.graphics.setColor(1,0,1,1)
    love.graphics.print("Press (S) to save Current Object code to console", menuSpaceL,screen_height-20)
  else
    love.graphics.setColor(1,0,1,1)
    love.graphics.print("Saved vectors to console.", menuSpaceL,screen_height-20)
  end
  love.graphics.setColor(mr,mg,mb,ma)
  love.graphics.print("Mode (M): "..modes[mode], menuSpaceR,screen_height-20)

  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Total Objects: "..#objects, menuSpaceR,screen_height-90)
  love.graphics.print("Ruler spacing (up/down): "..rulerspacing, menuSpaceR,screen_height-70)
  love.graphics.print("Spacing mulitpliter (left/right): "..rspeed, menuSpaceR,screen_height-50)
  if (currentObject) then
    love.graphics.print("Change Current Object (O): "..currentObject.name, menuSpaceL,screen_height-90)
    love.graphics.print("Current Object Type (T): "..currentObject.type, menuSpaceL,screen_height-70)
    love.graphics.print("(L)ineWidth: "..currentObject.lineWidth, menuSpaceL,screen_height-50)
    love.graphics.print("(C) - Sel color, (Z) - Rapid ON/OFF", menuSpaceR,screen_height-110)    
    love.graphics.setColor(defr,defg,defb,defa)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("fill",screen_width-100,screen_height-20,85,15)
    if (defr<0.3 and defg<0.3 and defb<0.3) then
      love.graphics.setColor(0.5,0.5,0.5,1)
    else 
      love.graphics.setColor(0,0,0,1)
    end
    love.graphics.print("Default color", screen_width-93,screen_height-19)
    love.graphics.rectangle("line",screen_width-100,screen_height-20,85,15)
  end
  if (multiVectorAdd) then
    love.graphics.setColor(1,0,0,1)
    love.graphics.print("RAPID ADD/DELETE/CYCLE", menuSpaceL,screen_height-110)
  end 
end
function drawMenu()
  drawSharedAttrib()
  if (currentObject.type==2) then
    drawRectAttrib()
  elseif (currentObject.type==3) then
    drawFontAttrib()
  elseif (currentObject.type==4) then
    drawPointBrushAttrib()
  end
end
function drawSharedAttrib()
  love.graphics.setColor(0.5,0.5,0.5,1)
  love.graphics.rectangle("fill",screen_width/2-200,screen_height/2-200,400,400)

  if (typing and typingAttrib==1) then
    love.graphics.setColor(0.2,0,0.8,1)
  else
    love.graphics.setColor(0.46,0.46,0.46,1)
  end
  love.graphics.rectangle("fill",lStart,screen_height/2-152.5, 200,20)
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.setLineWidth(2)
  local co = currentObject
  love.graphics.print("Obj. Name: ",screen_width/2-160,screen_height/2-150)
  if (typing) then 
    if (tblink and typingAttrib==1) then
      love.graphics.print(co.name.."_",lStart+5,screen_height/2-150)
    else
      love.graphics.print(co.name,lStart+5,screen_height/2-150)
    end
  else
    love.graphics.print(co.name,lStart+5,screen_height/2-150)
  end
  love.graphics.print("Obj. Color:",screen_width/2-160,screen_height/2-120)
  love.graphics.setColor(co.r,co.g,co.b,co.a)
  love.graphics.rectangle("fill",lStart,screen_height/2-122.5,200,20)
  love.graphics.setColor(0,0,0,1)
  love.graphics.rectangle("line",lStart,screen_height/2-122.5,200,20)
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Red: "..co.r,screen_width/2-160,screen_height/2-90)
  love.graphics.print("Green: "..co.g,screen_width/2-160,screen_height/2-60)
  love.graphics.print("Blue: "..co.b,screen_width/2-160,screen_height/2-30)
  love.graphics.print("Alpha: "..co.a,screen_width/2-160,screen_height/2)
  love.graphics.print("Width: "..co.lineWidth,screen_width/2-160,screen_height/2+30)
  
  --clickable indicator rects
  love.graphics.setColor(0.46,0.46,0.46,1)
  love.graphics.rectangle("fill",lStart,screen_height/2-92.5, 200,20)
  love.graphics.rectangle("fill",lStart,screen_height/2-62.5, 200,20)
  love.graphics.rectangle("fill",lStart,screen_height/2-32.5, 200,20)
  love.graphics.rectangle("fill",lStart,screen_height/2-2.5, 200,20)
  
  --sliders
  love.graphics.setColor(0,0,0,1) 
  love.graphics.line(lStart,screen_height/2-82.5,lEnd,screen_height/2-82.5)
  love.graphics.line(lStart,screen_height/2-52.5,lEnd,screen_height/2-52.5)
  love.graphics.line(lStart,screen_height/2-22.5,lEnd,screen_height/2-22.5)
  love.graphics.line(lStart,screen_height/2+7.5,lEnd,screen_height/2+7.5)
  love.graphics.setLineWidth(co.lineWidth)
  love.graphics.line(lStart,screen_height/2+37.5,lEnd,screen_height/2+37.5)
  
  --slider knobs
  love.graphics.setColor(co.r,0,0,1)
  love.graphics.rectangle("fill",lStart+((lEnd-lStart)*co.r)-10,screen_height/2-92.5,20,20)
  love.graphics.setColor(0,co.g,0,1)
  love.graphics.rectangle("fill",lStart+((lEnd-lStart)*co.g)-10,screen_height/2-62.5,20,20)
  love.graphics.setColor(0,0,co.b,1)
  love.graphics.rectangle("fill",lStart+((lEnd-lStart)*co.b)-10,screen_height/2-32.5,20,20)
  love.graphics.setColor(co.r,co.g,co.b,co.a)
  love.graphics.rectangle("fill",lStart+((lEnd-lStart)*co.a)-10,screen_height/2-2.5,20,20)
  love.graphics.setColor(1,1,1,1)
  --love.graphics.rectangle("fill",lStart+((lEnd-lStart)*co.lineWidth)-10,screen_height/2+27.5,20,20)
  love.graphics.rectangle("fill",lStart+((lEnd-lStart)*(co.lineWidth/40))-10,screen_height/2+27.5,20,20)
  
  love.graphics.setColor(0,0,0,1)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line",lStart+((lEnd-lStart)*co.r)-10,screen_height/2-92.5,20,20)
  love.graphics.rectangle("line",lStart+((lEnd-lStart)*co.g)-10,screen_height/2-62.5,20,20)
  love.graphics.rectangle("line",lStart+((lEnd-lStart)*co.b)-10,screen_height/2-32.5,20,20)
  love.graphics.rectangle("line",lStart+((lEnd-lStart)*co.a)-10,screen_height/2-2.5,20,20)
  --love.graphics.rectangle("line",lStart+((lEnd-lStart)*co.lineWidth)-10,screen_height/2+27.5,20,20)
  love.graphics.rectangle("line",lStart+((lEnd-lStart)*(co.lineWidth/40))-10,screen_height/2+27.5,20,20)
  
  --debug delete
  --love.graphics.setColor(1,1,1,1)
  --love.graphics.print("mx-lstart: "..(mx-lStart),screen_width/2-160,screen_height/2+90)
  --love.graphics.print("mx-lstart/200: "..(mx-lStart)/200,screen_width/2-160,screen_height/2+130)
  --love.graphics.print("co.r: "..co.r,screen_width/2-160,screen_height/2+160)
end
function drawFontAttrib()
  local co = currentObject
  
  --fontSize click rect
  love.graphics.setColor(0.46,0.46,0.46,1)
  love.graphics.rectangle("fill",lStart,screen_height/2+57.5, 200,20)
  
  if (typing and typingAttrib==2) then
    love.graphics.setColor(0.2,0,0.8,1)
  else
    love.graphics.setColor(0.46,0.46,0.46,1)
  end
  --text click rect
  love.graphics.rectangle("fill",lStart,screen_height/2+87.5, 200,20)
  --font click rect
  love.graphics.setColor(0.46,0.46,0.46,1)
  love.graphics.rectangle("fill",lStart,screen_height/2+117.5, 200,20)
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Font Size: "..co.fontSize,screen_width/2-160,screen_height/2+60)
  love.graphics.print("Obj. Text: ",screen_width/2-160,screen_height/2+90)
  if (typing) then 
    if (tblink and typingAttrib==2) then
      love.graphics.print(co.text.."_",lStart+5,screen_height/2+90)
    else
      love.graphics.print(co.text,lStart+5,screen_height/2+90)
    end
  else
    love.graphics.print(co.text,lStart+5,screen_height/2+90)
  end
  love.graphics.print("Font: ",screen_width/2-160,screen_height/2+120)
  love.graphics.push()
  love.graphics.setFont(arialFont)
  love.graphics.print(fontList[currentObject.fontNum],lStart+5,screen_height/2+120)
  love.graphics.pop()

  --fontSize line
  love.graphics.setColor(0,0,0,1)
  love.graphics.line(lStart,screen_height/2+67.5,lEnd,screen_height/2+67.5)
  
  --fontSize knob
  love.graphics.setColor(0.2,0.2,0.2,1)
  love.graphics.rectangle("fill",lStart+co.fontSize-10,screen_height/2+57.5,20,20)
  
  love.graphics.setColor(0,0,0,1)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line",lStart+co.fontSize-10,screen_height/2+57.5,20,20)
  
  
end
function drawRectAttrib()
  local co = currentObject
  
  --rect fill click area
  love.graphics.setColor(0.46,0.46,0.46,1)
  love.graphics.rectangle("fill",lStart,screen_height/2+57.5, 200,20)
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Rect. Fill Mode: ",screen_width/2-160,screen_height/2+60)
  if (co.fill) then 
    love.graphics.print("FILL",lStart+5,screen_height/2+60)
  else 
    love.graphics.print("LINE",lStart+5,screen_height/2+60)
  end
end
function drawPointBrushAttrib()
  local co=currentObject
  --click rect
  love.graphics.setColor(0.46,0.46,0.46,1)
  love.graphics.rectangle("fill",lStart,screen_height/2+57.5, 200,20)
  love.graphics.rectangle("fill",lStart,screen_height/2+87.5, 200,20)
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Point Size: "..co.pointSize,screen_width/2-160,screen_height/2+60)
  love.graphics.print("Sel.Radius: "..co.range,screen_width/2-160,screen_height/2+90)
  
  --pointSize line
  love.graphics.setColor(0,0,0,1)
  love.graphics.line(lStart,screen_height/2+67.5,lEnd,screen_height/2+67.5)
  love.graphics.line(lStart,screen_height/2+97.5,lEnd,screen_height/2+97.5)
  
  --pointSize knob
  love.graphics.setColor(0.2,0.2,0.2,1)
  love.graphics.rectangle("fill",lStart+co.pointSize-10,screen_height/2+57.5,20,20)
  love.graphics.rectangle("fill",lStart+co.range-10,screen_height/2+87.5,20,20)
  
  love.graphics.setColor(0,0,0,1)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle("line",lStart+co.pointSize-10,screen_height/2+57.5,20,20)
  love.graphics.rectangle("line",lStart+co.range-10,screen_height/2+87.5,20,20)
end
function drawPointBrush(obj)
    local v=obj
    --if not (v==currentObject) then
    --  love.graphics.setPointSize(6)
    --  love.graphics.setColor(v.r,v.g,v.b,v.a/10)
    --  love.graphics.points(obj.points)
    --end
    
    love.graphics.setPointSize(obj.pointSize)
    love.graphics.setColor(v.r,v.g,v.b,v.a)
    love.graphics.points(obj.points)
    
end
function drawTestCode()
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	-- rotate around the center of the screen by angle radians
  love.graphics.push()
	love.graphics.translate(width/2, height/2)
	love.graphics.rotate(t/1000)
	love.graphics.translate(-width/2, -height/2)
  drawObject(currentObject)
  love.graphics.pop()
	-- draw a white rectangle slightly off center
	love.graphics.setColor(0xff, 0xff, 0xff)
	love.graphics.rectangle('fill', width/2-100+200, height/2-100, 30, 40)
	-- draw a five-pixel-wide blue point at the center
	love.graphics.setPointSize(5)
	love.graphics.setColor(0, 0, 0xff)
	love.graphics.points(width/2, height/2)
  love.graphics.setPointSize(1)
  drawObject(currentObject)
end