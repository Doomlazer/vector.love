require "objects"

local validChars={
  "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","9","8","7","6","5","4","3","2","1",".","#","-",",","!",":",";","'"
}

function recalcRPointArry()
  local new={}
  for i=1,screen_width/rulerspacing,1 do 
    for u=1,screen_height/rulerspacing,1 do 
      table.insert(new,i*rulerspacing)
      table.insert(new,u*rulerspacing)
    end
  end
  rPointArray=new
end
function controlInputs()
  if (love.keyboard.isDown( "a" ) and not typing) then 
    if (aswitch) then
      aswitch=false
      local state=not menu
      menu=state
    end
  else 
    aswitch=true
  end
  if (menu) then
    love.mouse.setVisible(true)
    if love.mouse.isDown(1) then
      updateSliders()
    else
      fontswitch=true
      fillswitch=true
    end
  else
    standardControls()
    love.mouse.setVisible(false)
  end
end
function love.keypressed(key, scancode, isrepeat)
  if (typing) then
    if (key=="return") then
      typing=false
    end
    local txt=nil
    if (typingAttrib==1) then
      txt=currentObject.name
    elseif (typingAttrib==2) then
      txt=currentObject.text
    end 
    --delete letter
    if (key=="backspace") then
      if (string.len(txt)>0) then
        local l=string.len(txt)-1
        if (typingAttrib==1) then
          currentObject.name=string.sub(txt,1,l)
        elseif (typingAttrib==2) then
          currentObject.text=string.sub(txt,1,l)
        end 
      end
    else
      local valid=false
      for k,c in ipairs(validChars) do
        if (c==key) then
          valid=true
        end
      end
      if (key=="space" and (string.len(txt)<44)) then
        txt=txt.." "
        if (typingAttrib==1) then
          currentObject.name=txt.." "
        elseif (typingAttrib==2) then
          currentObject.text=txt.." "
        end 
      end
      if (valid and (string.len(txt)<44))then
        if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
          local sk
          if (key=="3") then
            sk="#"
          elseif (key=="1") then
            sk="!"
          elseif (key==";") then
            sk=":"
          else
            sk=string.upper(key)
          end
          if (typingAttrib==1) then
            currentObject.name=txt..sk
          elseif (typingAttrib==2) then
            currentObject.text=txt..sk
          end 
        else
          if (typingAttrib==1) then
            currentObject.name=txt..key
          elseif (typingAttrib==2) then
            currentObject.text=txt..key
          end 
        end
      end
    end
  end
