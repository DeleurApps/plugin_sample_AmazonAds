local amazonAds = require "plugin.amazonAds"
local widget = require( "widget" )
local json = require "json"


local function Callback(event)
	print("Callback: "..json.encode(event))
	if event.name == "Ad collapsed" then
		print("Ad collapsed")
	elseif event.name == "Ad failed to load" then
		print("Ad failed to load. isError:"..tostring(event.isError), event.response)
	elseif event.name == "Ad loaded" then
		print("Ad loaded", event.response)
	elseif event.name == "onAdExpanded" then
		print("onAdExpanded")
	end
end
amazonAds.init({appKey = "sample-app-v1_pub-2", testMode = true, licenseKey = "licenceKey"}, Callback)



local function pressShowButton(event)
	amazonAds.show({x=0, y=0, timeout = 20, size = "SIZE_300x250"}) --Sizes(optional): "SIZE_1024x50", "SIZE_300x250", "SIZE_300x50", "SIZE_320x50", "SIZE_600x90", "SIZE_728x90"; x=0, y=0 for default (top) positioning. top left coordinates of banners
end


local showButton = widget.newButton
{
	width = 198,
	height = 59,
	label = "Show",
	onRelease = pressShowButton,
}
showButton.x = display.contentWidth/2
showButton.y = display.contentHeight/4

local function pressHideButton(event)
	amazonAds.hide()
end


local hideButton = widget.newButton
{
	width = 198,
	height = 59,
	label = "Hide",
	onRelease = pressHideButton,
}
hideButton.x = display.contentWidth/2
hideButton.y = display.contentHeight* 3/4

