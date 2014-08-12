local amazonAds = require "plugin.amazonAds"
local widget = require( "widget" )
local json = require "json"


display.setDefault( "background", 197/255, 204/255, 212/255, 1 )


local sceneGroup = display.newGroup( )
local ox, oy = math.abs(display.screenOriginX), math.abs(display.screenOriginY)
local tabBarHeight = 0

-- Adjust label color for some themes
local labelColor = { 0 }
local adSize
local adX = 0
local adY = 0
local adTimeout = 10
local adHideSize = "banner"
local sizes
local adSizes
local typeSelect
local sizeSelect


local CallbackText = display.newText( "Callback Here", display.contentCenterX, 450, native.systemFont, 7 )
CallbackText:setFillColor( unpack(labelColor) )
sceneGroup:insert( CallbackText )

local function Callback(event)
	print("Callback: "..json.encode(event))
	CallbackText.text = "Callback: "..json.encode(event)
	if event.name == "license" then
		print("event.type: "..event.type, "event.status: "..event.status)
	elseif event.name == "collapsed" then
		print("Ad collapsed")
	elseif event.name == "failed" then
		print("Ad failed to load. isError:"..tostring(event.isError), event.response)
	elseif event.name == "loaded" then
		print("Ad loaded")
	elseif event.name == "expanded" then
		print("Ad expanded")
	elseif event.name == "loadedInterstitial" then
		print("Interstitial ad loaded")
	elseif event.name == "failedInterstitial" then
		print("Interstitial ad failed to load. isError:"..tostring(event.isError), event.response)
	elseif event.name == "presentedInterstitial" then
		print("Interstitial ad presented")
	elseif event.name == "dismissedInterstitial" then
		print("Interstitial ad dismissed")
	end
end
amazonAds.init({appKey = "sample-app-v1_pub-2", testMode = true, logging = false, licenseKey = "licenceKey"}, Callback)


if system.getInfo( "platformName" ) == "Android" then
	sizes = {"Auto", "1024x50", "300x250", "300x50", "320x50", "600x90", "728x90"}
	adSizes = {"SIZE_AUTO", "SIZE_1024x50", "SIZE_300x250", "SIZE_300x50", "SIZE_320x50", "SIZE_600x90", "SIZE_728x90"}
elseif system.getInfo( "platformName" ) == "iPhone OS" then
	sizes = {"320x50", "300x50","300x250", "728x90", "1024x50"}
	adSizes = {"SIZE_320x50", "SIZE_300x50","SIZE_300x250", "SIZE_728x90", "SIZE_1024x50"}
end

adSize = adSizes[1]

local function typeSelectListener( event )
	local target = event.target
	if target.segmentNumber == 1 then
		adSize = adSizes[sizeSelect.segmentNumber]
	elseif target.segmentNumber == 2 then
		adSize = "interstitial"
	end
end

typeSelect = widget.newSegmentedControl {
    left = 10,
    top = 0,
    segments = { "Banner", "Interstitial" },
    defaultSegment = 1,
	segmentWidth = 132,
    onPress = typeSelectListener
}
sceneGroup:insert( typeSelect )
typeSelect.x = display.contentCenterX
typeSelect.y = 70



local function sizeSelectListener( event )
	local target = event.target
	if typeSelect.segmentNumber == 1 then
		adSize = adSizes[sizeSelect.segmentNumber]
	end
end

sizeSelect = widget.newSegmentedControl {
    left = 10,
    top = 0,
    segments = sizes,
    defaultSegment = 1,
	segmentWidth = 320/#sizes,
    onPress = sizeSelectListener
}
sceneGroup:insert( sizeSelect )
sizeSelect.x = display.contentCenterX
sizeSelect.y = 120



local locationText = display.newText( "Location:", display.contentCenterX, 160, native.systemFont, 20 )
locationText.anchorY = 0
locationText:setFillColor( unpack(labelColor) )
sceneGroup:insert( locationText )

local xText = display.newText( "x:", 55, 200, native.systemFont, 14 )
xText.anchorY = 0
xText:setFillColor( unpack(labelColor) )
sceneGroup:insert( xText )

local yText = display.newText( "y:", 165, 200, native.systemFont, 14 )
yText.anchorY = 0
yText:setFillColor( unpack(labelColor) )
sceneGroup:insert( yText )

local doneBtn

local function xFieldHandler( event )
	if ( "began" == event.phase ) then
		doneBtn.isVisible = true
	elseif ( "editing" == event.phase ) then
		adX = tonumber(event.target.text)
	end
end

local function yFieldHandler( event )
	if ( "began" == event.phase ) then
		doneBtn.isVisible = true
	elseif ( "editing" == event.phase ) then
		adY = tonumber(event.target.text)
	end
end

local function doneBtnPress( event )
	native.setKeyboardFocus( nil )		-- remove keyboard
	doneBtn.isVisible = false
end

local xTextField = native.newTextField( 110, 210, 40, 30 )
xTextField:addEventListener( "userInput", xFieldHandler )
xTextField.size = 14
xTextField.text = 0
xTextField.inputType = "number"
sceneGroup:insert( xTextField )

local yTextField = native.newTextField( 220, 210, 40, 30 )
yTextField:addEventListener( "userInput", yFieldHandler )
yTextField.size = 14
yTextField.text = 0
yTextField.inputType = "number"
sceneGroup:insert( yTextField )

doneBtn = widget.newButton
{
	label = "Done",
	fontSize = 16,
	labelColor = 
	{ 
		default = { 0 },
	},
	emboss = true,
	onPress = doneBtnPress,
	x = 275,
	y = 210
}
doneBtn.isVisible = false
sceneGroup:insert( doneBtn )

local function loadBtnPress( event )
	amazonAds.load()
end

local loadBtn = widget.newButton
{
	label = "Load Interstitial Ad",
	fontSize = 20,
	labelColor = 
	{ 
		default = { 0 },
	},
	emboss = true,
	onPress = loadBtnPress,
	x = display.contentCenterX,
	y = 260
}
sceneGroup:insert( loadBtn )

local function showBtnPress( event )
	amazonAds.show({x=adX, y=adY, timeout = 10, size = adSize})
end

local showBtn = widget.newButton
{
	label = "Show Ad",
	fontSize = 30,
	labelColor = 
	{ 
		default = { 0 },
	},
	emboss = true,
	onPress = showBtnPress,
	x = display.contentCenterX,
	y = 310
}
sceneGroup:insert( showBtn )

local function hideBtnPress( event )
	local hideOptions = {"banner", "interstitial", "all"}
	amazonAds.hide(hideOptions[typeSelect.segmentNumber])
end

local hideBtn = widget.newButton
{
	label = "Hide Ad",
	fontSize = 30,
	labelColor = 
	{ 
		default = { 0 },
	},
	emboss = true,
	onPress = hideBtnPress,
	x = display.contentCenterX,
	y = 360
}

typeSelect = widget.newSegmentedControl {
    left = 10,
    top = 0,
    segments = { "Hide Banner", "Hide Interstitial", "Hide All" },
    defaultSegment = 1,
	segmentWidth = 88,
}
sceneGroup:insert( typeSelect )
typeSelect.x = display.contentCenterX
typeSelect.y = 410