end
function updateSliders()
  local v=currentObject
  if (mx>lStart-10 and mx<lEnd+10) then
    if (my>screen_height/2-152.5 and my<screen_height/2-130.5) then
      --change object name
        typing=true
        typingAttrib=1
    elseif (my>screen_height/2-92.5 and my<screen_height/2-72.5) then
      --red color slider
      v.r=(mx-lStart)/200
      if (v.r>1) then 
        v.r=1
      end
      if (v.r<0) then 
        v.r=0
      end      
    elseif (my>screen_height/2-62.5 and my<screen_height/2-42.5) then
      --green color slider
      v.g=(mx-lStart)/200
      if (v.g>1) then 
        v.g=1
      end
      if (v.g<0) then 
        v.g=0
      end 
    elseif (my>screen_height/2-32.5 and my<screen_height/2-12.5) then
      --blue color slider
      v.b=(mx-lStart)/200
      if (v.b>1) then 
        v.b=1
      end
      if (v.b<0) then 
        v.b=0
      end 
    elseif (my>screen_height/2-2.5 and my<screen_height/2+22.5) then
      --alpha slider
      v.a=(mx-lStart)/200
      if (v.a>1) then   
        v.a=1
      end
      if (v.a<0) then 
        v.a=0
      end 
    elseif (my>screen_height/2+27.5 and my<screen_height/2+52.5) then
      --line width slider
      v.lineWidth=(mx-lStart)/4
      if (v.lineWidth>40) then 
        v.lineWidth=40
      end
      if (v.lineWidth<1) then 
        v.lineWidth=1
      end 
    elseif (my>screen_height/2+57.5 and my<screen_height/2+77.5) then
      if (v.type==3) then
        --FONT fontSize slider
        local prev=v.fontSize
        v.fontSize=(mx-lStart)
        if (v.fontSize<1) then
          v.fontSize=1
        end
        if (v.fontSize>200) then
          v.fontSize=200
        end
        if (v.fontSize~=prev) then
          v.font=love.graphics.setNewFont("fonts/"..fontList[v.fontNum], v.fontSize)
        end
      elseif (v.type==4) then
        --POINTBRUSH pointSize slider
        v.pointSize=(mx-lStart)
        if (v.pointSize<1) then
          v.pointSize=1
        end
        if (v.pointSize>200) then
          v.pointSize=200
        end
      elseif (v.type==2) then
        --RECT toggle fill
        if (fillswitch) then
          fillswitch=false
          local state = not currentObject.fill
          v.fill=state
        end
      end
    elseif (my>screen_height/2+87.5 and my<screen_height/2+107.5) then
      --change text obj text
      if (v.type==3) then
        typing=true
        typingAttrib=2
      elseif (v.type==4) then
        --POINTBRUSH Selection Size slider
        v.range=(mx-lStart)
        if (v.range<1) then
          v.range=1
        end
        if (v.range>200) then
          v.range=200
        end
      end
    elseif (my>screen_height/2+117.5 and my<screen_height/2+137.5) then
      --change obj font
      if (v.type==3) then
        if (fontswitch) then
          fontswitch=false
          local case=false
          for k,v in pairs(fontList) do
            if (v==fontList[currentObject.fontNum]) then
              case=true
            end
          end
          if (case) then
            v.fontNum=v.fontNum+1
          end
          if (v.fontNum>#fontList) then
            v.fontNum=1
          end
          v.font=love.graphics.setNewFont("fonts/"..fontList[v.fontNum],v.fontSize)
        end
      end
    end
  end
end
function standardControls()
  if (t%10==0) then
    if love.keyboard.isDown( "up" ) then
      rulerSpacingUp()
    end
    if love.keyboard.isDown( "down" ) then
      rulerSpacingDown()
    end
    if love.keyboard.isDown( "left" ) then
      rulerSpeedDown()
    end
    if love.keyboard.isDown( "right" ) then
      rulerSpeedUp()
    end
  end
  if love.keyboard.isDown( "c" ) then
    colorPicker=true
  else
    colorPicker=false
  end
  if love.keyboard.isDown( "f" ) then
    toggleFill()
  else
    fswitch=true
  end
  if love.keyboard.isDown( "m" ) then
    changeMode()
  else
    mswitch=true
  end
  if love.keyboard.isDown( "o" ) then
    changeSelectedObject()
  else
    oswitch=true
  end
  if love.keyboard.isDown( "d" ) then
    objDelete()
  else
    dswitch=true
  end
  if love.keyboard.isDown("s") then
    saveCode()
  else
    sswitch=true
  end
  if love.keyboard.isDown("p") then
    pasteObjCopy()
  else
    pasteswitch=true
  end
  if love.keyboard.isDown("v") then --save current rgb as defaults
    defr=currentObject.r
    defg=currentObject.g
    defb=currentObject.b
    defa=currentObject.a
  end
  if love.keyboard.isDown("z") then
    multiPointAdd()
  else
    multiswitch=true
  end
  --current object lineWidth
  if love.keyboard.isDown("l") then
    changeLineWidth()
  else
    lswitch=true
  end
  --Toggle ruler grid
  if love.keyboard.isDown("r") then
    toggleRuler()
  else
    rulerswitch=true
  end
  --debug print objects
  if love.keyboard.isDown("3") then
    if (debugswitch) then
      debugswitch=false
      for i=1,20 do
        if (objects[i]) then
          print("i: "..i.."  object name: "..objects[i].name)
        end
      end
    end
  else
    if not debugswitch then
      print("debug key 3 active - print objects")
    end
    debugswitch=true
  end
  if love.mouse.isDown(1) then
    --Add Point
    if (mode==1) then 
      if multiVectorAdd then
        if not love.keyboard.isDown("lshift") then
          modeTaskOne(1,nil)
        end
      end
      if mouseswitch then
        mouseswitch=false
        if love.keyboard.isDown("lshift") then
          --new line
          objNum=objNum+1
          modeTaskOne(2,objNum)
        else
          --add point to existing object
          modeTaskOne(1,nil)
        end
      end
    --Move object
    elseif (mode==2) then
      if (moveswitch) then
        moveswitch=false
        prevX=cpx
        prevY=cpy
      end
      modeTaskTwo(1)
    --Add Rectangle
    elseif (mode==3) then
      if (rectswitch) then
        rectswitch=false
        objNum=objNum+1
        modeTaskThree(1,objNum) --create rect object as new currentobject 
      else
        modeTaskThree(2,nil) --drag rect until mouse released
      end
    --Add Text
    elseif( mode==4) then
      if (textswitch) then
        textswitch=false
        objNum=objNum+1
        modeTaskFour(objNum) --new text obj
      end
    --Add Point array
    elseif( mode==5) then
      if love.keyboard.isDown("lshift") or not (currentObject.type==4) then
        if (pointarrayswitch) then
          pointarrayswitch=false
          setClosestPoint()
          objNum=objNum+1
          modeTaskFive(1,objNum) --new pointArray
        else
          modeTaskFive(2,nil)
        end
      else
        modeTaskFive(2,nil)
      end
    end
  else
    mouseswitch=true
    moveswitch=true
    rectswitch=true
    textswitch=true
    pointarrayswitch=true
  end
end
function rulerSpacingUp()
  rulerspacing=rulerspacing+rspeed
  if (screen_width>screen_height) then
    if (rulerspacing>screen_width) then
      rulerspacing=screen_width 
    end
  else
    if (rulerspacing>screen_height) then
      rulerspacing=screen_height 
    end
  end
  recalcRPointArry()
end
function rulerSpacingDown()
  local minSpacing=3
  rulerspacing=rulerspacing-rspeed
  if (rulerspacing<minSpacing) then 
    rulerspacing=minSpacing
  end
  recalcRPointArry()
end
function rulerSpeedUp()
  rspeed=rspeed+1
  if (screen_width>screen_height) then
    if (rspeed>screen_width) then
      rspeed=screen_width
    end
  else
    if (rspeed>screen_height) then
      rspeed=screen_height
    end
  end  
end
function rulerSpeedDown()
  rspeed=rspeed-1
  if (rspeed<1) then rspeed=1 end
end
function toggleFill()
  if (fswitch) then
    fswitch=false
    if (currentObject.fill) then
      currentObject.fill=false
      deffill=false
    else
      currentObject.fill=true
      deffill=true
    end
  end
end
function changeMode()
  if (mswitch) then
    mswitch=false
    mode=mode+1
    if (mode>#modes) then
      mode=1
    end
  end
end
function changeSelectedObject()
  if (oswitch) then
    oswitch=false
    if (currentObject.num+1>#objects) then
      currentObject=objects[1]
    else
      currentObject=objects[currentObject.num+1]
    end
  end
end
function objDelete()
  if (dswitch or multiVectorAdd) then
    dswitch=false
    if (currentObject.type==1 or currentObject.type==4) then
      if (#currentObject.points>0) then 
        --table.remove(currentObject.points)
        --table.remove(currentObject.points)
        currentObject.points[#currentObject.points]=nil
        currentObject.points[#currentObject.points]=nil
      end
      if (#objects>0) then
        if (#currentObject.points==0) then 
          local temp=currentObject.num
          --table.remove(objects,temp)   
          objects[temp]=nil
        end
      end
    elseif (currentObject.type==2 or currentObject.type==3) then
      --delete rectange OR text
      local temp=currentObject.num
      --table.remove(objects,temp)
      objects[temp]=nil
      --relable object nums
      --for k,v in ipairs(objects) do
      --  v.num=k
      --end
      --if (temp>#objects) then
      --  currentObject=objects[#objects]
      --else
      --  currentObject=objects[temp]
      --end        
    end
  end
end
function saveCode()
    if (sswitch) then
      sswitch=falsex
      local dp=""
      for k, v in pairs(currentObject.points) do
        if (k==#currentObject.points) then
          dp=dp..v
        else
          dp=dp..v..", "
        end
      end 
      print("***********COPY CODE BELOW THIS LINE***********")
      print("--object name: "..currentObject.name)
      print("love.graphics.setColor("..currentObject.r..","..currentObject.g..","..currentObject.b..","..currentObject.a..")")
      print("local objKeyFrame={"..dp.."}")
      print("love.graphics.setLineWidth("..currentObject.lineWidth..")")
      print("love.graphics.line(objKeyFrame)")
    end
end
function multiPointAdd()
  if (multiswitch) then
    multiswitch=false
    if (multiVectorAdd) then
      multiVectorAdd=false
    else
      multiVectorAdd=true
    end
  end
end
function changeLineWidth()
  if (lswitch) then
    lswitch=false
    if love.keyboard.isDown("lshift") then
      currentObject.lineWidth=currentObject.lineWidth-1
      if (currentObject.lineWidth<0) then
        currentObject.lineWidth=40
      end
    else
      currentObject.lineWidth=currentObject.lineWidth+1
      if (currentObject.lineWidth>40) then
        currentObject.lineWidth=1
      end
    end
  end
  deflw=currentObject.lineWidth
end
function pasteObjCopy()
  if (pasteswitch) then 
    pasteswitch=false
    objNum=objNum+1
    local v=currentObject
    duplicateObject(objNum,v.type,v.r,v.g,v.b,v.a,v.lineWidth,v.points,v.text,v.name,v.font,v.fontSize,v.fill,v.range,v.sampleRate,v.fontNum)
  end
end
function toggleRuler()
  if (rulerswitch) then
    rulerswitch=false
    local case = not showRuler
    showRuler = case
  end
end